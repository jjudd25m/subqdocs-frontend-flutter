import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../data/service/database_helper.dart';
import '../../../data/service/recorder_service.dart';
import '../../../models/media_listing_model.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../model/patient_attachment_list_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../model/visit_recap_list_model.dart';
import '../repository/visit_main_repository.dart';
import '../views/attachmentDailog.dart';

class VisitMainController extends GetxController {
  //TODO: Implement VisitMainController

  RxBool isLoading = RxBool(false);
  RxString loadingMessage = RxString("");

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  RecorderService recorderService = RecorderService();

  RxBool isExpandRecording = true.obs;
  final count = 0.obs;
  RxBool isStartRecording = false.obs;
  RxInt isSelectedAttchmentOption = RxInt(0);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();
  // RxList<MediaListingModel> selectedList = RxList();

  Rxn<VisitRecapListModel> visitRecapList = Rxn();
  Rxn<PatientAttachmentListModel> patientAttachmentList = Rxn();

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    print("picked image is  ${pickedImage}");

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

  Future<void> captureImage(BuildContext context, {bool fromCamera = true}) async {
    list.clear();

    XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);

    print("media  file is  $image");

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
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
    }

    list.refresh();
    if (list.isNotEmpty) {
      showCustomDialog(context);
    }
  }

  Future<void> pickFiles(BuildContext context) async {
    list.clear();

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles();

    print("media  file is  ${fileList}");

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
          list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
        }

        list.refresh();

        if (list.isNotEmpty) {
          showCustomDialog(context);
        }
      },
    );
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

    print("visit id is :- $visitId");

    List<AudioFile> pendingFiles = await DatabaseHelper.instance.getPendingAudioFiles();
    print("local audio is :- ${pendingFiles}");

    if (patientId.value.isNotEmpty) {
      getVisitRecap();
      getPatientAttachment();
    }
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
    isLoading.value = true;
    loadingMessage.value = "Uploading Audio";

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    PatientTranscriptUploadModel patientTranscriptUploadModel = await _visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
    print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

    isLoading.value = false;

    Get.toNamed(Routes.PATIENT_INFO, arguments: {
      "trascriptUploadData": patientTranscriptUploadModel,
    });
  }

  Future<void> uploadAttachments() async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    Map<String, List<File>> profileParams = {};
    if (list.isNotEmpty) {
      print("profile is   available");
      // param['profile_image'] = profileImage.value;
      profileParams['attachments'] = list.map((model) => model.file).toList().whereType<File>().toList();
    } else {
      print("profile is not  available");
    }
    await _visitMainRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
    list.clear();
    getPatientAttachment();
  }

  Future<void> getVisitRecap() async {
    print("patientID is :- ${patientId.value}");
    visitRecapList.value = await _visitMainRepository.getVisitRecap(id: patientId.value);
  }

  Future<void> getPatientAttachment() async {
    patientAttachmentList.value = await _visitMainRepository.getPatientAttachment(id: visitId.value);

    print("patientAttachmentList is:- ${patientAttachmentList.value?.toJson()}");
  }

//   Future<void> submitAudio(File audioFile) async {
//     isLoading.value = true;
//     loadingMessage.value = "Uploading Audio";
//
//     var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
//
//     bool isConnected = await isInternetAvailable();
//
//     if (!isConnected) {
//       print("No internet connection");
//       // If no internet, save audio as BLOB in the local database
//       Uint8List audioBytes = await audioFile.readAsBytes(); // Read audio file as bytes
//
//       AudioFile audioFileToSave = AudioFile(
//         audioData: audioBytes,
//         fileName: audioFile.uri.pathSegments.last,
//         status: 'pending',
//       );
//
//       await DatabaseHelper.instance.insertAudioFile(audioFileToSave);
//
//       // Show a message or update UI
//       loadingMessage.value = "Audio saved locally. Will upload when internet is available.";
//       isLoading.value = false;
//
//       return;
//     } else {
//       print("internet connected");
//       // If there is internet, upload the audio
//       PatientTranscriptUploadModel patientTranscriptUploadModel =
//           await _visitMainRepository.uploadAudio(
//         audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
//
//       print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");
//
//     Get.toNamed(Routes.PATIENT_INFO, arguments: {
//       "trascriptUploadData": patientTranscriptUploadModel,
//     });
//   }
}
