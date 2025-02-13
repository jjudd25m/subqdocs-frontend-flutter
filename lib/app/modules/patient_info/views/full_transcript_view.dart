import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../controllers/patient_info_controller.dart';
import '../model/transcript_list_model.dart';

class FullTranscriptView extends GetView<PatientInfoController> {
  FullTranscriptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    color: AppColors.white,
                    border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                child: Column(
                  children: [
                    Container(
                      // height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            "Transcribing Summary",
                            style: AppFonts.medium(20, AppColors.textBlack),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                textAlign: TextAlign.left,
                                "(Transcription Time- ${(controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData.first.last.end ?? 0.0 / 60.0).toStringAsFixed(2)})",
                                style: AppFonts.medium(12, AppColors.textGrey),
                              ),
                              // Spacer()
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Stack(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12), color: AppColors.white, border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.3), width: 1)),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 6),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BaseImageView(
                                                    imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          textAlign: TextAlign.left,
                                                          controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData.first[index].speaker ?? "",
                                                          style: AppFonts.regular(14, AppColors.textPurple),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData.first[index].sentence ?? "",
                                                          style: AppFonts.regular(12, AppColors.textGrey),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),
                                                  Text(
                                                    "(${controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData.first[index].start ?? ""} - ${controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData.first[index].end ?? ""})",
                                                    style: AppFonts.regular(12, AppColors.textGrey),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                itemCount: controller.transcriptListModel.value?.responseData?.cleanedTranscript?.responseData.first.length ?? 0)),
                        if (controller.isFullTranscriptLoading.value) ...[
                          Center(
                              child: Column(
                            children: [
                              Lottie.asset(
                                'assets/lottie/loader.json',
                                width: 200,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                              Text(controller.isFullTranscriptLoadText.value)
                            ],
                          ))
                        ]
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 6,
          ),
        ],
      );
    });
  }

  Widget _headerBuildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTableCell(String text, bool isTotal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? Colors.black : Colors.grey[700],
        ),
      ),
    );
  }
}
