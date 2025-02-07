import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../core/utils/app_keys.dart';

class RecorderService {
  final AudioRecorder audioRecorder = AudioRecorder();

  File? recordFile;

  ///   startRecording
  Future<bool> startRecording() async {
    log("log: start recording");
    if (await audioRecorder.hasPermission()) {
      Directory dir = await getApplicationCacheDirectory();
      String filename = "${DateTime.now().millisecondsSinceEpoch.toString()}.m4a";
      await audioRecorder.start(
        const RecordConfig(),
        path: "${dir.path}/$filename",
      );
      return true;
    } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && AppKeys.instance.navigatorKey?.currentState?.context != null) {
      // showDialog(
      //     barrierDismissible: false,
      //     context: AppKeys.instance.navigatorKey!.currentState!.context,
      //     builder: (context) => const PermissionAlert());
    }
    return false;
  }

  ///   stopRecording
  Future<File?> stopRecording() async {
    String? s = await audioRecorder.stop();

    if (s != null) {
      recordFile = File(s);
      log("log: stop recording ${recordFile?.path}");
    }
    return recordFile;
  }

  ///   resumeRecording
  Future<void> resumeRecording() async {
    log("log: resume recording");
    await audioRecorder.resume();
  }

  ///   pauseRecording
  Future<void> pauseRecording() async {
    log("log: pause recording");
    await audioRecorder.pause();
  }

  ///   deleteRecording
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
}
