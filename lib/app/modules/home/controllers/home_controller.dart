import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';
import 'package:subqdocs/app/modules/home/model/Status.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/service/database_helper.dart';
import '../../login/model/login_model.dart';
import '../../visit_main/model/patient_transcript_upload_model.dart';
import '../../visit_main/repository/visit_main_repository.dart';
import '../model/deletePatientModel.dart';
import '../model/patient_list_model.dart';
import '../model/patient_schedule_model.dart';
import '../model/schedule_visit_list_model.dart';
import '../repository/home_repository.dart';

// class HomeController extends GetxController {
//   //TODO: Implement HomeController
//
//   final GlobalController globalController = Get.find();
//   final VisitMainRepository _visitMainRepository = VisitMainRepository();
//
//   final HomeRepository _homeRepository = HomeRepository();
//   TextEditingController fromController = TextEditingController();
//   TextEditingController toController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//
//   RxList<PatientListData> patientList = RxList<PatientListData>();
//   Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();
//   Rxn<PatientListModel> patientListModelOOffLine = Rxn<PatientListModel>();
//
//   Rxn<ScheduleVisitListModel> scheduleVisitListModel = Rxn<ScheduleVisitListModel>();
//   Rxn<ScheduleVisitListModel> scheduleVisitListModelOffline = Rxn<ScheduleVisitListModel>();
//   RxList<ScheduleVisitListData> scheduleVisitList = RxList<ScheduleVisitListData>();
//
//   Rxn<ScheduleVisitListModel> pastVisitListModel = Rxn<ScheduleVisitListModel>();
//   Rxn<ScheduleVisitListModel> pastVisitListModelOfLine = Rxn<ScheduleVisitListModel>();
//   RxList<ScheduleVisitListData> pastVisitList = RxList<ScheduleVisitListData>();
//
//   RxList<StatusModel> statusModel = RxList();
//
//   // RxInt selectedIndex = RxInt(-1);
//   RxList<int> selectedStatusIndex = RxList();
//
//   RxString startDate = RxString("MM/DD/YYYY");
//   RxString endDate = RxString("");
//
//   List<DateTime> selectedValue = [];
//
//   List<Map<String, dynamic>> sortingPastPatient = [
//     {"id": "first_name", "desc": "true"},
//     {"id": "appointmentTime", "desc": "true"},
//     {"id": "age", "desc": "true"},
//     {"id": "gender", "desc": "true"},
//     {"id": "previousVisitCount", "desc": "true"},
//     {"id": "status", "desc": "true"},
//
//     // Add more sorting parameters as needed
//   ];
//
//   List<Map<String, dynamic>> sortingSchedulePatient = [
//     {"id": "first_name", "desc": "true"},
//     {"id": "appointmentTime", "desc": "true"},
//     {"id": "age", "desc": "true"},
//     {"id": "gender", "desc": "true"},
//     {"id": "previousVisitCount", "desc": "true"},
//
//     // Add more sorting parameters as needed
//   ];
//
//   List<Map<String, dynamic>> sortingPatientList = [
//     {"id": "first_name", "desc": true},
//     {"id": "lastVisitDate", "desc": true},
//     {"id": "age", "desc": true},
//     {"id": "gender", "desc": true},
//     {"id": "visitCount", "desc": true},
//
//     // Add more sorting parameters as needed
//   ];
//   Map<String, String> nameToIdMap = {
//     "Patient Name": "first_name",
//     "Visit Date": "appointmentTime",
//     "Visit Date & Time": "appointmentTime",
//     "Last Visit Date": "lastVisitDate",
//     "Age": "age",
//     "Gender": "gender",
//     "Previous": "previousVisitCount",
//     "Previous Visits": "previousVisitCount",
//     "Status": "status",
//   };
//
//   bool sortName = false;
//   RxBool isInternetConnected = RxBool(true);
//
//   final count = 0.obs;
//
//   RxInt tabIndex = RxInt(0);
//
//   RxBool isPast = RxBool(false);
//   RxBool isPagination = RxBool(false);
//
//   var pagePatient = 1;
//   var pageSchedule = 1;
//   var pagePast = 1;
//
//   RxInt colIndex = RxInt(-1);
//   RxBool isAsending = RxBool(false);
//
//   RxInt colindexSchedule = RxInt(-1);
//   RxBool isAsendingSchedule = RxBool(false);
//
//   RxInt colIndexPatient = RxInt(-1);
//   RxBool isAsendingPatient = RxBool(false);
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     handelInternetConnection();
//     if (Get.arguments != null) {
//       tabIndex.value = Get.arguments["tabIndex"] ?? 0;
//       globalController.homeTabIndex.value = tabIndex.value;
//       customPrint("tabe index is:- ${Get.arguments["tabIndex"]}");
//     }
//
//     getPatientList();
//     getStatus();
//     getScheduleVisitList();
//     getPastVisitList();
//   }
//
//   void increment() => count.value++;
//
//   bool? getDescValue(List<Map<String, dynamic>> sorting, String displayName) {
//     // Find the actual key (id) from the name-to-id map
//     String? key = nameToIdMap[displayName];
//
//     if (key == null) {
//       customPrint("Invalid display name: $displayName");
//       return null; // Return null if no matching key is found
//     }
//
//     // Iterate over the sorting list to find the map with the matching 'id'
//     for (var map in sorting) {
//       if (map["id"] == key) {
//         customPrint("boll is ${map["desc"]}");
//         return map["desc"]; // Return the 'desc' value (true/false)
//       }
//     }
//
//     customPrint("No matching 'id' found for $displayName");
//     return null; // Return null if no matching 'id' is found
//   }
//
//   void setDateRange() {
//     customPrint("function  is called ");
//
//     if (selectedValue.isNotEmpty) {
//       for (int i = 0; i < selectedValue.length; i++) {
//         var dateTime = selectedValue[i];
//         // Format the date to 'MM-dd-yyyy'
//         customPrint("goint to this ");
//         if (selectedValue.length == 1) {
//           startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
//           endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
//         } else {
//           if (i == 0) {
//             startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
//           } else {
//             endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
//           }
//         }
//       }
//     } else {
//       DateTime dateTime = DateTime.now();
//       startDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
//       endDate.value = '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
//     }
//     Get.back();
//   }
//
//   void clearFilter({bool canPop = false}) {
//     searchController.text = "";
//
//     startDate.value = "MM/DD/YYYY";
//     endDate.value = "";
//     selectedStatusIndex.clear();
//     fromController.clear();
//     toController.clear();
//     getPatientList();
//     getScheduleVisitList();
//     getPastVisitList();
//   }
//
//   void changeScreen(bool isPast) async {
//     this.isPast.value = isPast;
//     this.isPast.refresh();
//   }
//
//   List<Map<String, dynamic>> toggleSortDesc(List<Map<String, dynamic>> sorting, String displayName) {
//     // Find the actual key (id) from the name-to-id map
//     String? key = nameToIdMap[displayName];
//
//     if (key == null) {
//       customPrint("Invalid display name: $displayName");
//
//       List<Map<String, dynamic>> empty = [
//         // Add more sorting parameters as needed
//       ];
//       return empty; // Return the original list if no matching key is found
//     }
//
//     // Iterate over the sorting list to find the map with the matching 'id'
//     for (var map in sorting) {
//       if (map["id"] == key) {
//         // Toggle the 'desc' value: if it's true, set it to false, and vice versa
//         map["desc"] = map["desc"] == true ? false : true;
//         break; // Exit loop once we've updated the map
//       }
//     }
//
//     return sorting.where((map) => map['id'] == key).toList();
//   }
//
//   Future<void> getLast2DaysData() async {
//     Map<String, dynamic> patientParam = {};
//     //param for the
//     patientParam['page'] = 1;
//     patientParam['limit'] = "1000";
//     String formattedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 2)));
//     String formattedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     patientParam['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//
//     Map<String, dynamic> scheduleParam = {};
//
//     scheduleParam['page'] = 1;
//     scheduleParam['limit'] = "3000";
//     scheduleParam['isPastPatient'] = 'false';
//     String formattedStartDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     String formattedEndDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 2)));
//     scheduleParam['dateRange'] = '{"startDate":"$formattedStartDateSchedule", "endDate":"$formattedEndDateSchedule"}';
//     Map<String, dynamic> pastParam = {};
//
//     pastParam['page'] = 1;
//     pastParam['limit'] = "3000";
//     pastParam['isPastPatient'] = 'true';
//     String formattedStartDatePast = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 2)));
//     String formattedEndDatePast = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     pastParam['dateRange'] = '{"startDate":"$formattedStartDatePast", "endDate":"$formattedEndDatePast"}';
//
//     try {
//       patientListModelOOffLine.value = await _homeRepository.getPatient(param: patientParam);
//       scheduleVisitListModelOffline.value = await _homeRepository.getScheduleVisit(param: scheduleParam);
//       pastVisitListModelOfLine.value = await _homeRepository.getPastVisit(param: pastParam);
//
//       await AppPreference.instance.setString(AppString.patientList, json.encode(patientListModelOOffLine.toJson()));
//       await AppPreference.instance.setString(AppString.schedulePatientList, json.encode(scheduleVisitListModelOffline.toJson()));
//       await AppPreference.instance.setString(AppString.pastPatientList, json.encode(pastVisitListModelOfLine.toJson()));
//     } catch (e) {
//       customPrint(e);
//     }
//   }
//
//   Future<void> getPatientList({String? sortingName = ""}) async {
//     Map<String, dynamic> param = {};
//
//     param['page'] = 1;
//     param['limit'] = "3000";
//     // param['search'] = searchController.text;
//
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text;
//     }
//
//     // Dynamically add sorting to the param map
//
//     if (sortingName!.isNotEmpty) {
//       param["sorting"] = toggleSortDesc(sortingPatientList, sortingName ?? "");
//     }
//
//     if (startDate.value != "" && endDate.value != "") {
//       // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);
//
//       DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       customPrint("start date is the ${startDateTime}");
//
//       String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
//       customPrint("start format date is  date is the ${formattedStartDate}");
//
//       DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
//
//       param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//     }
//
//     patientListModel.value = await _homeRepository.getPatient(param: param);
//
//     if (patientListModel.value?.responseData?.data != null) {
//       patientList.value = patientListModel.value?.responseData?.data ?? [];
//       getLast2DaysData();
//       getOfflineData();
//     }
//
//     for (var element in patientList) {
//       print("element is ${element.toJson()}");
//     }
//   }
//
//   Future<void> getScheduleVisitList({String? sortingName = ""}) async {
//     Map<String, dynamic> param = {};
//     param['page'] = 1;
//     param['limit'] = "3000";
//     param['isPastPatient'] = 'false';
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text;
//     }
//
//     // Dynamically add sorting to the param map
//     if (sortingName!.isNotEmpty) {
//       param["sorting"] = toggleSortDesc(sortingSchedulePatient, sortingName ?? "");
//     }
//
//     if (startDate.value != "" && endDate.value != "") {
//       // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);
//
//       DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       customPrint("start date is the ${startDateTime}");
//
//       String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
//       customPrint("start format date is  date is the ${formattedStartDate}");
//
//       DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
//
//       param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//     }
//
//     scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);
//
//     if (scheduleVisitListModel.value?.responseData?.data != null) {
//       scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
//       getLast2DaysData();
//       getOfflineData();
//     }
//   }
//
//   Future<void> getPastVisitList({String? sortingName = ""}) async {
//     Map<String, dynamic> param = {};
//     param['page'] = 1;
//     param['limit'] = "3000";
//     param['isPastPatient'] = 'true';
//
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text;
//     }
//
//     if (sortingName!.isNotEmpty) {
//       param["sorting"] = toggleSortDesc(sortingPastPatient, sortingName ?? "");
//     }
//
//     if (selectedStatusIndex.isNotEmpty) {
//       List<String> statusList = selectedStatusIndex.map((e) => statusModel[e].status.toString()!).toList();
//
//       customPrint("status array is- $statusList");
//       if (statusList.length == 1) {
//         param['status[0]'] = statusList;
//       } else {
//         param['status'] = statusList;
//       }
//     }
//
//     if (startDate.value != "" && endDate.value != "") {
//       // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);
//
//       DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       customPrint("start date is the ${startDateTime}");
//
//       String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
//       customPrint("start format date is  date is the ${formattedStartDate}");
//
//       DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
//
//       param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//     }
//
//     pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);
//
//     if (pastVisitListModel.value?.responseData?.data != null) {
//       pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
//       getLast2DaysData();
//       getOfflineData();
//     }
//
//     // await AppPreference.instance.setString(AppString.pastPatientList, json.encode(pastVisitListModel.toJson()));
//   }
//
//   Future<void> getScheduleVisitListFetchMore() async {
//     Map<String, dynamic> param = {};
//     param['page'] = ++pageSchedule;
//     param['limit'] = "3000";
//     param['isPastPatient'] = 'false';
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text;
//     }
//
//     List<Map<String, dynamic>> sorting = [
//       {"id": "first_name", "desc": sortName},
//       {"id": "last_name", "desc": sortName}
//       // Add more sorting parameters as needed
//     ];
//
//     // Dynamically add sorting to the param map
//     param["sorting"] = sorting;
//
//     if (startDate.value != "" && endDate.value != "") {
//       // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);
//
//       DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       customPrint("start date is the ${startDateTime}");
//
//       String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
//       customPrint("start format date is  date is the ${formattedStartDate}");
//
//       DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
//
//       param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//     }
//
//     scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);
//
//     if (scheduleVisitListModel.value?.responseData?.data != null) {
//       int? totalCount = scheduleVisitListModel.value?.responseData?.totalCount ?? 0;
//       int? dataCount = scheduleVisitList.length;
//
//       if (scheduleVisitList.length >= totalCount!) {
//         customPrint("no data fetch and add");
//         pageSchedule--;
//       } else {
//         customPrint(" data fetch and add");
//         scheduleVisitList.addAll(scheduleVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
//       }
//     } else {
//       customPrint("no data fetch and add");
//       pageSchedule--;
//     }
//   }
//
//   Future<void> getPatientListFetchMore({int? page}) async {
//     Map<String, dynamic> param = {};
//
//     param['page'] = ++pagePatient;
//     param['limit'] = "3000";
//     param['search'] = searchController.text;
//
//     List<Map<String, dynamic>> sorting = [
//       {"id": "first_name", "desc": sortName},
//       {"id": "last_name", "desc": sortName}
//       // Add more sorting parameters as needed
//     ];
//
//     // Dynamically add sorting to the param map
//     param["sorting"] = sorting;
//
//     if (startDate.value != "" && endDate.value != "") {
//       // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);
//
//       DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       customPrint("start date is the ${startDateTime}");
//
//       String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
//       customPrint("start format date is  date is the ${formattedStartDate}");
//
//       DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
//
//       param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//     }
//
//     patientListModel.value = await _homeRepository.getPatient(param: param);
//
//     if (patientListModel.value?.responseData?.data != null) {
//       int? totalCount = patientListModel.value?.responseData?.totalCount ?? 0;
//       int? dataCount = patientList.length;
//
//       if (patientList.length >= totalCount!) {
//         customPrint("no data fetch and add");
//         pagePatient--;
//       } else {
//         customPrint(" data fetch and add");
//         patientList.addAll(patientListModel.value?.responseData?.data as Iterable<PatientListData>);
//       }
//     } else {
//       customPrint("no data fetch and add");
//       pagePatient--;
//     }
//
//     customPrint("patient list is the :- ${patientList}");
//   }
//
//   Future<void> getPastVisitListFetchMore() async {
//     Map<String, dynamic> param = {};
//     param['page'] = ++pagePast;
//     param['limit'] = "3000";
//     param['isPastPatient'] = 'true';
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text;
//     }
//
//     List<Map<String, dynamic>> sorting = [
//       {"id": "first_name", "desc": sortName},
//       {"id": "last_name", "desc": sortName}
//       // Add more sorting parameters as needed
//     ];
//
//     if (selectedStatusIndex.isNotEmpty) {
//       List<String> statusList = selectedStatusIndex.map((e) => statusModel[e].status!).toList();
//
//       customPrint("status array is- $statusList");
//       if (statusList.length == 1) {
//         param['status[0]'] = statusList;
//       } else {
//         param['status'] = statusList;
//       }
//     }
//
//     param["sorting"] = sorting;
//
//     if (startDate.value != "" && endDate.value != "") {
//       // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);
//
//       DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       customPrint("start date is the ${startDateTime}");
//
//       String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
//       customPrint("start format date is  date is the ${formattedStartDate}");
//
//       DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
//       // Format the DateTime to the required format (yyyy mm dd)
//
//       String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);
//
//       param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
//     }
//
//     pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);
//
//     if (pastVisitListModel.value?.responseData?.data != null) {
//       int? totalCount = pastVisitListModel.value?.responseData?.totalCount ?? 0;
//       int? dataCount = pastVisitList.length;
//
//       if (pastVisitList.length >= totalCount!) {
//         customPrint("no data fetch and add");
//         pagePast--;
//       } else {
//         customPrint(" data fetch and add");
//         pastVisitList.addAll(pastVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
//       }
//     } else {
//       customPrint("no data fetch and add");
//       pagePast--;
//     }
//   }
//
//   Future<void> getOfflineData() async {
//     var response = await _homeRepository.getOfflineData();
//
//     print(" response type is  the ${response["response_type"]}");
//
//     if (response["response_type"] == "success") {
//       await AppPreference.instance.setString(AppString.offLineData, json.encode(response));
//     }
//   }
//
//   Future<void> getStatus() async {
//     StatusResponseModel statusResponseModel = await _homeRepository.getStatus();
//
//     statusModel.clear();
//
//     statusResponseModel.responseData?.forEach(
//       (element) {
//         statusModel.add(StatusModel(status: element));
//       },
//     );
//   }
//
//   void patientLoadMore() async {
//     customPrint("fetch more data beacuse needed");
//     getPatientListFetchMore();
//   }
//
//   Future<void> deletePatientById(int? id) async {
//     print("delete id is :- ${id}");
//     DeletePatientModel deletePatientModel = await _homeRepository.deletePatientById(id: id!);
//
//     CustomToastification().showToast("Patient deleted successfully");
//     customPrint("deleted data is :- ${deletePatientModel}");
//     getPatientList();
//     getPastVisitList();
//     getScheduleVisitList();
//   }
//
//   void scheduleSorting({String cellData = "", int colIndex = -1}) {
//     getScheduleVisitList(sortingName: cellData);
//     colindexSchedule.value = colIndex;
//
//     isAsendingSchedule.value = getDescValue(sortingSchedulePatient, cellData) ?? false;
//     colindexSchedule.refresh();
//     isAsendingSchedule.refresh();
//   }
//
//   void patientSorting({String cellData = "", int colIndex = -1}) {
//     getPatientList(sortingName: cellData);
//     colIndexPatient.value = colIndex;
//
//     isAsendingPatient.value = getDescValue(sortingPatientList, cellData) ?? false;
//     colIndexPatient.refresh();
//     isAsendingPatient.refresh();
//   }
//
//   void handelInternetConnection() {
//     final listener = InternetConnection().onStatusChange.listen((InternetStatus status) async {
//       switch (status) {
//         case InternetStatus.connected:
//           customPrint("now its  connected ");
//           getPastVisitList();
//           getScheduleVisitList();
//           getPatientList();
//           getStatus();
//
//           List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();
//
//           customPrint("audio file count is :- ${audio.length}");
//           if (audio.isNotEmpty) {
//             CustomToastification().showToast("Audio uploading start!", type: ToastificationType.info, toastDuration: 6);
//
//             uploadAllAudioFiles(() {
//               CustomToastification().showToast("All audio files have been uploaded!", type: ToastificationType.success, toastDuration: 6);
//               customPrint('All audio files have been uploaded!');
//             });
//           }
//
//           break;
//         case InternetStatus.disconnected:
//           var patient = PatientListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.patientList)));
//
//           var schedule = ScheduleVisitListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.schedulePatientList)));
//
//           var past = ScheduleVisitListModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.pastPatientList)));
//           patientList.value = patient.responseData?.data ?? [];
//           scheduleVisitList.value = schedule.responseData?.data ?? [];
//           pastVisitList.value = past.responseData?.data ?? [];
//           patientList.refresh();
//           scheduleVisitList.refresh();
//           pastVisitList.refresh();
//
//           customPrint("now its not connected from the home repository ");
//           break;
//       }
//     });
//   }
//
//   Future<void> uploadAllAudioFiles(Function onAllUploaded) async {
//     List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();
//
//     List<Future<bool>> uploadFutures = [];
//
//     for (var file in audio) {
//       uploadFutures.add(uploadLocalAudio(file).then((success) {
//         if (success) {
//           DatabaseHelper.instance.deleteAudioFile(file.id ?? 0);
//         }
//         return success;
//       }));
//     }
//
//     await Future.wait(uploadFutures);
//
//     onAllUploaded(); // This will trigger the callback function
//   }
//
//   Future<bool> uploadLocalAudio(AudioFile file) async {
//     try {
//       var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
//
//       customPrint("audio data is:- ${file.id}, ${file.fileName}, ${file.visitId}");
//
//       PatientTranscriptUploadModel patientTranscriptUploadModel =
//           await _visitMainRepository.uploadAudio(audioFile: File.fromUri(Uri.file(file.fileName ?? "")), token: loginData.responseData?.token ?? "", patientVisitId: file.visitId ?? "");
//       customPrint("audio upload response is:- ${patientTranscriptUploadModel.toJson()}");
//       return true; // You might want to change this logic to match your actual upload process
//     } catch (error) {
//       // If an error occurs during upload, return false
//       customPrint('Failed to upload audio: $error');
//       return false;
//     }
//   }
//
//   Future<void> patientScheduleCreate({required Map<String, dynamic> param}) async {
//     Loader().showLoadingDialogForSimpleLoader();
//
//     try {
//       PatientScheduleModel response = await _homeRepository.patientVisitCreate(param: param);
//       customPrint("patientVisitCreate API  internal response $response");
//       CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);
//       tabIndex.value = 1;
//       globalController.homeTabIndex.value = 1;
//
//       getPastVisitList();
//       getScheduleVisitList();
//       getPatientList();
//
//       Get.back();
//     } catch (e) {
//       Get.back();
//     }
//   }
// }

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final GlobalController globalController = Get.find();
  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  List<Map<String, dynamic>> lastSorting = [];

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

  RxList<StatusModel> statusModel = RxList();

  // RxInt selectedIndex = RxInt(-1);
  RxList<int> selectedStatusIndex = RxList();

  RxString startDate = RxString("MM/DD/YYYY");
  RxString endDate = RxString("");

  List<DateTime> selectedValue = [];

  List<Map<String, dynamic>> sortingPastPatient = [
    {"id": "first_name", "desc": "true"},
    {"id": "appointmentTime", "desc": "true"},
    {"id": "age", "desc": "true"},
    {"id": "gender", "desc": "true"},
    {"id": "previousVisitCount", "desc": "true"},
    {"id": "status", "desc": "true"},

    // Add more sorting parameters as needed
  ];

  List<Map<String, dynamic>> sortingSchedulePatient = [
    {"id": "first_name", "desc": "true"},
    {"id": "appointmentTime", "desc": "true"},
    {"id": "age", "desc": "true"},
    {"id": "gender", "desc": "true"},
    {"id": "previousVisitCount", "desc": "true"},

    // Add more sorting parameters as needed
  ];

  List<Map<String, dynamic>> sortingPatientList = [
    {"id": "first_name", "desc": true},
    {"id": "lastVisitDate", "desc": true},
    {"id": "age", "desc": true},
    {"id": "gender", "desc": true},
    {"id": "visitCount", "desc": true},

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

    handelInternetConnection();
    if (Get.arguments != null) {
      tabIndex.value = Get.arguments["tabIndex"] ?? 0;
      globalController.homeTabIndex.value = tabIndex.value;
      // customPrint("tabe index is:- ${Get.arguments["tabIndex"]}");
    }

    getPatientList();
    getStatus();
    getScheduleVisitList();
    getPastVisitList();
  }

  void increment() => count.value++;

  bool? getDescValue(List<Map<String, dynamic>> sorting, String displayName) {
    // Find the actual key (id) from the name-to-id map
    String? key = nameToIdMap[displayName];

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

  void clearFilter({bool canPop = false}) {
    searchController.text = "";
    lastSorting = [];
    startDate.value = "MM/DD/YYYY";
    endDate.value = "";
    selectedStatusIndex.clear();
    fromController.clear();
    toController.clear();
    getPatientList();
    getScheduleVisitList();
    getPastVisitList();
  }

  void changeScreen(bool isPast) async {
    this.isPast.value = isPast;
    this.isPast.refresh();
  }

  List<Map<String, dynamic>> toggleSortDesc(List<Map<String, dynamic>> sorting, String displayName) {
    // Find the actual key (id) from the name-to-id map
    String? key = nameToIdMap[displayName];

    if (key == null) {
      // customPrint("Invalid display name: $displayName");

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
    scheduleParam['limit'] = "20";
    scheduleParam['isPastPatient'] = 'false';
    String formattedStartDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String formattedEndDateSchedule = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 2)));
    scheduleParam['dateRange'] = '{"startDate":"$formattedStartDateSchedule", "endDate":"$formattedEndDateSchedule"}';
    Map<String, dynamic> pastParam = {};

    pastParam['page'] = 1;
    pastParam['limit'] = "20";
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

  Future<void> getPatientList({String? sortingName = ""}) async {
    Map<String, dynamic> param = {};

    param['page'] = 1;
    param['limit'] = "20";
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    // Dynamically add sorting to the param map

    if (sortingName!.isNotEmpty) {
      lastSorting = toggleSortDesc(sortingPatientList, sortingName ?? "");
      param["sorting"] = toggleSortDesc(sortingPatientList, sortingName ?? "");
    }

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      // customPrint("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // customPrint("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    patientListModel.value = await _homeRepository.getPatient(param: param);

    if (patientListModel.value?.responseData?.data != null) {
      patientList.value = patientListModel.value?.responseData?.data ?? [];
      getLast2DaysData();
      getOfflineData();
    }

    for (var element in patientList) {
      print("element is ${element.toJson()}");
    }
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
    if (sortingName!.isNotEmpty) {
      lastSorting = toggleSortDesc(sortingPatientList, sortingName ?? "");
      param["sorting"] = toggleSortDesc(sortingSchedulePatient, sortingName ?? "");
    }

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      // customPrint("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // customPrint("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);

    if (scheduleVisitListModel.value?.responseData?.data != null) {
      scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
      getLast2DaysData();
      getOfflineData();
    }
  }

  Future<void> getPastVisitList({String? sortingName = ""}) async {
    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "20";
    param['isPastPatient'] = 'true';
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    if (sortingName!.isNotEmpty) {
      lastSorting = toggleSortDesc(sortingPatientList, sortingName ?? "");
      param["sorting"] = toggleSortDesc(sortingPastPatient, sortingName ?? "");
    }

    if (selectedStatusIndex.isNotEmpty) {
      List<String> statusList = selectedStatusIndex.map((e) => statusModel[e].status.toString()!).toList();

      // customPrint("status array is- $statusList");
      if (statusList.length == 1) {
        param['status[0]'] = statusList;
      } else {
        param['status'] = statusList;
      }
    }

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      // customPrint("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // customPrint("start format date is  date is the ${formattedStartDate}");

      DateTime endDateTime = DateFormat('MM/dd/yyyy').parse(endDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateTime);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);

    if (pastVisitListModel.value?.responseData?.data != null) {
      pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
      getLast2DaysData();
      getOfflineData();
    }

    // await AppPreference.instance.setString(AppString.pastPatientList, json.encode(pastVisitListModel.toJson()));
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
    param["sorting"] = lastSorting;

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      // customPrint("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // customPrint("start format date is  date is the ${formattedStartDate}");

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
  }

  Future<void> getPatientListFetchMore({int? page}) async {
    Map<String, dynamic> param = {};

    param['page'] = ++pagePatient;
    param['limit'] = "20";
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    // Dynamically add sorting to the param map
    param["sorting"] = lastSorting;

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      // customPrint("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // customPrint("start format date is  date is the ${formattedStartDate}");

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
        // customPrint("no data fetch and add");
        pagePatient--;
      } else {
        // customPrint(" data fetch and add");
        patientList.addAll(patientListModel.value?.responseData?.data as Iterable<PatientListData>);
      }
    } else {
      // customPrint("no data fetch and add");
      pagePatient--;
    }

    // customPrint("patient list is the :- ${patientList}");
  }

  Future<void> getPastVisitListFetchMore() async {
    Map<String, dynamic> param = {};
    param['page'] = ++pagePast;
    param['limit'] = "20";
    param['isPastPatient'] = 'true';
    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text;
    }

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    if (selectedStatusIndex.isNotEmpty) {
      List<String> statusList = selectedStatusIndex.map((e) => statusModel[e].status!).toList();

      // customPrint("status array is- $statusList");
      if (statusList.length == 1) {
        param['status[0]'] = statusList;
      } else {
        param['status'] = statusList;
      }
    }

    param["sorting"] = lastSorting;

    if (startDate.value != "" && endDate.value != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDateTime = DateFormat('MM/dd/yyyy').parse(startDate.value);
      // Format the DateTime to the required format (yyyy mm dd)

      // customPrint("start date is the ${startDateTime}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDateTime);
      // customPrint("start format date is  date is the ${formattedStartDate}");

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
        customPrint("no data fetch and add");
        pagePast--;
      } else {
        // customPrint(" data fetch and add");
        pastVisitList.addAll(pastVisitListModel.value?.responseData?.data as Iterable<ScheduleVisitListData>);
      }
    } else {
      // customPrint("no data fetch and add");
      pagePast--;
    }
  }

  Future<void> getOfflineData() async {
    var response = await _homeRepository.getOfflineData();

    print(" response type is  the ${response["response_type"]}");

    if (response["response_type"] == "success") {
      await AppPreference.instance.setString(AppString.offLineData, json.encode(response));
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
    // customPrint("fetch more data beacuse needed");
    getPatientListFetchMore();
  }

  Future<void> deletePatientById(int? id) async {
    print("delete id is :- ${id}");
    DeletePatientModel deletePatientModel = await _homeRepository.deletePatientById(id: id!);

    CustomToastification().showToast("Patient deleted successfully");
    // customPrint("deleted data is :- ${deletePatientModel}");
    getPatientList();
    getPastVisitList();
    getScheduleVisitList();
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
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          // customPrint("now its  connected ");
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

          // customPrint("now its not connected from the home repository ");
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

      getPastVisitList();
      getScheduleVisitList();
      getPatientList();

      Get.back();
    } catch (e) {
      Get.back();
    }
  }
}
