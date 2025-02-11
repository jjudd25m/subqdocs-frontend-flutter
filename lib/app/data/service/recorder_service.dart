import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../core/utils/app_keys.dart';

// class RecorderService {
//   final AudioRecorder audioRecorder = AudioRecorder();
//
//   File? recordFile;
//
//   ///   startRecording
//   Future<bool> startRecording() async {
//     log("log: start recording");
//     if (await audioRecorder.hasPermission()) {
//       Directory dir = await getApplicationCacheDirectory();
//       String filename = "${DateTime.now().millisecondsSinceEpoch.toString()}.m4a";
//       await audioRecorder.start(
//         const RecordConfig(),
//         path: "${dir.path}/$filename",
//       );
//       return true;
//     } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && AppKeys.instance.navigatorKey?.currentState?.context != null) {
//       // showDialog(
//       //     barrierDismissible: false,
//       //     context: AppKeys.instance.navigatorKey!.currentState!.context,
//       //     builder: (context) => const PermissionAlert());
//     }
//     return false;
//   }
//
//   ///   stopRecording
//   Future<File?> stopRecording() async {
//     String? s = await audioRecorder.stop();
//
//     if (s != null) {
//       recordFile = File(s);
//       log("log: stop recording ${recordFile?.path}");
//     }
//     return recordFile;
//   }
//
//   ///   resumeRecording
//   Future<void> resumeRecording() async {
//     log("log: resume recording");
//     await audioRecorder.resume();
//   }
//
//   ///   pauseRecording
//   Future<void> pauseRecording() async {
//     log("log: pause recording");
//     await audioRecorder.pause();
//   }
//
//   ///   deleteRecording
//   Future<bool> deleteRecording() async {
//     log("log: delete recording");
//     if (recordFile != null) {
//       try {
//         if (recordFile?.existsSync() ?? false) {
//           recordFile!.deleteSync();
//         }
//       } catch (e) {
//         log("log: ${e.toString()}");
//       }
//       recordFile = null;
//       return true;
//     }
//     return false;
//   }
// }

class RecorderService {
  final AudioRecorder audioRecorder = AudioRecorder();

  File? recordFile;

  // Track recording time in seconds (using GetX Rx for reactivity)
  Rx<int> recordingTime = 0.obs;
  Rx<int> recordingStatus = 0.obs; // 0: Stopped, 1: Recording, 2: Paused

  Timer? _timer;

  /// Start Recording
  Future<bool> startRecording() async {
    log("log: start recording");
    if (await audioRecorder.hasPermission()) {
      Directory dir = await getApplicationCacheDirectory();
      String filename = "${DateTime.now().millisecondsSinceEpoch.toString()}.m4a";

      await audioRecorder.start(
        const RecordConfig(),
        path: "${dir.path}/$filename",
      );
      recordingStatus.value = 1;
      // Start the timer to update recording time
      _startTimer();

      return true;
    } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && AppKeys.instance.navigatorKey?.currentState?.context != null) {
      // Handle permission denial here
    }
    return false;
  }

  /// Stop Recording
  Future<File?> stopRecording() async {
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

    return recordFile;
  }

  /// Resume Recording
  Future<void> resumeRecording() async {
    log("log: resume recording");
    await audioRecorder.resume();

    // Update the recording status to "Recording"
    recordingStatus.value = 1;
    // Start the timer if resumed
    _startTimer();
  }

  /// Pause Recording
  Future<void> pauseRecording() async {
    log("log: pause recording");
    await audioRecorder.pause();

    // Update the recording status to "Paused"
    recordingStatus.value = 2;
    // Stop the timer if paused
    _stopTimer();
  }

  /// Delete Recording
  Future<bool> deleteRecording() async {
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
    });
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
