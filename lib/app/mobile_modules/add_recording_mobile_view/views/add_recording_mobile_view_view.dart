import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/base_screen_mobile.dart';
import 'package:subqdocs/widgets/custom_tab_button.dart';
import 'package:subqdocs/widgets/base_dropdown2.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/appbar.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_recording_mobile_view_controller.dart';
import 'audio_wave.dart';

class AddRecordingMobileViewView extends StatefulWidget {
  const AddRecordingMobileViewView({super.key});

  @override
  State<AddRecordingMobileViewView> createState() => _AddRecordingMobileViewViewState();
}

class _AddRecordingMobileViewViewState extends State<AddRecordingMobileViewView> with TickerProviderStateMixin {
  AddRecordingMobileViewController controller = Get.put(AddRecordingMobileViewController());

  bool isPast = true;

  bool temp = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  DateTime fromDate = DateTime.now();

  DateTime toDate = DateTime.now();

  GlobalKey<FormState> formKeyFrom = GlobalKey<FormState>();

  GlobalKey<FormState> formKeyTo = GlobalKey<FormState>();

  DateTimeRange? selectedDateRange;

  Timer? timer;

  late AnimationController _controller;
  final double borderWidth = 30.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    controller.globalController.getConnectedInputDevices();
    controller.checkAudioRecordPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenMobile(
      onPopCallBack: () {
        if (controller.recorderService.recordingStatus.value == 1) {
          controller.recorderService.stopRecording(controller.visitId);
        }
      },
      onItemSelected: (index) async {},
      body: Column(
        children: [
          CustomMobileAppBar(
            drawerKey: _key,
            titleWidget: Text("Recording", style: AppFonts.medium(15.0, AppColors.textBlackDark)),
            actions: const [SizedBox()],
            leadingWidget: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                highlightColor: Colors.transparent,
                icon: SvgPicture.asset(ImagePath.back_arrow_mobile, height: 20, width: 20),
                onPressed: () {
                  Get.until((route) => Get.currentRoute == Routes.HOME_VIEW_MOBILE);
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.backgroundMobileAppbar,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      PullDownButton(
                        routeTheme: const PullDownMenuRouteTheme(backgroundColor: AppColors.white),
                        itemBuilder:
                            (context) => [
                              PullDownMenuItem.selectable(
                                title: 'English',
                                selected: controller.globalController.getUserDetailModel.value?.responseData?.is_multi_language_preference == false ? true : false,
                                onTap: () async {
                                  controller.globalController.selectedLanguageValue.value = "English";
                                  controller.globalController.getUserDetailModel.value?.responseData?.is_multi_language_preference = false;
                                },
                              ),
                              PullDownMenuItem.selectable(
                                selected: controller.globalController.getUserDetailModel.value?.responseData?.is_multi_language_preference == true ? true : false,
                                title: 'Multi language',
                                onTap: () async {
                                  controller.globalController.selectedLanguageValue.value = "Multi Language";
                                  controller.globalController.getUserDetailModel.value?.responseData?.is_multi_language_preference = true;
                                },
                              ),
                            ],
                        buttonBuilder:
                            (context, showMenu) => CupertinoButton(
                              onPressed: showMenu,
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Text('Transcription in ${(controller.globalController.getUserDetailModel.value?.responseData?.is_multi_language_preference ?? false) ? "Multi language" : "English"}', style: const TextStyle(fontSize: 16)), const SizedBox(width: 8), Icon(controller.globalController.isDropdownOpen.value ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: 24)],
                              ),
                            ),
                      ),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer light purple layer with smoother fading
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                double opacity;
                                if (_controller.value < 0.25) {
                                  // Phase 1: Outer fades out (1 → 0) with curve
                                  opacity = Curves.easeOutQuad.transform(1.0 - (_controller.value * 4));
                                } else if (_controller.value < 0.75) {
                                  // Phases 2 & 3: Outer stays invisible
                                  opacity = 0.0;
                                } else {
                                  // Phase 4: Outer fades in (0 → 1) with curve
                                  opacity = Curves.easeInQuad.transform((_controller.value - 0.75) * 4);
                                }
                                return Container(width: 175, height: 175, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.lightpurpule.withValues(alpha: opacity), width: 40, strokeAlign: BorderSide.strokeAlignInside)));
                              },
                            ),
                            // Inner purple layer with smoother fading
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                double opacity;
                                if (_controller.value < 0.25) {
                                  // Phase 1: Inner stays fully visible
                                  opacity = 1.0;
                                } else if (_controller.value < 0.5) {
                                  // Phase 2: Inner fades out (1 → 0) with curve
                                  opacity = Curves.easeOutQuad.transform(1.0 - ((_controller.value - 0.25) * 4));
                                } else if (_controller.value < 0.75) {
                                  // Phase 3: Inner fades in (0 → 1) with curve
                                  opacity = Curves.easeInQuad.transform((_controller.value - 0.5) * 4);
                                } else {
                                  // Phase 4: Inner stays fully visible
                                  opacity = 1.0;
                                }
                                return Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.filterBorder.withValues(alpha: opacity), width: 40, strokeAlign: BorderSide.strokeAlignInside)));
                              },
                            ),
                            // Static audio icon
                            SizedBox(width: 140, height: 140, child: Image.asset(ImagePath.audio_recording_png, width: 100, height: 100)),
                          ],
                        ),
                      ),
                      if (controller.globalController.samples.isNotEmpty)
                        Center(child: AudioWave(
                            animation: false,
                            height: 30,
                            width: 160,
                            spacing: 2.5,
                            animationLoop: 0,
                            bars: controller.globalController.samples.map((sample) => sample).toList())),
                      // Mic selection dropdown (shown on all platforms, like iPad view)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            return BaseDropdown2<String>(
                              height: 35,
                              width: 175,
                              fontSize: 12,
                              inputDecoration: InputDecoration(
                                hintText: controller.globalController.selectedMic.value.isEmpty ? "Select..." : controller.globalController.selectedMic.value,
                                hintStyle: AppFonts.regular(12, AppColors.backgroundPurple),
                                suffixIconConstraints: const BoxConstraints.tightFor(width: 35, height: 27),
                                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.backgroundPurple, size: 27),
                                prefixIcon: Padding(padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5), child: SvgPicture.asset(ImagePath.micRecording)),
                                prefixIconConstraints: const BoxConstraints.tightFor(width: 32, height: 25),
                                fillColor: AppColors.lightpurpule,
                                filled: true,
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(100)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                              ),
                              controller: TextEditingController(),
                              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                              valueAsString: (value) => value ?? "",
                              items: controller.globalController.connectedMic,
                              selectedValue: controller.globalController.selectedMic.value,
                              onChanged: (value) {
                                controller.globalController.selectedMic.value = value ?? "";
                                controller.globalController.setPreferredAudioInput(value ?? "");
                              },
                              selectText: "Select Mic",
                            );
                          }),
                        ],
                      ),
                      Obx(() {
                        return Center(child: Text(textAlign: TextAlign.center, "(${controller.recorderService.formattedRecordingTime})", style: AppFonts.regular(14, AppColors.textBlack)));
                      }),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (controller.recorderService.recordingStatus.value == 1) {
                              // If recording, pause it
                              //  controller.updatePauseResumeAudioWidget();
                              await controller.recorderService.pauseRecording();
                            } else if (controller.recorderService.recordingStatus.value == 2) {
                              // If paused, resume the recording
                              //  controller.updatePauseResumeAudioWidget();
                              await controller.recorderService.resumeRecording(controller.visitId);
                            }
                          },
                          child: Column(
                            children: [
                              // Display different icons and text based on the recording status
                              Obx(() {
                                if (controller.recorderService.recordingStatus.value == 1) {
                                  // If recording, show pause button
                                  return SvgPicture.asset(
                                    ImagePath.mobile_pause,
                                    // Replace with the actual pause icon
                                    height: 60,
                                    width: 60,
                                  );
                                } else {
                                  // If paused, show resume button
                                  return SvgPicture.asset(
                                    ImagePath.mobile_resume,
                                    // Replace with the actual resume icon
                                    height: 60,
                                    width: 60,
                                  );
                                }
                              }),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          controller.captureImage(context);
                        },
                        child: Center(
                          child: Container(
                            width: 140,
                            height: 45,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.filterBorder, width: 0.5)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [SvgPicture.asset(ImagePath.mobile_camera, height: 20, width: 20), const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Take photo", style: AppFonts.regular(14, AppColors.textDarkGrey))]),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          Center(child: Text("Press the stop button to start generating your summary.", textAlign: TextAlign.center, style: AppFonts.regular(14.0, AppColors.textDarkGrey))),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: MediaQuery.of(context).padding.bottom),
            child: CustomTabButton(
              onPressed: () async {
                // File? audioFile = await controller.recorderService.stopRecording();
                final success = await controller.recorderService.stopRecording(controller.visitId);
                if(success) Get.back();
                //
                // globalController.stopLiveActivityAudio();
                // customPrint("audio file url is :- ${audioFile?.absolute}");

                // controller.submitAudio(audioFile!);
                // _toggleRecording();
              },
              text: "Stop Recording",
              enabledColor: AppColors.redText,
              borderRadius: 10,
            ),
          ),
          if (Platform.isAndroid) ...[const SizedBox(height: 20)],
        ],
      ),
      globalKey: _key,
    );
  }
}
