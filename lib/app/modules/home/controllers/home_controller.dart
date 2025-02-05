import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/patient_list_model.dart';
import '../model/schedule_visit_list_model.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  RxList<PatientListData> patientList = RxList<PatientListData>();
  Rxn<PatientListModel> patientListModel = Rxn<PatientListModel>();

  Rxn<ScheduleVisitListModel> scheduleVisitListModel = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> scheduleVisitList = RxList<ScheduleVisitListData>();

  Rxn<ScheduleVisitListModel> pastVisitListModel = Rxn<ScheduleVisitListModel>();
  RxList<ScheduleVisitListData> pastVisitList = RxList<ScheduleVisitListData>();

  final count = 0.obs;

  RxInt tabIndex = RxInt(0);

  RxBool isPast = RxBool(false);
  RxBool isPagination = RxBool(false);
  var page = 1;

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

  Future<void> getPatientList() async {
    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "1000";

    patientListModel.value = await _homeRepository.getPatient(param: param);
    patientList.value = patientListModel.value?.responseData?.data ?? [];
    print("patient List is :- ${patientList}");
  }

  Future<void> getScheduleVisitList() async {
    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "1000";
    param['patientType'] = "Pending";
    scheduleVisitListModel.value = await _homeRepository.getScheduleVisit(param: param);
    scheduleVisitList.value = scheduleVisitListModel.value?.responseData?.data ?? [];
  }

  Future<void> getPastVisitList() async {
    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "1000";
    param['patientType'] = "Finalize";
    pastVisitListModel.value = await _homeRepository.getPastVisit(param: param);
    pastVisitList.value = pastVisitListModel.value?.responseData?.data ?? [];
  }

  void patientLoadMore() {
    if (patientListModel.value?.responseData?.data?.length == patientListModel.value?.responseData?.totalCount) return;
    if (isPagination.value != false) return;
    patientFetchMoreData();
  }

  Future<void> patientFetchMoreData() async {
    isPagination.value = true;
    print("fetch more data API called");
    page = page + 1;

    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "1000";

    PatientListModel localPatientList = await _homeRepository.getPatient(param: {});
    // findContractorListData.add = findContractorListModel.data ?? [];
    patientList.addAll(localPatientList.responseData?.data as Iterable<PatientListData>);
    isPagination.value = false;
  }
}
