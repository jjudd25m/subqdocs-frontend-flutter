import 'dart:io';

import '../../../data/provider/api_provider.dart';
import '../model/patient_detail_model.dart';

class EditPatientDetailsRepository {
  Future<PatientDetailModel> getPatient({required String id, required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/getPatientById/${id}", queryParameters: param);
    print("response is for getPatient ID  $response");
    return PatientDetailModel.fromJson(response);
  }

  Future<dynamic> updatePatient(
      {required String id,
      required Map<String, dynamic> param,
      required Map<String, List<File>> files,
      required String token}) async {
    var response = await ApiProvider.instance
        .callPutMultiPartDioListOfFiles(url: "patient/update/$id", params: param, files: files, token: token);
    print("updatePatient API  internal response $response");
    return response;
  }
}
