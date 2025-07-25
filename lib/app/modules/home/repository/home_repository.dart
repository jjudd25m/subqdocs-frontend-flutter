import 'package:subqdocs/app/models/open_ai_status.dart';
import 'package:subqdocs/app/modules/home/model/statusModel.dart';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../../models/MedicalDoctorModel.dart';
import '../model/deletePatientModel.dart';
import '../model/latest_build_model.dart';
import '../model/patient_list_model.dart';
import '../model/patient_schedule_model.dart';
import '../model/schedule_visit_list_model.dart';

class HomeRepository {
  Future<PatientListModel> getPatient({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getAllPatients", queryParameters: param);
    return PatientListModel.fromJson(response);
  }

  Future<DeletePatientModel> deletePatientById({required int id}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/delete/$id", data: {});
    return DeletePatientModel.fromJson(response);
  }

  Future<ScheduleVisitListModel> getScheduleVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getScheduledAndPastPatient", queryParameters: param);
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<MedicalDoctorModel> getDoctorsAndMedicalAssistant({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("getUsersByRole", queryParameters: param);
    customPrint("getDoctorsAndMedicalAssistant API  internal response $response");
    return MedicalDoctorModel.fromJson(response);
  }
  Future<OpenAiStatus> getOpenAiStatus() async {
    var response = await ApiProvider.instance.callGet("openAiStatus");
    customPrint("getDoctorsAndMedicalAssistant API  internal response $response");
    return OpenAiStatus.fromJson(response);
  }

  Future<ScheduleVisitListModel> getPastVisit({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getScheduledAndPastPatient", queryParameters: param);
    customPrint("getScheduleVisit API  internal response $response");
    return ScheduleVisitListModel.fromJson(response);
  }

  Future<Map<String, dynamic>> getOfflineData() async {
    var response = await ApiProvider.instance.callGet("patient-visit-offline", queryParameters: {});
    return response;
  }

  Future<StatusResponseModel> getStatus() async {
    var response = await ApiProvider.instance.callGet("patient/visit/status");
    return StatusResponseModel.fromJson(response);
  }

  Future<PatientScheduleModel> patientVisitCreate({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("patient-visit/create", params: param);
    return PatientScheduleModel.fromJson(response);
  }

  Future<dynamic> patientReScheduleVisit({required Map<String, dynamic> param, required String visitId}) async {
    var response = await ApiProvider.instance.callPut("patient-visit/update/$visitId", param);
    return response;
  }

  Future<ChangeStatusModel> changeStatus({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient/updateVisitStatus/$id", params);
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }

  Future<LatestBuildModel> checkLatestBuild({String buildType = "IOS"}) async {
    try {
      var response = await ApiProvider.instance.callGet("build/latest", queryParameters: {"build_type": buildType});
      customPrint("checkLatestBuild API  internal response $response");
      return LatestBuildModel.fromJson(response);
    } catch (e) {
      customPrint("checkLatestBuild API  internal response $e");
      return LatestBuildModel(responseType: "failure", message: "Something went wrong");
    }
  }
}
