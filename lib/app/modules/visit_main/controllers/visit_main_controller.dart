import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../data/service/recorder_service.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../repository/visit_main_repository.dart';

class VisitMainController extends GetxController {
  //TODO: Implement VisitMainController

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  RecorderService recorderService = RecorderService();

  RxBool isExpandRecording = true.obs;
  final count = 0.obs;
  RxBool isStartRecording = false.obs;
  RxInt isSelectedAttchmentOption = RxInt(0);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> submitAudio(File audioFile) async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    PatientTranscriptUploadModel patientTranscriptUploadModel = await _visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: "1");
    print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

    Get.toNamed(Routes.PATIENT_INFO, arguments: {
      "trascriptUploadData": patientTranscriptUploadModel,
    });
  }
}
