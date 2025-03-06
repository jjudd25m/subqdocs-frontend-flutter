import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/service/database_helper.dart';
import '../../../data/service/recorder_service.dart';
import '../../../models/media_listing_model.dart';
import '../../../routes/app_pages.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../forgot_password/models/common_respons.dart';
import '../../forgot_password/models/send_otp_model.dart';
import '../../home/repository/home_repository.dart';
import '../../login/model/login_model.dart';
import '../model/patient_attachment_list_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../model/visit_recap_list_model.dart';
import '../model/visitmainModel.dart';
import '../repository/visit_main_repository.dart';
import '../views/attachmentDailog.dart';

class VisitMainController extends GetxController {
  //TODO: Implement VisitMainController

  Rxn<PatientDetailModel> patientDetailModel = Rxn();
  // Rxn<'List<ScheduledVisits>> scheduledVisits = Rxn();
  RxList<ScheduledVisits>? scheduledVisitsModel = RxList();

  RxBool isConnected = RxBool(true);

  final HomeRepository _homeRepository = HomeRepository();

  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  RxBool isStartTranscript = RxBool(false);
  RxBool isLoading = RxBool(false);
  RxString loadingMessage = RxString("");

  RxBool isImage = RxBool(false);
  RxBool isDocument = RxBool(false);

  String visitRecaps = "visitRecaps";
  String visitMainData = "visitMainData";
  String scheduledVisits = "scheduledVisits";
  String scheduleVisitsList = "scheduleVisitsList";

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  RecorderService recorderService = RecorderService();

  TextEditingController searchController = TextEditingController();

  RxBool isExpandRecording = true.obs;
  final count = 0.obs;
  RxBool isStartRecording = false.obs;
  RxInt isSelectedAttchmentOption = RxInt(-1);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();

  Rxn<VisitRecapListModel> visitRecapList = Rxn();
  Rxn<PatientAttachmentListModel> patientAttachmentList = Rxn();
  Rxn<VisitMainPatientDetails> patientData = Rxn();

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    customPrint("picked image is  $pickedImage");

    if (pickedImage != null) {}
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  // Future<void> captureImage(BuildContext context, {bool fromCamera = true}) async {
  //   list.clear();
  //
  //   XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);
  //
  //   customPrint("media  file is  $image");
  //
  //   XFile? _pickedFile;
  //   String? _fileName;
  //   DateTime? _pickDate;
  //   int? _fileSize;
  //   if (image != null) {
  //     _fileName = image.name; // Get the file name
  //     _pickDate = DateTime.now(); // Get the date when the file is picked
  //
  //     // Get the size of the file
  //     File file = File(image.path);
  //     _fileSize = file.lengthSync(); // Size in bytes
  //
  //     String? _filesizeString = _formatFileSize(_fileSize);
  //     String? _shortFileName;
  //     if (p.basename(_fileName).length > 15) {
  //       // Truncate the name to 12 characters and add ellipsis
  //       _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
  //     } else {
  //       _shortFileName = p.basename(_fileName); // Use the full name if it's already short
  //     }
  //     list.value.add(MediaListingModel(
  //         file: file,
  //         previewImage: null,
  //         fileName: _shortFileName,
  //         date: _formatDate(_pickDate),
  //         Size: _filesizeString));
  //   }
  //
  //   list.refresh();
  //   if (list.isNotEmpty) {
  //     showCustomDialog(context);
  //   }
  // }

