import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/model/Status.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../model/deletePatientModel.dart';
import '../model/patient_list_model.dart';
import '../model/schedule_visit_list_model.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxList<PatientListData> patientList = RxList<PatientListData>();
  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();

  Rxn<ScheduleVisitListModel> scheduleVisitListModel = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> scheduleVisitList = RxList<ScheduleVisitListData>();

  Rxn<ScheduleVisitListModel> pastVisitListModel = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> pastVisitList = RxList<ScheduleVisitListData>();

  RxList<StatusModel> statusModel = RxList();

  RxInt selectedIndex = RxInt(-1);

  RxString startDate = RxString("MM/DD/YYYY");
  RxString endDate = RxString("");

  List<DateTime> selectedValue = [];

  List<Map<String, dynamic>> sortingPastPatient = [
    {"id": "first_name", "desc": "false"},
    {"id": "appointmentTime", "desc": "false"},
    {"id": "age", "desc": "false"},
    {"id": "gender", "desc": "false"},
    {"id": "previousVisitCount", "desc": "false"},
    {"id": "status", "desc": "false"},

    // Add more sorting parameters as needed
  ];

  List<Map<String, dynamic>> sortingSchedulePatient = [
    {"id": "first_name", "desc": "false"},
    {"id": "appointmentTime", "desc": "false"},
    {"id": "age", "desc": "false"},
    {"id": "gender", "desc": "false"},
    {"id": "previousVisitCount", "desc": "false"},

    // Add more sorting parameters as needed
  ];

  List<Map<String, dynamic>> sortingPatientList = [
    {"id": "first_name", "desc": false},
    {"id": "lastVisitDate", "desc": false},
    {"id": "age", "desc": false},
    {"id": "gender", "desc": false},
    {"id": "visitCount", "desc": false},

    // Add more sorting parameters as needed
  ];
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

  bool sortName = false;
  RxBool isInternetConnected = RxBool(true);

  final count = 0.obs;

  RxInt tabIndex = RxInt(0);

  RxBool isPast = RxBool(false);
  RxBool isPagination = RxBool(false);

  var pagePatient = 1;
  var pageSchedule = 1;
  var pagePast = 1;

  RxInt colIndex = RxInt(-1);
  RxBool isAsending = RxBool(false);

  RxInt colindexSchedule = RxInt(-1);
  RxBool isAsendingSchedule = RxBool(false);

  RxInt colIndexPatient = RxInt(-1);
  RxBool isAsendingPatient = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    // bool result = await InternetConnection().hasInternetAccess;
    //
    // print("connection is the  $result");

    handelInternetConnection();
    if (Get.arguments != null) {
      tabIndex.value = Get.arguments["tabIndex"] ?? 0;

      print("tabe index is:- ${Get.arguments["tabIndex"]}");
    }

    getPatientList();
    getStatus();

    getScheduleVisitList();
    getPastVisitList();
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

  bool? getDescValue(List<Map<String, dynamic>> sorting, String displayName) {
    // Find the actual key (id) from the name-to-id map
    String? key = nameToIdMap[displayName];

    if (key == null) {
      print("Invalid display name: $displayName");
      return null; // Return null if no matching key is found
    }

    // Iterate over the sorting list to find the map with the matching 'id'
    for (var map in sorting) {
      if (map["id"] == key) {
        print("boll is ${map["desc"]}");
        return map["desc"]; // Return the 'desc' value (true/false)
      }
    }

    print("No matching 'id' found for $displayName");
    return null; // Return null if no matching 'id' is found
  }

  void setDateRange() {
    print("function  is called ");

    if (selectedValue.isNotEmpty) {
      for (int i = 0; i < selectedValue.length; i++) {
        var dateTime = selectedValue[i];
        // Format the date to 'MM-dd-yyyy'
        print("goint to this ");
        if (selectedValue.length == 1) {
          startDate.value =
              '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          endDate.value =
              '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
        } else {
          if (i == 0) {
            startDate.value =
                '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          } else {
            endDate.value =
                '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
          }
        }
      }
    } else {
      DateTime dateTime = DateTime.now();
      startDate.value =
          '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
      endDate.value =
          '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
    }
    Get.back();
  }

  void clearFilter({bool canPop = false}) {
    searchController.text = "";

    startDate.value = "MM/DD/YYYY";
    endDate.value = "";

    fromController.clear();
    toController.clear();
    getPatientList();
    getScheduleVisitList();
    getPastVisitList();

    // if(canPop)
    //   {
    //     Get.ca
    //   }
  }

  void changeScreen(bool isPast) async {
    this.isPast.value = isPast;
    this.isPast.refresh();
  }

  List<Map<String, dynamic>> toggleSortDesc(List<Map<String, dynamic>> sorting, String displayName) {
    // Find the actual key (id) from the name-to-id map
    String? key = nameToIdMap[displayName];

    if (key == null) {
      print("Invalid display name: $displayName");

      List<Map<String, dynamic>> empty = [
        // Add more sorting parameters as needed
      ];
      return empty; // Return the original list if no matching key is found
    }

    // Iterate over the sorting list to find the map with the matching 'id'
    for (var map in sorting) {
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

    param['page'] = 1;
    param['limit'] = "20";
    param['search'] = searchController.text;

    // Dynamically add sorting to the param map
    param["sorting"] = toggleSortDesc(sortingPatientList, sortingName ?? "");

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    patientListModel.value = await _homeRepository.getPatient(param: param);

    patientList.value = patientListModel.value?.responseData?.data ?? [];

    await AppPreference.instance.setString(AppString.patientList, json.encode(patientListModel.toJson()));

    print("patient list is the :- ${patientList}");
  }

  Future<void> getPatientListFetchMore({int? page}) async {
    Map<String, dynamic> param = {};

    param['page'] = ++pagePatient;
    param['limit'] = "20";
    param['search'] = searchController.text;

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    // Dynamically add sorting to the param map
    param["sorting"] = sorting;

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    patientListModel.value = await _homeRepository.getPatient(param: param);

    if (patientListModel.value?.responseData?.data != null) {
      int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
      int? dataCount = patientList.length;

      if (patientList.length >= totalCount!) {
        print("no data fetch and add");
        pagePatient--;
      } else {
        print(" data fetch and add");
        patientList.addAll(patientListModel.value?.responseData?.data as Iterable<PatientListData>);
      }
    } else {
      print("no data fetch and add");
      pagePatient--;
    }

    print("patient list is the :- ${patientList}");
  }

  Future<void> getScheduleVisitList({String? sortingName = ""}) async {
    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "20";
    param['isPastPatient'] = 'false';
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    // Dynamically add sorting to the param map
    param["sorting"] = toggleSortDesc(sortingSchedulePatient, sortingName ?? "");

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

    scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
    await AppPreference.instance.setString(AppString.schedulePatientList, json.encode(scheduleVisitListModel.toJson()));
  }

  Future<void> getScheduleVisitListFetchMore() async {
    Map<String, dynamic> param = {};
    param['page'] = ++pageSchedule;
    param['limit'] = "20";
    param['isPastPatient'] = 'false';
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    // Dynamically add sorting to the param map
    param["sorting"] = sorting;

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

    if (scheduleVisitListModel.value?.responseData?.data != null) {
      int? totalCount = scheduleVisitListModel.value?.responseData?.totalCount ?? 0;
      int? dataCount = scheduleVisitList.length;

      if (scheduleVisitList.length >= totalCount!) {
        print("no data fetch and add");
        pageSchedule--;
      } else {
        print(" data fetch and add");
        scheduleVisitList.addAll(scheduleVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
      }
    } else {
      print("no data fetch and add");
      pageSchedule--;
    }
    // scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
  }

  Future<void> getPastVisitList({String? sortingName = ""}) async {
    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "20";
    param['isPastPatient'] = 'true';
    param['search'] = searchController.text;

    param["sorting"] = toggleSortDesc(sortingPastPatient, sortingName ?? "");

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);
    pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];

    await AppPreference.instance.setString(AppString.pastPatientList, json.encode(pastVisitListModel.toJson()));
  }

  Future<void> getPastVisitListFetchMore() async {
    Map<String, dynamic> param = {};
    param['page'] = ++pagePast;
    param['limit'] = "20";
    param['isPastPatient'] = 'true';
    param['search'] = searchController.text;

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    param["sorting"] = sorting;

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);

    if (pastVisitListModel.value?.responseData?.data != null) {
      int? totalCount = pastVisitListModel.value?.responseData?.totalCount ?? 0;
      int? dataCount = pastVisitList.length;

      if (pastVisitList.length >= totalCount!) {
        print("no data fetch and add");
        pagePast--;
      } else {
        print(" data fetch and add");
        pastVisitList.addAll(pastVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
      }
    } else {
      print("no data fetch and add");
      pagePast--;
    }

    // pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
  }

  Future<void> getStatus() async {
    StatusResponseModel statusResponseModel = await _homeRepository.getStatus();

    statusResponseModel.responseData?.forEach(
      (element) {
        statusModel.add(StatusModel(status: element));
      },
    );

    // pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
  }

  void patientLoadMore() async {
    print("fetch more data beacuse needed");
    getPatientListFetchMore();

    // patientFetchMoreData();
  }

  // Future<void> patientFetchMoreData() async {
  //   isPagination.value = true;
  //   print("fetch more data API called");
  //   page = page + 1;
  //
  //   Map<String, dynamic> param = {};
  //   param['page'] = page;
  //   param['limit'] = "4";
  //
  //   PatientListModel localPatientList = await _homeRepository.getPatient(param: param);
  //   // findContractorListData.add = findContractorListModel.data ?? [];
  //   patientList.addAll(localPatientList.responseData?.data as Iterable<PatientListData>);
  //   isPagination.value = false;
  // }

  Future<void> deletePatientById(int? id) async {
    DeletePatientModel deletePatientModel = await _homeRepository.deletePatientById(id: id!);
    getPatientList();
    getPastVisitList();
    getScheduleVisitList();

    print("deleted data is :- ${deletePatientModel}");
  }

  void scheduleSorting({String cellData = "", int colIndex = -1}) {
    getScheduleVisitList(sortingName: cellData);
    colindexSchedule.value = colIndex;

    isAsendingSchedule.value = getDescValue(sortingSchedulePatient, cellData) ?? false;
    colindexSchedule.refresh();
    isAsendingSchedule.refresh();
  }

  void patientSorting({String cellData = "", int colIndex = -1}) {
    getPatientList(sortingName: cellData);
    colIndexPatient.value = colIndex;

    isAsendingPatient.value = getDescValue(sortingPatientList, cellData) ?? false;
    colIndexPatient.refresh();
    isAsendingPatient.refresh();
  }

  void handelInternetConnection() {
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          print("now its  connected ");
          getPastVisitList();
          getScheduleVisitList();
          getPatientList();

          break;
        case InternetStatus.disconnected:
          var patient = PatientListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.patientList)));
          var schedulePatient = ScheduleVisitListModel.fromJson(
              jsonDecode(AppPreference.instance.getString(AppString.schedulePatientList)));
          var pastPatient =
              ScheduleVisitListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.pastPatientList)));

          patientList.value = patient.responseData?.data ?? [];
          scheduleVisitList.value = schedulePatient.responseData?.data ?? [];
          pastVisitList.value = pastPatient.responseData?.data ?? [];
          patientList.refresh();
          scheduleVisitList.refresh();
          pastVisitList.refresh();

          print("now its not connected ");
          break;
      }
    });
  }
}
