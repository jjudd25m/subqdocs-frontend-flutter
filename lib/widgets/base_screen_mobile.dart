import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/custom_drawer/views/custom_drawer_mobile_view.dart';

import '../app/core/common/common_service.dart';
import '../app/core/common/global_mobile_controller.dart';
import '../app/core/common/logger.dart';
import '../app/routes/app_pages.dart';
import '../utils/app_colors.dart';

class BaseScreenMobile extends StatefulWidget {
  BaseScreenMobile({
    super.key,
    this.onPopCallBack,
    required this.body,
    required this.globalKey,
    this.isVisibleModel = false,
    this.onItemSelected,
    this.onDrawerChanged,
    this.onPlayCallBack,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar,
    this.showDrawer = true,
  });

  Widget body;

  final bool isVisibleModel;
  final Function(int index)? onItemSelected;

  final VoidCallback? onPopCallBack;
  final Function(bool status)? onDrawerChanged;

  final GlobalKey<ScaffoldState> globalKey;
  final VoidCallback? onPlayCallBack;

  bool? resizeToAvoidBottomInset = true;
  final bool showDrawer;
  final Widget? bottomNavigationBar;

  @override
  State<BaseScreenMobile> createState() => _BaseScreenMobileState();
}

class _BaseScreenMobileState extends State<BaseScreenMobile>
    with WidgetsBindingObserver {
  final GlobalMobileController globalController = Get.find();

  // CustomDrawerMobileController CustomDrawerMobileController = Get.find();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // globalController.valueOfy.value = globalController.adjustYPosition(globalController.valueOfy.value, context);
      // globalController.valueOfx.value = globalController.snapXToEdge(globalController.valueOfx.value, context);
    });
    // bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.onPopCallBack?.call();
      },

      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        key: widget.globalKey,
        backgroundColor: AppColors.backgroundMobileAppbar,
        onDrawerChanged: (isOpened) {
          if (widget.onDrawerChanged != null) {
            widget.onDrawerChanged!(isOpened);
          }
        },
        drawer:
            widget.showDrawer
                ? CustomDrawerMobileView(
                  onItemSelected: (index) async {
                    // await onItemSelected!(index);

                    widget.onItemSelected!(index);

                    if (index == 0) {
                      globalController.tabIndex.value = 0;
                    } else if (index == 1) {
                      globalController.tabIndex.value = 1;
                    } else if (index == 2) {
                      globalController.tabIndex.value = 2;
                    } else if (index == 3) {
                      globalController.tabIndex.value = 3;
                      await Get.toNamed(Routes.PERSONAL_SETTING_MOBILE_VIEW);
                      globalController.tabIndex.value = 1;
                      customPrint("get current home from setting back");
                    }

                    widget.globalKey.currentState!.closeDrawer();
                  },
                )
                : null,
        // appBar: CustomAppBar(),
        body: GestureDetector(
          onTap: removeFocus,
          child: SafeArea(
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Stack(
                // fit: StackFit.expand,
                // clipBehavior: Clip.none,
                children: [
                  widget.body,
                  // if (globalController.visitId.value.isNotEmpty || (globalController.isStartTranscript.value && widget.isVisibleModel)) ...[
                  //   DraggableFloatWidget(
                  //     key: UniqueKey(),
                  //     receiveParam: (x, y) {
                  //       globalController.valueOfx.value = x;
                  //       globalController.valueOfy.value = y;
                  //
                  //       // print("x and y ${p0}  ${p1}");
                  //     },
                  //     width: 433,
                  //     height: !globalController.isExpandRecording.value ? 91 : 520,
                  //     config: DraggableFloatWidgetBaseConfig(
                  //       initPositionXInLeft: false,
                  //       isFullScreen: false,
                  //       valueOfTheX: globalController.valueOfx.value,
                  //       valueOfThey: globalController.valueOfy.value,
                  //       initPositionYInTop: false,
                  //       initPositionYMarginBorder: 0,
                  //     ),
                  //     child: Material(
                  //       child: AnimatedContainer(
                  //         duration: Duration(milliseconds: 0),
                  //         // Set the duration for smooth animation
                  //         width: MediaQuery.of(context).size.width * 0.45,
                  //         decoration: BoxDecoration(
                  //           boxShadow: [BoxShadow(color: AppColors.backgroundLightGrey.withValues(alpha: 0.9), spreadRadius: 6, blurRadius: 4.0)],
                  //           borderRadius: BorderRadius.circular(12),
                  //           color: globalController.isExpandRecording.value ? AppColors.backgroundWhite : AppColors.black,
                  //         ),
                  //         padding: globalController.isExpandRecording.value ? EdgeInsets.symmetric(horizontal: 0, vertical: 0) : EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //         child: Column(
                  //           children: [
                  //             // Header Row (expand/collapse button)
                  //             if (globalController.isExpandRecording.value) ...[
                  //               Container(
                  //                 height: 50,
                  //                 padding: EdgeInsets.symmetric(horizontal: 20),
                  //                 decoration: BoxDecoration(
                  //                   boxShadow: [BoxShadow(color: AppColors.backgroundLightGrey.withValues(alpha: 0.9), spreadRadius: 6, blurRadius: 4.0)],
                  //                   borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                  //                   color: AppColors.backgroundPurple,
                  //                 ),
                  //                 child: Row(
                  //                   children: [
                  //                     SizedBox(
                  //                       width: MediaQuery.of(context).size.width * 0.30,
                  //                       child: Text(
                  //                         maxLines: 2,
                  //                         textAlign: TextAlign.start,
                  //                         globalController.isStartRecording.value ? "Recording in Progress" : "${globalController.patientFirstName} ${globalController.patientLsatName}",
                  //                         style: AppFonts.medium(14, AppColors.textWhite),
                  //                       ),
                  //                     ),
                  //                     Spacer(),
                  //                     GestureDetector(
                  //                       onTap: () {
                  //                         globalController.isExpandRecording.value = !globalController.isExpandRecording.value;
                  //
                  //                         print(" when the view is expanded  value of the y ${globalController.valueOfy}");
                  //                         print(" when the view is expanded  value of the x ${globalController.valueOfx}");
                  //                       },
                  //                       child: SvgPicture.asset(globalController.isExpandRecording.value ? ImagePath.collpase : ImagePath.expand_recording, height: 30, width: 30),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(height: 20),
                  //               if (globalController.recorderService.recordingStatus.value == 1) ...[
                  //                 Text(textAlign: TextAlign.center, "Transcription in progress", style: AppFonts.regular(17, AppColors.textBlack)),
                  //               ] else if (globalController.recorderService.recordingStatus.value == 2) ...[
                  //                 Text(textAlign: TextAlign.center, "Transcription is paused", style: AppFonts.regular(17, AppColors.textBlack)),
                  //               ],
                  //
                  //               SizedBox(height: 20),
                  //               Container(
                  //                 height: 110,
                  //                 width: 110,
                  //                 decoration: BoxDecoration(color: AppColors.ScreenBackGround1, shape: BoxShape.circle),
                  //                 child: SiriWaveform.ios7(controller: globalController.waveController, options: const IOS7SiriWaveformOptions(height: 60, width: 60)),
                  //               ),
                  //               SizedBox(height: 20),
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   GestureDetector(
                  //                     onTap: () async {
                  //                       if (globalController.recorderService.recordingStatus.value == 0) {
                  //                         if (widget.onPlayCallBack != null) {
                  //                           widget.onPlayCallBack?.call();
                  //                         }
                  //                         globalController.changeStatus("In-Room");
                  //                         // If not recording, start the recording
                  //                         globalController.startAudioWidget();
                  //                         globalController.recorderService.audioRecorder = AudioRecorder();
                  //
                  //                         await globalController.recorderService.startRecording(context);
                  //                       } else if (globalController.recorderService.recordingStatus.value == 1) {
                  //                         // If recording, pause it
                  //                         globalController.updatePauseResumeAudioWidget();
                  //                         await globalController.recorderService.pauseRecording();
                  //                       } else if (globalController.recorderService.recordingStatus.value == 2) {
                  //                         // If paused, resume the recording
                  //                         globalController.updatePauseResumeAudioWidget();
                  //                         await globalController.recorderService.resumeRecording();
                  //                       }
                  //                     },
                  //                     child: Column(
                  //                       children: [
                  //                         // Display different icons and text based on the recording status
                  //                         Obx(() {
                  //                           if (globalController.recorderService.recordingStatus.value == 0) {
                  //                             // If recording is stopped, show start button
                  //                             return SvgPicture.asset(ImagePath.start_recording, height: 50, width: 50);
                  //                           } else if (globalController.recorderService.recordingStatus.value == 1) {
                  //                             // If recording, show pause button
                  //                             return SvgPicture.asset(
                  //                               ImagePath.pause_recording,
                  //                               // Replace with the actual pause icon
                  //                               height: 50,
                  //                               width: 50,
                  //                             );
                  //                           } else {
                  //                             // If paused, show resume button
                  //                             return SvgPicture.asset(
                  //                               ImagePath.start_recording,
                  //                               // Replace with the actual resume icon
                  //                               height: 50,
                  //                               width: 50,
                  //                             );
                  //                           }
                  //                         }),
                  //                         SizedBox(height: 10),
                  //                         // Display corresponding text based on the status
                  //                         Obx(() {
                  //                           if (globalController.recorderService.recordingStatus.value == 0) {
                  //                             return Text(textAlign: TextAlign.center, "Start", style: AppFonts.medium(17, AppColors.textGrey));
                  //                           } else if (globalController.recorderService.recordingStatus.value == 1) {
                  //                             return Text(textAlign: TextAlign.center, "Pause", style: AppFonts.medium(17, AppColors.textGrey));
                  //                           } else {
                  //                             return Text(textAlign: TextAlign.center, "Resume", style: AppFonts.medium(17, AppColors.textGrey));
                  //                           }
                  //                         }),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   SizedBox(width: 20),
                  //                   GestureDetector(
                  //                     onTap: () async {
                  //                       File? audioFile = await globalController.recorderService.stopRecording();
                  //                       globalController.stopLiveActivityAudio();
                  //                       customPrint("audio file url is :- ${audioFile?.absolute}");
                  //                       if (audioFile != null) {
                  //                         globalController.submitAudio(audioFile!);
                  //                       }
                  //                     },
                  //                     child: Column(
                  //                       children: [
                  //                         SvgPicture.asset(ImagePath.stop_recording, height: 50, width: 50),
                  //                         SizedBox(height: 10),
                  //                         Text(textAlign: TextAlign.center, "Stop", style: AppFonts.medium(17, AppColors.textGrey)),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               SizedBox(height: 20),
                  //               Obx(() {
                  //                 return Text(textAlign: TextAlign.center, globalController.recorderService.formattedRecordingTime, style: AppFonts.regular(14, AppColors.textBlack));
                  //               }),
                  //               SizedBox(height: 10),
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                 child: Text(textAlign: TextAlign.center, "Press the stop button to start generating your summary.", style: AppFonts.regular(14, AppColors.textGrey)),
                  //               ),
                  //               SizedBox(height: 15),
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(horizontal: 20),
                  //                 child: Row(
                  //                   spacing: 15,
                  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                   children: [
                  //                     Expanded(
                  //                       child: GestureDetector(
                  //                         onTap: () async {
                  //                           if (globalController.isProd) {
                  //                             if (Get.currentRoute != Routes.VISIT_MAIN) {
                  //                               dynamic response = await Get.toNamed(
                  //                                 Routes.VISIT_MAIN,
                  //                                 arguments: {"visitId": globalController.visitId.value, "patientId": globalController.patientId.value, "unique_tag": DateTime.now().toString()},
                  //                               );
                  //                             }
                  //                           } else {
                  //                             if (globalController.recorderService.recordingStatus.value == 0) {
                  //                               FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['mp3', 'aac', 'm4a']);
                  //
                  //                               if (widget.onPlayCallBack != null) {
                  //                                 widget.onPlayCallBack?.call();
                  //                               }
                  //                               // globalController.changeStatus("In-Room");
                  //
                  //                               customPrint("audio is:- ${result?.files.first.xFile.path}");
                  //                               globalController.submitAudio(File(result?.files.first.path ?? ""));
                  //                             } else {
                  //                               CustomToastification().showToast("Audio recoding is in progress");
                  //                             }
                  //                           }
                  //                         },
                  //                         child: Container(
                  //                           height: 50,
                  //                           decoration: BoxDecoration(
                  //                             border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 2),
                  //                             color: AppColors.white,
                  //                             borderRadius: BorderRadius.circular(8),
                  //                           ),
                  //                           child: Row(
                  //                             mainAxisAlignment: MainAxisAlignment.center,
                  //                             children: [
                  //                               SizedBox(width: 10),
                  //
                  //                               if (globalController.isProd) SvgPicture.asset(ImagePath.backSvg, width: 14, height: 14),
                  //
                  //                               Expanded(
                  //                                 child: Text(
                  //                                   textAlign: TextAlign.center,
                  //                                   globalController.isProd ? "Back To Visit" : "Upload recording",
                  //                                   // "Back to Medical Record",
                  //                                   style: AppFonts.medium(13, AppColors.textGrey),
                  //                                 ),
                  //                               ),
                  //                               SizedBox(width: 10),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: Material(
                  //                         child: PopupMenuButton<String>(
                  //                           offset: const Offset(0, -290),
                  //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  //                           color: AppColors.white,
                  //                           position: PopupMenuPosition.under,
                  //                           padding: EdgeInsetsDirectional.zero,
                  //                           menuPadding: EdgeInsetsDirectional.zero,
                  //                           onSelected: (value) {},
                  //                           style: const ButtonStyle(
                  //                             padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                  //                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //                             maximumSize: WidgetStatePropertyAll(Size.zero),
                  //                             visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  //                           ),
                  //                           itemBuilder:
                  //                               (context) => [
                  //                             PopupMenuItem(
                  //                               padding: EdgeInsets.zero,
                  //                               onTap: () {
                  //                                 // controller.pickProfileImage();
                  //                                 globalController.captureImage(context);
                  //
                  //                                 // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                  //                               },
                  //                               // value: "",
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                 child: Row(
                  //                                   children: [
                  //                                     Icon(CupertinoIcons.camera, color: AppColors.textDarkGrey),
                  //                                     SizedBox(width: 10),
                  //                                     Text("Take Photo or Video", style: AppFonts.regular(16, AppColors.textBlack)),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             PopupMenuItem(
                  //                               // value: "",
                  //                               padding: EdgeInsets.zero,
                  //                               onTap: () async {
                  //                                 // controller.captureProfileImage();
                  //
                  //                                 globalController.captureImage(context, fromCamera: false);
                  //                               },
                  //                               child: Column(
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Container(width: double.infinity, height: 1, color: AppColors.textDarkGrey),
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                     child: Row(
                  //                                       children: [
                  //                                         Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: AppColors.textDarkGrey),
                  //                                         SizedBox(width: 10),
                  //                                         Text("Choose Photo", style: AppFonts.regular(16, AppColors.textBlack)),
                  //                                       ],
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                             PopupMenuItem(
                  //                               // value: "",
                  //                               padding: EdgeInsets.zero,
                  //                               onTap: () async {
                  //                                 // controller.captureProfileImage();
                  //                               },
                  //                               child: Column(
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                     child: Row(
                  //                                       children: [
                  //                                         Icon(Icons.document_scanner_sharp, color: AppColors.textDarkGrey),
                  //                                         SizedBox(width: 10),
                  //                                         Text("Scan Documents", style: AppFonts.regular(16, AppColors.textDarkGrey)),
                  //                                       ],
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                             PopupMenuItem(
                  //                               // value: "",
                  //                               padding: EdgeInsets.zero,
                  //                               onTap: () async {
                  //                                 // controller.captureProfileImage();
                  //
                  //                                 globalController.pickFiles(context);
                  //                               },
                  //                               child: Column(
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                  //                                   Padding(
                  //                                     padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                     child: Row(
                  //                                       children: [
                  //                                         Icon(Icons.file_copy_rounded, color: AppColors.textDarkGrey),
                  //                                         SizedBox(width: 10),
                  //                                         Text("Attach File", style: AppFonts.regular(16, AppColors.textBlack)),
                  //                                       ],
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ],
                  //                           child: Container(
                  //                             height: 50,
                  //                             decoration: BoxDecoration(border: Border.all(color: AppColors.textPurple, width: 2), color: AppColors.white, borderRadius: BorderRadius.circular(8)),
                  //                             child: Row(
                  //                               mainAxisAlignment: MainAxisAlignment.center,
                  //                               children: [
                  //                                 SvgPicture.asset(ImagePath.uploadImage, height: 20, width: 20),
                  //                                 SizedBox(width: 10),
                  //                                 Text(textAlign: TextAlign.center, "Upload Photos", style: AppFonts.medium(13, AppColors.textPurple)),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(height: 20),
                  //             ],
                  //             if (!globalController.isExpandRecording.value) ...[
                  //               SizedBox(height: 5),
                  //               Row(
                  //                 children: [
                  //                   SvgPicture.asset(ImagePath.recording, height: 45, width: 45),
                  //                   SizedBox(width: 10),
                  //                   Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       SizedBox(
                  //                         width: MediaQuery.of(context).size.width * 0.10,
                  //                         child: Text(
                  //                           maxLines: 2,
                  //                           textAlign: TextAlign.left,
                  //                           "${globalController.patientFirstName} ${globalController.patientLsatName}",
                  //                           style: AppFonts.regular(14, AppColors.textWhite),
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: 0),
                  //                       Obx(() {
                  //                         return Text(
                  //                           textAlign: TextAlign.left,
                  //                           maxLines: 3,
                  //                           globalController.recorderService.formattedRecordingTime,
                  //                           style: AppFonts.regular(14, AppColors.textGrey),
                  //                         );
                  //                       }),
                  //                     ],
                  //                   ),
                  //                   Spacer(),
                  //
                  //
                  //                   PopupMenuButton<String>(
                  //                       offset: const Offset(0, -290),
                  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  //                       color: AppColors.white,
                  //                       position: PopupMenuPosition.under,
                  //                       padding: EdgeInsetsDirectional.zero,
                  //                       menuPadding: EdgeInsetsDirectional.zero,
                  //                       onSelected: (value) {},
                  //                       style: const ButtonStyle(
                  //                         padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                  //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //                         maximumSize: WidgetStatePropertyAll(Size.zero),
                  //                         visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  //                       ),
                  //                       itemBuilder:
                  //                           (context) => [
                  //                         PopupMenuItem(
                  //                           padding: EdgeInsets.zero,
                  //                           onTap: () {
                  //                             // controller.pickProfileImage();
                  //                             globalController.captureImage(context);
                  //
                  //                             // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                  //                           },
                  //                           // value: "",
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                             child: Row(
                  //                               children: [
                  //                                 Icon(CupertinoIcons.camera, color: AppColors.textDarkGrey),
                  //                                 SizedBox(width: 10),
                  //                                 Text("Take Photo or Video", style: AppFonts.regular(16, AppColors.textBlack)),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         PopupMenuItem(
                  //                           // value: "",
                  //                           padding: EdgeInsets.zero,
                  //                           onTap: () async {
                  //                             // controller.captureProfileImage();
                  //
                  //                             globalController.captureImage(context, fromCamera: false);
                  //                           },
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               Container(width: double.infinity, height: 1, color: AppColors.textDarkGrey),
                  //                               Padding(
                  //                                 padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                 child: Row(
                  //                                   children: [
                  //                                     Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: AppColors.textDarkGrey),
                  //                                     SizedBox(width: 10),
                  //                                     Text("Choose Photo", style: AppFonts.regular(16, AppColors.textBlack)),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         PopupMenuItem(
                  //                           // value: "",
                  //                           padding: EdgeInsets.zero,
                  //                           onTap: () async {
                  //                             // controller.captureProfileImage();
                  //                           },
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                  //                               Padding(
                  //                                 padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                 child: Row(
                  //                                   children: [
                  //                                     Icon(Icons.document_scanner_sharp, color: AppColors.textDarkGrey),
                  //                                     SizedBox(width: 10),
                  //                                     Text("Scan Documents", style: AppFonts.regular(16, AppColors.textDarkGrey)),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         PopupMenuItem(
                  //                           // value: "",
                  //                           padding: EdgeInsets.zero,
                  //                           onTap: () async {
                  //                             // controller.captureProfileImage();
                  //
                  //                             globalController.pickFiles(context);
                  //                           },
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                  //                               Padding(
                  //                                 padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                  //                                 child: Row(
                  //                                   children: [
                  //                                     Icon(Icons.file_copy_rounded, color: AppColors.textDarkGrey),
                  //                                     SizedBox(width: 10),
                  //                                     Text("Attach File", style: AppFonts.regular(16, AppColors.textBlack)),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                       child: SvgPicture.asset(ImagePath.imageExpanded, height: 45, width: 45)
                  //                   ),
                  //
                  //                   SizedBox(width: 10),
                  //                   GestureDetector(
                  //                     onTap: () async {
                  //                       if (globalController.recorderService.recordingStatus.value == 0) {
                  //                         // If not recording, start the recording
                  //
                  //                         if (widget.onPlayCallBack != null) {
                  //                           widget.onPlayCallBack?.call();
                  //                         }
                  //                         globalController.changeStatus("In-Room");
                  //                         globalController.startAudioWidget();
                  //                         globalController.recorderService.audioRecorder = AudioRecorder();
                  //
                  //                         await globalController.recorderService.startRecording(context);
                  //                       } else if (globalController.recorderService.recordingStatus.value == 1) {
                  //                         // If recording, pause it
                  //                         globalController.updatePauseResumeAudioWidget();
                  //                         await globalController.recorderService.pauseRecording();
                  //                       } else if (globalController.recorderService.recordingStatus.value == 2) {
                  //                         // If paused, resume the recording
                  //                         globalController.updatePauseResumeAudioWidget();
                  //                         await globalController.recorderService.resumeRecording();
                  //                       }
                  //                       // await controller.recorderService.startRecording(context);
                  //                     },
                  //                     child: Obx(() {
                  //                       if (globalController.recorderService.recordingStatus.value == 0) {
                  //                         // If recording is stopped, show start button
                  //                         return SvgPicture.asset(ImagePath.dark_play, height: 45, width: 45);
                  //                       } else if (globalController.recorderService.recordingStatus.value == 1) {
                  //                         // If recording, show pause button
                  //                         return SvgPicture.asset(
                  //                           ImagePath.pause_white,
                  //                           // Replace with the actual pause icon
                  //                           height: 45,
                  //                           width: 45,
                  //                         );
                  //                       } else {
                  //                         // If paused, show resume button
                  //                         return SvgPicture.asset(
                  //                           ImagePath.dark_play,
                  //                           // Replace with the actual resume icon
                  //                           height: 45,
                  //                           width: 45,
                  //                         );
                  //                       }
                  //                     }),
                  //                     // SvgPicture.asset(
                  //                     //   ImagePath.pause_white,
                  //                     //   height: 45,
                  //                     //   width: 45,
                  //                     // ),
                  //                   ),
                  //                   SizedBox(width: 10),
                  //                   GestureDetector(
                  //                     onTap: () async {
                  //                       File? audioFile = await globalController.recorderService.stopRecording();
                  //                       customPrint("audio file url is :- ${audioFile?.absolute}");
                  //                       globalController.stopLiveActivityAudio();
                  //                       if (audioFile != null) {
                  //                         globalController.submitAudio(audioFile!);
                  //                       }
                  //                     },
                  //                     child: SvgPicture.asset(ImagePath.stop_recording, height: 45, width: 45),
                  //                   ),
                  //                   SizedBox(width: 10),
                  //                   GestureDetector(
                  //                     onTap: () {
                  //                       globalController.isExpandRecording.value = !globalController.isExpandRecording.value;
                  //
                  //                       print(" when the view is non expanded  value of the y ${globalController.valueOfy}");
                  //                       print(" when the view is non  expanded  value of the x ${globalController.valueOfx}");
                  //
                  //                       globalController.valueOfy.value = globalController.adjustYPosition(globalController.valueOfy.value, context);
                  //                     },
                  //                     child: SvgPicture.asset(ImagePath.expand_recording, height: 45, width: 45),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }
}
