import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/mobile_modules/patient_info_mobile_view/controllers/patient_info_mobile_view_controller.dart';

import '../../../../core/common/html_editor_container.dart';

class AlergiesEditableMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  AlergiesEditableMobileView({super.key, required this.controller});

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
        itemCount: controller.editableDataForAllergies.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            padding: const EdgeInsets.only(left: 10, right: 10),
            heightOfTheEditableView: 300,
            impresionAndPlanViewModel: controller.editableDataForAllergies[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForAllergies[index] = impressionModel;
              controller.editableDataForAllergies.refresh();
              controller.updateFullNote("allergies", controller.editableDataForAllergies);
              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;

              controller.editableDataForAllergies[index] = impressionModel;
              controller.editableDataForAllergies.refresh();
            },
          );
        },
      );
    });
  }
}
