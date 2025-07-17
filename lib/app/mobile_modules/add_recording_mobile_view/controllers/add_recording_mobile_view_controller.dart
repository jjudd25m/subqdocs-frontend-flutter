import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
// import '../../../widgets/customPermission.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:subqdocs/app/core/common/global_mobile_controller.dart';
import 'package:toastification/toastification.dart';

import '../../../../services/media_picker_services.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../widgets/customPermission.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../data/service/database_helper.dart';
import '../../../data/service/mobile_recorder_service.dart';
import '../../../models/audio_file.dart';
import '../../../models/media_listing_model.dart';
import '../../../modules/login/model/login_model.dart';
import '../../../modules/visit_main/model/patient_transcript_upload_model.dart';
import '../../../modules/visit_main/repository/visit_main_repository.dart';
import '../../../routes/app_pages.dart';

class AddRecordingMobileViewController extends GetxController {
  //TODO: Implement AddRecordingMobileViewController

  final VisitMainRepository visitMainRepository = VisitMainRepository();
  MobileRecorderService recorderService = MobileRecorderService();
  final GlobalMobileController globalController = Get.find();

  String patientId = "";
  String visitId = "";

  RxList<MediaListingModel> list = RxList();

  @override
  void onInit() {
    super.onInit();

    patientId = Get.arguments["patientId"];
    visitId = Get.arguments["visitId"];

    // WakelockPlus.enable();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // WakelockPlus.disable();
  }

