import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class PatientViewEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  PatientViewEditableMobileView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _taskListSection();
  }

  // Widget _taskListSection() {
  Widget _taskListSection() {
    return Obx(() {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.editableDataForPatientView.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            heightOfTheEditableView: 700,
            impresionAndPlanViewModel: controller.editableDataForPatientView[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForPatientView[index] = impressionModel;
              controller.editableDataForPatientView.refresh();
              // controller.updateFullNote("medications_html", controller.editableDataForMedication);
              // controller.updateImpressionAndPlan();
              controller.updatePatientView("patient_view_note_html", controller.editableDataForPatientView);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForPatientView[index] = impressionModel;
              controller.editableDataForPatientView.refresh();
            },
          );
        },
      );
    });
  }
}
