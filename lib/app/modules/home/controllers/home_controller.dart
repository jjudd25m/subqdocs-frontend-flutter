import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';
import 'package:subqdocs/app/modules/home/model/Status.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/service/database_helper.dart';
import '../../../models/ChangeModel.dart';
import '../../login/model/login_model.dart';
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

  final GlobalController globalController = Get.find();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();

  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController searchController = TextEditingController();



  RxList<PatientListData> patientList = RxList<PatientListData>();
  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
  Rxn<PatientListModel> patientListModelOOffLine = Rxn<PatientListModel>();

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
  // final ScrollController scrollControllerPatientList = ScrollController();

  RxList<StatusModel> statusModel = RxList();

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

  Map<String, String> nameToIdMap = {
    "Patient Name": "first_name",
    "Visit Date": "appointmentTime",
    "Visit Date & Time": "appointmentTime",
    "Last Visit Date": "lastVisitDate",
    "Age": "age",
    "Gender": "gender",
    "Previous": "previousVisitCount",
    "Previous Visits": "previousVisitCount",
    "Status": "status",
  };

  RxBool isInternetConnected = RxBool(true);
  RxInt tabIndex = RxInt(0);

  var pagePatient = 1;

  final Set<int> triggeredIndexes = <int>{};
  final Set<int> pastTriggeredIndexes = <int>{};
  final Set<int> scheduleTriggeredIndexes = <int>{};
  var pageSchedule = 1;
  var pagePast = 1;
  Set<int> _loadedThresholds = Set<int>();
  RxBool isLoading = RxBool(false);
  RxBool noMoreDataPatientList = RxBool(false);
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
    return formatter.format(now);
  }

  // void _onScroll() {
  //
  //
  //   print("scolling");
  //   //
  //   // if (!isLoading.value) {
  //   //   int currentLength = patientList.length;
  //   //   if (currentLength % 50 == 0 && !_loadedThresholds.contains(currentLength)) {
  //   //     _loadedThresholds.add(currentLength);
  //   //
  //   //
  //   //     print("scroll is needed ${scrollControllerPatientList.position}");
  //   //   }else{
  //   //     print("scroll is  not needed.  ${scrollControllerPatientList.position}");
  //   //   }
  //   // }
  // }
  @override
  void _onScrollPatientList() {
    if (!scrollControllerPatientList.hasClients) return;

    double offset = scrollControllerPatientList.position.pixels;
    int currentIndex = (offset / 50).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && currentIndex % 35 == 0 && !triggeredIndexes.contains(currentIndex)) {
      triggeredIndexes.add(currentIndex); // Mark as triggered
      patientLoadMore();

      print("scroll is needed ${currentIndex}");
      // onLoadMore(currentIndex);
    } else {
      print("scroll is  not needed.  ${currentIndex}");
    }
  }

  void _onScrollPastPatientList() {
    if (!scrollControllerPastPatientList.hasClients) return;

    double offset = scrollControllerPastPatientList.position.pixels;
    int currentIndex = (offset / 50).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && currentIndex % 35 == 0 && !pastTriggeredIndexes.contains(currentIndex)) {
      pastTriggeredIndexes.add(currentIndex); // Mark as triggered
      getPastVisitListFetchMore();

      print("scroll is needed $currentIndex");
      // onLoadMore(currentIndex);
    } else {
      print("scroll is  not needed.  $currentIndex");
    }
  }

  void _onScrollSchedulePatientList() {
    if (!scrollControllerSchedulePatientList.hasClients) return;

    double offset = scrollControllerSchedulePatientList.position.pixels;
    int currentIndex = (offset / 50).toInt(); // Calculate the nearest multiple of 50

    if (currentIndex != 0 && currentIndex % 35 == 0 && !scheduleTriggeredIndexes.contains(currentIndex)) {
      scheduleTriggeredIndexes.add(currentIndex); // Mark as triggered
      getScheduleVisitListFetchMore();

      print("scroll is needed $currentIndex");
      // onLoadMore(currentIndex);
    } else {
      print("scroll is  not needed.  $currentIndex");
    }
  }

  Future<void> onInit() async {
    super.onInit();

    HomePastPatientListSortingModel? homePastPatientData = await AppPreference.instance.getHomePastPatientListSortingModel();

    print("homePastPatientData:- ${homePastPatientData?.toJson()}");

    handelInternetConnection();
    if (Get.arguments != null) {
      tabIndex.value = Get.arguments["tabIndex"] ?? 0;
      globalController.homeTabIndex.value = tabIndex.value;
    }
    getPatientList();
    getStatus();

    scrollControllerPatientList.addListener(_onScrollPatientList);
    scrollControllerPastPatientList.addListener(_onScrollPastPatientList);
    scrollControllerSchedulePatientList.addListener(_onScrollSchedulePatientList);
    //
    // _observer = ScrollObserver.sliverMulti(itemCount: items.length);
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

  bool? getDescValue(List<Map<String, dynamic>> sorting, String displayName, int tabIndex) {
    // Find the actual key (id) from the name-to-id map
    String? key = nameToIdMap[displayName];
    print("display name is :- ${displayName}");

    if (tabIndex == 0) {
      if (displayName == "Previous Visits") {
        key = "visitCount";
        print("is :- ${key}");
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

    print("tabindex is :- $tabIndex display name is :- $displayName");
    print("key name:- $key");

    if (tabIndex == 0 && displayName == "Previous Visits") {
      key = "visitCount";
      print("inside key visitCount");
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

  Future<void> getPatientList({String? sortingName = ""}) async {
    Map<String, dynamic> param = {};
    pagePatient = 1;

    param['page'] = 1;
    param['limit'] = "100";
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
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

    print("param:- $param");
    globalController.saveHomePatientListData();
    patientListModel.value = await _homeRepository.getPatient(param: param);

    if (patientListModel.value?.responseData?.data != null) {
      patientList.value = patientListModel.value?.responseData?.data ?? [];
      getLast2DaysData();
      getOfflineData();
    }

    for (var element in patientList) {
      // print("element is ${element.toJson()}");
    }
  }

  Future<void> getScheduleVisitList({String? sortingName = "", bool isFist = false}) async {
    pageSchedule = 1;

    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "100";
    param['isPastPatient'] = 'false';

    print("Schedule sorting name:- $sortingName");

    if (sortingName!.isNotEmpty) {
      globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting = toggleSortDesc(globalController.sortingSchedulePatient, sortingName ?? "", 1);
      print("toggle name:- ${toggleSortDesc(globalController.sortingPatientList, sortingName ?? "", 1)}");
      param["sorting"] = globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting;
      print("getScheduleVisitList if sorting empty");
    } else {
      param["sorting"] = globalController.homeScheduleListSortingModel.value?.scheduleVisitSelectedSorting;
      print("getScheduleVisitList else sorting empty");
    }
    // }
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    if (globalController.homeScheduleListSortingModel.value?.startDate != "" && globalController.homeScheduleListSortingModel.value?.endDate != "") {
      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homeScheduleListSortingModel.value?.startDate ?? "");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homeScheduleListSortingModel.value?.endDate ?? "");
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    print("param:- $param");
    globalController.saveHomeScheduleListData();
    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

    if (scheduleVisitListModel.value?.responseData?.data != null) {
      scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
      getLast2DaysData();
      getOfflineData();
    }
  }

  Future<void> getPastVisitList({String? sortingName = "", bool isFist = false}) async {
    pagePast = 1;

    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "100";
    param['isPastPatient'] = 'true';
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    if (sortingName!.isNotEmpty) {
      globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting = toggleSortDesc(globalController.sortingPastPatient, sortingName ?? "", 2);
      param["sorting"] = globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting;
    } else {
      param["sorting"] = globalController.homePastPatientListSortingModel.value?.pastVisitSelectedSorting;
    }

    if (globalController.homePastPatientListSortingModel.value?.selectedStatusIndex?.isNotEmpty ?? false) {
      List<String>? statusList = globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? [];

      if (statusList.length == 1) {
        param['status[0]'] = statusList;
      } else {
        param['status'] = statusList;
      }
    }

    if (globalController.homePastPatientListSortingModel.value?.startDate != "" && globalController.homePastPatientListSortingModel.value?.endDate != "") {
      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homePastPatientListSortingModel.value?.startDate ?? "");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(globalController.homePastPatientListSortingModel.value?.endDate ?? "");

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    print("param:- $param");
    globalController.saveHomePastPatientData();
    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);

    if (pastVisitListModel.value?.responseData?.data != null) {
      pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
      getLast2DaysData();
      getOfflineData();
    }
  }

  Future<void> getScheduleVisitListFetchMore() async {
    int? totalCount = scheduleVisitListModel.value?.responseData?.totalCount ?? 0;
    if (scheduleVisitList.length < totalCount) {
      print("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
      isLoading.value = true;
      Map<String, dynamic> param = {};
      param['page'] = ++pageSchedule;
      param['limit'] = "100";
      param['isPastPatient'] = 'false';
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
      print("no pagination is not needed  beacuse ${scheduleVisitList.length}  is this and $totalCount");
    }
  }

  Future<void> getPatientListFetchMore({int? page}) async {
    int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
    if (patientList.length < totalCount) {
      print("pagination is  needed  beacuse ${patientList.length}  is this and $totalCount");
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

      print("no pagination is not needed  beacuse ${patientList.length}  is this and $totalCount");
    }
  }
  // Future<void> getPatientListFetchMore({int? page}) async {
  //   isLoading.value = true;
  //   Map<String, dynamic> param = {};
  //
  //   param['page'] = ++pagePatient;
  //   param['limit'] = "100";
  //   if (searchController.text.isNotEmpty) {
  //     param['search'] = searchController.text;
  //   }
  //
  //   // Dynamically add sorting to the param map
  //   param["sorting"] = globalController.homePatientListSortingModel.value?.patientListSelectedSorting;
  //
  //   if (startDate.value != "" && endDate.value != "") {
  //     DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
  //     String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
  //     DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
  //     String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
  //     param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
  //   }
  //
  //   globalController.saveHomePatientListData();
  //   patientListModel.value = await _homeRepository.getPatient(param: param);
  //
  //   isLoading.value = false;
  //   if (patientListModel.value?.responseData?.data != null) {
  //     int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
  //     int? dataCount = patientList.length;
  //
  //     if (patientList.length >= totalCount!) {
  //       pagePatient--;
  //     } else {
  //       patientList.addAll(patientListModel.value?.responseData?.data as Iterable<PatientListData>);
  //     }
  //   } else {
  //     pagePatient--;
  //   }
  // }

  Future<void> getPastVisitListFetchMore() async {
    int? totalCount = pastVisitListModel.value?.responseData?.totalCount ?? 0;

    if (pastVisitList.length < totalCount) {
      print("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
      isLoading.value = true;
      Map<String, dynamic> param = {};
      param['page'] = ++pagePast;
      param['limit'] = "100";
      param['isPastPatient'] = 'true';
      if (searchController.text.isNotEmpty) {
        param['search'] = searchController.text;
      }

      if (globalController.homePastPatientListSortingModel.value?.selectedStatusIndex?.isNotEmpty ?? false) {
        List<String>? statusList = globalController.homePastPatientListSortingModel.value?.selectedStatusIndex ?? [];

        // customPrint("status array is- $statusList");
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
      print("no pagination is not needed  beacuse ${pastVisitList.length}  is this and $totalCount");
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
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 2)));
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    patientParam['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';

    Map<String, dynamic> scheduleParam = {};

    scheduleParam['page'] = 1;
    scheduleParam['limit'] = "100";
    scheduleParam['isPastPatient'] = 'false';
    String formattedStartDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String formattedEndDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 2)));
    scheduleParam['dateRange'] = '{"startDate":"$formattedStartDateSchedule", "endDate":"$formattedEndDateSchedule"}';
    Map<String, dynamic> pastParam = {};

    pastParam['page'] = 1;
    pastParam['limit'] = "100";
    pastParam['isPastPatient'] = 'true';
    String formattedStartDatePast = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 2)));
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
    // customPrint("function  is called ");

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

    statusModel.clear();

    statusResponseModel.responseData?.forEach(
      (element) {
        statusModel.add(StatusModel(status: element));
      },
    );
  }

  void patientLoadMore() async {
    customPrint("fetch more data beacuse needed");
    getPatientListFetchMore();
  }

  Future<void> deletePatientById(int? id) async {
    print("delete id is :- ${id}");
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
    print("celldata is :- ${cellData}");

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
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) async {
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
      uploadFutures.add(uploadLocalAudio(file).then((success) {
        if (success) {
          DatabaseHelper.instance.deleteAudioFile(file.id ?? 0);
        }
        return success;
      }));
    }

    await Future.wait(uploadFutures);

    onAllUploaded(); // This will trigger the callback function
  }

  Future<bool> uploadLocalAudio(AudioFile file) async {
    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      // customPrint("audio data is:- ${file.id}, ${file.fileName}, ${file.visitId}");

      PatientTranscriptUploadModel patientTranscriptUploadModel =
          await _visitMainRepository.uploadAudio(audioFile: File.fromUri(Uri.file(file.fileName ?? "")), token: loginData.responseData?.token ?? "", patientVisitId: file.visitId ?? "");
      // customPrint("audio upload response is:- ${patientTranscriptUploadModel.toJson()}");
      return true; // You might want to change this logic to match your actual upload process
    } catch (error) {
      // If an error occurs during upload, return false
      // customPrint('Failed to upload audio: $error');
      return false;
    }
  }

  Future<void> patientScheduleCreate({required Map<String, dynamic> param}) async {
    Loader().showLoadingDialogForSimpleLoader();

    try {
      PatientScheduleModel response = await _homeRepository.patientVisitCreate(param: param);
      // customPrint("patientVisitCreate API  internal response $response");
      CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);
      tabIndex.value = 1;
      globalController.homeTabIndex.value = 1;

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
      // customPrint("patientVisitCreate API  internal response $response");
      CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);
      tabIndex.value = 1;
      globalController.homeTabIndex.value = 1;

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

  Future<void> patientReScheduleCreate({required Map<String, dynamic> param, required String visitId}) async {
    customPrint("visit id :- $visitId");
    dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);
    customPrint("patientReScheduleCreate API  internal response $response");
    CustomToastification().showToast("Visit reschedule successfully", type: ToastificationType.success);
    getScheduleVisitList(isFist: true);
    // patientDetailModel.value = await _editPatientDetailsRepository.getPatientDetails(id: patientId.value);
    // getPatientDetails();
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
      default:
        return AppColors.filterInsufficientInfoColor; // Default if status is unknown
    }
  }
}
