import 'dart:io';

import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../mobile_modules/add_recording_mobile_view/model/add_mobile_patient_model.dart';
import '../model/add_patient_model.dart';
import '../model/latest_genrated_id.dart';

class AddPatientRepository {
  Future<AddPatientModel> addPatient({required Map<String, dynamic> param, required Map<String, List<File>> files, required String token}) async {
    var response = await ApiProvider.instance.callPostMultiPartDioListOfFiles(params: param, url: "patient/create", files: files, token: token);
    customPrint("addPatient API  internal response $response");
    return AddPatientModel.fromJson(response);
  }

  Future<LatestPatientId> getLatestId() async {
    var response = await ApiProvider.instance.callGet("latest-patient-id");
    customPrint("addPatient API  internal response $response");
    return LatestPatientId.fromJson(response);
  }

  Future<void> uploadAttachments({required Map<String, List<File>> files, required String token, required String patientVisitId}) async {
    var response = await ApiProvider.instance.callPostMultiPartDioListOfFiles(url: "patient/attachments/$patientVisitId", params: {}, files: files, token: token);

    customPrint(response);
  }

  Future<AddMobilePatientModel> addMobilePatient({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("patient/mobile/create", params: param);
    customPrint("addMobilePatient API  internal response $response");
    return AddMobilePatientModel.fromJson(response);
  }
}
