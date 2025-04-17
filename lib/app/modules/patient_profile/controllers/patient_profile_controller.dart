import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:toastification/toastification.dart';

import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/global_controller.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../../routes/app_pages.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../home/model/patient_schedule_model.dart';
import '../../home/repository/home_repository.dart';

class PatientProfileController extends GetxController {
  //TODO: Implement PatientProfileController
  final GlobalController globalController = Get.find();
  final HomeRepository _homeRepository = HomeRepository();
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();
  Rxn<PatientDetailModel> patientDetailModel = Rxn();
  String patientId = "";
  String visitId = "";
  final count = 0.obs;

  RxString dob = RxString("N/A");

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.addRouteInit(Routes.PATIENT_PROFILE);
    });
    print("PatientProfileController init called");
    patientId = Get.arguments["patientData"];
    visitId = Get.arguments["visitId"];
  }

  @override
  void onReady() {
    super.onReady();
    getPatient(patientId, visitId);
  }

  @override
  void onClose() {
    super.onClose();

    if (globalController.getKeyByValue(globalController.breadcrumbHistory.last) == Routes.PATIENT_PROFILE) {
      globalController.popRoute();
    }
  }

  Future<void> onRefresh() async {
    print("_onRefresh called");
  }

  Future<void> changeStatus(String status, String strVisitId) async {
    try {
      Loader().showLoadingDialogForSimpleLoader();

      Map<String, dynamic> param = {};

      param['status'] = status;

      ChangeStatusModel changeStatusModel = await _editPatientDetailsRepository.changeStatus(id: strVisitId, params: param);
      Loader().stopLoader();
      if (changeStatusModel.responseType == "success") {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);
        getPatient(patientId, strVisitId);
      } else {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      }
    } catch (e) {
      Loader().stopLoader();
      CustomToastification().showToast("$e", type: ToastificationType.error);
    }
  }

  Future<void> getPatient(String id, String visitId) async {
    Loader().showLoadingDialogForSimpleLoader();

    Map<String, dynamic> param = {};

    if (visitId != "") {
      param['visit_id'] = visitId;
    }

    try {
      PatientDetailModel localPatientDetailModel = await _editPatientDetailsRepository.getPatientDetails(id: id);
      patientDetailModel.value = localPatientDetailModel;

      print("patientDetailModel-----:- ${patientDetailModel.value?.toJson()}");

      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(patientDetailModel.value?.responseData?.dateOfBirth ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat dateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String formattedDate = dateFormat.format(dateTime);
      dob.value = formattedDate;
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> patientScheduleCreate({required Map<String, dynamic> param}) async {
    PatientScheduleModel response = await _homeRepository.patientVisitCreate(param: param);
    print("patientVisitCreate API  internal response $response");
    CustomToastification().showToast(response.message ?? "", type: ToastificationType.success);
    getPatient(patientId, visitId);
  }

  Future<void> patientReScheduleCreate({required Map<String, dynamic> param, required String visitId}) async {
    print("visit id :- $visitId");
    dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);
    print("patientReScheduleCreate API  internal response $response");
    CustomToastification().showToast("Visit reschedule successfully", type: ToastificationType.success);
    getPatient(patientId, visitId);
  }

  Future<void> deletePatientVisit({required String id}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/visit/delete/$id", data: {});
    print(response);
    CustomToastification().showToast("Visit delete successfully", type: ToastificationType.success);
    getPatient(patientId, visitId);
  }
}
