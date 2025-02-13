import '../../../data/provider/api_provider.dart';
import '../model/patient_doctor_visit_data_model.dart';
import '../model/patient_fullnote_model.dart';
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

  Future<PatientDoctorVisitDataModel> getDoctorVisitData({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-visit/$id");
    print("getPatientView API  internal response $response");
    return PatientDoctorVisitDataModel.fromJson(response);
  }

  Future<PatientFullNoteModel> getFullNote({required String id}) async {
    var response = await ApiProvider.instance.callGet("full-note/$id");
    print("getFullNote API  internal response $response");
    return PatientFullNoteModel.fromJson(response);
  }

  Future<PatientFullNoteModel> getDoctorNote({required String id}) async {
    var response = await ApiProvider.instance.callGet("full-note/$id");
    print("getFullNote API  internal response $response");
    return PatientFullNoteModel.fromJson(response);
  }
}