  Future<void> captureImage(BuildContext context, {bool fromCamera = true, bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);

    customPrint("media  file is  $image");

    XFile? _pickedFile;
    String? _fileName;
    DateTime? _pickDate;
    int? _fileSize;
    if (image != null) {
      _fileName = image.name; // Get the file name
      _pickDate = DateTime.now(); // Get the date when the file is picked

      // Get the size of the file
      File file = File(image.path);
      _fileSize = file.lengthSync(); // Size in bytes

      String? _filesizeString = _formatFileSize(_fileSize);
      String? _shortFileName;
      if (p.basename(_fileName).length > 15) {
        // Truncate the name to 12 characters and add ellipsis
        _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
      } else {
        _shortFileName = p.basename(_fileName); // Use the full name if it's already short
      }
      list.value.add(MediaListingModel(
          file: file,
          previewImage: null,
          fileName: _shortFileName,
          date: _formatDate(_pickDate),
          Size: _filesizeString));
    }

    list.refresh();

    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  void clearFilter() {
    isSelectedAttchmentOption.value = -1;
    isDocument.value = false;
    isImage.value = false;
    getPatientAttachment();
    Get.back();
  }
  //
  // Future<void> pickFiles(BuildContext context) async {
  //   list.clear();
  //
  //   List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles();
  //
  //   customPrint("media  file is  $fileList");
  //
  //   fileList?.forEach(
  //     (element) {
  //       XFile? _pickedFile;
  //       String? _fileName;
  //       DateTime? _pickDate;
  //       int? _fileSize;
  //       if (element != null) {
  //         _fileName = element.name; // Get the file name
  //         _pickDate = DateTime.now(); // Get the date when the file is picked
  //
  //         // Get the size of the file
  //         File file = File(element.xFile.path);
  //         _fileSize = file.lengthSync(); // Size in bytes
  //
  //         String? _filesizeString = _formatFileSize(_fileSize);
  //
  //         String? _shortFileName;
  //         if (p.basename(_fileName).length > 15) {
  //           // Truncate the name to 12 characters and add ellipsis
  //           _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
  //         } else {
  //           _shortFileName = p.basename(_fileName); // Use the full name if it's already short
  //         }
  //         list.value.add(MediaListingModel(
  //             file: file,
  //             previewImage: null,
  //             fileName: _shortFileName,
  //             date: _formatDate(_pickDate),
  //             Size: _filesizeString));
  //       }
  //
  //       list.refresh();
  //
  //       if (list.isNotEmpty) {
  //         showCustomDialog(context);
  //       }
  //     },
  //   );
  // }

  Future<void> pickFiles(BuildContext context, {bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles();

    customPrint("media  file is  $fileList");

    fileList?.forEach(
      (element) {
        XFile? _pickedFile;
        String? _fileName;
        DateTime? _pickDate;
        int? _fileSize;
        if (element != null) {
          _fileName = element.name; // Get the file name
          _pickDate = DateTime.now(); // Get the date when the file is picked

          // Get the size of the file
          File file = File(element.xFile.path);
          _fileSize = file.lengthSync(); // Size in bytes

          String? _filesizeString = _formatFileSize(_fileSize);

          String? _shortFileName;
          if (p.basename(_fileName).length > 15) {
            // Truncate the name to 12 characters and add ellipsis
            _shortFileName = p.basename(_fileName).substring(0, 12) + '...';
          } else {
            _shortFileName = p.basename(_fileName); // Use the full name if it's already short
          }
          list.value.add(MediaListingModel(
              file: file,
              previewImage: null,
              fileName: _shortFileName,
              date: _formatDate(_pickDate),
              Size: _filesizeString));
        }
      },
    );
    list.refresh();
    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  RxString visitId = RxString("");
  RxString patientId = RxString("");
  RxList<MediaListingModel> list = RxList();

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return attachmentDailog(); // Our custom dialog
      },
    );
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    visitId.value = Get.arguments["visitId"];
    patientId.value = Get.arguments["patientId"];

    customPrint("visit id is :- $visitId");
    //it  will check the internet  connection and handel   offline and online mode

    var status = await InternetConnection().internetStatus;

    isConnected.value = status == InternetStatus.disconnected ? false : true;

    if (status == InternetStatus.disconnected) {
      print("you net is now Disconnected");

      offLine();
    } else {
      onLine();
    }

    handelInternetConnection();

    List<AudioFile> pendingFiles = await DatabaseHelper.instance.getPendingAudioFiles();
    customPrint("local audio is :- $pendingFiles");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> submitAudio(File audioFile) async {
    if (audioFile.path.isEmpty) {
      return;
    }

    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      customPrint("internet not available ");
      isLoading.value = true;
      loadingMessage.value = "Uploading Audio";
      Uint8List audioBytes = await audioFile.readAsBytes(); // Read audio file as bytes

      AudioFile audioFileToSave =
          AudioFile(audioData: audioBytes, fileName: audioFile.path, status: 'pending', visitId: visitId.value);

      await DatabaseHelper.instance.insertAudioFile(audioFileToSave);

      // Show a message or update UI
      loadingMessage.value = "Audio saved locally. Will upload when internet is available.";
      isLoading.value = false;

      CustomToastification()
          .showToast("Audio saved locally. Will upload when internet is available.", type: ToastificationType.success);

      List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();

      for (var file in audio) {
        customPrint("audio data is:-  ${file.visitId} ${file.fileName} ${file.id}");
      }
    } else {
      customPrint("internet available");
      isLoading.value = true;
      loadingMessage.value = "Uploading Audio";

      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      PatientTranscriptUploadModel patientTranscriptUploadModel = await _visitMainRepository.uploadAudio(
          audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
      customPrint("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

      isLoading.value = false;

      Get.toNamed(Routes.PATIENT_INFO, arguments: {
        "trascriptUploadData": patientTranscriptUploadModel,
      });
    }
  }

  Future<void> deleteAttachments(int id) async {
    Loader().showLoadingDialogForSimpleLoader();
    Map<String, List<int>> params = {};
    params["attachments"] = [id];

    customPrint("attch :- $params");
    CommonResponse commonResponse = await _visitMainRepository.deleteAttachments(params: params);
    if (commonResponse.responseType == "success") {
      CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.success);
    } else {
      CustomToastification().showToast(commonResponse.message ?? "", type: ToastificationType.error);
    }
    Get.back();
    Get.back();
    getPatientAttachment();
  }

  void handelInternetConnection() {
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          onLine();
          isConnected.value = true;

          break;
        case InternetStatus.disconnected:
          isConnected.value = false;
          offLine();

          break;
      }
    });
  }

  Future<void> uploadAttachments() async {
    Loader().showLoadingDialogForSimpleLoader();
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    Map<String, List<File>> profileParams = {};
    if (list.isNotEmpty) {
      customPrint("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['attachments'] = list.map((model) => model.file).toList().whereType<File>().toList();
    } else {
      customPrint("profile is not  available");
    }
    await _visitMainRepository.uploadAttachments(
        files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: patientId.value);
    list.clear();
    Get.back();
    getPatientAttachment();
  }

  Future<void> getVisitRecap() async {
    customPrint("patientID is :- ${patientId.value}");
    visitRecapList.value = await _visitMainRepository.getVisitRecap(id: patientId.value);
  }

  Future<void> getPatientAttachment() async {
    Map<String, dynamic> param = {};

    if (searchController.text != "") {
      param['search'] = searchController.text;
    }

    if (isImage.value) {
      param['image'] = true;
    }

    if (isDocument.value) {
      param['document'] = true;
    }

    try {
      patientAttachmentList.value = await _visitMainRepository.getPatientAttachment(id: patientId.value, param: param);
      // Get.back();
    } catch (error) {
      // Get.back();
    }

    customPrint("patientAttachmentList is:- ${patientAttachmentList.value?.toJson()}");
  }

  Future<void> getPatientDetails() async {
    Loader().showLoadingDialogForSimpleLoader();
    patientData.value = await _visitMainRepository.getPatientDetails(id: visitId.value);
    Get.back();
    customPrint("patientAttachmentList is:- ${patientAttachmentList.value?.toJson()}");
  }

  Future<void> launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> patientReScheduleCreate({required Map<String, dynamic> param, required String visitId}) async {
    customPrint("visit id :- $visitId");
    dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);
    customPrint("patientReScheduleCreate API  internal response $response");
    CustomToastification().showToast("Visit reschedule successfully", type: ToastificationType.success);
    patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);
    getPatientDetails();
  }

  Future<void> deletePatientVisit({required String id}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/visit/delete/$id", data: {});
    customPrint(response);
    CustomToastification().showToast("Visit delete successfully", type: ToastificationType.success);

    patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);

    if (patientDetailModel.value?.responseData?.scheduledVisits?.isEmpty ?? false) {
      Get.back();
    }
  }

  void onLine() async {
    customPrint("now its disConnected");

    if (patientId.value.isNotEmpty) {
      getVisitRecap();
      getPatientAttachment();
    }

    if (visitId.value.isNotEmpty) {
      getPatientDetails();
    }

    patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);
    // CustomToastification().showToast(" Internet Connected", type: ToastificationType.info);
  }

  void offLine() async {
    var responseData = jsonDecode(AppPreference.instance.getString(AppString.offLineData));

    var visitRecapListResponse = fetchVisitDetails(
        type: scheduleVisitsList, modelType: visitRecaps, visitId: visitId.value, responseData: responseData);

    var patientDetailsResponse = fetchVisitDetails(
        type: scheduleVisitsList, modelType: visitMainData, visitId: visitId.value, responseData: responseData);

    var scheduleVisitResponse = fetchVisitDetails(
        type: scheduleVisitsList, modelType: scheduledVisits, visitId: visitId.value, responseData: responseData);

    patientDetailModel.value = PatientDetailModel.fromJson(scheduleVisitResponse);

    visitRecapList.value = VisitRecapListModel.fromJson(visitRecapListResponse);

    patientData.value = VisitMainPatientDetails.fromJson(patientDetailsResponse);
  }

  Map<String, dynamic> fetchVisitDetails(
      {required Map<String, dynamic> responseData,
      required String type,
      required String visitId,
      required String modelType}) {
    // Extract the correct visit list based on the type (scheduleVisitsList or pastPatientVisitsList)
    List<dynamic> visitList = responseData['responseData'][type];

    // Initialize the result data
    var responseDataResult;

    // Search for the visit with the matching visit_id
    for (var visit in visitList) {
      // Check for the nested visit by visit-<visit_id> key
      var visitKey = 'visit-$visitId';
      if (visit.containsKey(visitKey)) {
        var visitDetails = visit[visitKey];

        // Check for the value of the key that we need (e.g., scheduledVisits)
        if (visitDetails['$modelType'] != null && visitDetails['$modelType'].isNotEmpty) {
          responseDataResult = visitDetails['$modelType']; // Set the value to return
        }
        break;
      }
    }

    // Return the formatted response

    if (modelType == scheduledVisits) {
      return {
        "responseData": {"scheduledVisits": responseDataResult},
        "message": " Details Fetched Successfully",
        "toast": true,
        "response_type": "success"
      };
    } else {
      return {
        "responseData": responseDataResult,
        "message": " Details Fetched Successfully",
        "toast": true,
        "response_type": "success"
      };
    }
  }
}
