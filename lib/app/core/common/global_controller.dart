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
import '../../data/service/database_helper.dart';
import '../../data/service/recorder_service.dart';
import '../../models/ChangeModel.dart';
import '../../modules/edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../modules/login/model/login_model.dart';
import '../../modules/visit_main/model/patient_transcript_upload_model.dart';
import '../../modules/visit_main/repository/visit_main_repository.dart';
import '../../routes/app_pages.dart';
import 'logger.dart';


class GlobalController extends GetxController {
  RxInt homeTabIndex = RxInt(0);
  // var breadcrumbHistory = <String>[];

  Map<String, String> breadcrumbs = {
    Routes.HOME: 'Patients & Visits',
    Routes.ADD_PATIENT: 'Add New',
    Routes.EDIT_PATENT_DETAILS: 'Edit Patient Information',
    Routes.VISIT_MAIN: 'Visit Main',
    Routes.PATIENT_INFO: 'Visit Documents',
    Routes.PATIENT_PROFILE: 'Patient Profile',
    Routes.ALL_ATTACHMENT: 'Attachments',
    Routes.SCHEDULE_PATIENT: 'Schedule Visit',
    Routes.PERSONAL_SETTING: 'Setting',
  };

  int closeFormState = 0;

//all variable for the model recording
//   --------------------------------------------------------------------------------------------------------------------------------------------------
  RxBool isStartTranscript = RxBool(false);
  RxBool isExpandRecording = true.obs;
  RecorderService recorderService = RecorderService();
  final VisitMainRepository visitMainRepository = VisitMainRepository();
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();
  RxString visitId = RxString("");
  RxString patientId = RxString("");

  // below  all the function is for the recording model
 // ----------------------------------------------------------------------------------------------------------------------------------------------------

