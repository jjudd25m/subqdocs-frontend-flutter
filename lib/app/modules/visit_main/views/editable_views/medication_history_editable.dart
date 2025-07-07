import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/visit_main_controller.dart';

class MedicationHistoryEditable extends StatelessWidget {
  VisitMainController controller;
  MedicationHistoryEditable({super.key, required this.controller});

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
        itemCount: controller.editableMedicationHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 500,
            impresionAndPlanViewModel: controller.editableMedicationHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableMedicationHistory[index] = impressionModel;
              controller.editableMedicationHistory.refresh();
              controller.updateFullNote("new_medications_html", controller.editableMedicationHistory);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editableMedicationHistory[index] = impressionModel;
              controller.editableMedicationHistory.refresh();
            },
          );
        },
      );
    });
  }
}
