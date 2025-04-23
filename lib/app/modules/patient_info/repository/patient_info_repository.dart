import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../model/patient_doctor_visit_data_model.dart';
import '../model/patient_fullnote_model.dart';
import '../model/patient_view_list_model.dart';
import '../model/transcript_list_model.dart';

class PatientInfoRepository {
  Future<TranscriptListModel> getTranscript({required String id}) async {
    try {
      var response = await ApiProvider.instance.callGet("patient/transcript/$id");
      customPrint("getTranscript API  internal response $response");
      return TranscriptListModel.fromJson(response);
    } catch (e) {
      customPrint("getTranscript API  internal response $e");
      return TranscriptListModel();
    }
  }

  Future<PatientViewListModel> getPatientView({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-view/$id");
    customPrint("getPatientView API  internal response $response");
    return PatientViewListModel.fromJson(response);
  }

  Future<ChangeStatusModel> getStatus() async {
    var response = await ApiProvider.instance.callGet("patient/visit/status", queryParameters: {});
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }

  Future<ChangeStatusModel> changeStatus({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient/updateVisitStatus/$id", params);
    customPrint("getPatientView API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }

  Future<PatientDoctorVisitDataModel> getDoctorVisitData({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-visit/$id");
    customPrint("getPatientView API  internal response $response");
    return PatientDoctorVisitDataModel.fromJson(response);
  }

  Future<PatientFullNoteModel> getFullNote({required String id}) async {
    var response = await ApiProvider.instance.callGet("full-note/$id");
    customPrint("getFullNote API  internal response $response");
    return PatientFullNoteModel.fromJson(response);
  }

  Future<DoctorViewModel> getDoctorNote({required String id}) async {
    var response = await ApiProvider.instance.callGet("doctors-view/$id");
    customPrint("getDoctorNote API  internal response $response");
    return DoctorViewModel.fromJson(response);
  }

  Future<dynamic> updateDoctorView({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("doctors-view-table/update/$id", params);
    customPrint("updateDoctorView API  internal response $response");
    return response;
  }
}
