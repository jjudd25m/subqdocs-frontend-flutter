import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:subqdocs/app/models/audio_wave.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/customPermission.dart';
import '../../core/common/global_controller.dart';

class RecorderService {
  AudioRecorder audioRecorder = AudioRecorder();

  // late AudioFileWaveformsC _waveformController;

  File? recordFile;
  RxString updatedRecordingTime = RxString("00:00");
  late StreamSubscription<Amplitude> waves;

  double normalized = 0.0;

  // Track recording time in seconds (using GetX Rx for reactivity)
  Rx<int> recordingTime = 0.obs;
  Rx<int> recordingStatus = 0.obs; // 0: Stopped, 1: Recording, 2: Paused

  Timer? _timer;
  Timer? _chunkTimer;
  String chunkFilePath = "";

  /// Start Recording
  Future<bool> startRecording(BuildContext context) async {
    WakelockPlus.enable();
    final GlobalController globalController = Get.find();
    globalController.samples.clear();
    log("log: start recording");
    final btMic = await audioRecorder.hasPermission();
    final btGranted = Platform.isAndroid ? await Permission.bluetoothConnect.request().isGranted : true;
    if (btMic && btGranted) {
      Directory dir = await getApplicationCacheDirectory();
      String filename = "${DateTime.now().millisecondsSinceEpoch.toString()}.m4a";

      await audioRecorder.start(const RecordConfig(), path: "${dir.path}/$filename");

      chunkFilePath = "${dir.path}/$filename";
      globalController.startMicListening();
      // globalController.setupEventListener();
      waves = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 50)).listen((amp) {
        const minDb = -45.0; // silence threshold
        const maxDb = 0.0; // max (loud)

        double normalized = ((amp.current - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);
        if (globalController.samples.length >= 30) {
          globalController.samples.removeAt(0);
        }
        globalController.samples.add(AudioWaveBar(heightFactor: normalized, color: AppColors.backgroundPurple));

        // Update the waveform
        globalController.waveController.amplitude = normalized;
      });

      recordingStatus.value = 1;
      // Start the timer to update recording time
      _startTimer();
      startChunkTimer();

      return true;
    } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && (await Permission.bluetoothConnect.isPermanentlyDenied || await Permission.bluetoothConnect.isDenied)) {
      // Handle permission denial here

      showDialog(barrierDismissible: false, context: context, builder: (context) => const PermissionAlert(permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.", permissionTitle: " Microphone  permission request", isMicPermission: true));
    }
    return false;
  }

  /// Stop Recording
  Future<File?> stopRecording() async {
    final GlobalController globalController = Get.find();

    globalController.waveController.amplitude = 0;
    globalController.stopMicListening();
    globalController.samples.clear();
    // globalController.eventSubscription?.cancel();
    String? s = await audioRecorder.stop();

    // Stop the timer when recording is stopped
    _stopTimer();

    if (s != null) {
      recordFile = File(s);
      log("log: stop recording ${recordFile?.path}");
    }

    // Reset the time when stopping the recording
    recordingTime.value = 0;
    // Update the recording status to "Stopped"
    recordingStatus.value = 0;
    WakelockPlus.disable();
    return recordFile;
  }

  /// Resume Recording
  Future<void> resumeRecording() async {
    WakelockPlus.enable();
    waves.resume();
    log("log: resume recording");
    await audioRecorder.resume();

    // Update the recording status to "Recording"
    recordingStatus.value = 1;
    // Start the timer if resumed
    _startTimer();
  }

  /// Pause Recording
  Future<void> pauseRecording() async {
    WakelockPlus.disable();
    waves.pause();
    log("log: pause recording");
    await audioRecorder.pause();

    // Update the recording status to "Paused"
    recordingStatus.value = 2;
    // Stop the timer if paused
    _stopTimer();
  }

  /// Delete Recording
  Future<bool> deleteRecording() async {
    final GlobalController globalController = Get.find();

    globalController.waveController.amplitude = 0;
    log("log: delete recording");
    if (recordFile != null) {
      try {
        if (recordFile?.existsSync() ?? false) {
          recordFile!.deleteSync();
        }
      } catch (e) {
        log("log: ${e.toString()}");
      }
      recordFile = null;
      return true;
    }
    return false;
  }

  /// Private method to start the timer and update the recording time every second
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingTime.value++;
      updatedRecordingTime.value = formattedRecordingTime;
    });
  }

  void startChunkTimer() {
    _chunkTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      print("path is :- $chunkFilePath");
      Duration? duration = await getAudioDuration(chunkFilePath);
      print("Audio Duration: ${duration?.inSeconds} seconds");
    });
  }

  Future<Duration?> getAudioDuration(String filePath) async {
    final player = AudioPlayer();
    try {
      await player.setFilePath(filePath);
      return player.duration;
    } catch (e) {
      print("Error loading audio: $e");
      return null;
    } finally {
      await player.dispose();
    }
  }

  /// Private method to stop the timer when recording is paused or stopped
  void _stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Method to get formatted time as minutes and seconds
  String get formattedRecordingTime {
    int minutes = (recordingTime.value / 60).floor();
    int seconds = recordingTime.value % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}
