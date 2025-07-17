import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/customPermission.dart';
import '../../core/common/global_controller.dart';
import '../../core/common/global_mobile_controller.dart';
import '../../mobile_modules/add_recording_mobile_view/views/audio_wave.dart';
import '../../routes/app_pages.dart';

// class MobileRecorderService {
//   final AudioRecorder audioRecorder = AudioRecorder();
//   static const MethodChannel _channel = MethodChannel('audio_recorder_channel');
//
//   File? recordFile;
//   RxString updatedRecordingTime = RxString("00:00");
//   late StreamSubscription<Amplitude> waves;
//
//   Rx<int> recordingTime = 0.obs;
//   Rx<int> recordingStatus = 0.obs;
//
//   RxString selectedMicrophone = 'Default'.obs;
//   RxList<String> availableMicrophones = <String>['Default'].obs;
//
//   Timer? _timer;
//
//   /// Initialize the recorder service
//   Future<void> init() async {
//     await _refreshAvailableMicrophones();
//   }
//
//   /// Refresh list of available microphones
//   Future<void> _refreshAvailableMicrophones() async {
//     try {
//       if (Platform.isAndroid || Platform.isIOS) {
//         final mics = await _getPlatformMicrophones();
//         availableMicrophones.value = mics;
//
//         if (!availableMicrophones.contains(selectedMicrophone.value)) {
//           selectedMicrophone.value = availableMicrophones.firstOrNull ?? 'Default';
//         }
//       }
//     } catch (e) {
//       debugPrint("Error getting microphones: $e");
//       availableMicrophones.value = ['Default'];
//       selectedMicrophone.value = 'Default';
//     }
//   }
//
//   /// Get available microphones using platform channels
//   Future<List<String>> _getPlatformMicrophones() async {
//     try {
//       if (Platform.isAndroid) {
//         final List<dynamic> mics = await _channel.invokeMethod('getAvailableMicrophones');
//         return mics.cast<String>();
//       } else if (Platform.isIOS) {
//         return ['Default', 'Microphone']; // iOS usually has fewer options
//       }
//       return ['Default'];
//     } catch (e) {
//       debugPrint("Error getting microphones: $e");
//       return ['Default'];
//     }
//   }
//
//   /// Change microphone input
//   Future<void> changeMicrophone(String microphone) async {
//     try {
//       if (recordingStatus.value == 1) {
//         await pauseRecording();
//         await _setPlatformMicrophone(microphone);
//         await resumeRecording();
//       } else {
//         await _setPlatformMicrophone(microphone);
//       }
//       selectedMicrophone.value = microphone;
//     } catch (e) {
//       debugPrint("Error changing microphone: $e");
//     }
//   }
//
//   /// Set microphone using platform channels
//   Future<void> _setPlatformMicrophone(String microphone) async {
//     try {
//       if (Platform.isAndroid) {
//         await _channel.invokeMethod('setMicrophone', {'source': microphone});
//       }
//       // iOS typically handles this automatically
//     } catch (e) {
//       debugPrint("Error setting microphone: $e");
//     }
//   }
//
//   /// iOS microphone selection
//   Future<void> _setIOSMicrophone(String microphone) async {
//     // iOS typically handles this automatically, but we can configure AVAudioSession
//     // This would require platform channels in a real implementation
//     debugPrint("iOS microphone selection: $microphone");
//   }
//
//   /// Start Recording
//   Future<bool> startRecording(BuildContext context) async {
//     final GlobalMobileController globalController = Get.find();
//     debugPrint("Starting recording with mic: ${selectedMicrophone.value}");
//
//     if (await audioRecorder.hasPermission()) {
//       // Set the selected microphone before starting
//       await _setPlatformMicrophone(selectedMicrophone.value);
//
//       Directory dir = await getApplicationCacheDirectory();
//       String filename = "${DateTime.now().millisecondsSinceEpoch.toString()}.m4a";
//
//       await audioRecorder.start(const RecordConfig(), path: "${dir.path}/$filename");
//
//       // Setup amplitude listener
//       waves = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 50)).listen((amp) {
//         const minDb = -45.0;
//         const maxDb = 0.0;
//
//         double normalized = ((amp.current - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);
//
//         if (globalController.samples.length >= 30) {
//           globalController.samples.removeAt(0);
//         }
//         globalController.samples.add(AudioWaveBar(heightFactor: normalized, color: AppColors.backgroundPurple));
//         globalController.waveController.amplitude = normalized;
//       });
//
//       recordingStatus.value = 1;
//       _startTimer();
//       return true;
//     } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied)) {
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder:
//             (context) => PermissionAlert(
//               onCancel: () {
//                 Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
//               },
//               permissionDescription: "To record audio, the app needs access to your microphone.",
//               permissionTitle: "Microphone permission request",
//               isMicPermission: true,
//             ),
//       );
//     }
//     return false;
//   }
//
//   /// Stop Recording
//   Future<File?> stopRecording() async {
//     final GlobalMobileController globalController = Get.find();
//
//     globalController.waveController.amplitude = 0;
//     globalController.samples.clear();
//     String? path = await audioRecorder.stop();
//
//     _stopTimer();
//
//     if (path != null) {
//       recordFile = File(path);
//       debugPrint("Recording saved to: ${recordFile?.path}");
//     }
//
//     recordingTime.value = 0;
//     recordingStatus.value = 0;
//
//     return recordFile;
//   }
//
//   /// Resume Recording
//   Future<void> resumeRecording() async {
//     waves.resume();
//     debugPrint("Resuming recording");
//     await audioRecorder.resume();
//     recordingStatus.value = 1;
//     _startTimer();
//   }
//
//   /// Pause Recording
//   Future<void> pauseRecording() async {
//     waves.pause();
//     debugPrint("Pausing recording");
//     await audioRecorder.pause();
//     recordingStatus.value = 2;
//     _stopTimer();
//   }
//
//   /// Delete Recording
//   Future<bool> deleteRecording() async {
//     final GlobalController globalController = Get.find();
//
//     globalController.waveController.amplitude = 0;
//     if (recordFile != null) {
//       try {
//         if (recordFile?.existsSync() ?? false) {
//           recordFile!.deleteSync();
//         }
//       } catch (e) {
//         debugPrint("Error deleting file: ${e.toString()}");
//       }
//       recordFile = null;
//       return true;
//     }
//     return false;
//   }
//
//   /// Private method to start the timer
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       recordingTime.value++;
//       updatedRecordingTime.value = formattedRecordingTime;
//     });
//   }
//
//   /// Private method to stop the timer
//   void _stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//   }
//
//   /// Get formatted time as minutes:seconds
//   String get formattedRecordingTime {
//     int minutes = (recordingTime.value / 60).floor();
//     int seconds = recordingTime.value % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }
//
//   /// Dispose resources
//   void dispose() {
//     waves.cancel();
//     _stopTimer();
//     audioRecorder.dispose();
//   }
// }

