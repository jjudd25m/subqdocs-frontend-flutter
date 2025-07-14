import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/service/database_helper.dart';
import '../../../models/ChangeModel.dart';
import '../../../models/MedicalRecords.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../../models/media_listing_model.dart';
import '../../../routes/app_pages.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../forgot_password/models/common_respons.dart';
import '../../home/repository/home_repository.dart';
import '../../login/model/login_model.dart';
import '../../patient_info/controllers/patient_info_controller.dart';
import '../../patient_info/model/impresion_and_plan_view_model.dart';
import '../model/patient_attachment_list_model.dart';
import '../model/visit_main_model.dart';
import '../model/visit_recap_list_model.dart';
import '../repository/visit_main_repository.dart';
import '../views/attachmentDailog.dart';

class VisitMainController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement VisitMainController

  Rxn<SelectedDoctorModel> selectedDoctorValueModel = Rxn();
  TextEditingController doctorController = TextEditingController();
  FocusNode doctorFocusNode = FocusNode();

  RxBool isKeyboardVisible = RxBool(false);
  PageController pageController = PageController();
  RxList<DateTime>? selectedDate = RxList([DateTime.now()]);
  String? attachmentStartDate;
  String? attachmentEndDate;

  final KeyboardController keyboardController = Get.put(KeyboardController());
  Rxn<PatientDetailModel> patientDetailModel = Rxn();
  Rxn<MedicalRecords> medicalRecords = Rxn();
  RxList<ScheduledVisits>? scheduledVisitsModel = RxList();

  RxList<ImpresionAndPlanViewModel> editableVisitSnapShot = RxList();
  RxList<ImpresionAndPlanViewModel> editablePersnoalNote = RxList();

  RxList<ImpresionAndPlanViewModel> editableCancerHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableMedicationHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableSkinHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableSocialHistory = RxList();
  RxList<ImpresionAndPlanViewModel> editableAllergies = RxList();

  RxBool isConnected = RxBool(true);

  final HomeRepository _homeRepository = HomeRepository();

  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  RxBool isLoading = RxBool(false);
  RxString loadingMessage = RxString("");

  RxBool isImage = RxBool(false);
  RxBool isDocument = RxBool(false);
  RxBool isDateFilter = RxBool(false);

  String visitRecaps = "visitRecaps";
  String visitMainData = "visitMainData";
  String scheduledVisits = "scheduledVisits";
  String scheduleVisitsList = "scheduleVisitsList";
  String fullNoteOfLastVisit = "fullNoteOfLastVisit";

  final VisitMainRepository visitMainRepository = VisitMainRepository();

  final GlobalController globalController = Get.find();
  TextEditingController searchController = TextEditingController();

  TextEditingController searchDoctorController = TextEditingController();

  RxString doctorValue = RxString("select doctor");
  RxString medicationValue = RxString("select M.A");

  final count = 0.obs;

  RxInt isSelectedAttchmentOption = RxInt(-1);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();

  Rxn<VisitRecapListModel> visitRecapList = Rxn();
  RxList<PatientAttachmentResponseData> patientAttachmentList = RxList();
  Rx<VisitMainPatientDetails> patientData = Rx(VisitMainPatientDetails());

  RxString visitId = RxString("");
  RxString patientId = RxString("");
  RxList<MediaListingModel> list = RxList();

  @override
  Future<void> onInit() async {
    super.onInit();
    // this is for the bread cum
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.addRouteInit(Routes.VISIT_MAIN);
    });

    if (Get.arguments["visitId"] != null) {
      visitId.value = Get.arguments["visitId"];
    }

    patientId.value = Get.arguments["patientId"];

    // WakelockPlus.enable();
    pageController = PageController(initialPage: DateUtils.monthDelta(DateTime(2000, 01, 01), selectedDate?.firstOrNull ?? DateTime.now()));

    if (visitId.value.isNotEmpty) {
      customPrint("visit id is :- $visitId");
      //it  will check the internet  connection and handel   offline and online mode

      var status = await InternetConnection().internetStatus;

      isConnected.value = status == InternetStatus.disconnected ? false : true;

      if (status == InternetStatus.disconnected) {
        customPrint("you net is now Disconnected");

        offLine();
      } else {
        onLine(isLoading: true);
      }

      handelInternetConnection();

      List<AudioFile> pendingFiles = await DatabaseHelper.instance.getPendingAudioFiles();
      customPrint("local audio is :- $pendingFiles");
    }

    globalController.isStartTranscript.value = false;

    globalController.isExpandRecording.value = true;
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisibleNow = bottomInset > 0.0;

    if (isKeyboardVisible != isVisibleNow) {
      isKeyboardVisible.value = isVisibleNow;
    }
  }

  Future<void> captureProfileImage() async {
    XFile? pickedImage = await MediaPickerServices().pickImage();
    customPrint("picked image is  $pickedImage");

    if (pickedImage != null) {}
  }

  // Future<void> updatePatientVisit(String keyName, List<ImpresionAndPlanViewModel> list) async {
  //   var response = await _patientInfoRepository.updateFullNote(id: patientFullNoteModel.value?.responseData?.id ?? 0, params: buildParams(keyName, list));
  // }

  Future<void> updatePatientVisit(String keyName, List<ImpresionAndPlanViewModel> list, int? id) async {
    if (id != null) var response = await visitMainRepository.updatePatientVisitView(id: id, params: buildParams(keyName, list));
  }

  Future<void> updateFullNote(String keyName, List<ImpresionAndPlanViewModel> list) async {
    var response = await visitMainRepository.updateFullNote(id: medicalRecords.value?.responseData?.id ?? 0, params: buildParams(keyName, list));
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

      double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);
      String? _shortFileName;
      if (p.basename(_fileName).length > 15) {
        // Truncate the name to 12 characters and add ellipsis
        _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
      } else {
        _shortFileName = p.basename(_fileName); // Use the full name if it's already short
      }
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
    }

    list.refresh();

    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  Future<void> updateData() async {
    patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);

    if (patientDetailModel.value?.responseData?.scheduledVisits?.isEmpty ?? false) {}
  }

  double _formatFileSizeDouble(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return (sizeInMB * 100).roundToDouble() / 100;
  }

  void clearFilter() {
    isSelectedAttchmentOption.value = -1;
    isDocument.value = false;
    isImage.value = false;
    isDateFilter.value = false;
    selectedDate = RxList([DateTime.now()]);
    getPatientAttachment();
    Get.back();
  }

  Future<void> updateSelectedDate() async {
    List<String> dates = getCustomDateRange(selectedDate ?? []);
    if (dates.length == 2) {
      attachmentStartDate = dates[0];
      attachmentEndDate = dates[1];
    }
  }

  List<String> getCustomDateRange(List<DateTime> selectedDate) {
    String startDate = '';
    String endDate = '';

    if (selectedDate.isNotEmpty) {
      for (int i = 0; i < selectedDate.length; i++) {
        var dateTime = selectedDate[i];
        if (selectedDate.length == 1) {
          // If there's only one date, set both startDate and endDate to the same value
          startDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          endDate = startDate;
        } else {
          if (i == 0) {
            // Set startDate to the first date
            startDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          } else {
            // Set endDate to the second date
            endDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
          }
        }
      }
    } else {
      // If no date is selected, set startDate and endDate to the current date
      DateTime dateTime = DateTime.now();
      startDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      endDate = startDate; // Set both dates to the current date
    }

    // Return both dates in a list
    return [startDate, endDate];
  }

  Future<void> pickFilesForDoc({bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  $fileList");

    // double totalFileSize = 0.0;

    fileList?.forEach((element) {
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

        // totalFileSize += _fileSize / (1024 * 1024);

        String? _filesizeString = _formatFileSize(_fileSize);
        double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

        String? _shortFileName;
        if (p.basename(_fileName).length > 15) {
          // Truncate the name to 12 characters and add ellipsis
          _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
        } else {
          _shortFileName = p.basename(_fileName); // Use the full name if it's already short
        }
        list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
      }

      list.refresh();
    });

    list.refresh();
    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(Get.context!);
      }
    }
  }

  Future<void> pickFiles(BuildContext context, {bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  $fileList");

    fileList?.forEach((element) {
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

        double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

        String? _shortFileName;
        if (p.basename(_fileName).length > 15) {
          // Truncate the name to 12 characters and add ellipsis
          _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
        } else {
          _shortFileName = p.basename(_fileName); // Use the full name if it's already short
        }
        list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true));
      }
    });
    list.refresh();
    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return attachmentDailog(this); // Our custom dialog
      },
    );
  }

  String getFileExtension(String filePath) {
    // Define image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];

    // Get the file extension
    String extension = p.extension(filePath);

    // Check if the extension is an image type
    if (imageExtensions.contains(extension.toLowerCase())) {
      return 'image'; // Return "image" if it's an image extension
    } else {
      return extension.replaceFirst('.', ''); // Return extension without dot
    }
  }

  String formatDateTime({required String firstDate, required String secondDate}) {
    if (firstDate != "" && secondDate != "") {
      // Parse the first and second arguments to DateTime objects
      DateTime firstDateTime = DateTime.parse(firstDate);
      DateTime secondDateTime = DateTime.parse(secondDate);

      // Format the first date (for month/day/year format)
      String formattedDate = DateFormat('MM/dd').format(firstDateTime);

      // Format the second time (for hours and minutes with am/pm)
      String formattedTime = DateFormat('h:mm a').format(secondDateTime.toLocal());

      // Return the formatted string in the desired format
      return '$formattedDate $formattedTime';
    } else {
      return "";
    }
  }

  String visitRecapformatDate({required String firstDate}) {
    if (firstDate != "") {
      // Parse the first and second arguments to DateTime objects
      DateTime firstDateTime = DateTime.parse(firstDate);

      // Format the first date (for month/day/year format)
      String formattedDate = DateFormat('MM/dd/yyyy').format(firstDateTime);

      // Return the formatted string in the desired format
      return formattedDate;
    } else {
      return "";
    }
  }

  @override
  void onReady() {
    super.onReady();

    customPrint("its on claaed");
  }

  @override
  void onClose() {
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.VISIT_MAIN) {
      globalController.popRoute();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // WakelockPlus.disable();
  }

  Future<void> onRefresh() async {
    customPrint("_onRefresh called");

    globalController.getDoctorsFilter();
    globalController.getMedicalAssistance();

    if (visitId.value.isNotEmpty) {
      customPrint("visit id is :- $visitId");
      //it  will check the internet  connection and handel   offline and online mode

      var status = await InternetConnection().internetStatus;

      isConnected.value = status == InternetStatus.disconnected ? false : true;

      if (status == InternetStatus.disconnected) {
        customPrint("you net is now Disconnected");

        offLine();
      } else {
        onLine(isLoading: true);
      }

      handelInternetConnection();

      List<AudioFile> pendingFiles = await DatabaseHelper.instance.getPendingAudioFiles();
      customPrint("local audio is :- $pendingFiles");
    }
  }

  Future<void> deleteAttachments(int id) async {
    Loader().showLoadingDialogForSimpleLoader();
    Map<String, List<int>> params = {};
    params["attachments"] = [id];

    customPrint("attch :- $params");
    CommonResponse commonResponse = await visitMainRepository.deleteAttachments(params: params);
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
          // offLine();

          break;
      }
    });
  }

  bool checkTotalSize() {
    double totalSize = 0.0;

    list.value.forEach((element) {
      totalSize += element.calculateSize ?? 0;
    });

    if (totalSize < 100) {
      return true;
    } else {
      return false;
    }
  }

  bool checkSingleSize() {
    bool isGraterThan10 = false;

    list.value.forEach((element) {
      if (element.isGraterThan10 ?? false) {
        isGraterThan10 = true;
      }
    });

    return isGraterThan10;
  }

  Future<void> uploadAttachments() async {
    if (checkTotalSize()) {
      if (checkSingleSize()) {
        CustomToastification().showToast("File Size must not exceed 10 MB", type: ToastificationType.error);
      } else {
        Get.back();
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
        await visitMainRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: patientId.value, params: {});
        list.clear();
        Get.back();
        getPatientAttachment();
      }
    } else {
      CustomToastification().showToast(" Total Files Size must not exceed 100 MB", type: ToastificationType.error);
    }
  }

  Future<void> getVisitRecap() async {
    customPrint("patientID is :- ${patientId.value}");
    visitRecapList.value = await visitMainRepository.getVisitRecap(id: patientId.value);
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

    if (isDateFilter.value) {
      param["dateRange[startDate]"] = attachmentStartDate;
      param["dateRange[endDate]"] = attachmentEndDate;
    }

    customPrint("param is :- $param");

    try {
      PatientAttachmentListModel patientAttachmentData = await visitMainRepository.getPatientAttachment(id: patientId.value, param: param);
      customPrint("patientAttachmentData success :- ${patientAttachmentData.toJson()}");
      patientAttachmentList.value = patientAttachmentData.responseData ?? [];
      customPrint("getPatientAttachment success :- ${patientAttachmentList.length}");
      patientAttachmentList.refresh();
    } catch (error) {
      customPrint("getPatientAttachment error is :- $error");
    }
    customPrint("patientAttachmentList is:- count ${patientAttachmentList.length}");
    customPrint("patientAttachmentList is:- ${patientAttachmentList.toJson()}");
  }

  void updateDoctorView(int id) async {
    Map<String, dynamic> param = {};
    // Map<String, List<File>> profileParams = {};
    if (id != -1) {
      param['doctor_id'] = id;
    }

    // if (patientId != "") {
    //   param['patient_id'] = patientId;
    // }
    // var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    try {
      dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId.value);

      CustomToastification().showToast("Update Doctor Successfully", type: ToastificationType.success);
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);
    }
  }

  void updateMedicalView(int id) async {
    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};
    if (id != -1) {
      param['medical_assistant_id'] = id;
    }

    try {
      dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId.value);

      CustomToastification().showToast("Update Medical Assistant Successfully", type: ToastificationType.success);
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);
    }
  }

  Future<void> getPatientDetails({bool isLoading = false}) async {
    if (isLoading) {
      Loader().showLoadingDialogForSimpleLoader();
    }

    try {
      Map<String, dynamic> param = {};

      if (visitId.value == "null") {
        param['patient_id'] = patientId.value;
      } else {
        param['visit_id'] = visitId.value;

        visitId.value;
      }

      patientData.value = await visitMainRepository.getPatientDetails(param: param);
      patientData.refresh();

      setPatientEditableData();
      customPrint("patientData age is :- ${patientData.value.responseData?.age}");

      if (patientData.value.responseData?.doctorId != null) {
        doctorValue.value = globalController.getDoctorNameById(patientData.value.responseData?.doctorId ?? -1) ?? "";
      }

      if (patientData.value.responseData?.medicalAssistantId != null) {
        medicationValue.value = globalController.getMedicalNameById(patientData.value.responseData?.medicalAssistantId ?? -1) ?? "select M.A";
      }

      customPrint("visit status is :- ${patientData.value.responseData?.visitStatus}");

      if (isLoading) {
        Get.back();
      }
    } catch (e) {
      if (isLoading) {
        customPrint("in the cathch ");

        Get.back();
      }
    }
  }

  Future<void> launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView, browserConfiguration: const BrowserConfiguration(showTitle: true))) {
      throw Exception('Could not launch $url');
    }
  }

  String visitDate(String? date) {
    String visitDate = "N/A";

    if (date != null) {
      DateTime visitdateTime = DateTime.parse(date ?? "");

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDate = visitformattedDate;
      return visitDate;
    } else {
      return "";
    }
  }

  String visitTime(String? time) {
    String visitTime = "N/A";

    if (time != null) {
      DateTime visitdateTime = DateTime.parse(time ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('hh:mm a');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitTime = visitformattedDate;
      return visitTime;
    } else {
      return "";
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

  Future<void> getMedicalRecords({required String id}) async {
    medicalRecords.value = await _editPatientDetailsRepository.getMedicalRecords(id: patientId.value);

    setMedicalHistroeyEditableData();
    medicalRecords.refresh();
  }

  void onLine({bool isLoading = false}) async {
    customPrint("now its disConnected");

    if (patientId.value.isNotEmpty && visitId.value != "null") {
      try {
        patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);
      } catch (e) {}

      getVisitRecap();
      getPatientAttachment();
      getMedicalRecords(id: patientId.value);
    } else {
      getPatientAttachment();
    }

    if (visitId.value.isNotEmpty) {
      getPatientDetails(isLoading: isLoading);
    }

    // CustomToastification().showToast(" Internet Connected", type: ToastificationType.info);
  }

  void offLine() async {
    var responseData = jsonDecode(AppPreference.instance.getString(AppString.offLineData));

    var visitRecapListResponse = fetchVisitDetails(type: scheduleVisitsList, modelType: visitRecaps, visitId: visitId.value, responseData: responseData);

    var patientDetailsResponse = fetchVisitDetails(type: scheduleVisitsList, modelType: visitMainData, visitId: visitId.value, responseData: responseData);

    var scheduleVisitResponse = fetchVisitDetails(type: scheduleVisitsList, modelType: scheduledVisits, visitId: visitId.value, responseData: responseData);

    var medicalRecords1 = fetchVisitDetails(type: scheduleVisitsList, modelType: fullNoteOfLastVisit, visitId: visitId.value, responseData: responseData);

    patientDetailModel.value = PatientDetailModel.fromJson(scheduleVisitResponse);

    visitRecapList.value = VisitRecapListModel.fromJson(visitRecapListResponse);

    patientData.value = VisitMainPatientDetails.fromJson(patientDetailsResponse);

    medicalRecords.value = MedicalRecords.fromJson(medicalRecords1);
  }

  Map<String, dynamic> fetchVisitDetails({required Map<String, dynamic> responseData, required String type, required String visitId, required String modelType}) {
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
        if (visitDetails[modelType] != null && visitDetails[modelType].isNotEmpty) {
          responseDataResult = visitDetails[modelType]; // Set the value to return
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
        "response_type": "success",
      };
    } else {
      return {"responseData": responseDataResult, "message": " Details Fetched Successfully", "toast": true, "response_type": "success"};
    }
  }

  Future<void> changeStatus(String status, String visitId) async {
    try {
      Map<String, dynamic> param = {};

      param['status'] = status;

      ChangeStatusModel changeStatusModel = await _homeRepository.changeStatus(id: visitId, params: param);
      if (changeStatusModel.responseType == "success") {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);
      } else {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      }
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);
    }

    patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);

    if (patientDetailModel.value?.responseData?.scheduledVisits?.isEmpty ?? false) {
      Get.back();
    }
  }

  void setPatientEditableData() {
    if (patientData.value.responseData?.visitSnapshot?.visitSnapshot != null) {
      editableVisitSnapShot.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientData.value.responseData?.visitSnapshot?.visitSnapshot ?? "");
      editableVisitSnapShot.add(ImpresionAndPlanViewModel(htmlContent: patientData.value.responseData?.visitSnapshot?.visitSnapshot ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableVisitSnapShot.refresh();
    }

    if (patientData.value.responseData?.personalNote?.personalNote != null) {
      editablePersnoalNote.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(patientData.value.responseData?.personalNote?.personalNote ?? "");
      editablePersnoalNote.add(ImpresionAndPlanViewModel(htmlContent: patientData.value.responseData?.personalNote?.personalNote ?? "", htmlEditorController: htmlEditorController, title: ""));
      editablePersnoalNote.refresh();
    }
  }

  void resetImpressionAndPlanList() {
    final editableLists = [editableVisitSnapShot, editablePersnoalNote, editableCancerHistory, editableMedicationHistory, editableSkinHistory, editableSocialHistory, editableAllergies];

    for (var list in editableLists) {
      for (var element in list) {
        element.isEditing = false;
      }
      list.refresh();
    }
  }

  void setMedicalHistroeyEditableData() {
    if (medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistoryHtml != null) {
      editableCancerHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "");
      editableCancerHistory.add(ImpresionAndPlanViewModel(htmlContent: medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableCancerHistory.refresh();
    }

    if (medicalRecords.value?.responseData?.fullNoteDetails?.newMedicationsHtml != null) {
      editableMedicationHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(medicalRecords.value?.responseData?.fullNoteDetails?.newMedicationsHtml ?? "");
      editableMedicationHistory.add(ImpresionAndPlanViewModel(htmlContent: medicalRecords.value?.responseData?.fullNoteDetails?.newMedicationsHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableMedicationHistory.refresh();
    }

    if (medicalRecords.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation != null) {
      editableSkinHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(medicalRecords.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "");
      editableSkinHistory.add(ImpresionAndPlanViewModel(htmlContent: medicalRecords.value?.responseData?.fullNoteDetails?.skinHistoryWithLocation ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableSkinHistory.refresh();
    }

    if (medicalRecords.value?.responseData?.fullNoteDetails?.socialHistoryHtml != null) {
      editableSocialHistory.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(medicalRecords.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "");
      editableSocialHistory.add(ImpresionAndPlanViewModel(htmlContent: medicalRecords.value?.responseData?.fullNoteDetails?.socialHistoryHtml ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableSocialHistory.refresh();
    }

    if (medicalRecords.value?.responseData?.fullNoteDetails?.allergies != null) {
      editableAllergies.clear();

      HtmlEditorController htmlEditorController = HtmlEditorController();
      htmlEditorController.setText(medicalRecords.value?.responseData?.fullNoteDetails?.allergies ?? "");
      editableAllergies.add(ImpresionAndPlanViewModel(htmlContent: medicalRecords.value?.responseData?.fullNoteDetails?.allergies ?? "", htmlEditorController: htmlEditorController, title: ""));
      editableAllergies.refresh();
    }
  }

  Map<String, String> buildParams(String keyName, List<ImpresionAndPlanViewModel> list) {
    return {keyName: list.firstOrNull?.htmlContent ?? ""};
  }
}
