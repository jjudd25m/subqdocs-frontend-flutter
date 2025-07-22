import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/app_string.dart';
import '../../../widgets/custom_toastification.dart';
import '../../data/service/database_helper.dart';
import '../../mobile_modules/add_recording_mobile_view/views/audio_wave.dart';
import '../../models/audio_file.dart';
import '../../modules/login/model/login_model.dart';
import '../../modules/personal_setting/model/get_user_detail_model.dart';
import '../../modules/personal_setting/repository/personal_setting_repository.dart';
import '../../modules/visit_main/model/patient_transcript_upload_model.dart';
import '../../modules/visit_main/repository/visit_main_repository.dart';
import 'app_preferences.dart';
import 'logger.dart';

class GlobalMobileController extends GetxController {
  RxnString selectedLanguageValue = RxnString("English");
  List<String> languageList = ["English", "Muti Language"];
  RxBool isDropdownOpen = RxBool(false);
  final VisitMainRepository visitMainRepository = VisitMainRepository();
  Rxn<GetOrganizationDetailModel> getEMAOrganizationDetailModel = Rxn<GetOrganizationDetailModel>();

  static const platform = MethodChannel('com.subqdocs/shared');
  static const EventChannel eventChannel = EventChannel('com.subqdocs/audioEvents');

  RxList<AudioWaveBar> samples = RxList([]);
  RxList<String> connectedMics = RxList();
  IOS7SiriWaveformController waveController = IOS7SiriWaveformController(amplitude: 0, color: Colors.red, frequency: 2, speed: 0.3);

  RxInt tabIndex = RxInt(1);

  Rxn<GetUserDetailModel> getUserDetailModel = Rxn<GetUserDetailModel>();

  final PersonalSettingRepository _personalSettingRepository = PersonalSettingRepository();

  StreamSubscription? eventSubscription;
  RxList<String> connectedMic = RxList();
  RxString selectedMic = RxString("");

  Future<void> startMicListening() async {
    await platform.invokeMethod('startAudioRouteListening');
    setupEventListener();
    await getActiveMicrophoneName();
  }

  Future<void> getUserDetail() async {
    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      getUserDetailModel.value = await _personalSettingRepository.getUserDetail(userId: loginData.responseData?.user?.id.toString() ?? "");
    } catch (e) {
      customPrint(e);
    }
  }

  Future<void> getActiveMicrophoneName() async {
    final String result = await platform.invokeMethod('getActiveMicrophoneName');
    customPrint(result);
    selectedMic.value = result;
  }

  void setupEventListener() {
    eventSubscription = eventChannel.receiveBroadcastStream().listen(
      (event) async {
        customPrint(" Received event from iOS: $event");
        if (event == 'audioDevicesChanged') {
          await getConnectedInputDevices();
        } else if (event == "bluetoothAudioDevicesChanged") {
          await getConnectedInputDevices();
          await getActiveMicrophoneName();
        }
      },
      onError: (error) {
        customPrint(" EventChannel error: $error");
      },
    );
  }

  Future<void> getConnectedInputDevices() async {
    try {
      final List devices = await platform.invokeMethod('getAudioInputDevices');
      connectedMic.value = devices.cast<String>();

      connectedMic.refresh();
      customPrint(devices);
    } on PlatformException catch (e) {
      customPrint("Failed to get audio devices: '${e.message}'.");
    }
  }

  Future<bool> setPreferredAudioInput(String portName) async {
    try {
      final bool result = await platform.invokeMethod('setPreferredAudioInput', portName);
      customPrint(result);
      return result;
    } on PlatformException catch (e) {
      customPrint('Error setting preferred input: $e');
      return false;
    }
  }

  String formatTimeToHHMMSS(String timeStr) {
    if (timeStr.isNotEmpty && timeStr != "") {
      final parts = timeStr.split(':').map(int.parse).toList();
      Duration duration;
      if (parts.length == 2) {
        duration = Duration(minutes: parts[0], seconds: parts[1]);
      } else if (parts.length == 3) {
        duration = Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
      } else {
        return "00:00:00";
      }
      final hh = (duration.inHours).toString().padLeft(2, '0');
      final mm = (duration.inMinutes.remainder(60)).toString().padLeft(2, '0');
      final ss = (duration.inSeconds.remainder(60)).toString().padLeft(2, '0');

      return '$hh:$mm:$ss';
    } else {
      return "";
    }
  }

  Future<void> handleAudioOnlineData() async{
    try{
      List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();

      if (audio.isNotEmpty) {
        CustomToastification().showToast("Audio uploading start!", type: ToastificationType.info, toastDuration: 6);

        uploadAllAudioFiles(() {
          CustomToastification().showToast("All audio files have been uploaded!", type: ToastificationType.success, toastDuration: 6);
        });
      }
    }catch(e){
      customPrint("error message: $e");
    }
  }

  Future<void> uploadAllAudioFiles(Function onAllUploaded) async {
    List<AudioFile> audio = await DatabaseHelper.instance.getPendingAudioFiles();

    List<Future<bool>> uploadFutures = [];

    for (var file in audio) {
      uploadFutures.add(
        uploadLocalAudio(file).then((success) {
          if (success) {
            DatabaseHelper.instance.deleteAudioFile(file.id ?? 0);
          }
          return success;
        }),
      );
    }

    await Future.wait(uploadFutures);

    onAllUploaded(); // This will trigger the callback function
  }

  Future<bool> uploadLocalAudio(AudioFile file) async {
    try {
      var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

      PatientTranscriptUploadModel patientTranscriptUploadModel = await visitMainRepository.uploadAudio(audioFile: File.fromUri(Uri.file(file.fileName ?? "")), token: loginData.responseData?.token ?? "", patientVisitId: file.visitId ?? "");
      return true; // You might want to change this logic to match your actual upload process
    } catch (error) {
      return false;
    }
  }
}