class MobileRecorderService {
  AudioRecorder audioRecorder = AudioRecorder();

  // late AudioFileWaveformsC _waveformController;

  File? recordFile;
  RxString updatedRecordingTime = RxString("00:00");
  late StreamSubscription<Amplitude> waves;

  double normalized = 0.0;

  // Track recording time in seconds (using GetX Rx for reactivity)
  Rx<int> recordingTime = 0.obs;
  Rx<int> recordingStatus = 0.obs; // 0: Stopped, 1: Recording, 2: Paused
  // final waveController = IOS7SiriWaveformController(
  //   amplitude: 1,
  //   color: AppColors.backgroundPurple,
  //   frequency: 0,
  //   speed: 0.50,
  // );

  Timer? _timer;

  /// Start Recording
  Future<bool> startRecording(BuildContext context) async {
    WakelockPlus.enable();
    final btMic = await audioRecorder.hasPermission();

    final GlobalMobileController globalController = Get.find();
    log("log: start recording");
    final btGranted = Platform.isAndroid ? await Permission.bluetoothConnect.request().isGranted : true;
    if (btMic && btGranted) {
      Directory dir = await getApplicationCacheDirectory();
      String filename = "${DateTime.now().millisecondsSinceEpoch.toString()}.m4a";

      await audioRecorder.start(const RecordConfig(), path: "${dir.path}/$filename");
      globalController.startMicListening();
      // waves = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 50)).listen((amp) {
      //   // globalController.waveController.amplitude = (amp.current / 100).clamp(0.01, 1.0);
      //   final db = amp.current ?? -160;
      //
      //   // Normalize the decibel to 0.0 - 1.0
      //   normalized = ((db + 60) / 60).clamp(0.0, 1.0);
      //
      //   // Update the waveform
      //   globalController.waveController.amplitude = normalized;
      // });
      waves = audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 50)).listen((amp) {
        const minDb = -45.0; // silence threshold
        const maxDb = 0.0; // max (loud)

        double normalized = ((amp.current - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);
        // final normalized = ((amp.current + 130) / 130).clamp(0.0, 1.0);
        log(amp.current.toString());

        if (globalController.samples.length >= 30) {
          globalController.samples.removeAt(0);
        }
        globalController.samples.add(AudioWaveBar(heightFactor: normalized, color: AppColors.backgroundPurple));
        globalController.waveController.amplitude = normalized;
        // globalController.samples.refresh();
      });
      recordingStatus.value = 1;
      // Start the timer to update recording time
      _startTimer();

      return true;
    } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && (await Permission.bluetoothConnect.isPermanentlyDenied || await Permission.bluetoothConnect.isDenied)) {
      // Handle permission denial here

      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (context) => PermissionAlert(
              onCancel: () {
                // Get.back();
                Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
              },
              permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.",
              permissionTitle: " Microphone  permission request",
              isMicPermission: true,
            ),
      );
    }
    return false;
  }

  /// Stop Recording
  Future<File?> stopRecording() async {
    final GlobalMobileController globalController = Get.find();

    globalController.waveController.amplitude = 0;
    globalController.samples.clear();
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
