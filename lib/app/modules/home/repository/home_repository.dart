import 'package:flutter/foundation.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../../models/MedicalDoctorModel.dart';
import '../model/deletePatientModel.dart';
import '../model/patient_list_model.dart';
import '../model/patient_schedule_model.dart';
import '../model/schedule_visit_list_model.dart';

class HomeRepository {
  Future<PatientListModel> getPatient({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getAllPatients", queryParameters: param);
    // print("getPatient:- ${response}");
    // customPrint("getPatient API  internal response $response");
    return PatientListModel.fromJson(response);
  }

  Future<DeletePatientModel> deletePatientById({required int id}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/delete/${id}", data: {});
    // customPrint("getPatient API  internal response $response");
    return DeletePatientModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getScheduleVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getScheduledAndPastPatient", queryParameters: param);
    // customPrint("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<MedicalDoctorModel> getDoctorsAndMedicalAssistant({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("getUsersByRole", queryParameters: param);
    customPrint("getDoctorsAndMedicalAssistant API  internal response $response");
    return MedicalDoctorModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getPastVisit({required Map<String, dynamic> param}) async {
    // customPrint(param);

    var response = await ApiProvider.instance.callGet("patient/getScheduledAndPastPatient", queryParameters: param);
    customPrint("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<Map<String, dynamic>> getOfflineData() async {
    var response = await ApiProvider.instance.callGet("patient-visit-offline", queryParameters: {});
    // customPrint("offLineData is  $response");
    return response;
  }

  Future<StatusResponseModel> getStatus() async {
    var response = await ApiProvider.instance.callGet("patient/visit/status");
    // customPrint("getScheduleVisit API  internal response $response");
    return StatusResponseModel.fromJson(response);
  }

  Future<PatientScheduleModel> patientVisitCreate({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("patient-visit/create", params: param);
    return PatientScheduleModel.fromJson(response);
  }

  Future<dynamic> patientReScheduleVisit({required Map<String, dynamic> param, required String visitId}) async {
    var response = await ApiProvider.instance.callPut("patient-visit/update/$visitId", param);
    // customPrint("patientReScheduleVisit ${response}");
    return response;
  }

  Future<ChangeStatusModel> changeStatus({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient/updateVisitStatus/$id", params);
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }
}