  Future<void> submitAudio(File audioFile) async {
    if (audioFile.path.isEmpty) {
      return;
    }

    Loader().showLoadingDialogForSimpleLoader();
    var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        Uint8List audioBytes = await audioFile.readAsBytes(); // Read audio file as bytes
        AudioFile audioFileToSave = AudioFile(fileName: audioFile.path, status: 'pending', visitId: visitId, audioData: audioBytes);
        await DatabaseHelper.instance.insertAudioFile(audioFileToSave);

        CustomToastification().showToast("Audio saved locally. Will upload when internet is available.", type: ToastificationType.success);
        Loader().stopLoader();
        Get.back();
      } else {
        PatientTranscriptUploadModel patientTranscriptUploadModel = await visitMainRepository.uploadAudio(audioFile: audioFile, token: loginData.responseData?.token ?? "", patientVisitId: visitId);
        Loader().stopLoader();
        customPrint("audio upload response is :-  {patientTranscriptUploadModel.toJson()}");

        Get.toNamed(Routes.PATIENT_INFO_MOBILE_VIEW, arguments: {"patientId": patientId, "visitId": visitId, "fromRecording": "1"});
      }
    } catch (e) {
      customPrint("Audio failed error is :- $e");
      Loader().stopLoader();
    }
  }

  Future<void> checkAudioRecordPermission() async {
    final btGranted = Platform.isAndroid ? await Permission.bluetoothConnect.request().isGranted : true;
    if (await recorderService.audioRecorder.hasPermission() && btGranted) {
      recorderService.startRecording(Get.context!);
    } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && (await Permission.bluetoothConnect.isPermanentlyDenied || await Permission.bluetoothConnect.isDenied)) {
      // Handle permission denial here

      showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder:
            (context) => PermissionAlert(
              onCancel: () {
                Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
              },
              onOpenSetting: () {
                Get.back();
              },
              permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.",
              permissionTitle: " Microphone  permission request",
              isMicPermission: true,
            ),
      );
    }
  }

  Future<void> captureImage(BuildContext context, {bool fromCamera = true, bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    XFile? image = await MediaPickerServices().pickImage(fromCamera: fromCamera);

    customPrint("media  file is  $image");

    XFile? _pickedFile;
    String? _fileName;
    DateTime? _pickDate;
    int? _fileSize;
    if (image != null) {
      _fileName = image.name; // Get the file name
      _pickDate = DateTime.now(); // Get the date when the file is picked

      // Get the size of the file
      File file = File(image.path);
      _fileSize = file.lengthSync(); // Size in bytes

      String? filesizeString = _formatFileSize(_fileSize);

      double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);
      String? _shortFileName;
      if (p.basename(_fileName).length > 15) {
        // Truncate the name to 12 characters and add ellipsis
        _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
      } else {
        _shortFileName = p.basename(_fileName); // Use the full name if it's already short
      }
      list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), size: filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true, time: globalController.formatTimeToHHMMSS(recorderService.formattedRecordingTime)));
    }

    list.refresh();

    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(date); // Format date to dd/MM/yyyy
  }

  double _formatFileSizeDouble(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return (sizeInMB * 100).roundToDouble() / 100;
  }

  String _formatFileSize(int bytes) {
    double sizeInKB = bytes / 1024; // Convert bytes to KB
    double sizeInMB = sizeInKB / 1024; // Convert KB to MB
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  Future<void> pickFilesForDoc({bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  $fileList");

    // double totalFileSize = 0.0;

    fileList?.forEach((element) {
      XFile? _pickedFile;
      String? _fileName;
      DateTime? _pickDate;
      int? _fileSize;

      if (element != null) {
        _fileName = element.name; // Get the file name
        _pickDate = DateTime.now(); // Get the date when the file is picked

        // Get the size of the file
        File file = File(element.xFile.path);
        _fileSize = file.lengthSync(); // Size in bytes

        // totalFileSize += _fileSize / (1024 * 1024);

        String? filesizeString = _formatFileSize(_fileSize);
        double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

        String? _shortFileName;
        if (p.basename(_fileName).length > 15) {
          // Truncate the name to 12 characters and add ellipsis
          _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
        } else {
          _shortFileName = p.basename(_fileName); // Use the full name if it's already short
        }
        list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), size: filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true, time: globalController.formatTimeToHHMMSS(recorderService.formattedRecordingTime)));
      }

      list.refresh();
    });

    list.refresh();
    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(Get.context!);
      }
    }
  }

  Future<void> pickFiles(BuildContext context, {bool clear = true}) async {
    if (clear) {
      list.clear();
    }

    List<PlatformFile>? fileList = await MediaPickerServices().pickAllFiles(fileType: FileType.custom);

    customPrint("media  file is  $fileList");

    fileList?.forEach((element) {
      XFile? _pickedFile;
      String? _fileName;
      DateTime? _pickDate;
      int? _fileSize;
      if (element != null) {
        _fileName = element.name; // Get the file name
        _pickDate = DateTime.now(); // Get the date when the file is picked

        // Get the size of the file
        File file = File(element.xFile.path);
        _fileSize = file.lengthSync(); // Size in bytes

        String? _filesizeString = _formatFileSize(_fileSize);

        double? _filesizeStringDouble = _formatFileSizeDouble(_fileSize);

        String? _shortFileName;
        if (p.basename(_fileName).length > 15) {
          // Truncate the name to 12 characters and add ellipsis
          _shortFileName = '${p.basename(_fileName).substring(0, 12)}...';
        } else {
          _shortFileName = p.basename(_fileName); // Use the full name if it's already short
        }
        list.value.add(MediaListingModel(file: file, previewImage: null, fileName: _shortFileName, date: _formatDate(_pickDate), size: _filesizeString, calculateSize: _filesizeStringDouble, isGraterThan10: _filesizeStringDouble < 10.00 ? false : true, time: globalController.formatTimeToHHMMSS(recorderService.formattedRecordingTime)));
      }
    });
    list.refresh();
    if (clear) {
      if (list.isNotEmpty) {
        showCustomDialog(context);
      }
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return audioAttachmentMobileDailog(this); // Our custom dialog
      },
    );
  }

  bool checkTotalSize() {
    double totalSize = 0.0;

    totalSize += list.fold(0, (sum, element) => sum + (element.calculateSize ?? 0));

    // list.value.forEach((element) {
    //   totalSize += element.calculateSize ?? 0;
    // });

    if (totalSize < 100) {
      return true;
    } else {
      return false;
    }
  }

  bool checkSingleSize() {
    bool isGraterThan10 = false;

    isGraterThan10 = list.fold(false, (result, element) => result || (element.isGraterThan10 ?? false));

    // list.value.forEach((element) {
    //   if (element.isGraterThan10 ?? false) {
    //     isGraterThan10 = true;
    //   }
    // });

    return isGraterThan10;
  }

  Future<void> uploadAttachments() async {
    if (checkTotalSize()) {
      if (checkSingleSize()) {
        CustomToastification().showToast("File Size must not exceed 10 MB", type: ToastificationType.error);
      } else {
        Get.back();
        Loader().showLoadingDialogForSimpleLoader();
        var loginData = LoginModel.fromJson(jsonDecode(AppPreference.instance.getString(AppString.prefKeyUserLoginData)));

        Map<String, List<File>> profileParams = {};
        Map<String, dynamic> params = {};
        bool shouldAdd = true;
        if (list.isNotEmpty) {
          customPrint("profile is   available");
          // param['profile_image'] = profileImage.value;
          profileParams['attachments'] = list.map((model) => model.file).toList().whereType<File>().toList();
          for (int i = 0; i < list.length; i++) {
            params['timestamp_$i'] = list[i].time;
            if (list[i].time == "00:00:00") {
              shouldAdd = false;
            }
          }
          if (shouldAdd) {
            params['visit_id'] = visitId;
          }
        } else {
          customPrint("profile is not  available");
        }
        await visitMainRepository.uploadAttachments(files: profileParams, token: loginData.responseData?.token ?? "", patientVisitId: patientId, params: params);
        list.clear();
        Get.back();
        // getPatientAttachment();
      }
    } else {
      CustomToastification().showToast(" Total Files Size must not exceed 100 MB", type: ToastificationType.error);
    }
  }
}

