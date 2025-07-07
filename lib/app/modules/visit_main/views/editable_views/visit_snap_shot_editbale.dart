import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/visit_main_controller.dart';

class VisitSnapShotEditbale extends StatelessWidget {
  VisitMainController controller;

  VisitSnapShotEditbale({super.key, required this.controller});

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
        itemCount: controller.editableVisitSnapShot.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 400,

            padding: const EdgeInsets.symmetric(horizontal: 0),
            impresionAndPlanViewModel: controller.editableVisitSnapShot[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableVisitSnapShot[index] = impressionModel;
              controller.editableVisitSnapShot.refresh();
              controller.updatePatientVisit("visit_snapshot", controller.editableVisitSnapShot, controller.patientData.value.responseData?.visitSnapshot?.id);
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editableVisitSnapShot[index] = impressionModel;
              controller.editableVisitSnapShot.refresh();
            },
          );
        },
      );
    });
  }
}
