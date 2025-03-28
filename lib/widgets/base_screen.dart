import 'dart:io';
import 'dart:ui';

import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../app/core/common/common_service.dart';
import '../app/core/common/global_controller.dart';
import '../app/core/common/logger.dart';
import '../app/modules/custom_drawer/views/custom_drawer_view.dart';
import '../app/routes/app_pages.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';
import '../widget/appbar.dart';
import '../widget/bredcums.dart';

class BaseScreen extends StatelessWidget {
   BaseScreen({super.key , required this.body, required this.globalKey});

  Widget body ;

   final GlobalKey<ScaffoldState> globalKey ;


   final GlobalController globalController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return Scaffold(
      key: globalKey,
      backgroundColor: AppColors.white,
      drawer: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: CustomDrawerView(
          onItemSelected: (index) async {
            if (index == 0) {
              final result = await Get.toNamed(Routes.ADD_PATIENT);

              globalKey.currentState!.closeDrawer();
            } else if (index == 1) {
              Get.toNamed(Routes.HOME, arguments: {
                "tabIndex": 1,
              });

              globalKey.currentState!.closeDrawer();
            } else if (index == 2) {
              Get.toNamed(Routes.HOME, arguments: {
                "tabIndex": 2,
              });
              globalKey.currentState!.closeDrawer();
            } else if (index == 3) {
              Get.toNamed(Routes.HOME, arguments: {
                "tabIndex": 0,
              });
              globalKey.currentState!.closeDrawer();
            }
          },
        ),
      ),
      // appBar: CustomAppBar(),
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: Obx(() {
            return Stack(
              children: [
                body,

                if (globalController.isStartTranscript.value) ...[
                  DraggableFloatWidget(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 100,
                    config: DraggableFloatWidgetBaseConfig(
                      isFullScreen: false,
                      initPositionYInTop: false,
                      initPositionYMarginBorder: 50,
                      // borderBottom: navigatorBarHeight + defaultBorderWidth,
                    ),
                    child: Positioned(
                      bottom: 120,
                      right: 30,
                      child: Obx(() {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          // Set the duration for smooth animation
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.backgroundLightGrey.withValues(alpha: 0.9),
                                spreadRadius: 6,
                                blurRadius: 4.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            color: globalController.isExpandRecording.value ? AppColors.backgroundWhite : AppColors.black,
                          ),
                          padding: globalController.isExpandRecording.value ? EdgeInsets.symmetric(horizontal: 0, vertical: 0) : EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          curve: Curves.easeInOut,
                          child: Column(
                            children: [
                              // Header Row (expand/collapse button)

                              if (globalController.isExpandRecording.value) ...[
                                Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.backgroundLightGrey.withValues(alpha: 0.9),
                                        spreadRadius: 6,
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      topLeft: Radius.circular(12),
                                    ),
                                    color: AppColors.backgroundPurple,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        "",
                                        // controller.globalController.isExpandRecording.value ? "Recording in Progress" :  "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}",
                                        style: AppFonts.medium(14, AppColors.textWhite),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          globalController.isExpandRecording.value = !globalController.isExpandRecording.value;
                                        },
                                        child: SvgPicture.asset(
                                    globalController.isExpandRecording.value ? ImagePath.collpase : ImagePath.expand_recording,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Recording in Progress",
                                  style: AppFonts.regular(17, AppColors.textBlack),
                                ),
                                SizedBox(height: 20),
                                Image.asset(
                                  ImagePath.wave,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (globalController.recorderService.recordingStatus.value == 0) {
                                          globalController.changeStatus("In-Room");
                                          // If not recording, start the recording
                                          await globalController.recorderService.startRecording(context);
                                        } else if (globalController.recorderService.recordingStatus.value == 1) {
                                          // If recording, pause it
                                          await globalController.recorderService.pauseRecording();
                                        } else if (globalController.recorderService.recordingStatus.value == 2) {
                                          // If paused, resume the recording
                                          await globalController.recorderService.resumeRecording();
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          // Display different icons and text based on the recording status
                                          Obx(() {
                                            if (globalController.recorderService.recordingStatus.value == 0) {
                                              // If recording is stopped, show start button
                                              return SvgPicture.asset(
                                                ImagePath.start_recording,
                                                height: 50,
                                                width: 50,
                                              );
                                            } else if (globalController.recorderService.recordingStatus.value == 1) {
                                              // If recording, show pause button
                                              return SvgPicture.asset(
                                                ImagePath.pause_recording, // Replace with the actual pause icon
                                                height: 50,
                                                width: 50,
                                              );
                                            } else {
                                              // If paused, show resume button
                                              return SvgPicture.asset(
                                                ImagePath.start_recording, // Replace with the actual resume icon
                                                height: 50,
                                                width: 50,
                                              );
                                            }
                                          }),
                                          SizedBox(height: 10),
                                          // Display corresponding text based on the status
                                          Obx(() {
                                            if (globalController.recorderService.recordingStatus.value == 0) {
                                              return Text(
                                                textAlign: TextAlign.center,
                                                "Start",
                                                style: AppFonts.medium(17, AppColors.textGrey),
                                              );
                                            } else if (globalController.recorderService.recordingStatus.value == 1) {
                                              return Text(
                                                textAlign: TextAlign.center,
                                                "Pause",
                                                style: AppFonts.medium(17, AppColors.textGrey),
                                              );
                                            } else {
                                              return Text(
                                                textAlign: TextAlign.center,
                                                "Resume",
                                                style: AppFonts.medium(17, AppColors.textGrey),
                                              );
                                            }
                                          }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () async {

                                        File? audioFile = await globalController.recorderService.stopRecording();
                                        customPrint("audio file url is :- ${audioFile?.absolute}");
                                        if (audioFile != null) {
                                          globalController.submitAudio(audioFile!);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            ImagePath.stop_recording,
                                            height: 50,
                                            width: 50,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Stop",
                                            style: AppFonts.medium(17, AppColors.textGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Obx(() {
                                  return Text(
                                    textAlign: TextAlign.center,
                                 globalController.recorderService.formattedRecordingTime,
                                    style: AppFonts.regular(14, AppColors.textBlack),
                                  );
                                }),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Press the stop button to start generating your summary.",
                                    style: AppFonts.regular(14, AppColors.textGrey),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    spacing: 15,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                                              allowMultiple: false,
                                              type: FileType.custom,
                                              allowedExtensions: ['mp3', 'aac', 'm4a'],
                                            );

                                            globalController.changeStatus("In-Room");
                                            customPrint("audio is:- ${result?.files.first.xFile.path}");
                                            globalController.submitAudio(File(result?.files.first.path ?? ""));

                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 2),
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 5),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "Upload recording",
                                                    // "Back to Medical Record",
                                                    style: AppFonts.medium(13, AppColors.textGrey),
                                                  ),
                                                ),
                                                SizedBox(width: 10)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: PopupMenuButton<String>(
                                          offset: const Offset(0, -290),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          color: AppColors.white,
                                          position: PopupMenuPosition.under,
                                          padding: EdgeInsetsDirectional.zero,
                                          menuPadding: EdgeInsetsDirectional.zero,
                                          onSelected: (value) {},
                                          style: const ButtonStyle(
                                              padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              maximumSize: WidgetStatePropertyAll(Size.zero),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                onTap: () {
                                                  // controller.pickProfileImage();
                                               globalController.captureImage(context);

                                                  // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                                                },
                                                // value: "",
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons.camera,
                                                        color: AppColors.textDarkGrey,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Take Photo or Video",
                                                        style: AppFonts.regular(16, AppColors.textBlack),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            PopupMenuItem(
                                              // value: "",
                                                padding: EdgeInsets.zero,
                                                onTap: () async {
                                                  // controller.captureProfileImage();

                                              globalController.captureImage(context, fromCamera: false);
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: AppColors.textDarkGrey,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons.photo_fill_on_rectangle_fill,
                                                            color: AppColors.textDarkGrey,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Choose Photo",
                                                            style: AppFonts.regular(16, AppColors.textBlack),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            PopupMenuItem(
                                              // value: "",
                                                padding: EdgeInsets.zero,
                                                onTap: () async {
                                                  // controller.captureProfileImage();
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: AppColors.appbarBorder,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.document_scanner_sharp,
                                                            color: AppColors.textDarkGrey,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Scan Documents",
                                                            style: AppFonts.regular(16, AppColors.textDarkGrey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            PopupMenuItem(
                                              // value: "",
                                                padding: EdgeInsets.zero,
                                                onTap: () async {
                                                  // controller.captureProfileImage();

                                                  globalController.pickFiles(context);
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: AppColors.appbarBorder,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.file_copy_rounded,
                                                            color: AppColors.textDarkGrey,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Attach File",
                                                            style: AppFonts.regular(16, AppColors.textBlack),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.textPurple, width: 2),
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  ImagePath.uploadImage,
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  "Upload Photos",
                                                  style: AppFonts.medium(13, AppColors.textPurple),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                              if (!globalController.isExpandRecording.value) ...[
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImagePath.recording,
                                      height: 45,
                                      width: 45,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.left,
                                          "",
                                          // "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}",
                                          style: AppFonts.regular(14, AppColors.textWhite),
                                        ),
                                        SizedBox(height: 0),
                                        Obx(() {
                                          return Text(
                                            textAlign: TextAlign.left,
                                           globalController.recorderService.formattedRecordingTime,
                                            style: AppFonts.regular(14, AppColors.textGrey),
                                          );
                                        }),
                                      ],
                                    ),
                                    Spacer(),
                                    GestureDetector(onTap: () async {
                                      if (globalController.recorderService.recordingStatus.value == 0) {
                                        // If not recording, start the recording
                                        globalController.changeStatus("In-Room");
                                        await globalController.recorderService.startRecording(context);
                                      } else if (globalController.recorderService.recordingStatus.value == 1) {
                                        // If recording, pause it
                                        await globalController.recorderService.pauseRecording();
                                      } else if (globalController.recorderService.recordingStatus.value == 2) {
                                        // If paused, resume the recording
                                        await globalController.recorderService.resumeRecording();
                                      }
                                      // await controller.recorderService.startRecording(context);
                                    }, child: Obx(() {
                                      if (globalController.recorderService.recordingStatus.value == 0) {
                                        // If recording is stopped, show start button
                                        return SvgPicture.asset(
                                          ImagePath.dark_play,
                                          height: 45,
                                          width: 45,
                                        );
                                      } else if (globalController.recorderService.recordingStatus.value == 1) {
                                        // If recording, show pause button
                                        return SvgPicture.asset(
                                          ImagePath.pause_white, // Replace with the actual pause icon
                                          height: 45,
                                          width: 45,
                                        );
                                      } else {
                                        // If paused, show resume button
                                        return SvgPicture.asset(
                                          ImagePath.dark_play, // Replace with the actual resume icon
                                          height: 45,
                                          width: 45,
                                        );
                                      }
                                    })
                                      // SvgPicture.asset(
                                      //   ImagePath.pause_white,
                                      //   height: 45,
                                      //   width: 45,
                                      // ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        File? audioFile = await globalController.recorderService.stopRecording();
                                        customPrint("audio file url is :- ${audioFile?.absolute}");

                                        globalController.changeStatus("In-Exam");

                                        if (audioFile != null) {
                                          globalController.submitAudio(audioFile!);
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        ImagePath.stop_recording,
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                       globalController.isExpandRecording.value = !globalController.isExpandRecording.value;
                                      },
                                      child: SvgPicture.asset(
                                        ImagePath.expand_recording,
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],

              ],
            );
          }),
        ),
      ),
    );
  }
}
