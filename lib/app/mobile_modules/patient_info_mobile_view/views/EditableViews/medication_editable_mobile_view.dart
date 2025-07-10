import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class MedicationEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  MedicationEditableMobileView({super.key, required this.controller});

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
        itemCount: controller.editableDataForMedication.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.only(left: 10, right: 10),
            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataForMedication[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForMedication[index] = impressionModel;
              controller.editableDataForMedication.refresh();
              controller.updateFullNote("medications_html", controller.editableDataForMedication);
              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForMedication[index] = impressionModel;
              controller.editableDataForMedication.refresh();
            },
          );
        },
      );
    });
  }
}
