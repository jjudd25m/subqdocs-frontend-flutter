import 'dart:async';
import 'dart:io';

import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:subqdocs/utils/Loader.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';

import '../app/core/common/common_service.dart';
import '../app/core/common/global_controller.dart';
import '../app/core/common/logger.dart';
import '../app/models/audio_wave.dart';
import '../app/modules/custom_drawer/views/custom_drawer_view.dart';
import '../app/modules/personal_setting/controllers/personal_setting_controller.dart';
import '../app/routes/app_pages.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/imagepath.dart';
import 'base_dropdown2.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key, this.onPopCallBack, required this.body, required this.globalKey, this.isVisibleModel = false, this.onItemSelected, this.onDrawerChanged, this.onPlayCallBack, this.resizeToAvoidBottomInset = true});

  final Widget body;

  final bool isVisibleModel;
  final Function(int index)? onItemSelected;

  final VoidCallback? onPopCallBack;
  final Function(bool status)? onDrawerChanged;

  final GlobalKey<ScaffoldState> globalKey;
  final VoidCallback? onPlayCallBack;

  final bool resizeToAvoidBottomInset;

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with WidgetsBindingObserver {
  final GlobalController globalController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.valueOfy.value = globalController.adjustYPosition(globalController.valueOfy.value, context);
      globalController.valueOfx.value = globalController.snapXToEdge(globalController.valueOfx.value, context);
    });
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.onPopCallBack?.call();
      },

      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        key: widget.globalKey,
        backgroundColor: AppColors.white,
        onDrawerChanged: (isOpened) {
          if (widget.onDrawerChanged != null) {
            widget.onDrawerChanged!(isOpened);
          }
        },
        drawer: CustomDrawerView(
          onItemSelected: (index) async {
            // await onItemSelected!(index);

            if (Get.currentRoute == Routes.HOME) {
              if (index == 0) {
                final result = await Get.toNamed(Routes.ADD_PATIENT);
                globalController.breadcrumbHistory.clear();
                globalController.addRoute(Routes.HOME);
                globalController.addRoute(Routes.ADD_PATIENT);

                widget.globalKey.currentState!.closeDrawer();
              } else if (index == 1) {
                globalController.tabIndex.value = 1;
                // Get.toNamed(Routes.HOME, arguments: {
                //   "tabIndex": 1,
                // });

                widget.globalKey.currentState!.closeDrawer();
              } else if (index == 2) {
                globalController.tabIndex.value = 2;
                // Get.toNamed(Routes.HOME, arguments: {
                //   "tabIndex": 2,
                // });
                widget.globalKey.currentState!.closeDrawer();
              } else if (index == 3) {
                globalController.tabIndex.value = 0;
                // Get.toNamed(Routes.HOME, arguments: {
                //   "tabIndex": 0,
                // });
                widget.globalKey.currentState!.closeDrawer();
              } else {
                if (!Get.isRegistered<PersonalSettingController>()) {
                  Get.put(PersonalSettingController());
                }

                PersonalSettingController personalSettingController = Get.find();
                personalSettingController.onInit();

                globalController.breadcrumbHistory.clear();
                globalController.addRoute(Routes.HOME);
                globalController.addRoute(Routes.PERSONAL_SETTING);
                widget.globalKey.currentState!.closeDrawer();

                Get.toNamed(Routes.PERSONAL_SETTING);
              }
            } else {
              if (index == 0) {
                if (Get.currentRoute != Routes.ADD_PATIENT) {
                  Get.until((route) => Get.currentRoute == Routes.HOME);

                  // Get.until(Routes.HOME, (route) => false);
                  globalController.breadcrumbHistory.clear();
                  globalController.addRoute(Routes.HOME);
                  globalController.addRoute(Routes.ADD_PATIENT);
                  final result = await Get.toNamed(Routes.ADD_PATIENT);
                }
                widget.globalKey.currentState!.closeDrawer();
              } else if (index == 1) {
                globalController.tabIndex.value = 1;
                // Get.offNamedUntil(Routes.HOME, (route) => false);
                Get.until((route) => Get.currentRoute == Routes.HOME);
                globalController.breadcrumbHistory.clear();

                // Get.toNamed(Routes.HOME, arguments: {
                //   "tabIndex": 1,
                // });

                widget.globalKey.currentState!.closeDrawer();
              } else if (index == 2) {
                globalController.tabIndex.value = 2;
                // Get.offNamedUntil(Routes.HOME, (route) => false);
                Get.until((route) => Get.currentRoute == Routes.HOME);
                globalController.breadcrumbHistory.clear();

                // Get.toNamed(Routes.HOME, arguments: {
                //   "tabIndex": 2,
                // });
                widget.globalKey.currentState!.closeDrawer();
              } else if (index == 3) {
                globalController.tabIndex.value = 0;
                // Get.offNamedUntil(Routes.HOME, (route) => false);
                Get.until((route) => Get.currentRoute == Routes.HOME);
                globalController.breadcrumbHistory.clear();
                // Get.toNamed(Routes.HOME, arguments: {
                //   "tabIndex": 0,
                // });
                widget.globalKey.currentState!.closeDrawer();
              } else {
                if (Get.currentRoute != Routes.PERSONAL_SETTING) {
                  // Get.offNamedUntil(Routes.HOME, (route) => false);
                  Get.until((route) => Get.currentRoute == Routes.HOME);

                  globalController.breadcrumbHistory.clear();

                  await Future.delayed(const Duration(milliseconds: 100));

                  globalController.addRoute(Routes.HOME);
                  globalController.addRoute(Routes.PERSONAL_SETTING);
                  Get.toNamed(Routes.PERSONAL_SETTING);
                }
                widget.globalKey.currentState!.closeDrawer();
              }
            }
          },
        ),
        // appBar: CustomAppBar(),
        body: GestureDetector(
          onTap: removeFocus,
          child: SafeArea(
            child: Obx(() {
              globalController.reinitController();

              return SizedBox(
                width: Get.width,
                height: Get.height,
                child: Stack(
                  // fit: StackFit.expand,
                  // clipBehavior: Clip.none,
                  children: [
                    widget.body,
                    if (globalController.visitId.value.isNotEmpty || (globalController.isStartTranscript.value && widget.isVisibleModel)) ...[
                      DraggableFloatWidget(
                        // key: UniqueKey(),
                        receiveParam: (x, y) {
                          globalController.valueOfx.value = x;
                          globalController.valueOfy.value = y;
                        },
                        width: !globalController.isExpandRecording.value ? 388 : 388,
                        height: !globalController.isExpandRecording.value ? 66 : 480,
                        config: DraggableFloatWidgetBaseConfig(initPositionXInLeft: false, isFullScreen: false, valueOfTheX: globalController.valueOfx.value, valueOfThey: globalController.valueOfy.value, initPositionYInTop: false, initPositionYMarginBorder: 0),
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 0),
                              // Set the duration for smooth animation
                              decoration: BoxDecoration(boxShadow: [BoxShadow(color: AppColors.buttonBackgroundGrey.withValues(alpha: 0.4), spreadRadius: 2, blurRadius: 1.0)], borderRadius: BorderRadius.circular(12), color: globalController.isExpandRecording.value ? AppColors.white : AppColors.black),
                              padding: globalController.isExpandRecording.value ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0) : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Column(
                                children: [
                                  // Header Row (expand/collapse button)
                                  if (globalController.isExpandRecording.value) ...[
                                    Container(
                                      padding: const EdgeInsets.only(left: 10, right: 13, top: 10, bottom: 10),
                                      decoration: BoxDecoration(boxShadow: [BoxShadow(color: AppColors.backgroundLightGrey.withValues(alpha: 0.9), spreadRadius: 6, blurRadius: 4.0)], borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)), color: AppColors.backgroundPurple),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 273, child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, globalController.isStartRecording.value ? "Recording in Progress" : "${globalController.patientFirstName} ${globalController.patientLsatName}", style: AppFonts.regular(14, AppColors.textWhite))),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              globalController.isExpandRecording.value = !globalController.isExpandRecording.value;

                                              print(" when the view is expanded  value of the y ${globalController.valueOfy}");
                                              print(" when the view is expanded  value of the x ${globalController.valueOfx}");
                                            },
                                            child: SvgPicture.asset(globalController.isExpandRecording.value ? ImagePath.collpase : ImagePath.expand_recording, height: 30, width: 30),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (globalController.recorderService.recordingStatus.value == 1) ...[
                                      Text(textAlign: TextAlign.center, "Transcription in progress", style: AppFonts.regular(17, AppColors.textBlack)),
                                    ] else if (globalController.recorderService.recordingStatus.value == 2) ...[
                                      Text(textAlign: TextAlign.center, "Transcription is paused", style: AppFonts.regular(17, AppColors.textBlack)),
                                    ] else ...[
                                      const Text(" "),
                                    ],

                                    const SizedBox(height: 16),

                                    globalController.samples.isNotEmpty ? const AudioWave(animation: false, key: ValueKey("wave"), height: 30, width: 110, spacing: 2.5, animationLoop: 0) : const SizedBox(height: 30),
                                    const SizedBox(height: 17),
                                    Row(
                                      spacing: 35,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (globalController.recorderService.recordingStatus.value == 0) {
                                              if (widget.onPlayCallBack != null) {
                                                widget.onPlayCallBack?.call();
                                              }
                                              globalController.changeStatus("In-Room");
                                              // If not recording, start the recording
                                              globalController.startAudioWidget();
                                              globalController.recorderService.audioRecorder = AudioRecorder();
                                              globalController.getConnectedInputDevices();
                                              await globalController.recorderService.startRecording(context);
                                            } else if (globalController.recorderService.recordingStatus.value == 1) {
                                              // If recording, pause it
                                              globalController.updatePauseResumeAudioWidget();
                                              await globalController.recorderService.pauseRecording();
                                            } else if (globalController.recorderService.recordingStatus.value == 2) {
                                              // If paused, resume the recording
                                              globalController.updatePauseResumeAudioWidget();
                                              await globalController.recorderService.resumeRecording();
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              // Display different icons and text based on the recording status
                                              Obx(() {
                                                if (globalController.recorderService.recordingStatus.value == 0) {
                                                  // If recording is stopped, show start button
                                                  return SvgPicture.asset(ImagePath.start_recording, height: 50, width: 50);
                                                } else if (globalController.recorderService.recordingStatus.value == 1) {
                                                  // If recording, show pause button
                                                  return SvgPicture.asset(
                                                    ImagePath.pause_recording,
                                                    // Replace with the actual pause icon
                                                    height: 58,
                                                    width: 58,
                                                  );
                                                } else {
                                                  // If paused, show resume button
                                                  return SvgPicture.asset(
                                                    ImagePath.start_recording,
                                                    // Replace with the actual resume icon
                                                    height: 58,
                                                    width: 58,
                                                  );
                                                }
                                              }),
                                              const SizedBox(height: 10),
                                              // Display corresponding text based on the status
                                              Obx(() {
                                                if (globalController.recorderService.recordingStatus.value == 0) {
                                                  return Text(textAlign: TextAlign.center, "Start", style: AppFonts.regular(12, AppColors.textGrey));
                                                } else if (globalController.recorderService.recordingStatus.value == 1) {
                                                  return Text(textAlign: TextAlign.center, "Pause", style: AppFonts.regular(12, AppColors.textGrey));
                                                } else {
                                                  return Text(textAlign: TextAlign.center, "Resume", style: AppFonts.regular(12, AppColors.textGrey));
                                                }
                                              }),
                                            ],
                                          ),
                                        ),
                                        // SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () async {
                                            File? audioFile = await globalController.recorderService.stopRecording();
                                            globalController.stopLiveActivityAudio();
                                            customPrint("audio file url is :- ${audioFile?.absolute}");
                                            if (audioFile != null) {
                                              globalController.submitAudio(audioFile);
                                            }
                                          },
                                          child: Column(children: [SvgPicture.asset(ImagePath.stop_recording, height: 58, width: 58), const SizedBox(height: 10), Text(textAlign: TextAlign.center, "Stop", style: AppFonts.regular(12, AppColors.textGrey))]),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Obx(() {
                                          return BaseDropdown2(
                                            height: 35,
                                            width: 175,
                                            fontSize: 12,
                                            inputDecoration: InputDecoration(
                                              hintText: globalController.selectedMic.value.isEmpty ? "Select..." : globalController.selectedMic.value,
                                              hintStyle: AppFonts.regular(12, AppColors.backgroundPurple),
                                              suffixIconConstraints: const BoxConstraints.tightFor(width: 35, height: 27),
                                              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.backgroundPurple, size: 27),
                                              prefixIcon: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                  child: SvgPicture.asset(
                                                    ImagePath.micRecording,
                                                    // width: 25, // Explicit size
                                                    // height: 25,
                                                  ),
                                                ),
                                              ),
                                              prefixIconConstraints: const BoxConstraints.tightFor(width: 32, height: 25),
                                              fillColor: AppColors.lightpurpule,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.circular(100), // main border radius
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100),
                                                // increased from 5 to 100 for roundness
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100),
                                                // increased from 5 to 100 for roundness
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            controller: TextEditingController(),
                                            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                            valueAsString: (value) => value ?? "aa",
                                            items: globalController.connectedMic.value,
                                            selectedValue: globalController.selectedMic.value ?? "",
                                            onChanged: (value) {
                                              globalController.selectedMic.value = value ?? "";
                                              globalController.setPreferredAudioInput(value ?? "");
                                            },
                                            selectText: "Select Mic",
                                          );
                                        }),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    Obx(() {
                                      return Text(textAlign: TextAlign.center, "(${globalController.recorderService.formattedRecordingTime})", style: AppFonts.regular(14, AppColors.textBlack));
                                    }),
                                    const SizedBox(height: 10),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 36), child: Text(textAlign: TextAlign.center, "Press the stop button to start generating your summary.", style: AppFonts.regular(12, AppColors.textGrey))),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 22.5),
                                      child: Row(
                                        spacing: 12,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (globalController.isProd) {
                                                  if (Get.currentRoute != Routes.VISIT_MAIN) {
                                                    Loader().showLoadingDialogForSimpleLoader();
                                                    dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": globalController.visitId.value, "patientId": globalController.patientId.value, "unique_tag": DateTime.now().toString()});
                                                    Loader().stopLoader();
                                                  } else {
                                                    Loader().showLoadingDialogForSimpleLoader();
                                                    Get.back(); // or Navigator.pop(context);
                                                    await Future.delayed(const Duration(milliseconds: 100)); // small delay to ensure pop
                                                    await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": globalController.visitId.value, "patientId": globalController.patientId.value, "unique_tag": DateTime.now().toString()});
                                                    Loader().stopLoader();
                                                  }
                                                } else {
                                                  if (globalController.recorderService.recordingStatus.value == 0) {
                                                    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['mp3', 'aac', 'm4a']);

                                                    if (widget.onPlayCallBack != null) {
                                                      widget.onPlayCallBack?.call();
                                                    }
                                                    // globalController.changeStatus("In-Room");

                                                    customPrint("audio is:- ${result?.files.first.xFile.path}");
                                                    globalController.submitAudio(File(result?.files.first.path ?? ""));
                                                  } else {
                                                    CustomToastification().showToast("Audio recoding is in progress");
                                                  }
                                                }
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(border: Border.all(color: AppColors.buttonBackgroundGrey, width: 1), color: AppColors.white, borderRadius: BorderRadius.circular(6)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(width: 10),

                                                    if (globalController.isProd) SvgPicture.asset(ImagePath.backSvg, width: 14, height: 14),

                                                    Expanded(
                                                      child: Text(
                                                        textAlign: TextAlign.center,
                                                        globalController.isProd ? "Back To Visit" : "Upload recording",
                                                        // "Back to Medical Record",
                                                        style: AppFonts.medium(13, AppColors.textGrey),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Material(
                                              child: PopupMenuButton<String>(
                                                offset: const Offset(0, -290),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                color: AppColors.white,
                                                position: PopupMenuPosition.under,
                                                padding: EdgeInsetsDirectional.zero,
                                                menuPadding: EdgeInsetsDirectional.zero,
                                                onSelected: (value) {},
                                                style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                                itemBuilder:
                                                    (context) => [
                                                      PopupMenuItem(
                                                        padding: EdgeInsets.zero,
                                                        onTap: () {
                                                          // controller.pickProfileImage();
                                                          globalController.captureImage(context);

                                                          // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                                                        },
                                                        // value: "",
                                                        child: Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.camera, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Take Photo or Video", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                      ),
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
                                                            Container(width: double.infinity, height: 1, color: AppColors.textDarkGrey),
                                                            Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Choose Photo", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        // value: "",
                                                        padding: EdgeInsets.zero,
                                                        onTap: () async {
                                                          // controller.captureProfileImage();
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                                            Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.document_scanner_sharp, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Scan Documents", style: AppFonts.regular(16, AppColors.textDarkGrey))])),
                                                          ],
                                                        ),
                                                      ),
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
                                                            Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                                            Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.file_copy_rounded, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Attach File", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(border: Border.all(color: AppColors.textPurple, width: 1), color: AppColors.white, borderRadius: BorderRadius.circular(6)),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(ImagePath.uploadImage, height: 20, width: 20), const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Upload Photos", style: AppFonts.medium(13, AppColors.textPurple))]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  if (!globalController.isExpandRecording.value) ...[
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(ImagePath.recording, height: 44, width: 44),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(maxLines: 1, textAlign: TextAlign.left, "${globalController.patientFirstName} ${globalController.patientLsatName}", style: AppFonts.regular(14, AppColors.textWhite), overflow: TextOverflow.ellipsis),
                                                const SizedBox(height: 0),
                                                Obx(() {
                                                  return Text(textAlign: TextAlign.left, maxLines: 3, globalController.recorderService.formattedRecordingTime, style: AppFonts.regular(14, AppColors.textGrey));
                                                }),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        PopupMenuButton<String>(
                                          offset: const Offset(0, -290),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          color: AppColors.white,
                                          position: PopupMenuPosition.under,
                                          padding: EdgeInsetsDirectional.zero,
                                          menuPadding: EdgeInsetsDirectional.zero,
                                          onSelected: (value) {},
                                          style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  padding: EdgeInsets.zero,
                                                  onTap: () {
                                                    // controller.pickProfileImage();
                                                    globalController.captureImage(context);

                                                    // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                                                  },
                                                  // value: "",
                                                  child: Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.camera, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Take Photo or Video", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                ),
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
                                                      Container(width: double.infinity, height: 1, color: AppColors.textDarkGrey),
                                                      Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Choose Photo", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  // value: "",
                                                  padding: EdgeInsets.zero,
                                                  onTap: () async {
                                                    // controller.captureProfileImage();
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                                      Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.document_scanner_sharp, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Scan Documents", style: AppFonts.regular(16, AppColors.textDarkGrey))])),
                                                    ],
                                                  ),
                                                ),
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
                                                      Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                                      Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.file_copy_rounded, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Attach File", style: AppFonts.regular(16, AppColors.textBlack))])),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                          child: SvgPicture.asset(ImagePath.imageExpanded, height: 44, width: 44),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () async {
                                            if (globalController.recorderService.recordingStatus.value == 0) {
                                              // If not recording, start the recording

                                              if (widget.onPlayCallBack != null) {
                                                widget.onPlayCallBack?.call();
                                              }
                                              globalController.changeStatus("In-Room");
                                              globalController.startAudioWidget();
                                              globalController.recorderService.audioRecorder = AudioRecorder();
                                              globalController.getConnectedInputDevices();
                                              await globalController.recorderService.startRecording(context);
                                            } else if (globalController.recorderService.recordingStatus.value == 1) {
                                              // If recording, pause it
                                              globalController.updatePauseResumeAudioWidget();
                                              await globalController.recorderService.pauseRecording();
                                            } else if (globalController.recorderService.recordingStatus.value == 2) {
                                              // If paused, resume the recording
                                              globalController.updatePauseResumeAudioWidget();
                                              await globalController.recorderService.resumeRecording();
                                            }
                                            // await controller.recorderService.startRecording(context);
                                          },
                                          child: Obx(() {
                                            if (globalController.recorderService.recordingStatus.value == 0) {
                                              // If recording is stopped, show start button
                                              return SvgPicture.asset(ImagePath.dark_play, height: 4, width: 44);
                                            } else if (globalController.recorderService.recordingStatus.value == 1) {
                                              // If recording, show pause button
                                              return SvgPicture.asset(
                                                ImagePath.pause_white,
                                                // Replace with the actual pause icon
                                                height: 44,
                                                width: 44,
                                              );
                                            } else {
                                              // If paused, show resume button
                                              return SvgPicture.asset(
                                                ImagePath.dark_play,
                                                // Replace with the actual resume icon
                                                height: 44,
                                                width: 44,
                                              );
                                            }
                                          }),
                                          // SvgPicture.asset(
                                          //   ImagePath.pause_white,
                                          //   height: 45,
                                          //   width: 45,
                                          // ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () async {
                                            File? audioFile = await globalController.recorderService.stopRecording();
                                            customPrint("audio file url is :- ${audioFile?.absolute}");
                                            globalController.stopLiveActivityAudio();
                                            if (audioFile != null) {
                                              globalController.submitAudio(audioFile!);
                                            }
                                          },
                                          child: SvgPicture.asset(ImagePath.stop_recording, height: 44, width: 44),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            globalController.isExpandRecording.value = !globalController.isExpandRecording.value;

                                            print(" when the view is non expanded  value of the y ${globalController.valueOfy}");
                                            print(" when the view is non  expanded  value of the x ${globalController.valueOfx}");

                                            globalController.valueOfy.value = globalController.adjustYPosition(globalController.valueOfy.value, context);
                                          },
                                          child: SvgPicture.asset(ImagePath.expand_recording, height: 30, width: 30),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
