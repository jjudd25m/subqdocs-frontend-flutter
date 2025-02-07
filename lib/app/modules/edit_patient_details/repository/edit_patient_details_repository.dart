import '../../../data/provider/api_provider.dart';
import '../model/patient_detail_model.dart';

class EditPatientDetailsRepository {
  Future<PatientDetailModel> getPatient({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient/getPatientById/${id}");
    print("getPatient API  internal response $response");
    return PatientDetailModel.fromJson(response);
  }

  Future<dynamic> updatePatient({required String id, required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPut("patient/update/$id", param);
    print("updatePatient API  internal response $response");
    return response;
  }
}
