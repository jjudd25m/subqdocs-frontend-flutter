import 'dart:io';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../../models/MedicalRecords.dart';
import '../model/patient_detail_model.dart';

class EditPatientDetailsRepository {
  Future<PatientDetailModel> getPatient({required String id, required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getPatientById/${id}", queryParameters: param);
    print("response is for getPatient  $response");
    return PatientDetailModel.fromJson(response);
  }

  Future<PatientDetailModel> getPatientDetails({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient/${id}/profileDetails", queryParameters: {});
    print("response is for getPatientDetails  $response");

    PatientDetailModel res = PatientDetailModel.fromJson(response);
    print("response is for getPatientDetails  $res");
    return res;
    // return PatientDetailModel.fromJson(response);
  }

  Future<MedicalRecords> getMedicalRecords({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient/visitFullNoteData/${id}", queryParameters: {});
    print("response is for getMedicalRecords  $response");
    return MedicalRecords.fromJson(response);
  }

  Future<dynamic> updatePatient({required String id, required Map<String, dynamic> param, required Map<String, List<File>> files, required String token}) async {
    var response = await ApiProvider.instance.callPutMultiPartDioListOfFiles(url: "patient/update/$id", params: param, files: files, token: token);
    print("updatePatient API  internal response $response");
    return response;
  }

  Future<ChangeStatusModel> changeStatus({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient/updateVisitStatus/$id", params);
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }
}
