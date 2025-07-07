import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class ExamEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  ExamEditableMobileView({super.key, required this.controller});

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
        itemCount: controller.editableDataForExam.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataForExam[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForExam[index] = impressionModel;
              controller.editableDataForExam.refresh();
              controller.updateFullNote("exam", controller.editableDataForExam);
              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForExam[index] = impressionModel;
              controller.editableDataForExam.refresh();
            },
          );
        },
      );
    });
  }
}
