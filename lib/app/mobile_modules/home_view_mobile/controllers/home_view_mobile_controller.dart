import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:subqdocs/app/core/common/global_mobile_controller.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/app_update_dialog.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../../widgets/device_info_model.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../modules/add_patient/repository/add_patient_repository.dart';
import '../../../modules/home/model/latest_build_model.dart';
import '../../../modules/home/model/patient_list_model.dart';
import '../../../modules/home/model/schedule_visit_list_model.dart';
import '../../../modules/home/repository/home_repository.dart';
import '../../../modules/login/model/login_model.dart';
import '../../../modules/personal_setting/repository/personal_setting_repository.dart';
import '../../../routes/app_pages.dart';
import '../../add_recording_mobile_view/model/add_mobile_patient_model.dart';

class HomeViewMobileController extends GetxController {
  //TODO: Implement HomeViewMobileController

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  RxBool isQuickStartShow = RxBool(false);

  final AddPatientRepository _addPatientRepository = AddPatientRepository();

  final HomeRepository _homeRepository = HomeRepository();

  RxBool isHomePatientListLoading = RxBool(false);
  RxBool isHomeScheduleListLoading = RxBool(false);
  RxBool isHomePastPatientListLoading = RxBool(false);

  RxBool isLoading = RxBool(false);
  RxBool noMoreDataPatientList = RxBool(false);
  RxBool noMoreDataPastPatientList = RxBool(false);
  RxBool noMoreDataSchedulePatientList = RxBool(false);

  final Set<int> triggeredIndexes = <int>{};
  final Set<int> pastTriggeredIndexes = <int>{};
  final Set<int> scheduleTriggeredIndexes = <int>{};

  var pageSchedule = 1;
  var pagePast = 1;
  var pagePatient = 1;

  final ScrollController scrollControllerPatientList = ScrollController();
  final ScrollController scrollControllerPastPatientList = ScrollController();
  final ScrollController scrollControllerSchedulePatientList = ScrollController();

  RxBool showClearButton = RxBool(false);
  final GlobalMobileController globalController = Get.find();
  TextEditingController searchController = TextEditingController();

  Rxn<ScheduleVisitListModel> scheduleVisitListModel = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> scheduleVisitList = RxList<ScheduleVisitListData>();
  Rxn<ScheduleVisitListModel> pastVisitListModel = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> pastVisitList = RxList<ScheduleVisitListData>();

  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
  RxList<PatientListData> patientList = RxList<PatientListData>();

  @override
  Future<void> onInit() async {
    super.onInit();

    Get.put(GlobalMobileController());

    Map<String, String> deviceInfo = await DeviceInfoService.getDeviceInfoAsJson();
    print("device info is:- $deviceInfo");
    globalController.getUserDetail();
    handelInternetConnection();

    scrollControllerPatientList.addListener(_onScrollPatientList);
    scrollControllerPastPatientList.addListener(_onScrollPastPatientList);
    scrollControllerSchedulePatientList.addListener(_onScrollSchedulePatientList);
    searchController.clear();
    showClearButton.value = false;

    getOrganizationDetail();
    // getLatestBuild();
  }

  @override
  void onReady() {
    super.onReady();

    initialDataFetch();
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

  Future<void> getOrganizationDetail() async {
    try {
      globalController.getEMAOrganizationDetailModel.value = await _personalSettingRepository.getOrganizationDetail();

      // patientSyncSocketSetup();
      customPrint("isEmaIntegration is :- ${globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration}");
      customPrint("has_ema_configs is :- ${globalController.getEMAOrganizationDetailModel.value?.responseData?.has_ema_configs}");
    } catch (e) {
      customPrint("error on get OrganizationDetail :- $e");
    }
  }

  Future<void> getUserDetail() async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    globalController.getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.responseData?.user?.id.toString() ?? "");
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

    param['sorting'] = [
      {'id': 'appointmentTime', 'desc': true},
    ];

