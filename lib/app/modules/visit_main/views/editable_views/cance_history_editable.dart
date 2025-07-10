import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/visit_main_controller.dart';

class CancerHistoryEditable extends StatelessWidget {
  VisitMainController controller;
  CancerHistoryEditable({super.key, required this.controller});

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
        itemCount: controller.editableCancerHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 250,
            impresionAndPlanViewModel: controller.editableCancerHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableCancerHistory[index] = impressionModel;
              controller.editableCancerHistory.refresh();
              controller.updateFullNote("cancer_history_html", controller.editableCancerHistory);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editableCancerHistory[index] = impressionModel;
              controller.editableCancerHistory.refresh();
            },
          );
        },
      );
    });
  }
}
