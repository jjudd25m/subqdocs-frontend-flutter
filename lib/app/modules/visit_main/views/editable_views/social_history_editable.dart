import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/visit_main_controller.dart';

class SocialHistoryEditable extends StatelessWidget {
  VisitMainController controller;
  SocialHistoryEditable({super.key, required this.controller});

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
        itemCount: controller.editableSocialHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 250,
            impresionAndPlanViewModel: controller.editableSocialHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableSocialHistory[index] = impressionModel;
              controller.editableSocialHistory.refresh();
              controller.updateFullNote("social_history_html", controller.editableSocialHistory);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editableSocialHistory[index] = impressionModel;
              controller.editableSocialHistory.refresh();
            },
          );
        },
      );
    });
  }
}
