import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class CancerHistoryEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  CancerHistoryEditableMobileView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _taskListSection();
  }

  Widget _taskListSection() {
    return Obx(() {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.editableDataForCancerHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.only(left: 10, right: 10),

            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataForCancerHistory[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForCancerHistory[index] = impressionModel;
              controller.editableDataForCancerHistory.refresh();

              controller.updateFullNote("cancer_history_html", controller.editableDataForCancerHistory);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForCancerHistory[index] = impressionModel;
              controller.editableDataForCancerHistory.refresh();
            },
          );
        },
      );
    });
  }
}
