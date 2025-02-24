import 'package:flutter/foundation.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';

import '../../../data/provider/api_provider.dart';
import '../model/deletePatientModel.dart';
import '../model/patient_list_model.dart';
import '../model/patient_schedule_model.dart';
import '../model/schedule_visit_list_model.dart';

class HomeRepository {
  Future<PatientListModel> getPatient({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getAllPatients", queryParameters: param);
    print("getPatient API  internal response $response");
    return PatientListModel.fromJson(response);
  }

  Future<DeletePatientModel> deletePatientById({required int id}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/delete/${id}", data: {});
    print("getPatient API  internal response $response");
    return DeletePatientModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getScheduleVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getScheduledAndPastPatient", queryParameters: param);
    print("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getPastVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getScheduledAndPastPatient", queryParameters: param);
    print("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<StatusResponseModel> getStatus() async {
    var response = await ApiProvider.instance.callGet("patient/visit/status");
    print("getScheduleVisit API  internal response $response");
    return StatusResponseModel.fromJson(response);
  }

  Future<PatientScheduleModel> patientVisitCreate({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("patient-visit/create", params: param);
    return PatientScheduleModel.fromJson(response);
    print("patientVisitCreate API  internal response $response");
  }

  Future<dynamic> patientReScheduleVisit({required Map<String, dynamic> param, required String visitId}) async {
    var response = await ApiProvider.instance.callPut("patient-visit/update/$visitId", param);
    print("patientReScheduleVisit ${response}");
    return response;
    print("patientVisitCreate API  internal response $response");
  }
}
