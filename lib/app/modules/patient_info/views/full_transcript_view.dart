import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../controllers/patient_info_controller.dart';

class FullTranscriptView extends StatelessWidget {
  FullTranscriptView({super.key, required this.controller});

  PatientInfoController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.white, border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
              child: Column(
                children: [
                  if (controller.transcriptListModel.value?.message != "This Visit Was Cancelled") ...[
                    if ((controller.transcriptListModel.value?.responseData?.mergedTranscript?.responseData?.isNotEmpty ?? false)) ...[
                      Container(
                        decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          return Skeletonizer(
                            enabled: controller.transcriptListModel.value?.responseData == null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const SizedBox(height: 4),
                                if (controller.transcriptListModel.value?.responseData?.mergedTranscript?.responseData?.isNotEmpty ?? false) ...[
                                  Row(children: [Text(textAlign: TextAlign.left, "(Transcription Time-  ${(convertSecondsToMinutes(controller.transcriptListModel.value?.responseData?.mergedTranscript?.responseData?.last.transcript?.last.end.round() ?? 0))})", style: AppFonts.medium(12, AppColors.textGrey))]),
                                ] else ...[
                                  Row(children: [Text(textAlign: TextAlign.left, "(Transcription Time- 00:00:00)", style: AppFonts.medium(12, AppColors.textGrey))]),
                                ],
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      if (controller.transcriptListModel.value?.responseData?.status == "Failure") ...[Center(child: Text(controller.transcriptListModel.value?.responseData?.message ?? "-", textAlign: TextAlign.center, style: AppFonts.medium(14, AppColors.black)))],
                      if (controller.transcriptListModel.value?.message == "This Visit Was Cancelled") ...[Center(child: Text(controller.transcriptListModel.value?.message ?? "-", textAlign: TextAlign.center, style: AppFonts.medium(14, AppColors.black)))],

                      if (controller.transcriptListModel.value?.message != "This Visit Was Cancelled") ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Skeletonizer(
                            enabled: controller.transcriptListModel.value?.responseData == null || controller.transcriptListModel.value?.responseData?.mergedTranscript == null,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) => ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.transcriptList[index].transcript?.length ?? 0,
                                    itemBuilder: (context, subIndex) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.white, border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.3), width: 1)),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 6),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const BaseImageView(imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s", width: 20, height: 20),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(textAlign: TextAlign.left, controller.transcriptListModel.value?.responseData?.mergedTranscript?.responseData?[index].transcript?[subIndex].speaker ?? "", style: AppFonts.regular(14, AppColors.textPurple)),
                                                          const SizedBox(height: 4),
                                                          Text(controller.transcriptList[index].transcript?[subIndex].sentence ?? "", style: AppFonts.regular(12, AppColors.textGrey)),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Text(convertSecondsToMinutes(controller.transcriptList[index].transcript?[subIndex].end.round()), style: AppFonts.regular(12, AppColors.textGrey)),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },
                                  ),
                              itemCount: controller.transcriptList.length,
                              // itemCount: controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData?.length ?? 0,
                            ),
                          ),
                        ),
                      ],

                      // if (controller.isFullTranscriptLoading.value) ...[
                      //   Center(child: Column(children: [Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isFullTranscriptLoadText.value)])),
                      // ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      );
    });
  }

  Widget _headerBuildTableCell(String text) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  Widget _buildTableCell(String text, bool isTotal) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(text, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? Colors.black : Colors.grey[700])));
  }

  String convertSecondsToMinutes(int seconds) {
    int minutes = seconds ~/ 60; // Integer division for minutes
    int remainingSeconds = seconds % 60; // Remainder for seconds
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}'; // Format as MM:SS
  }
}
