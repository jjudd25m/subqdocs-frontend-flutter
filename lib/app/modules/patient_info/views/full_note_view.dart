import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:subqdocs/widget/base_image_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../controllers/patient_info_controller.dart';

class FullNoteView extends GetView<PatientInfoController> {
  const FullNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
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
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Cancer History",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      // Text(
                                                      //   textAlign: TextAlign.center,
                                                      //   '\u2022',
                                                      //   style: AppFonts.regular(20, AppColors.textGrey),
                                                      // ),
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                          child: Text(
                                                        textAlign: TextAlign.left,
                                                        controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistory?[index] ?? "",
                                                        style: AppFonts.regular(15, AppColors.textGrey),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(height: 0),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.cancerHistory?.length ?? 0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Skin History",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      // Text(
                                                      //   textAlign: TextAlign.center,
                                                      //   '\u2022',
                                                      //   style: AppFonts.regular(20, AppColors.textGrey),
                                                      // ),
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                          child: Text(
                                                        textAlign: TextAlign.left,
                                                        controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistory?[index] ?? "",
                                                        style: AppFonts.regular(15, AppColors.textGrey),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(height: 0),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.skinHistory?.length ?? 0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Social History",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      // Text(
                                                      //   textAlign: TextAlign.center,
                                                      //   '\u2022',
                                                      //   style: AppFonts.regular(20, AppColors.textGrey),
                                                      // ),
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                          child: Text(
                                                        textAlign: TextAlign.left,
                                                        controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistory?[index] ?? "",
                                                        style: AppFonts.regular(15, AppColors.textGrey),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(height: 0),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.socialHistory?.length ?? 0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Medications",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      // Text(
                                                      //   textAlign: TextAlign.center,
                                                      //   '\u2022',
                                                      //   style: AppFonts.regular(20, AppColors.textGrey),
                                                      // ),
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                          child: Text(
                                                        textAlign: TextAlign.left,
                                                        controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?[index] ?? "",
                                                        style: AppFonts.regular(15, AppColors.textGrey),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(height: 0),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.medications?.length ?? 0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Allergies",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => InkWell(
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
                                                        controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies?[index] ?? "",
                                                        style: AppFonts.regular(15, AppColors.textGrey),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(height: 0),
                                                ],
                                              ),
                                            ),
                                          ),
                                      itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.allergies?.length ?? 0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ],
                    )),
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
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Chief Complaint",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.chiefComplaint ?? "",
                                    style: AppFonts.medium(14, AppColors.textGrey),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "HPI",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.hpi ?? "",
                                    style: AppFonts.medium(14, AppColors.textGrey),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Review of Systems",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   textAlign: TextAlign.left,
                                      //   "A focused review of systems was completed, including:",
                                      //   style: AppFonts.regular(15, AppColors.textGrey),
                                      // ),
                                      SizedBox(height: 10),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) => InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 0),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            textAlign: TextAlign.center,
                                                            '\u2022',
                                                            style: AppFonts.regular(20, AppColors.textGrey),
                                                          ),
                                                          SizedBox(width: 15),
                                                          Expanded(
                                                              child: Text(
                                                            textAlign: TextAlign.left,
                                                            controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem?[index] ?? "",
                                                            style: AppFonts.regular(15, AppColors.textGrey),
                                                          )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.reviewOfSystem?.length ?? 0),
                                      SizedBox(height: 10),
                                      // Text(
                                      //   textAlign: TextAlign.left,
                                      //   "Don reported that he has not experienced night sweats, skin rash, chest pain, shortness of breath, fever or chills.",
                                      //   style: AppFonts.regular(15, AppColors.textGrey),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Exam",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   textAlign: TextAlign.left,
                                      //   controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.ex ?? "",
                                      //   style: AppFonts.regular(15, AppColors.textGrey),
                                      // ),
                                      SizedBox(height: 10),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) => InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 0),
                                                      Row(
                                                        children: [
                                                          // Text(
                                                          //   textAlign: TextAlign.center,
                                                          //   '\u2022',
                                                          //   style: AppFonts.regular(20, AppColors.textGrey),
                                                          // ),
                                                          SizedBox(width: 15),
                                                          Expanded(
                                                              child: Text(
                                                            textAlign: TextAlign.left,
                                                            controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam?[index] ?? "",
                                                            style: AppFonts.regular(15, AppColors.textGrey),
                                                          )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.exam?.length ?? 0),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                color: AppColors.white,
                                border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                                  // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Impressions and Plan",
                                            style: AppFonts.medium(16, AppColors.textPurple),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ReorderableListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    onReorder: (oldIndex, newIndex) {
                                      // setState(() {
                                      if (newIndex > oldIndex) {
                                        newIndex = newIndex - 1;
                                      }
                                      // });
                                      final task = controller.tasks.removeAt(oldIndex);
                                      controller.tasks.insert(newIndex, task);
                                    },
                                    children: [
                                      for (final task in controller.tasks)
                                        Container(
                                          key: ValueKey(task),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImagePath.reorder,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  // Expanded(
                                                  //   child: Text(
                                                  //     textAlign: TextAlign.left,
                                                  //     "1. History of Malignant melanoma on the right side of the nose (Z85.820)",
                                                  //     style: AppFonts.medium(14, AppColors.textPurple),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 50, top: 0, bottom: 20),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index) => InkWell(
                                                          onTap: () {},
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    // Text(
                                                                    //   textAlign: TextAlign.center,
                                                                    //   '\u2022',
                                                                    //   style: AppFonts.regular(20, AppColors.textGrey),
                                                                    // ),
                                                                    SizedBox(width: 5),
                                                                    Expanded(
                                                                        child: Text(
                                                                      textAlign: TextAlign.left,
                                                                      controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?[index] ?? "",
                                                                      style: AppFonts.regular(15, AppColors.textGrey),
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 0),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    itemCount: controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan?.length ?? 0),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                                              //   child: Text(
                                              //     textAlign: TextAlign.left,
                                              //     "I discussed the importance of regular skin checks and self-examinations with Don. I also emphasized consistent sun protection, including wearing protective clothing and using sunscreen with zinc and titanium oxide.",
                                              //     style: AppFonts.medium(16, AppColors.textGrey),
                                              //   ),
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 50, top: 20, bottom: 20),
                                              //   child: ListView.builder(
                                              //       shrinkWrap: true,
                                              //       itemBuilder: (context, index) => InkWell(
                                              //             onTap: () {},
                                              //             child: Padding(
                                              //               padding: const EdgeInsets.symmetric(horizontal: 0),
                                              //               child: Column(
                                              //                 children: [
                                              //                   Row(
                                              //                     children: [
                                              //                       Text(
                                              //                         textAlign: TextAlign.center,
                                              //                         '\u2022',
                                              //                         style: AppFonts.regular(20, AppColors.textGrey),
                                              //                       ),
                                              //                       SizedBox(width: 15),
                                              //                       Expanded(
                                              //                           child: Text(
                                              //                         textAlign: TextAlign.left,
                                              //                         "Cephalexin 500 mg Capsule",
                                              //                         style: AppFonts.regular(15, AppColors.textGrey),
                                              //                       )),
                                              //                     ],
                                              //                   ),
                                              //                   SizedBox(height: 0),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ),
                                              //       itemCount: 4),
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 50, top: 20, bottom: 20),
                                              //   child: BaseImageView(width: double.infinity, height: 200, imageUrl: "https://www.cdfa.ca.gov/v6.5/sample/images/gallery/orangecounty-big.jpg"),
                                              // ),
                                            ],
                                          ),
                                        )
                                      // Card(
                                      //   color: AppColors.white,
                                      //   key: ValueKey(task),
                                      //   elevation: 5.0,
                                      //   child: ListTile(
                                      //     title: Text(task),
                                      //     leading: const Icon(Icons.work, color: Colors.black),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         textAlign: TextAlign.left,
                                //         "A comprehensive skin exam was conducted with the medical assistant present. The scalp, face, trunk, and extremities were thoroughly examined. \n \nDon has skin type II. He appeared well-groomed, well-nourished, and was alert and oriented to person, place, and time. \n \nFindings included: \n",
                                //         style: AppFonts.regular(15, AppColors.textGrey),
                                //       ),
                                //       SizedBox(height: 10),
                                //       ListView.builder(
                                //           shrinkWrap: true,
                                //           itemBuilder: (context, index) => InkWell(
                                //                 onTap: () {},
                                //                 child: Padding(
                                //                   padding: const EdgeInsets.symmetric(horizontal: 0),
                                //                   child: Column(
                                //                     children: [
                                //                       SizedBox(height: 0),
                                //                       Row(
                                //                         children: [
                                //                           Text(
                                //                             textAlign: TextAlign.center,
                                //                             '\u2022',
                                //                             style: AppFonts.regular(20, AppColors.textGrey),
                                //                           ),
                                //                           SizedBox(width: 15),
                                //                           Expanded(
                                //                               child: Text(
                                //                             textAlign: TextAlign.left,
                                //                             "Brown, scaly plaques scattered across the trunk",
                                //                             style: AppFonts.regular(15, AppColors.textGrey),
                                //                           )),
                                //                         ],
                                //                       ),
                                //                       SizedBox(height: 0),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ),
                                //           itemCount: 4),
                                //       SizedBox(height: 10),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        // Container(
                        //     width: double.infinity,
                        //     padding: EdgeInsets.symmetric(horizontal: 0),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        //         color: AppColors.white,
                        //         border: Border.all(color: AppColors.backgroundLightGrey, width: 1)),
                        //     child: Column(
                        //       children: [
                        //         Container(
                        //           height: 60,
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        //               color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                        //               border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1)),
                        //           padding: EdgeInsets.symmetric(horizontal: 10),
                        //           child: Column(
                        //             children: [
                        //               SizedBox(
                        //                 height: 10,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Text(
                        //                     textAlign: TextAlign.center,
                        //                     "Images",
                        //                     style: AppFonts.medium(16, AppColors.textPurple),
                        //                   ),
                        //                   Spacer(),
                        //                   SvgPicture.asset(
                        //                     ImagePath.edit_outline,
                        //                     height: 40,
                        //                     width: 40,
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(horizontal: 20),
                        //           child: Container(
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(12), color: AppColors.imageBannerGrayBackground, border: Border.all(color: AppColors.imageBannerGrayBorder, width: 1)),
                        //             padding: EdgeInsets.symmetric(horizontal: 20),
                        //             child: Column(
                        //               children: [
                        //                 SizedBox(height: 15),
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       textAlign: TextAlign.left,
                        //                       overflow: TextOverflow.ellipsis,
                        //                       "Right side of the nose before the laser session",
                        //                       style: AppFonts.medium(12, AppColors.textBlack),
                        //                     ),
                        //                     SizedBox(width: 10),
                        //                     SvgPicture.asset(
                        //                       ImagePath.edit,
                        //                       height: 25,
                        //                       width: 25,
                        //                     ),
                        //                     Spacer(),
                        //                     SvgPicture.asset(
                        //                       ImagePath.chat_outline,
                        //                       height: 40,
                        //                       width: 40,
                        //                     ),
                        //                     SizedBox(width: 10),
                        //                     SvgPicture.asset(
                        //                       ImagePath.delete_outline,
                        //                       height: 40,
                        //                       width: 40,
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(height: 10),
                        //                 BaseImageView(width: double.infinity, height: 200, imageUrl: "https://www.cdfa.ca.gov/v6.5/sample/images/gallery/orangecounty-big.jpg"),
                        //                 SizedBox(height: 10),
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       textAlign: TextAlign.center,
                        //                       "12/24/2024 - 10:13AM",
                        //                       style: AppFonts.medium(14, AppColors.textGrey),
                        //                     ),
                        //                     SizedBox(width: 10),
                        //                     Spacer(),
                        //                   ],
                        //                 ),
                        //                 SizedBox(height: 10),
                        //                 Container(
                        //                     decoration:
                        //                         BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.white, border: Border.all(color: AppColors.imageBannerGrayBorder, width: 1)),
                        //                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        //                     child: Column(
                        //                       children: [
                        //                         Row(
                        //                           children: [
                        //                             ClipRRect(
                        //                                 borderRadius: BorderRadius.circular(22.5),
                        //                                 child: BaseImageView(width: 45, height: 45, imageUrl: "https://www.cdfa.ca.gov/v6.5/sample/images/gallery/orangecounty-big.jpg")),
                        //                             SizedBox(width: 10),
                        //                             Text(
                        //                               textAlign: TextAlign.center,
                        //                               "Dr. Tinajero",
                        //                               style: AppFonts.medium(14, AppColors.textBlack),
                        //                             ),
                        //                             SizedBox(width: 10),
                        //                             Spacer(),
                        //                             SvgPicture.asset(
                        //                               ImagePath.edit_outline,
                        //                               height: 40,
                        //                               width: 40,
                        //                             ),
                        //                             SizedBox(width: 10),
                        //                             SvgPicture.asset(
                        //                               ImagePath.delete_outline,
                        //                               height: 40,
                        //                               width: 40,
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         SizedBox(
                        //                           height: 10,
                        //                         ),
                        //                         Text(
                        //                           textAlign: TextAlign.left,
                        //                           "Pre-treatment photo of the nasal scar prior to the first erbium Pearl Fractional laser session. Documenting baseline appearance for progress tracking.",
                        //                           style: AppFonts.medium(14, AppColors.textGrey),
                        //                         ),
                        //                       ],
                        //                     )),
                        //                 SizedBox(height: 20),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 20,
                        //         ),
                        //         // Padding(
                        //         //   padding: const EdgeInsets.symmetric(horizontal: 10),
                        //         //   child: Column(
                        //         //     crossAxisAlignment: CrossAxisAlignment.start,
                        //         //     children: [
                        //         //       Text(
                        //         //         textAlign: TextAlign.left,
                        //         //         "A comprehensive skin exam was conducted with the medical assistant present. The scalp, face, trunk, and extremities were thoroughly examined. \n \nDon has skin type II. He appeared well-groomed, well-nourished, and was alert and oriented to person, place, and time. \n \nFindings included: \n",
                        //         //         style: AppFonts.regular(15, AppColors.textGrey),
                        //         //       ),
                        //         //       SizedBox(height: 10),
                        //         //       ListView.builder(
                        //         //           shrinkWrap: true,
                        //         //           itemBuilder: (context, index) => InkWell(
                        //         //                 onTap: () {},
                        //         //                 child: Padding(
                        //         //                   padding: const EdgeInsets.symmetric(horizontal: 0),
                        //         //                   child: Column(
                        //         //                     children: [
                        //         //                       SizedBox(height: 0),
                        //         //                       Row(
                        //         //                         children: [
                        //         //                           Text(
                        //         //                             textAlign: TextAlign.center,
                        //         //                             '\u2022',
                        //         //                             style: AppFonts.regular(20, AppColors.textGrey),
                        //         //                           ),
                        //         //                           SizedBox(width: 15),
                        //         //                           Expanded(
                        //         //                               child: Text(
                        //         //                             textAlign: TextAlign.left,
                        //         //                             "Brown, scaly plaques scattered across the trunk",
                        //         //                             style: AppFonts.regular(15, AppColors.textGrey),
                        //         //                           )),
                        //         //                         ],
                        //         //                       ),
                        //         //                       SizedBox(height: 0),
                        //         //                     ],
                        //         //                   ),
                        //         //                 ),
                        //         //               ),
                        //         //           itemCount: 4),
                        //         //       SizedBox(height: 10),
                        //         //     ],
                        //         //   ),
                        //         // ),
                        //         // SizedBox(
                        //         //   height: 10,
                        //         // ),
                        //       ],
                        //     )),
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      );
    });
  }
}

// return Container(child:  if(context.isPhone)...[
// // ColumnWidget1(),
// // ColumnWidget2()
// ]else...[
// Row(
// children: [
// Expanded 3 ColumnWidget1(),
// SizedBox(widget: 20),
// Expanded 7 ColumnWidget2()
// ],
// )
// ],);
