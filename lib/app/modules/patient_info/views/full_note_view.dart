import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:subqdocs/app/modules/patient_info/views/EditableViews/skin_history_editable_view.dart';
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 30,
                      child: Column(
                        spacing: 15,
                        children: [
                          CommonContainer(title: "Cancer History", child: CancerHistoryEditableView()),
                          CommonContainer(title: "Skin History", child: skinHistoryEditableView()),
                          CommonContainer(title: "Social History", child: SocialHistoryEditableView()),
                          CommonContainer(title: "Medications", child: MedicationEditable()),
                          CommonContainer(title: "Allergies", child: AlergiesEditable()),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 70,
                      child: Column(
                        spacing: 15,
                        children: [
                          CommonContainer(title: "Chief Complaint", child: ChiefComplaint()),
                          CommonContainer(title: "HPI", child: HpiEditableView()),
                          CommonContainer(title: "Review of Systems", child: ReviewOfSystemsEditableView()),
                          CommonContainer(title: "Exam", child: ExamEditable()),
                          ImpressionAndPlanPatientView(),
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
