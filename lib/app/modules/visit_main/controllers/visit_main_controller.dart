import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../data/service/database_helper.dart';
import '../../../data/service/recorder_service.dart';
import '../../../routes/app_pages.dart';
import '../../login/model/login_model.dart';
import '../model/patient_transcript_upload_model.dart';
import '../repository/visit_main_repository.dart';

class VisitMainController extends GetxController {
  //TODO: Implement VisitMainController

  RxBool isLoading = RxBool(false);
  RxString loadingMessage = RxString("");

  final VisitMainRepository _visitMainRepository = VisitMainRepository();
  RecorderService recorderService = RecorderService();

  RxBool isExpandRecording = true.obs;
  final count = 0.obs;
  RxBool isStartRecording = false.obs;
  RxInt isSelectedAttchmentOption = RxInt(0);
  List<String> patientType = ["New Patient", "Old Patient"];
  RxnString selectedMedicalAssistant = RxnString();

  RxString visitId = RxString("");

  @override
  Future<void> onInit() async {
    super.onInit();

    visitId.value = Get.arguments["visitId"];
    print("visit id is :- $visitId");

    List<AudioFile> pendingFiles = await DatabaseHelper.instance.getPendingAudioFiles();
    print("local audio is :- ${pendingFiles}");
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

  // Future<void> submitAudio(File audioFile) async {
  //   isLoading.value = true;
  //   loadingMessage.value = "Uploading Audio";
  //
  //   var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
  //
  //   PatientTranscriptUploadModel patientTranscriptUploadModel = await _visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);
  //   print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");
  //
  //   isLoading.value = false;
  //
  //   Get.toNamed(Routes.PATIENT_INFO, arguments: {
  //     "trascriptUploadData": patientTranscriptUploadModel,
  //   });
  // }

  Future<void> submitAudio(File audioFile) async {
    isLoading.value = true;
    loadingMessage.value = "Uploading Audio";

    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

    bool isConnected = await isInternetAvailable();

    if (!isConnected) {
      print("No internet connection");
      // If no internet, save audio as BLOB in the local database
      Uint8List audioBytes = await audioFile.readAsBytes(); // Read audio file as bytes

      AudioFile audioFileToSave = AudioFile(
        audioData: audioBytes,
        fileName: audioFile.uri.pathSegments.last,
        status: 'pending',
      );

      await DatabaseHelper.instance.insertAudioFile(audioFileToSave);

      // Show a message or update UI
      loadingMessage.value = "Audio saved locally. Will upload when internet is available.";
      isLoading.value = false;

      return;
    } else {
      print("internet connected");
      // If there is internet, upload the audio
      PatientTranscriptUploadModel patientTranscriptUploadModel =
          await _visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);

      print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

      isLoading.value = false;

      // Navigate to the next screen
      Get.toNamed(Routes.PATIENT_INFO, arguments: {
        "trascriptUploadData": patientTranscriptUploadModel,
      });
    }
  }

  Future<void> uploadPendingAudioFiles() async {
    bool isConnected = await isInternetAvailable();

    if (!isConnected) return;

    List<AudioFile> pendingFiles = await DatabaseHelper.instance.getPendingAudioFiles();

    for (var file in pendingFiles) {
      // Convert BLOB data back into a file (audioBytes)
      Uint8List audioBytes = file.audioData;
      File audioFile = File('${Directory.systemTemp.path}/${file.fileName}');

      // Write the audio bytes to a temporary file
      await audioFile.writeAsBytes(audioBytes as List<int>);

      try {
        var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
        PatientTranscriptUploadModel patientTranscriptUploadModel =
            await _visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId.value);

        print("audio upload response is :- ${patientTranscriptUploadModel.toJson()}");

        // On successful upload, update the local database and delete the file
        await DatabaseHelper.instance.updateAudioFileStatus(file.id!);

        // Now delete the audio file from the local database
        await DatabaseHelper.instance.deleteAudioFile(file.id!);

        // Optionally, delete the temporary file from the device
        await audioFile.delete();
      } catch (e) {
        print("Error uploading audio: $e");
      }
    }
  }

  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
