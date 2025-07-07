import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class SocialHistoryEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  SocialHistoryEditableMobileView({super.key, required this.controller});

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
        itemCount: controller.editableDataForSocialHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.only(left: 10, right: 10),
            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataForSocialHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForSocialHistory[index] = impressionModel;
              controller.editableDataForSocialHistory.refresh();
              controller.updateFullNote("social_history_html", controller.editableDataForSocialHistory);
              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForSocialHistory[index] = impressionModel;
              controller.editableDataForSocialHistory.refresh();
            },
          );
        },
      );
    });
  }
}
