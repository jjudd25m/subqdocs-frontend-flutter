import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_fonts.dart';
import '../../../../../utils/imagepath.dart';
import '../../../../core/common/html_editor_container.dart';
import '../../../visit_main/model/doctor_view_model.dart';
import '../../controllers/patient_info_controller.dart';
import '../../model/impresion_and_plan_view_model.dart';

class SocialHistoryEditableView extends StatelessWidget {
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);
  SocialHistoryEditableView({super.key});

  @override
  Widget build(BuildContext context) {
    return _taskListSection();
  }

  // Widget _taskListSection() {
  Widget _taskListSection() {
    return Obx(() {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.editableDataForSocialHistory.length,
        itemBuilder: (context, index) {
          return HtmlEditorViewWidget(
            heightOfTheEditableView: 400,
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
