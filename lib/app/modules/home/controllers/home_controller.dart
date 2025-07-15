import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:subqdocs/app/modules/home/model/latest_build_model.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_string.dart';
import '../../../../widgets/app_update_dialog.dart';
import '../../../../widgets/customPermission.dart';
import '../../../../widgets/device_info_model.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/service/database_helper.dart';
import '../../../data/service/socket_service.dart';
import '../../../models/ChangeModel.dart';
import '../../../models/MedicalDoctorModel.dart';
import '../../login/model/login_model.dart';
import '../../personal_setting/model/filter_past_visit_status.dart';
import '../../personal_setting/repository/personal_setting_repository.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../../visit_main/repository/visit_main_repository.dart';
import '../model/deletePatientModel.dart';
import '../model/home_past_patient_list_sorting_model.dart';
import '../model/patient_list_model.dart';
import '../model/patient_schedule_model.dart';
import '../model/schedule_visit_list_model.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  RxBool isEMAFetching = RxBool(false);
  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  List<FilterPastVisitStatusCategoryModel> filterPastVisitStatusCategoryData = [];
  final rightController = SideMenuController();

  RxBool showClearButton = RxBool(false);

  final GlobalController globalController = Get.find();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxList<PatientListData> patientList = RxList<PatientListData>();
  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
  Rxn<PatientListModel> patientListModelOOffLine = Rxn<PatientListModel>();
  Rxn<MedicalDoctorModel> doctorListModel = Rxn<MedicalDoctorModel>();

  Rxn<MedicalDoctorModel> medicalListModel = Rxn<MedicalDoctorModel>();

  Rxn<ScheduleVisitListModel> scheduleVisitListModel = Rxn<ScheduleVisitListModel>();
  Rxn<ScheduleVisitListModel> scheduleVisitListModelOffline = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> scheduleVisitList = RxList<ScheduleVisitListData>();
  Rxn<ScheduleVisitListModel> pastVisitListModel = Rxn<ScheduleVisitListModel>();
  Rxn<ScheduleVisitListModel> pastVisitListModelOfLine = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> pastVisitList = RxList<ScheduleVisitListData>();

  // late final ScrollObserver _observer;
  final ScrollController scrollControllerPatientList = ScrollController();
  final ScrollController scrollControllerPastPatientList = ScrollController();
  final ScrollController scrollControllerSchedulePatientList = ScrollController();

  static const ROLE_DOCTOR = "Doctor";
  static const ROLE_MEDICAL_ASSISTANT = "Medical Assistant";

  SocketService socketService = SocketService();

  String getNextRoundedTime() {
    DateTime now = DateTime.now();

    int minutes = now.minute;
    int roundedMinutes = ((minutes + 14) ~/ 15) * 15; // Adding 14 ensures rounding up

    if (roundedMinutes == 60) {
      now = now.add(Duration(minutes: 60 - minutes));
      now = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }

    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(now);
  }

  RxString startDate = RxString("MM/DD/YYYY");
  RxString endDate = RxString("");
  List<DateTime> selectedValue = [];
  Map<String, String> nameToIdMap = {"Patient Name": "first_name", "Visit Date": "appointmentTime", "Visit Date & Time": "appointmentTime", "Last Visit Date": "lastVisitDate", "Age": "age", "Gender": "gender", "Previous": "previousVisitCount", "Previous Visits": "previousVisitCount", "Status": "status", "Provider": 'doctorName'};
  RxBool isInternetConnected = RxBool(true);

  var pagePatient = 1;

  final Set<int> triggeredIndexes = <int>{};
  final Set<int> pastTriggeredIndexes = <int>{};
  final Set<int> scheduleTriggeredIndexes = <int>{};
  var pageSchedule = 1;
  var pagePast = 1;
  RxBool isLoading = RxBool(false);
  RxBool noMoreDataPatientList = RxBool(false);
  RxBool noMoreDataPastPatientList = RxBool(false);
  RxBool noMoreDataSchedulePatientList = RxBool(false);

  String getNextRoundedTimeHHForStartNow() {
    DateTime now = DateTime.now().toUtc();

    int minutes = now.minute;
    int roundedMinutes = ((minutes + 9) ~/ 10) * 10; // Adding 9 ensures rounding up for 10-min intervals

    if (roundedMinutes == 60) {
      now = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }

    final DateFormat formatter = DateFormat('HH:mm:ss');
    customPrint("next available slot is :- ${formatter.format(now)}");
    return formatter.format(now);
  }

  String getNextRoundedTimeHH() {
    DateTime now = DateTime.now().toUtc();

    int minutes = now.minute;
    int roundedMinutes = ((minutes + 14) ~/ 15) * 15; // Adding 14 ensures rounding up

    if (roundedMinutes == 60) {
      now = now.add(Duration(minutes: 60 - minutes));
      now = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
    } else {
      now = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    }

    final DateFormat formatter = DateFormat('HH:mm:ss');

    customPrint("next available slot is :- ${formatter.format(now)}");

    return formatter.format(now);
  }

  RxBool isHomePatientListLoading = RxBool(false);
  RxBool isHomeScheduleListLoading = RxBool(true);
  RxBool isHomePastPatientListLoading = RxBool(false);

  @override
  void _onScrollPatientList() {
    if (!scrollControllerPatientList.hasClients) return;

    double offset = scrollControllerPatientList.position.pixels;
    int currentIndex = (offset / 40).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && (currentIndex - 50) % 100 == 0 && !triggeredIndexes.contains(currentIndex)) {
      triggeredIndexes.add(currentIndex); // Mark as triggered
      patientLoadMore();
      customPrint("scroll is needed $currentIndex");
    } else {
      customPrint("scroll is  not needed.  $currentIndex");
    }
  }

  void _onScrollPastPatientList() {
    if (!scrollControllerPastPatientList.hasClients) return;

    double offset = scrollControllerPastPatientList.position.pixels;
    int currentIndex = (offset / 40).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && (currentIndex - 50) % 100 == 0 && !pastTriggeredIndexes.contains(currentIndex)) {
      pastTriggeredIndexes.add(currentIndex); // Mark as triggered
      getPastVisitListFetchMore();

      customPrint("scroll is needed $currentIndex");
    } else {
      customPrint("scroll is  not needed.  $currentIndex");
    }
  }

  void _onScrollSchedulePatientList() {
    if (!scrollControllerSchedulePatientList.hasClients) return;

    double offset = scrollControllerSchedulePatientList.position.pixels;
    int currentIndex = (offset / 45).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && (currentIndex - 50) % 100 == 0 && !scheduleTriggeredIndexes.contains(currentIndex)) {
      scheduleTriggeredIndexes.add(currentIndex); // Mark as triggered
      getScheduleVisitListFetchMore();

      customPrint("scroll is needed $currentIndex");
    } else {
      customPrint("scroll is  not needed.  $currentIndex");
    }
  }

  Future<void> onInit() async {
    super.onInit();
    Get.put(GlobalController());

    Map<String, String> deviceInfo = await DeviceInfoService.getDeviceInfoAsJson();
    print("device info is:- $deviceInfo");

    // await getLatestBuild();
    customPrint("home controller called");

    globalController.liveActivitiesPlugin.init(appGroupId: 'group.subqdocs.liveactivities', urlScheme: 'la');

    globalController.listenForUserNameUpdate();

    globalController.liveActivitiesPlugin.activityUpdateStream.listen((event) {
      customPrint('Activity update: $event');
    });

    globalController.urlSchemeSubscription = globalController.liveActivitiesPlugin.urlSchemeStream().listen((schemeData) async {
      if (schemeData.path == '/stop') {
        File? audioFile = await globalController.recorderService.stopRecording();
        customPrint("audio file url is :- ${audioFile?.absolute}");
        if (audioFile != null) {
          globalController.stopLiveActivityAudio();
          globalController.submitAudio(audioFile);
        }
      } else if (schemeData.path == '/pause') {
        globalController.updatePauseResumeAudioWidget();
        await globalController.recorderService.pauseRecording();
      } else if (schemeData.path == '/resume') {
        globalController.updatePauseResumeAudioWidget();
        await globalController.recorderService.resumeRecording();
      }
    });

    filterPastVisitStatusCategoryData.add(FilterPastVisitStatusCategoryModel(category: "SCHEDULED", subcategories: ["Scheduled", "Late"]));
    filterPastVisitStatusCategoryData.add(FilterPastVisitStatusCategoryModel(category: "IN PROGRESS", subcategories: ["Checked In", "In Progress", "Paused"]));
    filterPastVisitStatusCategoryData.add(FilterPastVisitStatusCategoryModel(category: "PAST", subcategories: ["Pending", "In Exam", "Finalized", "Insufficient Information", "Not Recorded"]));
    filterPastVisitStatusCategoryData.add(FilterPastVisitStatusCategoryModel(category: "CANCELLED/NO SHOW", subcategories: ["Cancelled", "No Show"]));

    globalController.getUserDetail();

    HomePastPatientListSortingModel? homePastPatientData = await AppPreference.instance.getHomePastPatientListSortingModel();

    customPrint("homePastPatientData:- ${homePastPatientData?.toJson()}");

    handelInternetConnection();
    if (Get.arguments != null) {
      globalController.tabIndex.value = Get.arguments["tabIndex"] ?? 0;
    }
    // getPatientList();
    getScheduleVisitList();

    getStatus();
    globalController.getDoctorsFilter();
    globalController.getMedicalAssistance();

    scrollControllerPatientList.addListener(_onScrollPatientList);
    scrollControllerPastPatientList.addListener(_onScrollPastPatientList);
    scrollControllerSchedulePatientList.addListener(_onScrollSchedulePatientList);

    getOrganizationDetail();
    getUserDetail();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollControllerPatientList.removeListener(_onScrollPatientList);
    scrollControllerPatientList.dispose();

    scrollControllerPastPatientList.removeListener(_onScrollPastPatientList);
    scrollControllerPastPatientList.dispose();

    scrollControllerSchedulePatientList.removeListener(_onScrollSchedulePatientList);
    scrollControllerSchedulePatientList.dispose();
  }

  void patientSyncSocketSetup() {
    if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      socketService.socket.emit("EMA_user_joined", [loginData.responseData?.user?.id]);

      socketService.socket.on("patient_sync_started", (data) {
        var res = data as Map<String, dynamic>;

        String status = res["status"];

        switch (status) {
          case "SUCCESS":
            isEMAFetching.value = false;
            customPrint("patient_sync_started status is :- $status");
            break;
          case "COMPLETED":
            isEMAFetching.value = false;
            customPrint("patient_sync_started status is :- $status");
            break;
          case "IN_PROGRESS":
            isEMAFetching.value = true;
            customPrint("patient_sync_started status is :- $status");
            break;
          case "FAILURE":
            isEMAFetching.value = false;
            customPrint("patient_sync_started status is :- $status");
            break;
        }

        // customPrint("---------------------------------------------");
        // customPrint("patient_sync_started status is :- $res");
      });
    }
  }

  Future<void> getUserDetail() async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    globalController.getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.responseData?.user?.id.toString() ?? "");
  }

  Future<void> getOrganizationDetail() async {
    try {
      globalController.getEMAOrganizationDetailModel.value = await _personalSettingRepository.getOrganizationDetail();

      patientSyncSocketSetup();
    } catch (e) {
      customPrint("error on get OrganizationDetail :- $e");
    }
  }

  Future<void> updateViews() async {
    update();
  }

  bool? getDescValue(List<Map<String, dynamic>> sorting, String displayName, int tabIndex) {
    // Find the actual key (id) from the name-to-id map
    String? key = nameToIdMap[displayName];
    customPrint("display name is :- $displayName");

    // if (displayName == 'Provider') {
    //   key = "doctorName";
    // }

    if (tabIndex == 0) {
      if (displayName == "Previous Visits") {
        key = "visitCount";
        customPrint("is :- $key");
      }
    } else if (tabIndex == 2) {
      if (displayName == "Previous \nVisits") {
        key = "previousVisitCount";
      }
    }

    if (key == null) {
      // customPrint("Invalid display name: $displayName");
      return null; // Return null if no matching key is found
    }

    // Iterate over the sorting list to find the map with the matching 'id'
    for (var map in sorting) {
      if (map["id"] == key) {
        // customPrint("boll is ${map["desc"]}");
        return map["desc"]; // Return the 'desc' value (true/false)
      }
    }

    // customPrint("No matching 'id' found for $displayName");
    return null; // Return null if no matching 'id' is found
  }

  List<Map<String, dynamic>> toggleSortDesc(List<Map<String, dynamic>> sorting, String displayName, int tabIndex) {
    // Find the actual key (id) from the name-to-id map

    String? key = nameToIdMap[displayName];

    customPrint("tabindex is :- $tabIndex display name is :- $displayName");
    customPrint("key name:- $key");

    // if (displayName == 'Provider') {
    //   key = "doctorName";
    // }

    if (tabIndex == 0 && displayName == "Previous Visits") {
      key = "visitCount";
      customPrint("inside key visitCount");
    } else if (tabIndex == 2 && displayName == "Previous \nVisits") {
      key = "previousVisitCount";
    }

    if (key == null) {
      // customPrint("Invalid display name: $displayName");

      List<Map<String, dynamic>> empty = [
        // Add more sorting parameters as needed
      ];
      return empty; // Return the original list if no matching key is found
    }

    // print("sorting val is :- $sorting");
    // Iterate over the sorting list to find the map with the matching 'id'
    for (var map in sorting) {
      // print("map value is :- ${map}");
      if (map["id"] == key) {
        // Toggle the 'desc' value: if it's true, set it to false, and vice versa
        map["desc"] = map["desc"] == true ? false : true;
        break; // Exit loop once we've updated the map
      }
    }

    return sorting.where((map) => map['id'] == key).toList();
  }

  Future<void> getPatientList({String? sortingName = "", bool isLoading = false}) async {
    patientList.clear();

    isHomePatientListLoading.value = true;

    Map<String, dynamic> param = {};
    pagePatient = 1;
    triggeredIndexes.clear();

    // if (isLoading) {
    //   Loader().showLoadingDialogForSimpleLoader();
    // }

    param['page'] = 1;
    param['limit'] = "100";
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
      param['is_after_sync'] = 'false';
    }

    // Dynamically add sorting to the param map

    if (sortingName!.isNotEmpty) {
      globalController.homePatientListSortingModel.value?.patientListSelectedSorting = toggleSortDesc(globalController.sortingPatientList, sortingName, 0);
      param["sorting"] = globalController.homePatientListSortingModel.value?.patientListSelectedSorting;
    } else {
      param["sorting"] = globalController.homePatientListSortingModel.value?.patientListSelectedSorting;
    }

    if (globalController.homePatientListSortingModel.value?.startDate != "" && globalController.homePatientListSortingModel.value?.endDate != "") {
      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homePatientListSortingModel.value?.startDate ?? "");
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homePatientListSortingModel.value?.endDate ?? "");
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    // print("param:- $param");
    globalController.saveHomePatientListData();
    patientListModel.value = await _homeRepository.getPatient(param: param);

    isHomePatientListLoading.value = false;

    // if (isLoading) {
    //   Loader().stopLoader();
    // }

    if (patientListModel.value?.responseData?.data != null) {
      patientList.value = patientListModel.value?.responseData?.data ?? [];

      // getLast2DaysData();
      // getOfflineData();
    }

    for (var element in patientList) {
      // print("element is ${element.toJson()}");
    }
  }

  Future<void> getScheduleVisitList({String? sortingName = "", bool isFist = false}) async {
    scheduleVisitList.clear();

    pageSchedule = 1;
    scheduleTriggeredIndexes.clear();
    noMoreDataSchedulePatientList.value = false;

    isHomeScheduleListLoading.value = true;

    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "100";
    param['isPastPatient'] = 'false';

    if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
      param['is_after_sync'] = 'false';
    }

    customPrint("Schedule sorting name:- $sortingName");

    if (sortingName!.isNotEmpty) {
      globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting = toggleSortDesc(globalController.sortingSchedulePatient, sortingName ?? "", 1);
      customPrint("toggle name:- ${toggleSortDesc(globalController.sortingPatientList, sortingName ?? "", 1)}");
      param["sorting"] = globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting;
      customPrint("getScheduleVisitList if sorting empty");
    } else {
      param["sorting"] = globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting;
      customPrint("getScheduleVisitList else sorting empty");
    }
    // }
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    if (globalController.homeScheduleListSortingModel.value?.selectedDoctorNames?.isNotEmpty ?? false) {
      List<int>? statusList = globalController.homeScheduleListSortingModel.value?.selectedDoctorId ?? [];

      if (statusList.length == 1) {
        param['doctorsName[0]'] = statusList;
      } else {
        param['doctorsName'] = statusList;
      }
    }

    if (globalController.homeScheduleListSortingModel.value?.selectedMedicationNames?.isNotEmpty ?? false) {
      List<int>? statusList = globalController.homeScheduleListSortingModel.value?.selectedMedicationId ?? [];

      if (statusList.length == 1) {
        param['medicalAssistantsName[0]'] = statusList;
      } else {
        param['medicalAssistantsName'] = statusList;
      }
    }

    if (globalController.homeScheduleListSortingModel.value?.startDate != "" && globalController.homeScheduleListSortingModel.value?.endDate != "") {
      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homeScheduleListSortingModel.value?.startDate ?? "");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homeScheduleListSortingModel.value?.endDate ?? "");
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    customPrint("param:- $param");
    globalController.saveHomeScheduleListData();
    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

    isHomeScheduleListLoading.value = false;

    if (scheduleVisitListModel.value?.responseData?.data != null) {
      scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];

      // getLast2DaysData();
      // getOfflineData();
    }
  }

  List<String> formatStatusList(List<String> statuses) {
    return statuses.map((status) {
      // Replace spaces with hyphens and handle specific cases
      String formatted = status.replaceAll(' ', '-');

      customPrint("formated $formatted");

      // Handle specific replacements (add more if needed)
      if (formatted == 'Checked-In') return 'Checked-in';
      if (formatted == 'In-Progress') return 'Inprogress';
      if (formatted == 'In-Room') return 'In-Room';
      if (formatted == 'In-Exam') return 'In-Exam';
      if (formatted == 'No-Show') return 'No Show';
      if (formatted == 'Insufficient-Information') return 'Insufficient Information';
      if (formatted == 'Not-Recorded') return 'Not Recorded';

      // Default case: capitalize first letter of each word after hyphen
      formatted = formatted
          .split('-')
          .map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join('-');

      return formatted;
    }).toList();
  }

  Future<void> getPastVisitList({String? sortingName = "", bool isFist = false}) async {
    pastVisitList.clear();

    pagePast = 1;
    pastTriggeredIndexes.clear();
    noMoreDataPatientList.value = false;

    isHomePastPatientListLoading.value = true;

    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "100";
    param['isPastPatient'] = 'true';
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }
    if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
      param['is_after_sync'] = 'false';
    }

    if (sortingName!.isNotEmpty) {
      globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting = toggleSortDesc(globalController.sortingPastPatient, sortingName ?? "", 2);

      param["sorting"] = globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting;
    } else {
      param["sorting"] = globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting;
    }

    if (globalController.homePastPatientListSortingModel.value?.selectedStatusIndex?.isNotEmpty ?? false) {
      List<String>? statusList = globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? [];

      statusList = formatStatusList(statusList);

      customPrint("Status list is :- $statusList");

      if (statusList.length == 1) {
        param['status[0]'] = statusList;
      } else {
        param['status'] = statusList;
      }
    }

    if (globalController.homePastPatientListSortingModel.value?.selectedDoctorNames?.isNotEmpty ?? false) {
      List<int>? statusList = globalController.homePastPatientListSortingModel.value?.selectedDoctorId ?? [];

      if (statusList.length == 1) {
        param['doctorsName[0]'] = statusList;
      } else {
        param['doctorsName'] = statusList;
      }
    }

    if (globalController.homePastPatientListSortingModel.value?.selectedMedicationNames?.isNotEmpty ?? false) {
      List<int>? statusList = globalController.homePastPatientListSortingModel.value?.selectedMedicationId ?? [];

      if (statusList.length == 1) {
        param['medicalAssistantsName[0]'] = statusList;
      } else {
        param['medicalAssistantsName'] = statusList;
      }
    }

    if (globalController.homePastPatientListSortingModel.value?.startDate != "" && globalController.homePastPatientListSortingModel.value?.endDate != "") {
      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homePastPatientListSortingModel.value?.startDate ?? "");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homePastPatientListSortingModel.value?.endDate ?? "");

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    customPrint("param:- $param");
    globalController.saveHomePastPatientData();
    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);

    isHomePastPatientListLoading.value = false;

    if (pastVisitListModel.value?.responseData?.data != null) {
      pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
      // getLast2DaysData();
      // getOfflineData();
    }
  }

  Future<void> getScheduleVisitListFetchMore() async {
    int? totalCount = scheduleVisitListModel.value?.responseData?.totalCount ?? 0;
    if (scheduleVisitList.length < totalCount) {
      customPrint("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
      isLoading.value = true;
      noMoreDataSchedulePatientList.value = false;
      Map<String, dynamic> param = {};
      param['page'] = ++pageSchedule;
      param['limit'] = "100";
      param['isPastPatient'] = 'false';

      if (globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
        param['is_after_sync'] = 'false';
      }

      if (searchController.text.isNotEmpty) {
        param['search'] = searchController.text;
      }

      // Dynamically add sorting to the param map
      param["sorting"] = globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting;

      if (startDate.value != "" && endDate.value != "") {
        DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
        String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
        DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
        param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
      }

      globalController.saveHomeScheduleListData();
      scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

      isLoading.value = false;
      if (scheduleVisitListModel.value?.responseData?.data != null) {
        int? totalCount = scheduleVisitListModel.value?.responseData?.totalCount ?? 0;
        int? dataCount = scheduleVisitList.length;

        if (scheduleVisitList.length >= totalCount!) {
          // customPrint("no data fetch and add");
          pageSchedule--;
        } else {
          // customPrint(" data fetch and add");
          scheduleVisitList.addAll(scheduleVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
        }
      } else {
        // customPrint("no data fetch and add");
        pageSchedule--;
      }
    } else {
      noMoreDataSchedulePatientList.value = true;
      customPrint("no pagination is not needed  beacuse ${scheduleVisitList.length}  is this and $totalCount");
    }
  }

  Future<void> getPatientListFetchMore({int? page}) async {
    int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
    if (patientList.length < totalCount) {
      customPrint("pagination is  needed  beacuse ${patientList.length}  is this and $totalCount");
      isLoading.value = true;
      noMoreDataPatientList.value = false;

      Map<String, dynamic> param = {};

      param['page'] = ++pagePatient;
      param['limit'] = "100";
      if (searchController.text.isNotEmpty) {
        param['search'] = searchController.text;
      }

      // Dynamically add sorting to the param map
      param["sorting"] = globalController.homePatientListSortingModel.value?.patientListSelectedSorting;

      if (startDate.value != "" && endDate.value != "") {
        DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
        String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
        DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
        param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
      }

      globalController.saveHomePatientListData();
      patientListModel.value = await _homeRepository.getPatient(param: param);

      isLoading.value = false;
      if (patientListModel.value?.responseData?.data != null) {
        int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
        int? dataCount = patientList.length;

        if (patientList.length >= totalCount) {
          pagePatient--;
        } else {
          patientList.addAll(patientListModel.value?.responseData?.data as Iterable<PatientListData>);
        }
      } else {
        pagePatient--;
      }
    } else {
      noMoreDataPatientList.value = true;

      customPrint("no pagination is not needed  beacuse ${patientList.length}  is this and $totalCount");
    }
  }

  Future<void> getPastVisitListFetchMore() async {
    int? totalCount = pastVisitListModel.value?.responseData?.totalCount ?? 0;

    if (pastVisitList.length < totalCount) {
      customPrint("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
      isLoading.value = true;
      noMoreDataPastPatientList.value = false;

      Map<String, dynamic> param = {};
      param['page'] = ++pagePast;
      param['limit'] = "100";
      param['isPastPatient'] = 'true';
      if (searchController.text.isNotEmpty) {
        param['search'] = searchController.text;
      }

      if (globalController.homePastPatientListSortingModel.value?.selectedStatusIndex?.isNotEmpty ?? false) {
        List<String>? statusList = globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? [];

        statusList = formatStatusList(statusList);

        if (statusList.length == 1) {
          param['status[0]'] = statusList;
        } else {
          param['status'] = statusList;
        }
      }

      param["sorting"] = globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting;

      if (startDate.value != "" && endDate.value != "") {
        DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);

        String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);

        DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);

        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

        param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
      }

      globalController.saveHomePastPatientData();
      pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);

      isLoading.value = false;

      if (pastVisitListModel.value?.responseData?.data != null) {
        int? totalCount = pastVisitListModel.value?.responseData?.totalCount ?? 0;
        int? dataCount = pastVisitList.length;

        if (pastVisitList.length >= totalCount!) {
          customPrint("no data fetch and add");
          pagePast--;
        } else {
          pastVisitList.addAll(pastVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
        }
      } else {
        pagePast--;
      }
    } else {
      noMoreDataPastPatientList.value = true;
      customPrint("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
    }
  }

  Future<void> getOfflineData() async {
    var response = await _homeRepository.getOfflineData();

    if (response["response_type"] == "success") {
      await AppPreference.instance.setString(AppString.offLineData, json.encode(response));
    }
  }

  Future<void> getLast2DaysData() async {
    Map<String, dynamic> patientParam = {};
    //param for the
    patientParam['page'] = 1;
    patientParam['limit'] = "1000";
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 2)));
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    patientParam['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';

    Map<String, dynamic> scheduleParam = {};

    scheduleParam['page'] = 1;
    scheduleParam['limit'] = "100";
    scheduleParam['isPastPatient'] = 'false';
    String formattedStartDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String formattedEndDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 2)));
    scheduleParam['dateRange'] = '{"startDate":"$formattedStartDateSchedule", "endDate":"$formattedEndDateSchedule"}';
    Map<String, dynamic> pastParam = {};

    pastParam['page'] = 1;
    pastParam['limit'] = "100";
    pastParam['isPastPatient'] = 'true';
    String formattedStartDatePast = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 2)));
    String formattedEndDatePast = DateFormat('yyyy-MM-dd').format(DateTime.now());
    pastParam['dateRange'] = '{"startDate":"$formattedStartDatePast", "endDate":"$formattedEndDatePast"}';

    try {
      patientListModelOOffLine.value = await _homeRepository.getPatient(param: patientParam);
      scheduleVisitListModelOffline.value = await _homeRepository.getScheduleVisit(param: scheduleParam);
      pastVisitListModelOfLine.value = await _homeRepository.getPastVisit(param: pastParam);

      await AppPreference.instance.setString(AppString.patientList, json.encode(patientListModelOOffLine.toJson()));
      await AppPreference.instance.setString(AppString.schedulePatientList, json.encode(scheduleVisitListModelOffline.toJson()));
      await AppPreference.instance.setString(AppString.pastPatientList, json.encode(pastVisitListModelOfLine.toJson()));
    } catch (e) {
      // customPrint(e);
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
          startDate = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          endDate = startDate;
        } else {
          if (i == 0) {
            // Set startDate to the first date
            startDate = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          } else {
            // Set endDate to the second date
            endDate = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          }
        }
      }
    } else {
      // If no date is selected, set startDate and endDate to the current date
      DateTime dateTime = DateTime.now();
      startDate = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
      endDate = startDate; // Set both dates to the current date
    }

    // Return both dates in a list
    return [startDate, endDate];
  }

  void setDateRange() {
    if (selectedValue.isNotEmpty) {
      for (int i = 0; i < selectedValue.length; i++) {
        var dateTime = selectedValue[i];
        // Format the date to 'MM-dd-yyyy'
        // customPrint("goint to this ");
        if (selectedValue.length == 1) {
          startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
        } else {
          if (i == 0) {
            startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          } else {
            endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          }
        }
      }
    } else {
      DateTime dateTime = DateTime.now();
      startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
      endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
    }
    Get.back();
  }

  void clearFilter({bool canPop = false, bool isRefresh = true}) {
    searchController.text = "";

    startDate.value = "MM/DD/YYYY";
    endDate.value = "";
    fromController.clear();
    toController.clear();

    if (isRefresh) {
      getPatientList();
      getScheduleVisitList();
      getPastVisitList();
    }
  }

  Future<void> getStatus() async {
    StatusResponseModel statusResponseModel = await _homeRepository.getStatus();
  }

  void patientLoadMore() async {
    customPrint("fetch more data beacuse needed");
    getPatientListFetchMore();
  }

  Future<void> deletePatientById(int? id) async {
    customPrint("delete id is :- $id");
    DeletePatientModel deletePatientModel = await _homeRepository.deletePatientById(id: id!);

    CustomToastification().showToast("Patient deleted successfully");
    getPatientList();
    getPastVisitList();
    getScheduleVisitList();
  }

  void scheduleSorting({String cellData = "", int colIndex = -1}) {
    getScheduleVisitList(sortingName: cellData);

    globalController.homeScheduleListSortingModel.value?.colIndex = colIndex;

    globalController.homeScheduleListSortingModel.value?.isAscending = getDescValue(globalController.sortingSchedulePatient, cellData, 1) ?? false;
    globalController.saveHomeScheduleListData();
    scheduleTriggeredIndexes.clear();
  }

  void patientSorting({String cellData = "", int colIndex = -1}) {
    customPrint("celldata is :- $cellData");

    if (cellData == "Previous Visits") {
      getPatientList(sortingName: cellData);
    } else {
      getPatientList(sortingName: cellData);
    }

    globalController.homePatientListSortingModel.value?.colIndex = colIndex;
    globalController.homePatientListSortingModel.value?.isAscending = getDescValue(globalController.sortingPatientList, cellData, 0) ?? false;
    globalController.homePastPatientListSortingModel.refresh();

    globalController.saveHomePatientListData();
    triggeredIndexes.clear();
  }

  void handelInternetConnection() {
    final _ = InternetConnection().onStatusChange.listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          getPastVisitList();
          getScheduleVisitList();
          getPatientList();
          getStatus();

          List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();

          // customPrint("audio file count is :- ${audio.length}");
          if (audio.isNotEmpty) {
            CustomToastification().showToast("Audio uploading start!", type: ToastificationType.info, toastDuration: 6);

            uploadAllAudioFiles(() {
              CustomToastification().showToast("All audio files have been uploaded!", type: ToastificationType.success, toastDuration: 6);
              // customPrint('All audio files have been uploaded!');
            });
          }

          break;
        case InternetStatus.disconnected:
          var patient = PatientListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.patientList)));

          var schedule = ScheduleVisitListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.schedulePatientList)));

          var past = ScheduleVisitListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.pastPatientList)));
          patientList.value = patient.responseData?.data ?? [];
          scheduleVisitList.value = schedule.responseData?.data ?? [];
          pastVisitList.value = past.responseData?.data ?? [];
          patientList.refresh();
          scheduleVisitList.refresh();
          pastVisitList.refresh();

          break;
      }
    });
  }

  Future<void> uploadAllAudioFiles(Function onAllUploaded) async {
    List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();

    List<Future<bool>> uploadFutures = [];

    for (var file in audio) {
      uploadFutures.add(
        uploadLocalAudio(file).then((success) {
          if (success) {
            DatabaseHelper.instance.deleteAudioFile(file.id ?? 0);
          }
          return success;
        }),
      );
    }

    await Future.wait(uploadFutures);

    onAllUploaded(); // This will trigger the callback function
  }

  Future<bool> uploadLocalAudio(AudioFile file) async {
    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      PatientTranscriptUploadModel patientTranscriptUploadModel = await _visitMainRepository.uploadAudio(audioFile: File.fromUri(Uri.file(file.fileName ?? "")), token: loginData.responseData?.token ?? "", patientVisitId: file.visitId ?? "");
      return true; // You might want to change this logic to match your actual upload process
    } catch (error) {
      return false;
    }
  }

  Future<void> pastPatientStartNow(String patientId, String firstName, String lastName, {required Map<String, dynamic> param}) async {
    Loader().showLoadingDialogForSimpleLoader();

    try {
      PatientScheduleModel response = await _homeRepository.patientVisitCreate(param: param);
      CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);

      startVisit(patientId, response.responseData?.id.toString() ?? "", firstName, lastName);

      // globalController.addRoute(Routes.VISIT_MAIN);
      // dynamic responseVisitMain = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": response.responseData?.id.toString(), "patientId": response.responseData?.patientId.toString(), "unique_tag": DateTime.now().toString()});
      //
      // globalController.valueOfx.refresh();
      //
      // globalController.isStartTranscript.refresh();
      // customPrint("back from response");

      getPastVisitList();
      getScheduleVisitList();
      getPatientList();

      Loader().stopLoader();
    } catch (e) {
      Loader().stopLoader();
    }
  }

  Future<void> patientScheduleCreate({required Map<String, dynamic> param}) async {
    Loader().showLoadingDialogForSimpleLoader();
    Get.back();

    try {
      PatientScheduleModel response = await _homeRepository.patientVisitCreate(param: param);
      CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);
      globalController.tabIndex.value = 1;

      globalController.saveHomeScheduleListData();
      globalController.saveHomePastPatientData();
      globalController.saveHomePatientListData();

      getPastVisitList();
      getScheduleVisitList();
      getPatientList();

      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> startNow({required Map<String, dynamic> param}) async {
    Loader().showLoadingDialogForSimpleLoader();

    try {
      PatientScheduleModel response = await _homeRepository.patientVisitCreate(param: param);
      CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);
      globalController.tabIndex.value = 1;

      globalController.saveHomeScheduleListData();
      globalController.saveHomePastPatientData();
      globalController.saveHomePatientListData();

      getPastVisitList();
      getScheduleVisitList();
      getPatientList();

      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  String toUtcIsoStringAlreadyUtc(String date, String time) {
    // Parse date parts
    List<String> dateParts = date.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Parse time parts
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    // Create DateTime in UTC directly
    DateTime utcDateTime = DateTime.utc(year, month, day, hour, minute, second);

    // Return ISO8601 string with Z
    return utcDateTime.toIso8601String();
  }

  String dateToUtcMidnightIsoString(String date) {
    List<String> parts = date.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    DateTime dt = DateTime.utc(year, month, day);
    // toIso8601String() produces like 2025-05-27T00:00:00.000Z by default for UTC
    return dt.toIso8601String();
  }

  Future<void> patientReScheduleCreate({required Map<String, dynamic> param, required String visitId, required String visitTime, required String visitDate, int? rowIndex, int? doctorId}) async {
    customPrint("visit id :- $visitId");

    dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);
    customPrint("patientReScheduleCreate API  internal response $response");
    CustomToastification().showToast("Visit reschedule successfully", type: ToastificationType.success);

    customPrint(toUtcIsoStringAlreadyUtc(visitDate, visitTime));
    if (rowIndex != null) scheduleVisitList[rowIndex].appointmentTime = toUtcIsoStringAlreadyUtc(visitDate, visitTime);

    if (rowIndex != null) scheduleVisitList[rowIndex].visitDate = dateToUtcMidnightIsoString(visitDate);

    if (rowIndex != null && doctorId != null && doctorId != -1) {
      scheduleVisitList[rowIndex].doctorName = globalController.getDoctorNameById(doctorId);
    }

    scheduleVisitList.refresh();

    // getScheduleVisitList(isFist: true);
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

      getScheduleVisitList(isFist: true);
    } catch (e) {
      CustomToastification().showToast("$e", type: ToastificationType.error);
      getScheduleVisitList(isFist: true);
    }
  }

  Future<void> deletePatientVisit({required String id}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/visit/delete/$id", data: {});
    customPrint(response);
    CustomToastification().showToast("Visit delete successfully", type: ToastificationType.success);
    getScheduleVisitList(isFist: true);
  }

  // Function to map the status to color
  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return AppColors.filterPendingColor;
      case "Finalized":
        return AppColors.filterFinalizedColor;
      case "Checked-in":
        return AppColors.filterCheckedInColor;
      case "Checked-In":
        return AppColors.filterCheckedInColor;
      case "In-Progress":
        return AppColors.filterInProgressColor;
      case "Paused":
        return AppColors.filterPausedColor;
      case "Scheduled":
        return AppColors.filterScheduleColor;
      case "In-Room":
        return AppColors.filterNotRecordedColor;
      case "In-Exam":
        return AppColors.filterInProgressColor;
      case "Late":
        return AppColors.filterLateColor;
      case "Checked-out":
        return AppColors.filterCancelledColor;
      case "Cancelled":
        return AppColors.filterCanceledColor;
      case "No-Show":
        return AppColors.filterNoShowColor;
      case "Not-Recorded":
        return AppColors.filterNotRecordedColor;
      default:
        return AppColors.filterInsufficientInfoColor; // Default if status is unknown
    }
  }

  Future<void> getLatestBuild() async {
    final info = await PackageInfo.fromPlatform();

    customPrint(info.version);
    LatestBuildModel latestBuildModel = await _homeRepository.checkLatestBuild();

    String latestBuild = latestBuildModel.responseData?.dataValues?.versionNumber ?? "1.0";
    customPrint("Latest build :- $latestBuild");
    String currentBuild = info.version;
    customPrint("Current build:- $currentBuild");
    customPrint(isVersionGreater(latestBuild, currentBuild));
    if (isVersionGreater(latestBuild, currentBuild)) {
      customPrint("inside update");
      showIOSForceUpdateDialog(Get.context!, latestBuildModel.responseData?.dataValues?.versionSummary ?? "");
    } else {
      customPrint("outside update");
    }
  }

  Future<void> startVisit(String patientId, String visitId, String firstName, String lastName) async {
    if (globalController.visitId.isNotEmpty) {
      CustomToastification().showToast("Recording is already in progress", type: ToastificationType.info);
    } else {
      if (await globalController.recorderService.audioRecorder.hasPermission()) {
        globalController.isStartTranscript.value = true;

        // controller.globalController.patientId.value = controller.patientId.value;
        // controller.globalController.visitId.value = controller.visitId.value;

        globalController.patientFirstName.value = firstName;
        globalController.attachmentId.value = patientId;
        globalController.patientLsatName.value = lastName;
        globalController.patientFirstName.value = firstName;
        globalController.patientLsatName.value = lastName;
        globalController.valueOfx.value = 0;
        globalController.valueOfy.value = 0;

        globalController.visitId = RxString(visitId);
        globalController.patientId = RxString(patientId);

        globalController.changeStatus("In-Room");
        // If not recording, start the recording
        globalController.startAudioWidget();
        globalController.recorderService.audioRecorder = AudioRecorder();
        globalController.getConnectedInputDevices();
        await globalController.recorderService.startRecording(Get.context!);
        // controller.updateData();
      } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied)) {
        // Handle permission denial here

        showDialog(barrierDismissible: false, context: Get.context!, builder: (context) => const PermissionAlert(permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.", permissionTitle: " Microphone  permission request", isMicPermission: true));
      }
    }
  }

  bool isVersionGreater(String version1, String version2) {
    return compareVersions(version1, version2) > 0;
  }

  int compareVersions(String version1, String version2) {
    // Split version numbers into parts
    final v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Make both parts the same length by padding with zeros
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    // Compare each part
    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }

    return 0; // versions are equal
  }
}
