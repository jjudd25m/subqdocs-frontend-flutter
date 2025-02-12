import 'dart:io';

import 'package:mime/mime.dart';

import '../../../core/common/app_preferences.dart';
import '../../../data/provider/api_provider.dart';
import '../model/patient_transcript_upload_model.dart';

class VisitMainRepository {
  Future<PatientTranscriptUploadModel> uploadAudio(
      {required File audioFile, required String token, required String patientVisitId}) async {
    String? mimeType = lookupMimeType(audioFile.path);
    var response = await ApiProvider.instance.callPostMultiPartDio(
        "patient/transcript/upload/$patientVisitId", {}, {"audio": audioFile}, mimeType ?? "", token);
    return PatientTranscriptUploadModel.fromJson(response);
  }

  Future<void> uploadAttachments(
      {required Map<String, List<File>> files, required String token, required String patientVisitId}) async {
    var response = await ApiProvider.instance.callPostMultiPartDioListOfFiles(
        url: "patient/attachments/${patientVisitId}", params: {}, files: files, token: token);

    print(response);
  }
}
