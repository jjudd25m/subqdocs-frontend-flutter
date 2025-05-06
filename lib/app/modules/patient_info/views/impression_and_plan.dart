import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/patient_info/views/EditableViews/CommonContainer.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../core/common/html_editor_container.dart';
import '../controllers/patient_info_controller.dart';

class ImpressionAndPlanPatientView extends StatelessWidget {
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  ImpressionAndPlanPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(title: "Impressions and Plan", child: _taskListSection());
  }

  // Widget _taskListSection() {
  // Widget _taskListSection() {
  //   return Obx(() {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10),
  //       child: ListView.builder(
  //         padding: EdgeInsets.zero,
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: controller.impressionAndPlanListFullNote.length,
  //         itemBuilder: (context, index) {
  //           return Theme(
  //             data: ThemeData(
  //               splashColor: Colors.transparent, // Remove splash color
  //               highlightColor: Colors.transparent, // Remove highlight color
  //             ),
  //             child: ExpansionTile(
  //               initiallyExpanded: true,
  //               visualDensity: VisualDensity(vertical: -4),
  //               tilePadding: const EdgeInsets.only(left: 10, right: 10),
  //               childrenPadding: EdgeInsets.all(0),
  //               collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
  //               shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
  //               backgroundColor: AppColors.backgroundWhite,
  //               collapsedBackgroundColor: AppColors.backgroundWhite,
  //               title: Row(
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.all(5),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(6),
  //                       color: AppColors.backgroundPurple.withAlpha(50),
  //                       border: Border.all(color: AppColors.backgroundPurple.withAlpha(50), width: 0.01),
  //                     ),
  //
  //                     child: Flexible(
  //                       child: Text(" ${index + 1} .${controller.impressionAndPlanListFullNote[index].title}" ?? "", style: AppFonts.medium(18, AppColors.textPurple)),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               children: <Widget>[
  //                 HtmlEditorViewWidget(
  //                   heightOfTheEditableView: 500,
  //                   isBorder: true,
  //                   padding: const EdgeInsets.only(left: 10, right: 10),
  //                   impresionAndPlanViewModel: controller.impressionAndPlanListFullNote[index],
  //                   index: index + 1,
  //                   onUpdateCallBack: (impressionModel, content) {
  //                     impressionModel.htmlContent = content;
  //
  //                     controller.impressionAndPlanListFullNote[index] = impressionModel;
  //                     controller.impressionAndPlanListFullNote.refresh();
  //
  //                     controller.updateImpressionAndPlanFullNote();
  //                   },
  //                   toggleCallBack: (impressionModel) {
  //                     controller.resetImpressionAndPlanList();
  //                     impressionModel.isEditing = true;
  //
  //                     controller.impressionAndPlanListFullNote[index] = impressionModel;
  //                     controller.impressionAndPlanListFullNote.refresh();
  //                     controller.impressionAndPlanListFullNote[index].htmlEditorController.setFocus();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   });
  // }
  Widget _taskListSection() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ReorderableListView(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = controller.impressionAndPlanListFullNote.removeAt(oldIndex);
            controller.impressionAndPlanListFullNote.insert(newIndex, item);
            controller.impressionAndPlanListFullNote.refresh();
          },
          children: List.generate(controller.impressionAndPlanListFullNote.length, (index) {
            final model = controller.impressionAndPlanListFullNote[index];
            return Padding(
              key: ValueKey(index),
              padding: EdgeInsets.only(top: 5),
              child: Theme(
                // Required for ReorderableListView
                data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  visualDensity: VisualDensity(vertical: -4),
                  tilePadding: const EdgeInsets.only(left: 0, right: 10),
                  childrenPadding: EdgeInsets.all(0),
                  collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                  shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                  backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),

                  collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                  title: Row(
                    children: [
                      SizedBox(width: 5),
                      SvgPicture.asset(ImagePath.dragAndDrop),
                      SizedBox(width: 10),
                      Flexible(child: Text("${index + 1}. ${model.title ?? ""}", style: AppFonts.medium(16, AppColors.textPurple))),
                      // Rearranging icon
                    ],
                  ),
                  children: [
                    Container(
                      color: AppColors.white,
                      child: HtmlEditorViewWidget(
                        heightOfTheEditableView: 500,
                        isBorder: true,
                        padding: const EdgeInsets.only(left: 40, right: 10),
                        impresionAndPlanViewModel: model,
                        index: index + 1,
                        onUpdateCallBack: (impressionModel, content) {
                          impressionModel.htmlContent = content;
                          controller.impressionAndPlanListFullNote[index] = impressionModel;
                          controller.impressionAndPlanListFullNote.refresh();
                          controller.updateImpressionAndPlanFullNote();
                        },
                        toggleCallBack: (impressionModel) {
                          controller.resetImpressionAndPlanList();
                          impressionModel.isEditing = true;
                          controller.impressionAndPlanListFullNote[index] = impressionModel;
                          controller.impressionAndPlanListFullNote.refresh();
                          impressionModel.htmlEditorController.setFocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
