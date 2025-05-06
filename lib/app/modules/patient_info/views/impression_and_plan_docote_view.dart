import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/patient_info/views/EditableViews/CommonContainer.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../core/common/html_editor_container.dart';
import '../controllers/patient_info_controller.dart';

class ImpressionAndPlanDoctorView extends StatelessWidget {
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  ImpressionAndPlanDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(title: "Impressions and Plan", child: _taskListSection());
  }

  // Widget _taskListSection() {
  Widget _taskListSection() {
    return Obx(() {
      return Container(
        child: ReorderableListView(
          padding: EdgeInsets.only(bottom: 5 , top: 5 , left: 10 , right: 10),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = controller.impressionAndPlanList.removeAt(oldIndex);
            controller.impressionAndPlanList.insert(newIndex, item);
            controller.impressionAndPlanList.refresh();
          },
          children: List.generate(controller.impressionAndPlanList.length, (index) {
            final model = controller.impressionAndPlanList[index];
            return Padding(
              key: ValueKey(index),
              padding: const EdgeInsets.only(bottom: 5),
              child: Theme(
                // Required for ReorderableListView
                data: ThemeData(
                  splashColor: Colors.transparent, // Remove splash color
                  highlightColor: Colors.transparent, // Remove highlight color
                ),
                child: Container(
                  child: ExpansionTile(
                    initiallyExpanded: true,

                    tilePadding: EdgeInsets.only(right: 20, bottom: 0),
                    visualDensity: VisualDensity(vertical: -4),
                    childrenPadding: EdgeInsets.all(0),
                    collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                    shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                    backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),

                    collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                    clipBehavior: Clip.none,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          SvgPicture.asset(ImagePath.dragAndDrop),
                          SizedBox(width: 10),
                          Flexible(child: Text(" ${index + 1}. ${model.title ?? ""}", style: AppFonts.medium(16, AppColors.textPurple))),
                          // Drag icon
                        ],
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        color: AppColors.white,
                        child: HtmlEditorViewWidget(
                          heightOfTheEditableView: 500,
                          isBorder: false,
                          padding: const EdgeInsets.only(left: 40, right: 10),
                          impresionAndPlanViewModel: model,
                          onUpdateCallBack: (impressionModel, content) {
                            controller.impressionAndPlanList[index] = impressionModel;
                            controller.impressionAndPlanList.refresh();
                            controller.updateImpressionAndPlan();
                          },
                          toggleCallBack: (impressionModel) {
                            controller.resetImpressionAndPlanList();
                            impressionModel.isEditing = true;
                            controller.impressionAndPlanList[index] = impressionModel;
                            controller.impressionAndPlanList.refresh();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
