import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../controllers/patient_info_controller.dart';
import '../model/patient_fullnote_model.dart';

class FullNoteView extends StatelessWidget {
  FullNoteView({super.key});

  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if ((controller.isFullNoteLoading.value || controller.patientFullNoteModel.value?.responseData == null)) ...[
            Center(child: Column(children: [Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isFullNoteLoadText.value)])),
          ] else ...[
            if (controller.patientFullNoteModel.value?.responseData?.status == "Failure") ...[
              Center(child: Text(controller.patientFullNoteModel.value?.responseData?.message ?? "No data found", textAlign: TextAlign.center)),
            ] else ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 30,
                      child: Column(
                        spacing: 15,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                  ),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Cancer History", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child:
                                      controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistory?.isNotEmpty ?? false
                                          ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder:
                                                (context, index) => InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 2),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                          crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                          children: [
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Text(
                                                                textAlign: TextAlign.left,
                                                                controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistory ?? "",
                                                                style: AppFonts.regular(14, AppColors.textGrey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount: 1,
                                          )
                                          : Row(children: [Text(textAlign: TextAlign.left, "-", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.1),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Skin History", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child:
                                      controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistory?.isNotEmpty ?? false
                                          ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder:
                                                (context, index) => InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 2),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 0),
                                                            Expanded(
                                                              child: Text(
                                                                textAlign: TextAlign.left,
                                                                controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistory ?? "",
                                                                style: AppFonts.regular(15, AppColors.textGrey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount: 1,
                                          )
                                          : Row(children: [Text(textAlign: TextAlign.left, "-", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Social History", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child:
                                      controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistory?.isNotEmpty ?? false
                                          ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder:
                                                (context, index) => InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 2),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 0),
                                                            Expanded(
                                                              child: Text(
                                                                textAlign: TextAlign.left,
                                                                controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistory ?? "",
                                                                style: AppFonts.regular(15, AppColors.textGrey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount: 1,
                                          )
                                          : Row(children: [Text(textAlign: TextAlign.left, "-", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Medications", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child:
                                      controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?.isNotEmpty ?? false
                                          ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder:
                                                (context, index) => InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 2),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Text(
                                                                textAlign: TextAlign.left,
                                                                "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?[index].title} : ${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?[index].dosage} ",
                                                                style: AppFonts.regular(15, AppColors.textGrey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: Text(
                                                                textAlign: TextAlign.left,
                                                                "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?[index].purpose}",
                                                                style: AppFonts.regular(15, AppColors.textGrey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?.length ?? 0,
                                          )
                                          : Row(children: [Text(textAlign: TextAlign.left, "-", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Allergies", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child:
                                      controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies?.isNotEmpty ?? false
                                          ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder:
                                                (context, index) => InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 2),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                textAlign: TextAlign.left,
                                                                controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies ?? "",
                                                                style: AppFonts.regular(15, AppColors.textGrey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            itemCount: 1,
                                          )
                                          : Row(children: [Text(textAlign: TextAlign.left, "-", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 70,
                      child: Column(
                        spacing: 15,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Chief Complaint", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplain ?? "",
                                          style: AppFonts.medium(14, AppColors.textGrey),
                                        ),
                                      ),
                                      // Spacer()
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "HPI", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "",
                                    style: AppFonts.medium(14, AppColors.textGrey),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Review of Systems", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (context, index) => InkWell(
                                              onTap: () {},
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 0),
                                                    if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem!.toJson().values.toList()[index].toString().isNotEmpty ??
                                                        false) ...[
                                                      if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem!.toJson().values.toList()[index] != "-") ...[
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem!.toJson().values.toList()[index] !=
                                                                        "-") ...[
                                                                      TextSpan(
                                                                        text:
                                                                            "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem!.toJson().keys.toList()[index]}: ",
                                                                        recognizer: TapGestureRecognizer()..onTap = () {},
                                                                        style: AppFonts.semiBold(14, AppColors.black),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem!.toJson().values.toList()[index] ??
                                                                            "-",
                                                                        recognizer: TapGestureRecognizer()..onTap = () {},
                                                                        style: AppFonts.regular(14, AppColors.black),
                                                                      ),
                                                                    ],
                                                                  ],
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                    SizedBox(height: 0),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem?.toJson().keys.toList().length ?? 0,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0.01),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Exam", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 0),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (context, index) => InkWell(
                                              onTap: () {},
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 0),
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 0),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width: double.maxFinite,
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: "General Appearance: ",
                                                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                                                    style: AppFonts.semiBold(14, AppColors.black),
                                                                  ),
                                                                  TextSpan(
                                                                    text: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam?.generalAppearance ?? "",
                                                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                                                    style: AppFonts.regular(14, AppColors.black),
                                                                  ),
                                                                ],
                                                              ),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(children: [Text("Skin: ", style: AppFonts.semiBold(14, AppColors.black)), Spacer()]),
                                                    for (Skin skinData in controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam?.skin ?? [])
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width: double.maxFinite,
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(text: "• ", style: AppFonts.medium(20, AppColors.textPurple)),
                                                                    TextSpan(
                                                                      text: "${skinData.location}: ",
                                                                      recognizer: TapGestureRecognizer()..onTap = () {},
                                                                      style: AppFonts.semiBold(14, AppColors.black),
                                                                    ),
                                                                    TextSpan(text: skinData.finding, recognizer: TapGestureRecognizer()..onTap = () {}, style: AppFonts.regular(14, AppColors.black)),
                                                                  ],
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    SizedBox(height: 10),
                                                    Row(children: [Text("Other Systems: ", style: AppFonts.semiBold(14, AppColors.black)), Spacer()]),
                                                    for (String otherSystemData in controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam?.otherSystems ?? [])
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: SizedBox(
                                                              width: double.maxFinite,
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(text: "• ", style: AppFonts.medium(20, AppColors.textPurple)),
                                                                    // TextSpan(
                                                                    //   text: "${skinData.location}: ",
                                                                    //   recognizer: TapGestureRecognizer()..onTap = () {},
                                                                    //   style: AppFonts.semiBold(14, AppColors.black),
                                                                    // ),
                                                                    TextSpan(text: otherSystemData, recognizer: TapGestureRecognizer()..onTap = () {}, style: AppFonts.regular(14, AppColors.black)),
                                                                  ],
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    SizedBox(height: 0),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        itemCount: 1,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                              color: AppColors.white,
                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                    color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Impressions and Plan", style: AppFonts.medium(16, AppColors.textPurple)),
                                          Spacer(),
                                          SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ReorderableListView(
                                    buildDefaultDragHandles: false,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    onReorder: (oldIndex, newIndex) {},
                                    children: [
                                      for (final task in controller.tasks)
                                        Container(
                                          key: ValueKey(task),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10, top: 0, bottom: 20),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) => InkWell(
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    textAlign: TextAlign.center,
                                                                    "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].number}.",
                                                                    style: AppFonts.bold(14, AppColors.textPurple),
                                                                  ),
                                                                  SizedBox(width: 5),
                                                                  Expanded(
                                                                    child: Text(
                                                                      textAlign: TextAlign.left,
                                                                      "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].title} (${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].code})" ??
                                                                          "",
                                                                      style: AppFonts.regular(14, AppColors.textPurple),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Html(
                                                                      data: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].description ?? "",
                                                                      style: {"body": Style(margin: Margins.all(0), fontFamily: "Poppins", fontSize: FontSize(14.0))},
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 10),
                                                              if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].procedure?.type != "-") ...[
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        textAlign: TextAlign.left,
                                                                        "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].procedure?.type}.",
                                                                        style: AppFonts.bold(14, AppColors.textBlack),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                                for (final details
                                                                    in controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].procedure?.details ?? [])
                                                                  Row(children: [Expanded(child: Text(textAlign: TextAlign.left, "$details.", style: AppFonts.regular(14, AppColors.textBlack)))]),
                                                              ],
                                                              SizedBox(height: 10),
                                                              if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].medications != "-") ...[
                                                                Row(children: [Expanded(child: Text(textAlign: TextAlign.left, "Medications", style: AppFonts.bold(14, AppColors.textBlack)))]),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        textAlign: TextAlign.left,
                                                                        "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].medications}.",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                              SizedBox(height: 10),
                                                              if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].orders != "-") ...[
                                                                Row(children: [Expanded(child: Text(textAlign: TextAlign.left, "Orders:", style: AppFonts.bold(14, AppColors.textBlack)))]),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        textAlign: TextAlign.left,
                                                                        "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].orders}",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                              ],
                                                              Row(
                                                                children: [
                                                                  Expanded(child: Text(textAlign: TextAlign.left, "Counseling and Discussion:", style: AppFonts.bold(14, AppColors.textBlack))),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      textAlign: TextAlign.left,
                                                                      "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].counselingAndDiscussion}.",
                                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              if (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].followUp?.isNotEmpty ?? false) ...[
                                                                SizedBox(height: 10),
                                                                Row(children: [Expanded(child: Text(textAlign: TextAlign.left, "Follow up:", style: AppFonts.bold(14, AppColors.textBlack)))]),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        textAlign: TextAlign.left,
                                                                        "${controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index].followUp}.",
                                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10),
                                                              ],
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?.length ?? 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ],
          // ],
        ],
      );
    });
  }
}
