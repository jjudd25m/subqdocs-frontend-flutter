import 'dart:io';

import 'package:mime/mime.dart';

import '../../../core/common/app_preferences.dart';
import '../../../data/provider/api_provider.dart';
import '../../patient_info/model/patient_view_list_model.dart';
import '../model/patient_attachment_list_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../model/visit_recap_list_model.dart';

class VisitMainRepository {
  Future<PatientTranscriptUploadModel> uploadAudio({required File audioFile, required String token, required String patientVisitId}) async {
    String? mimeType = lookupMimeType(audioFile.path);
    var response = await ApiProvider.instance.callPostMultiPartDio("patient/transcript/upload/$patientVisitId", {}, {"audio": audioFile}, mimeType ?? "", token);
    return PatientTranscriptUploadModel.fromJson(response);
  }

  Future<void> uploadAttachments({required Map<String, List<File>> files, required String token, required String patientVisitId}) async {
    var response = await ApiProvider.instance.callPostMultiPartDioListOfFiles(url: "patient/attachments/${patientVisitId}", params: {}, files: files, token: token);

    print(response);
  }

  Future<VisitRecapListModel> getVisitRecap({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-visit/getAllVisitRecap/$id");
    print("getVisitRecap API  internal response $response");
    return VisitRecapListModel.fromJson(response);
  }

  Future<PatientAttachmentListModel> getPatientAttachment({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient/attachments/$id");
    print("getPatientAttachment API internal response $response");
    return PatientAttachmentListModel.fromJson(response);
  }
}
