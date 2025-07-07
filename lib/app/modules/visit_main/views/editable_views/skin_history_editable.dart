import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/visit_main_controller.dart';

class SkinHistoryEditable extends StatelessWidget {
  VisitMainController controller;
  SkinHistoryEditable({super.key, required this.controller});

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
        itemCount: controller.editableSkinHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 250,
            impresionAndPlanViewModel: controller.editableSkinHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableSkinHistory[index] = impressionModel;
              controller.editableSkinHistory.refresh();
              controller.updateFullNote("social_history_html", controller.editableSkinHistory);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editableSkinHistory[index] = impressionModel;
              controller.editableSkinHistory.refresh();
            },
          );
        },
      );
    });
  }
}