  Future<void> changeStatus(String status) async {
    try {
      // Loader().showLoadingDialogForSimpleLoader();

      Map<String, dynamic> param = {};

      param['status'] = status;

      ChangeStatusModel changeStatusModel = await visitMainRepository.changeStatus(id: visitId.value, params: param);
      if (changeStatusModel.responseType == "success") {
        // Get.back();
        // Get.back();
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);

        patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);

        if (patientDetailModel.value?.responseData?.scheduledVisits?.isEmpty ?? false) {
          Get.back();
        }
      } else {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
        // Get.back();
        // Get.back();
      }
    } catch (e) {
      // customPrint("$e");
      CustomToastification().showToast("$e", type: ToastificationType.error);
      // Get.back();
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

      PatientTranscriptUploadModel patientTranscriptUploadModel =
      await visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
      customPrint("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

      // isLoading.value = false;
      Get.back();
  isStartTranscript.value = false;

      await Get.toNamed(Routes.PATIENT_INFO, arguments: {
        "trascriptUploadData": patientTranscriptUploadModel,
        "unique_tag": DateTime.now().toString(),
      });

      getPatientDetails();
    }
  }



  // ---------------------------------------------------------------------------------------------------------------------------------------------------












  void popUntilRoute(String targetRoute) {
    int targetIndex = breadcrumbHistory.indexOf(targetRoute);
    if (targetIndex != -1) {
      // Pop screens above the target route
      breadcrumbHistory.removeRange(targetIndex + 1, breadcrumbHistory.length); // Remove all screens above the target route
      breadcrumbHistory.refresh();
      print('Popped screens above: $targetRoute');
      // closeFormState = 0;
      // Optionally, navigate to the target route after popping
      // Get.toNamed(targetRoute);
    } else {
      print('Target route not found in history');
      breadcrumbHistory.refresh();
    }
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
      print('Popped Route: $poppedRoute');
    } else {
      print('Route stack is empty!');
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
    print('Cleared route stack');
  }

  List<Map<String, dynamic>> sortingPastPatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "previousVisitCount", "desc": true},
    {"id": "status", "desc": true},
  ];

  RxList<FilterListingModel> pastFilterListingModel = RxList([]);
  RxList<FilterListingModel> scheduleFilterListingModel = RxList([]);

  List<Map<String, dynamic>> sortingSchedulePatient = [
    {"id": "first_name", "desc": true},
    {"id": "appointmentTime", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "previousVisitCount", "desc": true},
  ];

  List<Map<String, dynamic>> sortingPatientList = [
    {"id": "first_name", "desc": true},
    {"id": "lastVisitDate", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "visitCount", "desc": true},
  ];

  List<Map<String, dynamic>> patientListSelectedSorting = [];
  List<Map<String, dynamic>> scheduleVisitSelectedSorting = [
    {"id": "appointmentTime", "desc": false}
  ];

  List<Map<String, dynamic>> pastVisitSelectedSorting = [
    {"id": "appointmentTime", "desc": "true"}
  ];

  Rxn<HomePastPatientListSortingModel> homePastPatientListSortingModel = Rxn();
  Rxn<HomePatientListSortingModel> homePatientListSortingModel = Rxn();
  Rxn<HomeScheduleListSortingModel> homeScheduleListSortingModel = Rxn();

  @override
  void onInit() async {
    super.onInit();

    HomePastPatientListSortingModel? homePastPatientData = await AppPreference.instance.getHomePastPatientListSortingModel();
    if (homePastPatientData != null) {
      homePastPatientListSortingModel.value = homePastPatientData;
      print("existing HomePastPatientListSortingModel:- ${homePastPatientData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['sortingPastPatient'] = sortingPastPatient;
      json['pastVisitSelectedSorting'] = pastVisitSelectedSorting;
      json['colIndex'] = 1;
      json['isAscending'] = true;
      json['selectedStatusIndex'] = ["Pending"];
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['endDate'] = "";
      homePastPatientListSortingModel.value = HomePastPatientListSortingModel.fromJson(json);
      print("first initialize homePastPatientListSortingModel :- $json");
    }

    HomePatientListSortingModel? homePatientListData = await AppPreference.instance.getHomePatientListSortingModel();
    if (homePatientListData != null) {
      homePatientListSortingModel.value = homePatientListData;
      print("existing HomePatientListSortingModel:- ${homePatientListData.toJson()}");
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
      print("first initialize homePatientListSortingModel :- $json");
    }

    HomeScheduleListSortingModel? homeScheduleListData = await AppPreference.instance.getHomeScheduleListSortingModel();
    if (homeScheduleListData != null) {
      homeScheduleListSortingModel.value = homeScheduleListData;
      print("existing HomeScheduleListSortingModel:- ${homeScheduleListData.toJson()}");
    } else {
      Map<String, dynamic> json = <String, dynamic>{};
      json['scheduleVisitSelectedSorting'] = scheduleVisitSelectedSorting;
      json['sortingSchedulePatient'] = sortingSchedulePatient;
      json['colIndex'] = 1;
      json['isAscending'] = false;
      json['selectedDateValue'] = [];
      json['startDate'] = "";
      json['endDate'] = "";
      homeScheduleListSortingModel.value = HomeScheduleListSortingModel.fromJson(json);
      print("first initialize homeScheduleListSortingModel :- $json");
    }

    setPastListingModel();
    setScheduleListingModel();
  }

  void setPastListingModel() {
    pastFilterListingModel.clear();

    if ((homePastPatientListSortingModel.value?.selectedStatusIndex ?? []).isNotEmpty) {
      pastFilterListingModel.add(FilterListingModel(filterName: "Status", filterValue: homePastPatientListSortingModel.value!.selectedStatusIndex!.join(",")));
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
      saveHomePastPatientData();
    } else {
      homePastPatientListSortingModel.value?.startDate = "";
      homePastPatientListSortingModel.value?.endDate = "";
      homePastPatientListSortingModel.value?.selectedStatusIndex = [];
      homePastPatientListSortingModel.value?.selectedDateValue = [];
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

      saveHomeScheduleListData();
    } else {
      homeScheduleListSortingModel.value?.startDate = "";
      homeScheduleListSortingModel.value?.endDate = "";
      homeScheduleListSortingModel.value?.selectedDateValue = [];

      saveHomeScheduleListData();
    }
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
}
