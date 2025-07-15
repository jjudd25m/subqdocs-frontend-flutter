import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:path/path.dart' as p;
import 'package:siri_wave/siri_wave.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../football_game_live_activity_model.dart';
import '../../../widget/globle_attchmnets.dart';
import '../../data/service/database_helper.dart';
import '../../data/service/recorder_service.dart';
import '../../data/service/socket_service.dart';
import '../../models/ChangeModel.dart';
import '../../models/MedicalDoctorModel.dart';
import '../../models/ScheduleModel.dart';
import '../../models/SelectedDoctorMedicationModel.dart';
import '../../models/audio_wave.dart';
import '../../models/media_listing_model.dart';
import '../../modules/edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../modules/home/model/FilterListingModel.dart';
import '../../modules/home/model/home_past_patient_list_sorting_model.dart';
import '../../modules/home/model/home_patient_list_sorting_model.dart';
import '../../modules/home/model/home_schedule_list_sorting_model.dart';
import '../../modules/home/model/patient_list_model.dart';
import '../../modules/home/repository/home_repository.dart';
import '../../modules/login/model/login_model.dart';
import '../../modules/personal_setting/model/get_user_detail_model.dart';
import '../../modules/personal_setting/repository/personal_setting_repository.dart';
import '../../modules/visit_main/controllers/visit_main_controller.dart';
import '../../modules/visit_main/model/patient_transcript_upload_model.dart';
import '../../modules/visit_main/repository/visit_main_repository.dart';
import '../../routes/app_pages.dart';
import 'app_preferences.dart';
import 'logger.dart';

class GlobalController extends GetxController {
  // Rxn<GetUserDetailModel> getUserDetailModel = Rxn<GetUserDetailModel>();

  Rxn<GetOrganizationDetailModel> getEMAOrganizationDetailModel = Rxn<GetOrganizationDetailModel>();

  RxnString selectedLanguageValue = RxnString("English");
  List<String> languageList = ["English", "Muti Language"];
  RxBool isDropdownOpen = RxBool(false);

  static const platform = MethodChannel('com.subqdocs/shared');
  static const EventChannel eventChannel = EventChannel('com.subqdocs/audioEvents');
  StreamSubscription? eventSubscription;
  RxList<String> connectedMic = RxList();
  RxString selectedMic = RxString("");

  RxList<AudioWaveBar> samples = RxList([]);

  // var breadcrumbHistory = <String>[];

  RxnInt selectedRowIndex = RxnInt();

  bool isProd = false;

  SuggestionsController<PatientListData> suggestionsController = SuggestionsController();

  Rxn<PatientListData> searchText = Rxn();

  RxBool isLoading = RxBool(false);
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();

  RxInt tabIndex = RxInt(1);
  Map<String, String> breadcrumbs = {Routes.HOME: 'Patients & Visits', Routes.ADD_PATIENT: 'Add New', Routes.EDIT_PATENT_DETAILS: 'Edit Patient Information', Routes.VISIT_MAIN: 'Medical Record', Routes.PATIENT_INFO: 'Visit Documents', Routes.PATIENT_PROFILE: 'Patient Profile', Routes.ALL_ATTACHMENT: 'Attachments', Routes.SCHEDULE_PATIENT: 'Schedule Visit', Routes.PERSONAL_SETTING: 'Settings'};

  int closeFormState = 0;

  //all variable for the model recording
  //   --------------------------------------------------------------------------------------------------------------------------------------------------
  RxBool isStartTranscript = RxBool(false);
  Rxn<MedicalDoctorModel> doctorListModel = Rxn<MedicalDoctorModel>();
  Rxn<GetUserDetailModel> getUserDetailModel = Rxn<GetUserDetailModel>();
  RxList<PatientListData> patientList = RxList<PatientListData>();

  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
  Rxn<MedicalDoctorModel> medicalListModel = Rxn<MedicalDoctorModel>();
  RxBool isStartRecording = false.obs;
  RxBool isExpandRecording = true.obs;
  RecorderService recorderService = RecorderService();

  final VisitMainRepository visitMainRepository = VisitMainRepository();
  final HomeRepository _homeRepository = HomeRepository();

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();
  static const ROLE_DOCTOR = "Doctor";
  static const ROLE_MEDICAL_ASSISTANT = "Medical Assistant";

  RxDouble valueOfx = RxDouble(0);
  RxDouble valueOfy = RxDouble(0);

  RxString visitId = RxString("");
  RxString patientId = RxString("");
  RxString attachmentId = RxString("");
  RxString patientFirstName = RxString("");
  RxString patientLsatName = RxString("");

  RxList<MediaListingModel> list = RxList();

  final liveActivitiesPlugin = LiveActivities();
  String? latestActivityId;
  StreamSubscription<UrlSchemeData>? urlSchemeSubscription;
  FootballGameLiveActivityModel? footballGameLiveActivityModel;

  static const subqdocsChannel = MethodChannel('com.subqdocs/shared');

  RxList<SelectedDoctorModel> selectedDoctorModel = RxList<SelectedDoctorModel>();
  RxList<SelectedDoctorModel> selectedMedicalModel = RxList<SelectedDoctorModel>();

  RxList<SelectedDoctorModel> selectedDoctorModelSchedule = RxList<SelectedDoctorModel>();
  RxList<SelectedDoctorModel> selectedMedicalModelSchedule = RxList<SelectedDoctorModel>();

  Rxn<ScheduleModel> scheduleVisitModel = Rxn();

  IOS7SiriWaveformController waveController = IOS7SiriWaveformController(amplitude: 0, color: Colors.red, frequency: 2, speed: 0.3);

