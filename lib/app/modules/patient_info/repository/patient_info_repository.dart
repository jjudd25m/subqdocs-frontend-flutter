import '../../../data/provider/api_provider.dart';
import '../model/patient_view_list_model.dart';
import '../model/transcript_list_model.dart';

class PatientInfoRepository {
  Future<TranscriptListModel> getTranscript({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient/transcript/$id");
    print("getTranscript API  internal response $response");
    return TranscriptListModel.fromJson(response);
  }

  Future<PatientViewListModel> getPatientView({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-view/$id");
    print("getPatientView API  internal response $response");
    return PatientViewListModel.fromJson(response);
  }
}
