import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_toolkit/flutter_audio_toolkit.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subqdocs/app/core/common/global_mobile_controller.dart';
import 'package:subqdocs/app/models/Records.dart';
import 'package:toastification/toastification.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../utils/Loader.dart';
import '../../../utils/app_string.dart';
import '../../../widgets/customPermission.dart';
import '../../../widgets/custom_toastification.dart';
import '../../core/common/app_preferences.dart';
import '../../core/common/logger.dart';
import '../../mobile_modules/add_recording_mobile_view/views/audio_wave.dart';
import '../../models/audio_file.dart';
import '../../modules/login/model/login_model.dart';
import '../../modules/visit_main/repository/visit_main_repository.dart';
import '../../routes/app_pages.dart';
import '../provider/api_provider.dart';
import 'database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MobileRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterAudioToolkit _audioToolkit = FlutterAudioToolkit();
  final int _sampleRate = 16000;
  final int _numChannels = 1;
  int chunkIndex = 0;
  final List<int> _pcmBuffer = [];
  final List<File> chunkFiles = [];
  Timer? _chunkTimer, _timer;
  RxList<AudioWaveBar> samples = <AudioWaveBar>[].obs;
  late StreamController<Uint8List> _pcmStreamController;
  StreamSubscription<Uint8List>? _pcmSubscription;
  RxString updatedRecordingTime = RxString("00:00");
  Rx<int> recordingTime = 0.obs;
  Rx<int> recordingStatus = 0.obs;
  int audioId = 0;
  final VisitMainRepository visitMainRepository = VisitMainRepository();
  String sessionId = "";
  bool isLastChunk = false;

  /// Start recording with real-time chunking and waveform
  Future<bool> startRecording(BuildContext context, String visitId) async {
    WakelockPlus.enable();
    final GlobalMobileController globalController = Get.find();
    globalController.samples.clear();
    final btMic = Platform.isAndroid ? await Permission.microphone.request().isGranted : true;
    final btGranted = Platform.isAndroid ? await Permission.bluetoothConnect.request().isGranted : true;
    if (btMic && btGranted) {
      _pcmStreamController = StreamController<Uint8List>();
      await _recorder.openRecorder();
      await _recorder.startRecorder(codec: Codec.pcm16, sampleRate: _sampleRate, numChannels: _numChannels, toStream: _pcmStreamController.sink);
      globalController.startMicListening();
      _pcmSubscription = _pcmStreamController.stream.listen((buffer) {
        _pcmBuffer.addAll(buffer);
        double amplitude = _calculateAmplitude(buffer);
        if (globalController.samples.length >= 30) globalController.samples.removeAt(0);
        globalController.samples.add(AudioWaveBar(heightFactor: amplitude, color: Colors.purple));
        globalController.waveController.amplitude = amplitude;
      });
      recordingStatus.value = 1;
      _startTimer();
      _chunkTimer = Timer.periodic(const Duration(seconds: 15), (_) => _setChunk(visitId));
      return true;
    } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && (await Permission.bluetoothConnect.isPermanentlyDenied || await Permission.bluetoothConnect.isDenied)) {
      // Handle permission denial here

      showDialog(barrierDismissible: false, context: context, builder: (context) => const PermissionAlert(permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.", permissionTitle: " Microphone  permission request", isMicPermission: true));
    }
    return false;
  }

  /// Stop recording and upload any remaining chunk
  Future<void> stopRecording(String visitId) async {
    final GlobalMobileController globalController = Get.find();
    WakelockPlus.disable();
    globalController.waveController.amplitude = 0;
    isLastChunk = true;
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    _chunkTimer?.cancel();
    await _pcmSubscription?.cancel();
    await _pcmStreamController.close();
    if (_pcmBuffer.isNotEmpty) {
      String filePath = await _savePcmAsWavAndConvertToM4a(_pcmBuffer, visitId);
      chunkFiles.add(File(filePath));
      _pcmBuffer.clear();
      await uploading(visitId);
    }

  }

  /// Upload a chunk every 15 seconds, regardless of buffer size
  void _setChunk(String visitId) async {
    log("_setChunk called, buffer length: ${_pcmBuffer.length}");
    if (_pcmBuffer.isNotEmpty) {
      List<int> chunk = List.from(_pcmBuffer);
      String filePath = await _savePcmAsWavAndConvertToM4a(chunk, visitId);
      log("message:File $filePath");
      File chunkFile = File(filePath);
      chunkFiles.add(chunkFile);
      _pcmBuffer.clear();
      await uploading(visitId);
    }
  }

  /// Save PCM data as a WAV file, then convert to m4a, retrying if conversion fails
  Future<String> _savePcmAsWavAndConvertToM4a(List<int> pcmData, String? visitId) async {
    final dir = await getTemporaryDirectory();
    final wavData = _pcmToWav(Uint8List.fromList(pcmData), _sampleRate, _numChannels);
    final wavFile = File('${dir.path}/chunk_${visitId}_${DateTime.now().millisecondsSinceEpoch}.wav');
    await wavFile.writeAsBytes(wavData, flush: true);
    final m4aFile = File('${dir.path}/${visitId}_${chunkIndex++}_${DateTime.now().millisecondsSinceEpoch}.m4a');
    await convertWavToM4A(wavFile.path, m4aFile.path);
    return m4aFile.path;
    // int maxRetries = 3;
    // int attempt = 0;
    // bool success = false;
    // while (attempt < maxRetries && !success) {
    //   success =
    //   log("messageSuccess: $success");
    //   if (success) {
    //     log('Conversion failed, retrying... (attempt  [31m${attempt + 1} [0m)');
    //     await Future.delayed(const Duration(seconds: 1));
    //   }
    //   attempt++;
    // }
    // if (success) {

    // } else {
    //   log('Conversion failed after $maxRetries attempts.');
    //   throw Exception('WAV to M4A conversion failed after $maxRetries attempts.');
    //   // return "";
    // }
  }

  /// Convert PCM to WAV (add header)
  List<int> _pcmToWav(Uint8List pcmData, int sampleRate, int numChannels) {
    int byteRate = sampleRate * numChannels * 2;
    int blockAlign = numChannels * 2;
    int dataLength = pcmData.length;
    int fileLength = 36 + dataLength;
    var header = <int>[...'RIFF'.codeUnits, ..._intToBytes(fileLength, 4), ...'WAVE'.codeUnits, ...'fmt '.codeUnits, ..._intToBytes(16, 4), ..._intToBytes(1, 2), ..._intToBytes(numChannels, 2), ..._intToBytes(sampleRate, 4), ..._intToBytes(byteRate, 4), ..._intToBytes(blockAlign, 2), ..._intToBytes(16, 2), ...'data'.codeUnits, ..._intToBytes(dataLength, 4)];
    return header + pcmData;
  }

  List<int> _intToBytes(int value, int byteCount) {
    final result = <int>[];
    for (int i = 0; i < byteCount; i++) {
      result.add((value >> (8 * i)) & 0xFF);
    }
    return result;
  }

  /// Convert WAV to M4A
  Future<bool> convertWavToM4A(String wavFile, String m4aFile) async {
    try {
      await _audioToolkit.convertAudio(inputPath: wavFile, outputPath: m4aFile, format: AudioFormat.m4a);
      return true;
    } catch (e) {
      log("error message: $e");
      return false;
    }
  }

  /// Calculate normalized amplitude for waveform
  double _calculateAmplitude(Uint8List buffer) {
    int max = 0;
    for (int i = 0; i < buffer.length; i += 2) {
      int sample = buffer[i] | (buffer[i + 1] << 8);
      if (sample & 0x8000 != 0) sample = sample - 0x10000;
      if (sample < 0) sample = -sample;
      if (sample > max) max = sample;
    }
    return (max / 32768.0).clamp(0.0, 1.0);
  }

  Future<void> resumeRecording(String visitId) async {
    WakelockPlus.enable();
    _pcmSubscription?.resume();
    await _recorder.resumeRecorder();
    recordingStatus.value = 1;
    _startTimer();
    _chunkTimer = Timer.periodic(const Duration(seconds: 15), (_) => _setChunk(visitId));
  }

  /// Pause Recording
  Future<void> pauseRecording() async {
    WakelockPlus.disable();
    _pcmSubscription?.pause();
    await _recorder.pauseRecorder();
    recordingStatus.value = 2;
    _stopTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingTime.value++;
      updatedRecordingTime.value = formattedRecordingTime;
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      _chunkTimer?.cancel();
      _chunkTimer = null;
    }
  }

  /// Stub for uploading a chunk to your API
  Future<bool> uploadChunk(File chunkFile,String visitId) async {
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        Uint8List audioBytes = await chunkFile.readAsBytes(); // Read audio file as bytes
        AudioFile audioFileToSave = AudioFile(fileName: chunkFile.path, status: 'pending', visitId: visitId, audioData: audioBytes);
        audioId = await DatabaseHelper.instance.insertAudioFile(audioFileToSave);
        await DatabaseHelper.instance.insertAudioChunkFile(audioId, chunkIndex, audioFileToSave);

        CustomToastification().showToast("Audio saved locally. Will upload when internet is available.", type: ToastificationType.success);
      } else {
        Uint8List audioBytes = await chunkFile.readAsBytes(); // Read audio file as bytes
        AudioFile audioFileToSave = AudioFile(fileName: chunkFile.path, status: 'pending', visitId: visitId, audioData: audioBytes);
        audioId = await DatabaseHelper.instance.insertAudioFile(audioFileToSave);
        await DatabaseHelper.instance.insertAudioChunkFile(audioId, chunkIndex, audioFileToSave);
        String? mimeType = lookupMimeType(chunkFile.path);
        if(sessionId == "" && sessionId.isEmpty) {
          Records records = await visitMainRepository.uploadRecordInitialized(visitId: visitId, chunkFile: chunkFile, mimeType: mimeType ?? "", token: loginData.responseData?.token ?? "");
          sessionId = records.responseData?.sessionId ?? "";
        }else if(isLastChunk == false){
          Map<String,dynamic> params = {};
          params["chunkIndex"] = chunkIndex;
          params["isLastChunk"] = isLastChunk;
          var response  = await visitMainRepository.uploadRecordings(sessionId: sessionId,params: params, chunkFile: chunkFile, mimeType: mimeType ?? "", token: loginData.responseData?.token ?? "");
        }else if(isLastChunk){
          Map<String,dynamic> params = {};
          params["session_id"] = sessionId;
          var response = await visitMainRepository.uploadLastRecord(visitId: visitId, params: params ,chunkFile: chunkFile, mimeType: mimeType ?? "", token: loginData.responseData?.token ?? "");
        }
        return true;
      }
    }
    catch (e) {
      customPrint("Audio failed error is :- $e");
      Loader().stopLoader();
    }
    return false;
  }

  Future<void> uploading(String visitId) async{
    log("messageChunkFiles: ${chunkFiles.length}");

    if(chunkFiles.isEmpty) return;
    // final stopwatch = Stopwatch() ..start();
    try{

      while(chunkFiles.isNotEmpty){
        String fileName = chunkFiles.first.toString().split('/').last;
        List<String> parts = fileName.split('_');
        int cIndex = int.parse(parts[1]);
        final success = await uploadChunk(chunkFiles.first,visitId);

        if(success){
          chunkFiles.removeAt(0);
          await DatabaseHelper.instance.deleteAudioFile(audioId);
        }else{
          await Future.delayed(Duration(minutes: 10));
          break;
        }
      }
    }catch(e){
      log("error message: $e");
    }

  }

  String get formattedRecordingTime {
    int minutes = (recordingTime.value / 60).floor();
    int seconds = recordingTime.value % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}
