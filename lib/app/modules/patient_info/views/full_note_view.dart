import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:subqdocs/app/modules/patient_info/views/EditableViews/skin_history_editable_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../controllers/patient_info_controller.dart';
import 'EditableViews/CommonContainer.dart';
import 'EditableViews/alergies_editable.dart';
import 'EditableViews/cancer_history_editable_view.dart';
import 'EditableViews/chief_complaint.dart';
import 'EditableViews/exam_editable.dart';
import 'EditableViews/hpi_editable_view.dart';
import 'EditableViews/medication_editable.dart';
import 'EditableViews/review_of_systems.dart';
import 'EditableViews/social_history_editable_view.dart';
import 'impression_and_plan.dart';

class FullNoteView extends StatelessWidget {
  FullNoteView({super.key, required this.controller});

  PatientInfoController controller;

  // PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // if ((controller.isFullNoteLoading.value || controller.patientFullNoteModel.value?.responseData == null)) ...[
          //   Center(child: Column(children: [Lottie.asset('assets/lottie/loader.json', width: 200, height: 200, fit: BoxFit.fill), Text(controller.isFullNoteLoadText.value)])),
          // ] else ...[
          if (controller.patientFullNoteModel.value?.responseType == "error") ...[
            Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(controller.patientFullNoteModel.value?.message ?? "No data found", textAlign: TextAlign.start, style: AppFonts.medium(14, AppColors.textBlack)))),
          ] else if (controller.patientFullNoteModel.value?.responseData?.status?.toLowerCase() == "failure") ...[
            Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(controller.patientFullNoteModel.value?.responseData?.message ?? "No data found", textAlign: TextAlign.start, style: AppFonts.medium(14, AppColors.textBlack)))),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(textAlign: TextAlign.left, "Patient Medical Record", style: AppFonts.medium(20, AppColors.textBlack)),
                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      controller.copyAllSection();
                    },
                    child: const Icon(Icons.copy, color: Colors.grey),
                  ),

                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      controller.loadFullNotePDF(controller.visitId);
                    },
                    child: SvgPicture.asset(ImagePath.download_pdf, width: 30, height: 30),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: AppColors.borderTable)),

                    child: Theme(
                      // Required for ReorderableListView
                      data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                      child: ExpansionTile(
                        enabled: true,
                        initiallyExpanded: true,
                        visualDensity: const VisualDensity(vertical: -4),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        trailing: SvgPicture.asset(ImagePath.expanseTileIcon),
                        childrenPadding: const EdgeInsets.all(0),
                        collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                        shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                        backgroundColor: AppColors.white,
                        showTrailingIcon: true,
                        collapsedBackgroundColor: AppColors.white,
                        title: Row(children: [Text("Patient History", style: AppFonts.medium(16, AppColors.black))]),
                        children: [
                          Column(
                            children: [
                              const Divider(height: 1, color: AppColors.borderTable),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    CommonContainer(title: "Cancer History", child: controller.editableDataForCancerHistory.isEmpty ? const FullNoteSectionSkeleton() : CancerHistoryEditableView(controller: controller)),
                                    CommonContainer(title: "Skin History", child: controller.editableDataForSkinHistory.isEmpty ? const FullNoteSectionSkeleton() : SkinHistoryEditableView(controller: controller)),
                                    CommonContainer(title: "Social History", child: controller.editableDataForSocialHistory.isEmpty ? const FullNoteSectionSkeleton() : SocialHistoryEditableView(controller: controller)),
                                    CommonContainer(title: "Medications", child: controller.editableDataForMedication.isEmpty ? const FullNoteSectionSkeleton() : MedicationEditable(controller: controller)),
                                    CommonContainer(title: "Allergies", child: controller.editableDataForAllergies.isEmpty ? const FullNoteSectionSkeleton() : AlergiesEditable(controller: controller)),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CommonContainer(title: "Chief Complaint", child: controller.editableChiefView.isEmpty ? const FullNoteSectionSkeleton() : ChiefComplaint(controller: controller)),
                  CommonContainer(title: "HPI", child: controller.editableDataHpiView.isEmpty ? const FullNoteSectionSkeleton() : HpiEditableView(controller: controller)),
                  CommonContainer(title: "Review of Systems", child: controller.editableDataForReviewOfSystems.isEmpty ? const FullNoteSectionSkeleton() : ReviewOfSystemsEditableView(controller: controller)),
                  CommonContainer(title: "Exam", child: controller.editableDataForExam.isEmpty ? const FullNoteSectionSkeleton() : ExamEditable(controller: controller)),
                  ImpressionAndPlanPatientView(controller: controller),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          // ],
          // ],
        ],
      );
    });
  }
}

class FullNoteSectionSkeleton extends StatelessWidget {
  const FullNoteSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          spacing: 10,
          children: [
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf."))]),
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf."))]),
          ],
        ),
      ),
    );
  }
}

class ImpressionPlanSkeleton extends StatelessWidget {
  const ImpressionPlanSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          spacing: 10,
          children: [
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf.", maxLines: 2))]),
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf.", maxLines: 2))]),
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf.", maxLines: 2))]),
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf.", maxLines: 2))]),
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf.", maxLines: 2))]),
            Row(children: [Expanded(child: Text("You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf You came in for treatment of bothersome small growths on your right hand and a lesion on your right inner calf.", maxLines: 2))]),
          ],
        ),
      ),
    );
  }
}
