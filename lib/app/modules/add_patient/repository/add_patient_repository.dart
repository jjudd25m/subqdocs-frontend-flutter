import '../../../data/provider/api_provider.dart';
import '../model/add_patient_model.dart';

class AddPatientRepository {
  Future<AddPatientModel> addPatient({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callPost("patient/create", params: param);
    print("addPatient API  internal response $response");
    return AddPatientModel.fromJson(response);
  }
}
