import 'dart:io';

import '../../../data/provider/api_provider.dart';
import '../model/add_patient_model.dart';

class AddPatientRepository {
  Future<AddPatientModel> addPatient(
      {required Map<String, dynamic> param, required Map<String, List<File>> files, required String token}) async {
    var response = await ApiProvider.instance
        .callPostMultiPartDioListOfFiles(params: param, url: "patient/create", files: files, token: token);
    print("addPatient API  internal response $response");
    return AddPatientModel.fromJson(response);
  }
}