  double adjustYPosition(double yPosition, BuildContext context) {
    // Get the height of the screen

    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate the threshold for the bottom 400px
    double bottomThreshold = screenHeight - 600;

    // If the yPosition exceeds the threshold (more than 400px from the bottom), adjust it
    if (yPosition > bottomThreshold) {
      // Adjust the position to be exactly 400px above the bottom
      return bottomThreshold;
    } else {
      // Return the original yPosition if it's within the last 400px from the bottom
      return yPosition;
    }
  }

  double snapXToEdge(double xPosition, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Snap directly to left edge if closer or right edge otherwise
    return (xPosition < screenWidth / 2) ? 0 : screenWidth;
  }



  void reinitController() {
    waveController = IOS7SiriWaveformController(amplitude: 0, color: AppColors.backgroundPurple, frequency: 3, speed: 0.9);
  }

  // below  all the function is for the recording model
  // ----------------------------------------------------------------------------------------------------------------------------------------------------

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return GlobleAttchmnets(); // Our custom dialog
      },
    );
  }

  void wipeData() {
    patientId.value = "";
    attachmentId.value = "";
    visitId.value = "";
    patientFirstName.value = "";
    patientLsatName.value = "";
    valueOfx.value = 0;
    valueOfy.value = 0;
  }

  Future<void> getMedicalAssistance() async {
    try {
      Map<String, dynamic> param = {};

      param['role'] = ROLE_MEDICAL_ASSISTANT;
      medicalListModel.value = await _homeRepository.getDoctorsAndMedicalAssistant(param: param);

      if (medicalListModel.value?.responseType == "success") {
        selectedMedicalModel.clear();
        selectedMedicalModelSchedule.clear();
        medicalListModel.value?.responseData?.forEach((element) {
          selectedMedicalModel.add(SelectedDoctorModel(id: element.id, name: element.name, profileImage: element.profileImage, isDeleted: element.deletedAt ?? ""));
          selectedMedicalModelSchedule.add(SelectedDoctorModel(id: element.id, name: element.name, profileImage: element.profileImage));

          setMedicalModel();
          setMedicalModelSchedule();
        });
      }
    } catch (e) {
      customPrint("$e");
    }
  }

  Future<void> getUserDetail() async {
    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
      customPrint("login data :- ${loginData.toJson()}");
      getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.responseData?.user?.id.toString() ?? "");

      customPrint("global controller:- ${getUserDetailModel.value?.toJson()}");
    } catch (e) {
      customPrint("error on global controller getUserDetail");
      customPrint(e);
    }
  }

  Future<void> getDoctorsFilter() async {
    try {
      Map<String, dynamic> param = {};

      param['role'] = ROLE_DOCTOR;
      doctorListModel.value = await _homeRepository.getDoctorsAndMedicalAssistant(param: param);

      print("doctor list is:- ${doctorListModel.value?.toJson()}");

      if (doctorListModel.value?.responseType == "success") {
        selectedDoctorModel.clear();
        selectedDoctorModelSchedule.clear();
        doctorListModel.value?.responseData?.forEach((element) {
          selectedDoctorModel.add(SelectedDoctorModel(id: element.id, name: element.name, profileImage: element.profileImage, isDeleted: element.deletedAt ?? "false"));
          selectedDoctorModelSchedule.add(SelectedDoctorModel(id: element.id, name: element.name, profileImage: element.profileImage));

          setDoctorModel();
          setDoctorModelSchedule();
        });
      }
    } catch (e) {
      customPrint("$e");
    }
  }

  Future<void> changeStatus(String status) async {
    try {
      Loader().showLoadingDialogForSimpleLoader();

      Map<String, dynamic> param = {};

      param['status'] = status;

      print("pram is:- $param");
      print("visit id for quick is ${visitId.value} ");

      ChangeStatusModel changeStatusModel = await visitMainRepository.changeStatus(id: visitId.value, params: param);

      Loader().stopLoader();
      if (changeStatusModel.responseType == "success") {
        // Get.back();
        // Get.back();
        // CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);

        if (Get.currentRoute == Routes.VISIT_MAIN) {
          Get.find<VisitMainController>(tag: Get.arguments["unique_tag"]).updateData();
        }
      } else {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
        // Get.back();
        // Get.back();
      }
    } catch (e) {
      customPrint("catch changeStatus for global controller ${e.toString()}");
      Loader().stopLoader();
      CustomToastification().showToast(e.toString(), type: ToastificationType.error);
      // Get.back();
    }
  }

  Future<void> stopLiveActivityAudio() async {
    liveActivitiesPlugin.endAllActivities();
    latestActivityId = null;
  }

  Future<void> startAudioWidget() async {
    customPrint("audio time is :- ${recorderService.formattedRecordingTime}");

    footballGameLiveActivityModel = FootballGameLiveActivityModel(userName: "${patientFirstName.value} ${patientLsatName.value}", recordingTime: recorderService.formattedRecordingTime, resumeRecording: recorderService.recordingStatus.value.toString());

    customPrint("footballGameLiveActivityModel is :- ${footballGameLiveActivityModel?.toMap()}");
    final activityId = await liveActivitiesPlugin.createActivity(footballGameLiveActivityModel?.toMap() ?? {});

    liveActivitiesPlugin.activityUpdateStream.listen((event) {
      customPrint("activityUpdateStream event is:- $event");
    });

    recorderService.updatedRecordingTime.listen((p0) {
      final data = footballGameLiveActivityModel!.copyWith(userName: "${patientFirstName.value} ${patientLsatName.value}", recordingTime: p0, resumeRecording: recorderService.recordingStatus.value.toString());
      liveActivitiesPlugin.updateActivity(latestActivityId!, data.toMap());
    });

    // String = updatedRecordingTime;

    latestActivityId = activityId;
  }

  // Listen for native event when userName is updated
  void listenForUserNameUpdate() {
    subqdocsChannel.setMethodCallHandler((call) async {
      if (call.method == 'onUserNameUpdated') {
        // Data updated, handle it in Flutter
        customPrint("User Name Updated in native code!");
        // You can refresh your UI or take any necessary action here
      }
    });
  }

  Future<void> updatePauseResumeAudioWidget() async {
    if (recorderService.recordingStatus.value == 1) {
      final data = FootballGameLiveActivityModel(userName: "${patientFirstName.value} ${patientLsatName.value}", recordingTime: recorderService.formattedRecordingTime, resumeRecording: "2");
      liveActivitiesPlugin.updateActivity(latestActivityId!, data.toMap());
    } else {
      final data = FootballGameLiveActivityModel(userName: "${patientFirstName.value} ${patientLsatName.value}", recordingTime: recorderService.formattedRecordingTime, resumeRecording: "1");
      liveActivitiesPlugin.updateActivity(latestActivityId!, data.toMap());
    }
  }

  Future<void> submitAudio(File audioFile) async {
    if (audioFile.path.isEmpty) {
      return;
    }

    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      customPrint("internet not available ");
      // isLoading.value = true;
      // loadingMessage.value = "Uploading Audio";
      Loader().showLoadingDialogForSimpleLoader();

      Uint8List audioBytes = await audioFile.readAsBytes(); // Read audio file as bytes

      AudioFile audioFileToSave = AudioFile(audioData: audioBytes, fileName: audioFile.path, status: 'pending', visitId: visitId.value);

      await DatabaseHelper.instance.insertAudioFile(audioFileToSave);

      // Show a message or update UI
      // loadingMessage.value = "Audio saved locally. Will upload when internet is available.";
      // isLoading.value = false;

      Get.back();

      CustomToastification().showToast("Audio saved locally. Will upload when internet is available.", type: ToastificationType.success);

      List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();

      for (var file in audio) {
        customPrint("audio data is:-  ${file.visitId} ${file.fileName} ${file.id}");
      }
    } else {
      customPrint("internet available");
      // isLoading.value = true;
      // loadingMessage.value = "Uploading Audio";
      Loader().showLoadingDialogForSimpleLoader();
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      try {
        PatientTranscriptUploadModel patientTranscriptUploadModel = await visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
        Loader().stopLoader();

        LoginModel loginInfo = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

        loginInfo.responseData?.user?.is_multi_language_preference = getUserDetailModel.value?.responseData?.is_multi_language_preference ?? false;

        await AppPreference.instance.setString(AppString.prefKeyUserLoginData, json.encode(loginInfo.toJson()));

        // getUserDetail();
        customPrint("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

        // isLoading.value = false;

        isStartTranscript.value = false;
        wipeData();

        if (Get.currentRoute == Routes.PATIENT_INFO) {
          Get.until((route) => Get.currentRoute == Routes.HOME);

          // Get.until(Routes.HOME, (route) => false);
          breadcrumbHistory.clear();
          addRoute(Routes.HOME);
          // addRoute(Routes.PATIENT_INFO);

          await Get.toNamed(Routes.PATIENT_INFO, arguments: {"trascriptUploadData": patientTranscriptUploadModel, "unique_tag": DateTime.now().toString()});
        } else {
          await Get.toNamed(Routes.PATIENT_INFO, arguments: {"trascriptUploadData": patientTranscriptUploadModel, "unique_tag": DateTime.now().toString()});
        }

        if (Get.currentRoute == Routes.VISIT_MAIN) {
          // Get.find<VisitMainController>().getPatientDetails();
          Get.find<VisitMainController>(tag: Get.arguments["unique_tag"]).getPatientDetails();
        }
      } catch (e) {
        customPrint("Audio failed error is :- $e");
        Loader().stopLoader();
      }
    }
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
        Map<String, dynamic> params = {};
        bool shouldAdd = true;
        if (list.isNotEmpty) {
          customPrint("profile is   available");
          // param['profile_image'] = profileImage.value;
          profileParams['attachments'] = list.map((model) => model.file).toList().whereType<File>().toList();
          for (int i = 0; i < list.length; i++) {
            params['timestamp_$i'] = list[i].time;
            if (list[i].time == "00:00:00") {
              shouldAdd = false;
            }
          }
          if (shouldAdd) {
            params['visit_id'] = visitId.value;
          }
          customPrint("visit_id: ${visitId.value} + patient_id: ${attachmentId.value}");
        } else {
          customPrint("profile is not  available");
        }
        await visitMainRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: attachmentId.value, params: params);
        list.clear();
        Get.back();

        if (Get.currentRoute == Routes.VISIT_MAIN) {
          // Get.find<VisitMainController>().getPatientAttachment();

          Get.find<VisitMainController>(tag: Get.arguments["unique_tag"]).getPatientAttachment();
        }
      }
    } else {
      CustomToastification().showToast(" Total Files Size must not exceed 100 MB", type: ToastificationType.error);
    }
  }

  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  double _formatFileSizeDouble(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return (sizeInMB * 100).roundToDouble() / 100;
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
        _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
      } else {
        _shortFileName = p.basename(_fileName); // Use the full name if it's already short
      }
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), Size: _filesizeString));
    }

    list.refresh();

    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  // ---------------------------------------------------------------------------------------------------------------------------------------------------

  void popUntilRoute(String targetRoute) {
    int targetIndex = breadcrumbHistory.indexOf(targetRoute);
    if (targetIndex != -1) {
      // Pop screens above the target route
      breadcrumbHistory.removeRange(targetIndex + 1, breadcrumbHistory.length); // Remove all screens above the target route
      breadcrumbHistory.refresh();
      customPrint('Popped screens above: $targetRoute');
      // closeFormState = 0;
      // Optionally, navigate to the target route after popping
      // Get.toNamed(targetRoute);
    } else {
      customPrint('Target route not found in history');
      breadcrumbHistory.refresh();
    }
  }

  int getDoctorIdByName(String? name) {
    customPrint("medical name $name");

    if (name == null) {
      return -1;
    }

    if (name.trim().isEmpty) {
      return -1;
    }

    final doctor = selectedDoctorModel.firstWhereOrNull(
      (doctor) => doctor.name != null && doctor.name!.toLowerCase().contains(name!.toLowerCase()),
      // Return null if no match is found
    );

    // Return the id if doctor is found, otherwise return null
    return doctor?.id ?? -1;
  }

  int getDoctorIdByNameSchedule(String? name) {
    final doctor = selectedDoctorModelSchedule.firstWhereOrNull(
      (doctor) => doctor.name != null && doctor.name!.toLowerCase().contains(name!.toLowerCase()),
      // Return null if no match is found
    );

    // Return the id if doctor is found, otherwise return null
    return doctor?.id ?? -1;
  }

  String? getDoctorNameById(int id) {
    // Find the first doctor where the id matches
    final doctor = selectedDoctorModel.firstWhereOrNull(
      (doctor) => doctor.id == id, // Compare the id
    );

    // Return the name of the doctor if found, otherwise return null
    return doctor?.name;
  }

  String? getDoctorNameByIdSchedule(int id) {
    // Find the first doctor where the id matches
    final doctor = selectedDoctorModelSchedule.firstWhereOrNull(
      (doctor) => doctor.id == id, // Compare the id
    );

    // Return the name of the doctor if found, otherwise return null
    return doctor?.name;
  }

  String? getMedicalNameById(int id) {
    // Find the first doctor where the id matches
    final doctor = selectedMedicalModel.firstWhereOrNull(
      (doctor) => doctor.id == id, // Compare the id
    );

    // Return the name of the doctor if found, otherwise return null
    return doctor?.name;
  }

  String? getMedicalNameByIdSchedule(int id) {
    // Find the first doctor where the id matches
    final doctor = selectedMedicalModelSchedule.firstWhereOrNull(
      (doctor) => doctor.id == id, // Compare the id
    );

    // Return the name of the doctor if found, otherwise return null
    return doctor?.name;
  }

  int getMedicalIdByName(String? name) {
    customPrint("medical name $name");

    if (name == null) {
      return -1;
    }

    if (name.trim().isEmpty) {
      return -1;
    }

    final doctor = selectedMedicalModel.firstWhereOrNull(
      (doctor) => doctor.name != null && doctor.name!.toLowerCase().contains(name!.toLowerCase()),
      // Return null if no match is found
    );

    // Return the id if doctor is found, otherwise return null
    return doctor?.id ?? -1;
  }

  int getMedicalIdByNameSchedule(String? name) {
    final doctor = selectedMedicalModelSchedule.firstWhereOrNull(
      (doctor) => doctor.name != null && doctor.name!.toLowerCase().contains(name!.toLowerCase()),
      // Return null if no match is found
    );

    // Return the id if doctor is found, otherwise return null
    return doctor?.id ?? -1;
  }

  RxList<String> breadcrumbHistory = RxList([]);

  // as of now dont use furher this  function
  void addRoute(String route) {
    // breadcrumbHistory.add(breadcrumbs[route] ?? route);
  }

  void addRouteInit(String route) {
    closeFormState = 1;

    breadcrumbHistory.add(breadcrumbs[route] ?? route);
  }

  String getKeyByValue(String value) {
    // Iterate over the map and check for a match
    return breadcrumbs.keys.firstWhere((key) => breadcrumbs[key] == value, orElse: () => 'Not Found');
  }

  // Pop the last route from the stack
  void popRoute() {
    // if(closeFormState == 1) {
    if (breadcrumbHistory.isNotEmpty) {
      var poppedRoute = breadcrumbHistory.removeLast();
      customPrint('Popped Route: $poppedRoute');
    } else {
      customPrint('Route stack is empty!');
    }
    // }else{
    //   closeFormState = 1;
    //
    // }
  }

  // Get the current route stack
  List<String> getRouteStack() {
    return breadcrumbHistory;
  }

  // Optionally, clear the entire stack
  void clearStack() {
    breadcrumbHistory.clear();
    customPrint('Cleared route stack');
  }

  List<Map<String, dynamic>> sortingPastPatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "previousVisitCount", "desc": true},
    {"id": "doctorName", "desc": true},
    {"id": "status", "desc": true},
  ];

  RxList<FilterListingModel> pastFilterListingModel = RxList([]);
  RxList<FilterListingModel> scheduleFilterListingModel = RxList([]);

  List<Map<String, dynamic>> sortingSchedulePatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "doctorName", "desc": true},
    {"id": "previousVisitCount", "desc": true},
  ];

  List<Map<String, dynamic>> sortingPatientList = [
    {"id": "first_name", "desc": true},
    {"id": "lastVisitDate", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "doctorName", "desc": true},
    {"id": "visitCount", "desc": true},
  ];

  List<Map<String, dynamic>> patientListSelectedSorting = [];
  List<Map<String, dynamic>> scheduleVisitSelectedSorting = [
    {"id": "appointmentTime", "desc": false},
  ];

  List<Map<String, dynamic>> pastVisitSelectedSorting = [
    {"id": "appointmentTime", "desc": "true"},
  ];

  Rxn<HomePastPatientListSortingModel> homePastPatientListSortingModel = Rxn();
  Rxn<HomePatientListSortingModel> homePatientListSortingModel = Rxn();
  Rxn<HomeScheduleListSortingModel> homeScheduleListSortingModel = Rxn();
  SocketService socketService = SocketService();

  @override
  void onInit() async {
    super.onInit();

    HomePastPatientListSortingModel? homePastPatientData = await AppPreference.instance.getHomePastPatientListSortingModel();
    if (homePastPatientData != null) {
      homePastPatientListSortingModel.value = homePastPatientData;
      customPrint("existing HomePastPatientListSortingModel:- ${homePastPatientData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['sortingPastPatient'] = sortingPastPatient;
      json['pastVisitSelectedSorting'] = pastVisitSelectedSorting;
      json['colIndex'] = 1;
      json['isAscending'] = true;
      json['selectedStatusIndex'] = ["Pending"];
      json['selectedMedicationId'] = [];
      json['selectedDoctorId'] = [];
      json['selectedDateValue'] = [];

      json['startDate'] = "";
      json['endDate'] = "";
      homePastPatientListSortingModel.value = HomePastPatientListSortingModel.fromJson(json);
      customPrint("first initialize homePastPatientListSortingModel :- $json");
    }

    HomePatientListSortingModel? homePatientListData = await AppPreference.instance.getHomePatientListSortingModel();
    if (homePatientListData != null) {
      homePatientListSortingModel.value = homePatientListData;
      customPrint("existing HomePatientListSortingModel:- ${homePatientListData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['sortingPatientList'] = sortingPatientList;
      json['patientListSelectedSorting'] = patientListSelectedSorting;
      json['colIndex'] = -1;
      json['isAscending'] = true;
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['endDate'] = "";
      homePatientListSortingModel.value = HomePatientListSortingModel.fromJson(json);
      customPrint("first initialize homePatientListSortingModel :- $json");
    }

    HomeScheduleListSortingModel? homeScheduleListData = await AppPreference.instance.getHomeScheduleListSortingModel();
    if (homeScheduleListData != null) {
      homeScheduleListSortingModel.value = homeScheduleListData;
      customPrint("existing HomeScheduleListSortingModel:- ${homeScheduleListData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['scheduleVisitSelectedSorting'] = scheduleVisitSelectedSorting;
      json['sortingSchedulePatient'] = sortingSchedulePatient;
      json['colIndex'] = 1;
      json['isAscending'] = false;
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['selectedMedicationId'] = [];
      json['selectedDoctorId'] = [];
      json['endDate'] = "";
      homeScheduleListSortingModel.value = HomeScheduleListSortingModel.fromJson(json);
      customPrint("first initialize homeScheduleListSortingModel :- $json");
    }

    socketService.openAISocket.onConnect((_) {
      customPrint('global openAISocket connect');
      // socket.emit('msg', 'test');
    });

    socketService.openAISocket.on('connect', (_) {
      customPrint('global openAISocket socket connected');
    });

    socketService.openAISocket.onConnectError((data) {
      print("connection openAISocket error :- ${data}");
    });

    socketService.openAISocket.on('disconnect', (_) {
      customPrint('global openAISocket Socket disconnected');
    });

    socketService.openAISocket.on('error', (err) {
      customPrint('global openAISocket Socket error: $err');
    });

    socketService.openAISocket.on("openaiStatusUpdate", (data) {
      customPrint('global openAISocket Socket Open Ai server status $data');
      var res = data as Map<String, dynamic>;
      customPrint('Open Ai server status $res');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomToastification().showChatGPTDownBanner();
      });
    });

    setPastListingModel();
    setScheduleListingModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("global controller disponse");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    print("global controller close");
  }

  Future<void> startMicListening() async {
    await platform.invokeMethod('startAudioRouteListening');
    setupEventListener();
    await getActiveMicrophoneName();
  }

  void setupEventListener() {
    eventSubscription = eventChannel.receiveBroadcastStream().listen(
      (event) async {
        customPrint(" Received event from iOS: $event");
        if (event == 'audioDevicesChanged') {
          await getConnectedInputDevices();
        } else if (event == "bluetoothAudioDevicesChanged") {
          await getConnectedInputDevices();
          await getActiveMicrophoneName();
        }
      },
      onError: (error) {
        customPrint(" EventChannel error: $error");
      },
    );
  }

  Future<void> stopMicListening() async {
    await platform.invokeMethod('stopAudioRouteListening');
    eventSubscription?.cancel();
  }

  Future<void> getConnectedInputDevices() async {
    try {
      final List devices = await platform.invokeMethod('getAudioInputDevices');
      connectedMic.value = devices.cast<String>();

      connectedMic.refresh();
      customPrint(devices);
    } on PlatformException catch (e) {
      customPrint("Failed to get audio devices: '${e.message}'.");
    }
  }

  Future<bool> setPreferredAudioInput(String portName) async {
    try {
      final bool result = await platform.invokeMethod('setPreferredAudioInput', portName);
      customPrint(result);
      return result;
    } on PlatformException catch (e) {
      customPrint('Error setting preferred input: $e');
      return false;
    }
  }

  Future<void> getActiveMicrophoneName() async {
    final String result = await platform.invokeMethod('getActiveMicrophoneName');
    customPrint(result);
    selectedMic.value = result;
  }

  void setDoctorModel() {
    var selectedDoctorIds = Set<int>.from(homePastPatientListSortingModel.value!.selectedDoctorId ?? []);

    // Loop through doctor models and mark them as selected if their ID exists in the set
    for (var doctorModel in selectedDoctorModel) {
      doctorModel.isSelected = selectedDoctorIds.contains(doctorModel.id);
    }
  }

  void setDoctorModelSchedule() {
    var selectedDoctorIds = Set<int>.from(homeScheduleListSortingModel.value!.selectedDoctorId ?? []);

    // Loop through doctor models and mark them as selected if their ID exists in the set
    for (var doctorModel in selectedDoctorModelSchedule) {
      doctorModel.isSelected = selectedDoctorIds.contains(doctorModel.id);
    }
  }

  void setMedicalModel() {
    var selectedMedicalIds = Set<int>.from(homePastPatientListSortingModel.value!.selectedMedicationId ?? []);

    // Loop through doctor models and mark them as selected if their ID exists in the set
    for (var medicalModel in selectedMedicalModel) {
      medicalModel.isSelected = selectedMedicalIds.contains(medicalModel.id);
    }
  }

  void setMedicalModelSchedule() {
    var selectedMedicalIds = Set<int>.from(homeScheduleListSortingModel.value!.selectedMedicationId ?? []);

    // Loop through doctor models and mark them as selected if their ID exists in the set
    for (var medicalModel in selectedMedicalModelSchedule) {
      medicalModel.isSelected = selectedMedicalIds.contains(medicalModel.id);
    }
  }

  void setPastListingModel() {
    pastFilterListingModel.clear();

    if ((homePastPatientListSortingModel.value?.selectedStatusIndex ?? []).isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Status", filterValue: homePastPatientListSortingModel.value!.selectedStatusIndex!.join(",")));
    }

    if ((homePastPatientListSortingModel.value?.selectedMedicationNames ?? []).isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Medical Assistant", filterValue: homePastPatientListSortingModel.value!.selectedMedicationNames!.join(",")));
    }

    if ((homePastPatientListSortingModel.value?.selectedDoctorNames ?? []).isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Doctor", filterValue: homePastPatientListSortingModel.value!.selectedDoctorNames!.join(",")));
    }

    if ((homePastPatientListSortingModel.value?.startDate ?? "").isNotEmpty && (homePastPatientListSortingModel.value?.endDate ?? "").isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Visit Date", filterValue: "${homePastPatientListSortingModel.value?.startDate} - ${homePastPatientListSortingModel.value?.endDate} "));
    }
  }

  void setScheduleListingModel() {
    scheduleFilterListingModel.clear();

    if ((homeScheduleListSortingModel.value?.startDate ?? "").isNotEmpty && (homeScheduleListSortingModel.value?.endDate ?? "").isNotEmpty) {
      scheduleFilterListingModel.add(FilterListingModel(filterName: "Visit Date", filterValue: "${homeScheduleListSortingModel.value?.startDate} - ${homeScheduleListSortingModel.value?.endDate} "));
    }

    if ((homeScheduleListSortingModel.value?.selectedMedicationNames ?? []).isNotEmpty) {
      scheduleFilterListingModel.add(FilterListingModel(filterName: "Medical Assistant", filterValue: homeScheduleListSortingModel.value!.selectedMedicationNames!.join(",")));
    }

    if ((homeScheduleListSortingModel.value?.selectedDoctorNames ?? []).isNotEmpty) {
      scheduleFilterListingModel.add(FilterListingModel(filterName: "Doctor", filterValue: homeScheduleListSortingModel.value!.selectedDoctorNames!.join(",")));
    }
  }

  void saveMedicalFilter({required int selectedId, required String name}) {
    homePastPatientListSortingModel.value?.selectedMedicationId?.add(selectedId);
    homePastPatientListSortingModel.value?.selectedMedicationNames?.add(name);
    saveHomePastPatientData();
  }

  void saveMedicalFilterSchedule({required int selectedId, required String name}) {
    homeScheduleListSortingModel.value?.selectedMedicationId?.add(selectedId);
    homeScheduleListSortingModel.value?.selectedMedicationNames?.add(name);

    saveHomeScheduleListData();
  }

  void removeMedicalFilterByIndex({required int index}) {
    homePastPatientListSortingModel.value?.selectedMedicationId?.removeAt(index);
    homePastPatientListSortingModel.value?.selectedMedicationNames?.removeAt(index);

    selectedMedicalModel.refresh();
    homePastPatientListSortingModel.refresh();
    saveHomePastPatientData();
  }

  void removeMedicalFilterByIndexSchedule({required int index}) {
    homeScheduleListSortingModel.value?.selectedMedicationId?.removeAt(index);
    homeScheduleListSortingModel.value?.selectedMedicationNames?.removeAt(index);

    selectedMedicalModelSchedule.refresh();
    homeScheduleListSortingModel.refresh();
    saveHomeScheduleListData();
  }

  void removeDoctorFilterByIndex({required int index}) {
    homePastPatientListSortingModel.value?.selectedDoctorNames?.removeAt(index);
    homePastPatientListSortingModel.value?.selectedDoctorId?.removeAt(index);
    selectedDoctorModel.refresh();
    homePastPatientListSortingModel.refresh();
    saveHomePastPatientData();
  }

  void removeDoctorFilterByIndexSchedule({required int index}) {
    homeScheduleListSortingModel.value?.selectedDoctorNames?.removeAt(index);
    homeScheduleListSortingModel.value?.selectedDoctorId?.removeAt(index);
    selectedDoctorModelSchedule.refresh();
    homeScheduleListSortingModel.refresh();

    saveHomeScheduleListData();
  }

  void removeStatusFilterByIndex({required int index}) {
    homePastPatientListSortingModel.value?.selectedStatusIndex?.removeAt(index);

    homePastPatientListSortingModel.refresh();

    saveHomePastPatientData();
  }

  void saveDoctorFilter({required int selectedId, required String name}) {
    homePastPatientListSortingModel.value?.selectedDoctorId?.add(selectedId);
    homePastPatientListSortingModel.value?.selectedDoctorNames?.add(name);
    saveHomePastPatientData();
  }

  void saveDoctorFilterSchedule({required int selectedId, required String name}) {
    homeScheduleListSortingModel.value?.selectedDoctorId?.add(selectedId);
    homeScheduleListSortingModel.value?.selectedDoctorNames?.add(name);

    saveHomeScheduleListData();
  }

  void removeDoctorFilter({required int selectedId, required String name}) {
    homePastPatientListSortingModel.value?.selectedDoctorId?.removeWhere((element) {
      return element == selectedId;
    });
    homePastPatientListSortingModel.value?.selectedDoctorNames?.removeWhere((element) {
      return element == name;
    });
    saveHomePastPatientData();
  }

  void removeDoctorFilterSchedule({required int selectedId, required String name}) {
    homeScheduleListSortingModel.value?.selectedDoctorId?.removeWhere((element) {
      return element == selectedId;
    });
    homeScheduleListSortingModel.value?.selectedDoctorNames?.removeWhere((element) {
      return element == name;
    });

    saveHomeScheduleListData();
  }

  void removeMedicalFilter({required int selectedId, required String name}) {
    homePastPatientListSortingModel.value?.selectedMedicationId?.removeWhere((element) {
      return element == selectedId;
    });
    homePastPatientListSortingModel.value?.selectedMedicationNames?.removeWhere((element) {
      return element == name;
    });
    saveHomePastPatientData();
  }

  void removeMedicalFilterSchedule({required int selectedId, required String name}) {
    homeScheduleListSortingModel.value?.selectedMedicationId?.removeWhere((element) {
      return element == selectedId;
    });
    homeScheduleListSortingModel.value?.selectedMedicationNames?.removeWhere((element) {
      return element == name;
    });

    saveHomeScheduleListData();
  }

  void removePastFilter({String? keyName}) {
    if (keyName != null) {
      if (keyName == "Visit Date") {
        homePastPatientListSortingModel.value?.startDate = "";
        homePastPatientListSortingModel.value?.endDate = "";
        homePastPatientListSortingModel.value?.selectedDateValue = [];
      }

      if (keyName == "Status") {
        homePastPatientListSortingModel.value?.selectedStatusIndex = [];
      }

      if (keyName == "Medical Assistant") {
        homePastPatientListSortingModel.value?.selectedMedicationNames = [];
        homePastPatientListSortingModel.value?.selectedMedicationId = [];
        setMedicalModel();
      }

      if (keyName == "Doctor") {
        homePastPatientListSortingModel.value?.selectedDoctorNames = [];
        homePastPatientListSortingModel.value?.selectedDoctorId = [];
        setDoctorModel();
      }
      saveHomePastPatientData();
    } else {
      homePastPatientListSortingModel.value?.startDate = "";
      homePastPatientListSortingModel.value?.selectedDoctorNames = [];
      homePastPatientListSortingModel.value?.selectedDoctorId = [];
      homePastPatientListSortingModel.value?.selectedMedicationNames = [];
      homePastPatientListSortingModel.value?.selectedMedicationId = [];

      homePastPatientListSortingModel.value?.endDate = "";
      homePastPatientListSortingModel.value?.selectedStatusIndex = [];
      homePastPatientListSortingModel.value?.selectedDateValue = [];

      setMedicalModel();
      setDoctorModel();
      saveHomePastPatientData();
    }
  }

  void removeScheduleFilter({String? keyName}) {
    if (keyName != null) {
      if (keyName == "Visit Date") {
        homeScheduleListSortingModel.value?.startDate = "";
        homeScheduleListSortingModel.value?.endDate = "";
        homeScheduleListSortingModel.value?.selectedDateValue = [];
      }

      if (keyName == "Medical Assistant") {
        homeScheduleListSortingModel.value?.selectedMedicationNames = [];
        homeScheduleListSortingModel.value?.selectedMedicationId = [];
        setMedicalModelSchedule();
      }

      if (keyName == "Doctor") {
        homeScheduleListSortingModel.value?.selectedDoctorNames = [];
        homeScheduleListSortingModel.value?.selectedDoctorId = [];
        setDoctorModelSchedule();
      }

      saveHomeScheduleListData();
    } else {
      homeScheduleListSortingModel.value?.startDate = "";
      homeScheduleListSortingModel.value?.endDate = "";
      homeScheduleListSortingModel.value?.selectedDateValue = [];
      homeScheduleListSortingModel.value?.selectedDoctorNames = [];
      homeScheduleListSortingModel.value?.selectedDoctorId = [];
      homeScheduleListSortingModel.value?.selectedMedicationNames = [];
      homeScheduleListSortingModel.value?.selectedMedicationId = [];

      saveHomeScheduleListData();
    }
  }

  Future<List<PatientListData>> getPatientList({String searchValue = ""}) async {
    // patientList.clear();
    Map<String, dynamic> param = {};

    if (searchValue.isNotEmpty) {
      param['search'] = searchValue;
    }

    try {
      patientListModel.value = await _homeRepository.getPatient(param: param);

      if (patientListModel.value?.responseData?.data != null) {
        patientList.value = patientListModel.value?.responseData?.data ?? [];

        return patientList.value;
      }
    } catch (e) {
      return [];
    }

    return [];
  }

  Future<void> saveHomePastPatientData() async {
    setPastListingModel();
    AppPreference.instance.setHomePastPatientListSortingModel(homePastPatientListSortingModel.value!);
  }

  Future<void> saveHomePatientListData() async {
    AppPreference.instance.setHomePatientListSortingModel(homePatientListSortingModel.value!);
  }

  Future<void> saveHomeScheduleListData() async {
    setScheduleListingModel();

    AppPreference.instance.setHomeScheduleListSortingModel(homeScheduleListSortingModel.value!);
  }

  void scheduledVisit() {
    if (scheduleVisitModel.value?.patientId == null) {
      CustomToastification().showToast("Please Select Patient First", type: ToastificationType.error);
      return;
    }

    if (scheduleVisitModel.value?.selectedVisitTimeValue == null) {
      CustomToastification().showToast("Please Select Visit Time ", type: ToastificationType.error);
      return;
    }

    // if (scheduleVisitModel.value?.selectedDoctorValueSchedule == null) {
    //   CustomToastification().showToast("Please Select Doctor", type: ToastificationType.error);
    //   return;
    // }

    if (scheduleVisitModel.value?.visitDateController.text == "") {
      CustomToastification().showToast("Please Select Date ", type: ToastificationType.error);
      return;
    }

    editPatient();
  }

  // bool validateVisitTime(String? visitTimeInput, DateTime? selectedDate) {
  //   if (visitTimeInput == null || visitTimeInput.trim().isEmpty) {
  //     CustomToastification().showToast("Please Select Visit Time", type: ToastificationType.error);
  //     return false;
  //   }
  //
  //   DateTime selectedTime;
  //   try {
  //     selectedTime = DateFormat('HH:mm').parseStrict(visitTimeInput.trim());
  //   } catch (e) {
  //     CustomToastification().showToast("Please enter a valid time.", type: ToastificationType.error);
  //     return false;
  //   }
  //
  //   final DateTime openingTime = DateFormat('HH:mm').parse("07:00");
  //   final DateTime closingTime = DateFormat('HH:mm').parse("23:59");
  //
  //   if (selectedTime.isBefore(openingTime) || selectedTime.isAfter(closingTime)) {
  //     CustomToastification().showToast("This visit is outside normal operating hours", type: ToastificationType.error);
  //     return false;
  //   }
  //
  //   if (selectedDate == null) {
  //     CustomToastification().showToast("Please Select Date", type: ToastificationType.error);
  //     return false;
  //   }
  //
  //   DateTime now = DateTime.now();
  //
  //   // Check if selectedDate is today (year, month, day match)
  //   bool isToday = (selectedDate.year == now.year &&
  //       selectedDate.month == now.month &&
  //       selectedDate.day == now.day);
  //
  //   if (isToday) {
  //     // Combine selected date with selectedTime to get full DateTime
  //     DateTime combinedSelectedDateTime = DateTime(
  //       selectedDate.year,
  //       selectedDate.month,
  //       selectedDate.day,
  //       selectedTime.hour,
  //       selectedTime.minute,
  //     );
  //
  //     if (combinedSelectedDateTime.isBefore(now)) {
  //       CustomToastification().showToast("Visit time must be in the future", type: ToastificationType.error);
  //       return false;
  //     }
  //   }
  //
  //   return true; // all validations passed
  // }

  Future<void> editPatient() async {
    Loader().showLoadingDialogForSimpleLoader();

    isLoading.value = true;
    Map<String, dynamic> param = {};
    Map<String, List<File>> profileParams = {};

    if (scheduleVisitModel.value?.visitDateController.text != "" && scheduleVisitModel.value?.visitDateController.text != null) {
      param['visit_date'] = DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(scheduleVisitModel.value?.visitDateController.text ?? ""));
    }

    if (scheduleVisitModel.value?.selectedDoctorValueSchedule != null && scheduleVisitModel.value?.selectedDoctorValueSchedule != "") {
      if (getDoctorIdByName(scheduleVisitModel.value?.selectedDoctorValueSchedule) != -1) {
        param['doctor_id'] = getDoctorIdByName(scheduleVisitModel.value?.selectedDoctorValueSchedule);
      }
    }

    if (scheduleVisitModel.value?.selectedMedicationValueSchedule != null && scheduleVisitModel.value?.selectedMedicationValueSchedule != "") {
      if (getMedicalIdByName(scheduleVisitModel.value?.selectedMedicationValueSchedule) != -1) {
        param['medical_assistant_id'] = getMedicalIdByName(scheduleVisitModel.value?.selectedMedicationValueSchedule);
      }
    }

    String? time = scheduleVisitModel.value?.selectedVisitTimeValue.text;

    if (time != null) {
      DateTime firstTime = DateFormat('hh:mm a').parse(time).toUtc(); // 10:30 AM to DateTime

      // Now format it to the hh:mm:ss format
      String formattedTime = DateFormat('HH:mm:ss').format(firstTime.toUtc());

      customPrint("date time is $formattedTime");

      param['visit_time'] = formattedTime;
    }

    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      dynamic response = await _editPatientDetailsRepository.updatePatient(files: profileParams, id: scheduleVisitModel.value?.patientId?.toString() ?? "", param: param, token: loginData.responseData?.token ?? "");

      isLoading.value = false;

      isLoading.value = false;
      CustomToastification().showToast("Visit Created Successfully", type: ToastificationType.success);

      Get.back();

      if (Get.currentRoute == Routes.HOME) {
        Get.find<HomeController>().getScheduleVisitList();
      }
      Loader().stopLoader();
    } catch (error) {
      Get.back();
      isLoading.value = false;
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }
}
