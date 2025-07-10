import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class HpiEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  HpiEditableMobileView({super.key, required this.controller});

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
        itemCount: controller.editableDataHpiView.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataHpiView[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataHpiView[index] = impressionModel;
              controller.editableDataHpiView.refresh();
              controller.updateFullNote("hpi", controller.editableDataHpiView);
              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataHpiView[index] = impressionModel;
              controller.editableDataHpiView.refresh();
            },
          );
        },
      );
    });
  }
}
