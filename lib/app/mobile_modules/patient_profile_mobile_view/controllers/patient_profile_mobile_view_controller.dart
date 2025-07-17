import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Loader.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/global_mobile_controller.dart';
import '../../../core/common/logger.dart';
import '../../../models/ChangeModel.dart';
import '../../../modules/edit_patient_details/model/patient_detail_model.dart';
import '../../../modules/edit_patient_details/repository/edit_patient_details_repository.dart';
import '../../../modules/home/repository/home_repository.dart';

class PatientProfileMobileViewController extends GetxController {
  //TODO: Implement PatientProfileMobileViewController

  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> tabKeys = [
    GlobalKey(), // Scheduled Visits (index 0)
    GlobalKey(), // Visit Recaps (index 1)
    GlobalKey(), // More Documents (index 2)
  ];

  final HomeRepository _homeRepository = HomeRepository();
  final EditPatientDetailsRepository _editPatientDetailsRepository = EditPatientDetailsRepository();
  final GlobalMobileController globalController = Get.find();
  Rxn<PatientDetailModel> patientDetailModel = Rxn();

  String patientId = "";

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    patientId = Get.arguments["patientId"];
    getPatient(patientId);
  }

  Future<void> getPatient(String id) async {
    Loader().showLoadingDialogForSimpleLoader();

    try {
      PatientDetailModel localPatientDetailModel = await _editPatientDetailsRepository.getPatientDetails(id: id);
      Loader().stopLoader();

      patientDetailModel.value = localPatientDetailModel;
    } catch (e) {
      Loader().stopLoader();
      CustomToastification().showToast(e.toString(), type: ToastificationType.error);
    }
  }

  String getDate(String? date) {
    String visitDate = "N/A";

    if (date != null) {
      DateTime visitdateTime = DateTime.parse(date ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDate = visitformattedDate;
    }
    return visitDate;
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

  Future<void> changeStatus(String status, String strVisitId) async {
    try {
      Loader().showLoadingDialogForSimpleLoader();

      Map<String, dynamic> param = {};

      param['status'] = status;

      ChangeStatusModel changeStatusModel = await _editPatientDetailsRepository.changeStatus(id: strVisitId, params: param);
      Loader().stopLoader();
      if (changeStatusModel.responseType == "success") {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.success);
        getPatient(patientId);
      } else {
        CustomToastification().showToast("${changeStatusModel.message}", type: ToastificationType.error);
      }
    } catch (e) {
      Loader().stopLoader();
      CustomToastification().showToast("$e", type: ToastificationType.error);
    }
  }

  Future<void> reScheduleVisit({required Map<String, dynamic> param, required String visitId}) async {
    dynamic response = await _homeRepository.patientReScheduleVisit(param: param, visitId: visitId);
    customPrint("patientReScheduleCreate API  internal response $response");
    CustomToastification().showToast("Visit reschedule successfully", type: ToastificationType.success);
    getPatient(patientId);
  }
}