class audioAttachmentMobileDailog extends StatelessWidget {
  AddRecordingMobileViewController controller;

  audioAttachmentMobileDailog(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .50),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              width: 360,
              color: AppColors.backgroundPurple,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Add Attachments", style: AppFonts.medium(14, Colors.white)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.list.clear();
                        Get.back();
                      },
                      child: SvgPicture.asset("assets/images/cross_white.svg", width: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DottedBorder(
                      color: AppColors.textDarkGrey,
                      strokeWidth: 0.5,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SvgPicture.asset("assets/images/upload_image.svg"),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), child: Text("Upload and manage Photos", textAlign: TextAlign.center, style: AppFonts.medium(14, AppColors.black))),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: CustomButton(
                                navigate: () async {
                                  await controller.pickFiles(context, clear: false);
                                },
                                label: "Choose Files",
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text("Supported Formats: JPG, PNG, WEBP, MP3, WAV,MP4, DOC, PDF", textAlign: TextAlign.start, style: AppFonts.medium(10, AppColors.textDarkGrey)),
                    const SizedBox(height: 12),
                    CustomButton(
                      navigate: () async {
                        await controller.captureImage(context, fromCamera: true, clear: false);
                      },
                      label: "Take a photo",
                      backGround: Colors.white,
                      isTrue: false,
                      textColor: AppColors.backgroundPurple,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Files", style: AppFonts.medium(16, AppColors.black)),
                      const SizedBox(height: 5),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.textDarkGrey, // Border color
                                  width: 0.5,
                                  // Border width
                                ),

                                borderRadius: BorderRadius.circular(10), // Optional: to make the corners rounded
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/placeholde_image.svg"),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(controller.list.value[index].fileName ?? ""),
                                        //
                                        Text(controller.visitId),
                                        Text("${controller.list.value[index].date ?? " "} |  ${controller.list.value[index].size ?? ""}"),

                                        if (controller.list.value[index].isGraterThan10 ?? false) Text("File Size must not exceed 10 MB", style: AppFonts.medium(15, Colors.red)),
                                      ],
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        controller.list.removeAt(index);
                                        controller.list.refresh();
                                      },
                                      child: SvgPicture.asset("assets/images/logo_cross.svg", width: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: controller.list.length,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              navigate: () {
                                Get.back();
                              },
                              label: "Cancel",
                              backGround: Colors.white,
                              isTrue: false,
                              textColor: AppColors.backgroundPurple,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              navigate: () {
                                controller.uploadAttachments();
                              },
                              label: "Add",
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
