import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/common/html_editor_container.dart';
import '../../controllers/patient_info_mobile_view_controller.dart';

class ReviewOfSystemsMobileView extends StatelessWidget {
  PatientInfoMobileViewController controller;

  // PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);
  ReviewOfSystemsMobileView({super.key, required this.controller});

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
        itemCount: controller.editableDataForReviewOfSystems.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 350,
            impresionAndPlanViewModel: controller.editableDataForReviewOfSystems[index],
            onUpdateCallBack: (impressionModel, content) {
              controller.editableDataForReviewOfSystems[index] = impressionModel;
              controller.editableDataForReviewOfSystems.refresh();
              controller.updateFullNote("review_of_system", controller.editableDataForReviewOfSystems);
              // controller.updateImpressionAndPlan();
            },
            toggleCallBack: (impressionModel) {
              controller.resetImpressionAndPlanList();
              impressionModel.isEditing = true;
              controller.editableDataForReviewOfSystems[index] = impressionModel;
              controller.editableDataForReviewOfSystems.refresh();
            },
          );
        },
      );
    });
  }
}
