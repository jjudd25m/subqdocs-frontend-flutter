import 'dart:io';

import 'package:get/get.dart';
import 'package:mime/mime.dart';

import '../../../../widget/device_detection.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/global_mobile_controller.dart';
import '../../../core/common/logger.dart';
import '../../../data/provider/api_provider.dart';
import '../../../models/ChangeModel.dart';
import '../../forgot_password/models/common_respons.dart';
import '../model/all_attachment_list_model.dart';
import '../model/patient_attachment_list_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../model/visit_main_model.dart';
import '../model/visit_recap_list_model.dart';

class VisitMainRepository {
  Future<void> uploadAttachments({required Map<String, List<File>> files, required String token, required String patientVisitId, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPostMultiPartDioListOfFiles(url: "patient/attachments/$patientVisitId", params: params, files: files, token: token);

    customPrint("uploadAttachments API response :- $response");
    customPrint(response);
  }

  Future<PatientTranscriptUploadModel> uploadAudio({required File audioFile, required String token, required String patientVisitId}) async {
    final GlobalController globalController = Get.find();
    final GlobalMobileController globalMobileController = Get.find();

    String deviceType = await getDeviceType(Get.context!);
    bool is_multi_language_preference = false;

    if (deviceType == 'iPad') {
      is_multi_language_preference = globalController.getUserDetailModel.value?.responseData?.is_multi_language_preference ?? false;
    } else {
      is_multi_language_preference = globalMobileController.getUserDetailModel.value?.responseData?.is_multi_language_preference ?? false;
    }

    String? mimeType = lookupMimeType(audioFile.path);

    customPrint("uploadAudio :- $patientVisitId");

    var response = await ApiProvider.instance.callPostMultiPartDio("patient/transcript/upload/$patientVisitId", {"isMulti": is_multi_language_preference}, {"audio": audioFile}, mimeType ?? "", token);
    return PatientTranscriptUploadModel.fromJson(response);
  }

  // Future<void> uploadAttachments({required Map<String, List<File>> files, required String token, required String patientVisitId}) async {
  //   var response = await ApiProvider.instance.callPostMultiPartDioListOfFiles(url: "patient/attachments/$patientVisitId", params: {}, files: files, token: token);
  //
  //   customPrint("uploadAttachments API response :- $response");
  //   customPrint(response);
  // }

  Future<CommonResponse> deleteAttachments({required Map<String, List<int>> params}) async {
    var response = await ApiProvider.instance.callDelete(url: "patient/attachments", data: params);

    customPrint(response);
    return CommonResponse.fromJson(response);
  }

  Future<dynamic> updatePatientVisitView({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient-visit/update-visit/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  Future<VisitRecapListModel> getVisitRecap({required String id}) async {
    var response = await ApiProvider.instance.callGet("patient-visit/getAllVisitRecap/$id");
    customPrint("getVisitRecap API  internal response :- $response");
    customPrint("getVisitRecap API  internal response $response");
    return VisitRecapListModel.fromJson(response);
  }

  Future<dynamic> updateFullNote({required int id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("full-note/update/$id", params);
    customPrint("getPatientView API  internal response $response");
    return response;
  }

  Future<PatientAttachmentListModel> getPatientAttachment({required String id, required Map<String, dynamic> param}) async {
    try {
      var response = await ApiProvider.instance.callGet("patient/attachments/$id", queryParameters: param);
      customPrint("getPatientAttachment API internal response $response");

      PatientAttachmentListModel testing = PatientAttachmentListModel.fromJson(response);

      return testing;
      // return PatientAttachmentListModel.fromJson(response);
    } catch (e) {
      return PatientAttachmentListModel.fromJson({});
    }
  }

  Future<AllAttachmentListModel> getAllPatientAttachment({required String id, required Map<String, dynamic> param}) async {
    try {
      var response = await ApiProvider.instance.callGet("patient/attachments/viewAll/$id", queryParameters: param);
      customPrint("getAllPatientAttachment API internal response $response");
      return AllAttachmentListModel.fromJson(response);
    } catch (e) {
      return AllAttachmentListModel.fromJson({});
    }
  }

  Future<VisitMainPatientDetails> getPatientDetails({required Map<String, dynamic> param}) async {
    var response = await ApiProvider.instance.callGet("patient/visitMainPatientData", queryParameters: param);
    customPrint("getPatientDetails API internal response $response");
    return VisitMainPatientDetails.fromJson(response);
  }

  Future<ChangeStatusModel> changeStatus({required String id, required Map<String, dynamic> params}) async {
    var response = await ApiProvider.instance.callPut("patient/updateVisitStatus/$id", params);
    customPrint("changeStatus API  internal response $response");
    return ChangeStatusModel.fromJson(response);
  }
}
