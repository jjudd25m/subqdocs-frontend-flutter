import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  bool sortName = false;

  final count = 0.obs;

  RxInt tabIndex = RxInt(0);

  RxBool isPast = RxBool(false);
  RxBool isPagination = RxBool(false);
  var pagePatient = 1;

  var pageSchedule = 1;
  var pagePast = 1;

  @override
  void onInit() {
    super.onInit();

    getPatientList();
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

  void changeScreen(bool isPast) async {
    this.isPast.value = isPast;
    this.isPast.refresh();
  }

  Future<void> getPatientList({int? page}) async {
    Map<String, dynamic> param = {};

    param['page'] = 1;
    param['limit'] = "20";
    param['search'] = searchController.text;

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    // Dynamically add sorting to the param map
    param["sorting"] = sorting;

    if (toController.text != "" && fromController.text != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDate = DateFormat('MM-dd-yyyy').parse(fromController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDate}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDate = DateFormat('MM-dd-yyyy').parse(toController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    patientListModel.value = await _homeRepository.getPatient(param: param);
    patientList.value = patientListModel.value?.responseData?.data ?? [];
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

    if (toController.text != "" && fromController.text != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDate = DateFormat('MM-dd-yyyy').parse(fromController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDate}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDate = DateFormat('MM-dd-yyyy').parse(toController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

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

  Future<void> getScheduleVisitList() async {
    Map<String, dynamic> param = {};
    param['page'] = 1;
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

    if (toController.text != "" && fromController.text != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDate = DateFormat('MM-dd-yyyy').parse(fromController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDate}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDate = DateFormat('MM-dd-yyyy').parse(toController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }

    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);
    scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
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

    if (toController.text != "" && fromController.text != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDate = DateFormat('MM-dd-yyyy').parse(fromController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDate}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDate = DateFormat('MM-dd-yyyy').parse(toController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

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

  Future<void> getPastVisitList() async {
    Map<String, dynamic> param = {};
    param['page'] = 1;
    param['limit'] = "1";
    param['isPastPatient'] = 'true';
    param['search'] = searchController.text;

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    param["sorting"] = sorting;

    if (toController.text != "" && fromController.text != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDate = DateFormat('MM-dd-yyyy').parse(fromController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDate}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDate = DateFormat('MM-dd-yyyy').parse(toController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      param['dateRange'] = '{"startDate":"$formattedStartDate", "endDate":"$formattedEndDate"}';
    }
    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);
    pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
  }

  Future<void> getPastVisitListFetchMore() async {
    Map<String, dynamic> param = {};
    param['page'] = ++pagePast;
    param['limit'] = "1";
    param['isPastPatient'] = 'true';
    param['search'] = searchController.text;

    List<Map<String, dynamic>> sorting = [
      {"id": "first_name", "desc": sortName},
      {"id": "last_name", "desc": sortName}
      // Add more sorting parameters as needed
    ];

    param["sorting"] = sorting;

    if (toController.text != "" && fromController.text != "") {
      // DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromController.text);

      DateTime startDate = DateFormat('MM-dd-yyyy').parse(fromController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      print("start date is the ${startDate}");

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      print("start format date is  date is the ${formattedStartDate}");

      DateTime endDate = DateFormat('MM-dd-yyyy').parse(toController.text);
      // Format the DateTime to the required format (yyyy mm dd)

      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

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
}