    customPrint("param:- $param");
    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);

    isHomePastPatientListLoading.value = false;

    if (pastVisitListModel.value?.responseData?.data != null) {
      pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
      update(); // This is crucial for GetBuilder
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

    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    param['sorting'] = [
      {'id': 'appointmentTime', 'desc': false},
    ];

    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

    isHomeScheduleListLoading.value = false;

    if (scheduleVisitListModel.value?.responseData?.data != null) {
      scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
      update(); // This is crucial for GetBuilder
    }
  }

  Future<void> getPatientList({String? sortingName = "", bool isLoading = false}) async {
    patientList.clear();
    isHomePatientListLoading.value = true;
    Map<String, dynamic> param = {};
    pagePatient = 1;
    triggeredIndexes.clear();

    param['page'] = 1;
    param['limit'] = "100";
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }
    patientListModel.value = await _homeRepository.getPatient(param: param);
    isHomePatientListLoading.value = false;
    if (patientListModel.value?.responseData?.data != null) {
      patientList.value = patientListModel.value?.responseData?.data ?? [];
      update(); // This is crucial for GetBuilder
    }
  }

  void handelInternetConnection() {
    final _ = InternetConnection().onStatusChange.listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          getPastVisitList();
          getScheduleVisitList();
          getPatientList();

          // List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();
          //
          // if (audio.isNotEmpty) {
          //   CustomToastification().showToast("Audio uploading start!", type: ToastificationType.info, toastDuration: 6);
          //
          //   // uploadAllAudioFiles(() {
          //   //   CustomToastification().showToast("All audio files have been uploaded!", type: ToastificationType.success, toastDuration: 6);
          //   //   // customPrint('All audio files have been uploaded!');
          //   // });
          // }

          break;
        case InternetStatus.disconnected:
          break;
      }
    });
  }

  // on scroll method

  @override
  void _onScrollPatientList() {
    if (!scrollControllerPatientList.hasClients) return;

    double offset = scrollControllerPatientList.position.pixels;
    int currentIndex = (offset / 40).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && (currentIndex - 50) % 100 == 0 && !triggeredIndexes.contains(currentIndex)) {
      triggeredIndexes.add(currentIndex); // Mark as triggered
      patientLoadMore();
      // customPrint("scroll is needed ${currentIndex}");
    } else {
      // customPrint("scroll is  not needed.  ${currentIndex}");
    }
  }

  void _onScrollPastPatientList() {
    if (!scrollControllerPastPatientList.hasClients) return;

    double offset = scrollControllerPastPatientList.position.pixels;
    int currentIndex = (offset / 40).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && (currentIndex - 50) % 100 == 0 && !pastTriggeredIndexes.contains(currentIndex)) {
      pastTriggeredIndexes.add(currentIndex); // Mark as triggered
      getPastVisitListFetchMore();

      // customPrint("scroll is needed $currentIndex");
    } else {
      // customPrint("scroll is  not needed.  $currentIndex");
    }
  }

  void _onScrollSchedulePatientList() {
    if (!scrollControllerSchedulePatientList.hasClients) return;

    double offset = scrollControllerSchedulePatientList.position.pixels;
    int currentIndex = (offset / 45).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && (currentIndex - 50) % 100 == 0 && !scheduleTriggeredIndexes.contains(currentIndex)) {
      scheduleTriggeredIndexes.add(currentIndex); // Mark as triggered
      getScheduleVisitListFetchMore();

      // customPrint("scroll is needed $currentIndex");
    } else {
      // customPrint("scroll is  not needed.  $currentIndex");
    }
  }

  void clearFilter({bool canPop = false, bool isRefresh = true}) {
    searchController.text = "";

    // startDate.value = "MM/DD/YYYY";
    // endDate.value = "";
    // fromController.clear();
    // toController.clear();

    if (isRefresh) {
      getPatientList();
      getScheduleVisitList();
      getPastVisitList();
    }
  }

  // fetch more data method

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
      if (searchController.text.isNotEmpty) {
        param['search'] = searchController.text;
      }

      param['sorting'] = [
        {'id': 'appointmentTime', 'desc': false},
      ];

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
          update(); // This is crucial for GetBuilder
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

  void patientLoadMore() async {
    customPrint("fetch more data beacuse needed");
    getPatientListFetchMore();
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

      patientListModel.value = await _homeRepository.getPatient(param: param);

      isLoading.value = false;
      if (patientListModel.value?.responseData?.data != null) {
        int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
        int? dataCount = patientList.length;

        if (patientList.length >= totalCount) {
          pagePatient--;
        } else {
          patientList.addAll(patientListModel.value?.responseData?.data as Iterable<PatientListData>);
          update(); // This is crucial for GetBuilder
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

      param['sorting'] = [
        {'id': 'appointmentTime', 'desc': true},
      ];

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
          update(); // This is crucial for GetBuilder
        }
      } else {
        pagePast--;
      }
    } else {
      noMoreDataPastPatientList.value = true;
      customPrint("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
    }
  }

  Future<void> createVisit(int patientId) async {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, dynamic> param = {};

    param['id'] = patientId;

    try {
      AddMobilePatientModel addPatientModel = await _addPatientRepository.addMobilePatient(param: param);
      customPrint("_addPatientRepository response is ${addPatientModel.toJson()} ");
      CustomToastification().showToast("Patient added successfully", type: ToastificationType.success);
      Loader().stopLoader();

      await Get.toNamed(Routes.ADD_RECORDING_MOBILE_VIEW, arguments: {"patientId": addPatientModel.responseData?.patientId.toString(), "visitId": addPatientModel.responseData?.id.toString()});
      updateTabbar();
    } catch (error) {
      customPrint("_addPatientRepository catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
      Loader().stopLoader();
    }
  }

  Future<void> initialDataFetch() async {
    await Future.wait([getPatientList(), getScheduleVisitList(isFist: true), getPastVisitList(isFist: true)]);
  }

  Future<void> updateTabbar() async {
    searchController.clear();
    showClearButton.value = false;
    clearFilter(isRefresh: false);
    initialDataFetch();

    // if (globalController.tabIndex.value == 0) {
    //   searchController.clear();
    //   showClearButton.value = false;
    //   globalController.tabIndex.value = 0;
    //   clearFilter(isRefresh: false);
    //   getPatientList();
    // } else if (globalController.tabIndex.value == 1) {
    //   globalController.tabIndex.value = 1;
    //
    //   searchController.clear();
    //   showClearButton.value = false;
    //   clearFilter(isRefresh: false);
    //   getScheduleVisitList(isFist: true);
    // } else if (globalController.tabIndex.value == 2) {
    //   globalController.tabIndex.value = 2;
    //   searchController.clear();
    //   showClearButton.value = false;
    //   clearFilter(isRefresh: false);
    //   getPastVisitList(isFist: true);
    // }
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

  String getScheduleDate(String visitDate) {
    if (visitDate != null) {
      DateTime visitdateTime = DateTime.parse(visitDate ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('d MMM');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDate = visitformattedDate;
      return visitDate;
    }
    return "";
  }

  String getScheduleTime(String visitTime) {
    if (visitTime != null) {
      DateTime visitdateTime = DateTime.parse(visitTime ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('hh:mm a');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      return visitTime = visitformattedDate;
    }
    return "";
  }
}
