import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/app/modules/patient_info/views/EditableViews/CommonContainer.dart';
import 'package:subqdocs/widgets/ContainerButton.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../core/common/html_editor_container.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/impresion_and_plan_view_model.dart';
import 'drop_drown_search_table.dart';
import 'inline_editing_dropdown.dart';

class ImpressionAndPlanDoctorView extends StatelessWidget {
  PatientInfoController controller = Get.find<PatientInfoController>(
    tag: Get.arguments["unique_tag"],
  );

  ImpressionAndPlanDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      title: "Impressions and Plan",
      child: _taskListSection(context),
    );
  }

  // Widget _taskListSection() {
  Widget _taskListSection(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Container(
            child: ReorderableListView(
              padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                controller.resetImpressionAndPlanList();
                if (newIndex > oldIndex) newIndex -= 1;
                final item = controller.impressionAndPlanList.removeAt(
                  oldIndex,
                );
                controller.impressionAndPlanList.insert(newIndex, item);
                controller.impressionAndPlanList.refresh();

                controller.updateImpressionAndPlan();
              },
              children: List.generate(controller.impressionAndPlanList.length, (
                index,
              ) {
                final model = controller.impressionAndPlanList[index];
                return Padding(
                  key: ValueKey(index),
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Theme(
                    // Required for ReorderableListView
                    data: ThemeData(
                      splashColor: Colors.transparent, // Remove splash color
                      highlightColor:
                          Colors.transparent, // Remove highlight color
                    ),
                    child: Container(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        enabled: false,
                        tilePadding: EdgeInsets.only(right: 20, bottom: 0),
                        visualDensity: VisualDensity(vertical: -4),
                        childrenPadding: EdgeInsets.all(0),
                        collapsedShape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppColors.backgroundPurple.withValues(
                          alpha: 0.2,
                        ),

                        showTrailingIcon: false,
                        collapsedBackgroundColor: AppColors.backgroundPurple
                            .withValues(alpha: 0.2),

                        title: Popover(
                          key: UniqueKey(),
                          context,
                          controller: model.popoverController,
                          // controller: PopoverController(),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          scrollEnabled: true,
                          hideArrow: true,
                          alignment: PopoverAlignment.leftTop,

                          applyActionWidth: false,
                          contentWidth: 500,
                          action: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 0),
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                SvgPicture.asset(ImagePath.dragAndDrop),
                                SizedBox(width: 10),
                                Expanded(
                                  child: InlineEditingDropdown(
                                    textStyle: AppFonts.medium(
                                      16,
                                      AppColors.textPurple,
                                    ),
                                    initialText:
                                        "${index + 1} ${model.title ?? "Select Icd10 Code"}",
                                    toggle: () {
                                      model.popoverController.toggle();
                                    },

                                    onSubmitted: (String) {},
                                    onChanged: (String, isApiCall) {
                                      model.title = String;

                                      if (isApiCall) {
                                        controller.updateImpressionAndPlan();
                                      }

                                      // popoverController.open();
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.impressionAndPlanList.removeAt(
                                      index,
                                    );
                                    controller.impressionAndPlanList.refresh();
                                    controller.updateImpressionAndPlan();
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                      ),
                                      child: SvgPicture.asset(
                                        ImagePath.delete_black,
                                      ),
                                    ),
                                  ),
                                ),
                                // Drag icon
                              ],
                            ),
                          ),
                          content: DiagnosisDropDrownSearchTable(
                            items:
                                (model.siblingIcd10 ?? []).map((e) {
                                  return ProcedurePossibleAlternatives(
                                    code: e.code,
                                    description: e.name,
                                    isPin: true,
                                  );
                                }).toList(),

                            onItemSelected: (value, _) {
                              print("called ");

                              controller.impressionAndPlanList[index].title =
                                  "${value.description} (${value.code})";
                              controller.impressionAndPlanList.refresh();
                              controller.updateImpressionAndPlan();
                            },
                            controller: controller,
                            onSearchItemSelected: (p0, p1) {
                              controller.impressionAndPlanList[index].title =
                                  "${p1} (${p0})";
                              controller.impressionAndPlanList.refresh();
                              controller.updateImpressionAndPlan();
                            },
                            onInitCallBack: () {},
                            tableRowIndex: -1,
                          ),
                        ),

                        children: <Widget>[
                          Container(
                            color: AppColors.white,
                            child: HtmlEditorViewWidget(
                              heightOfTheEditableView: 500,
                              isBorder: false,
                              padding: const EdgeInsets.only(
                                left: 40,
                                right: 10,
                              ),
                              impresionAndPlanViewModel: model,
                              onUpdateCallBack: (impressionModel, content) {
                                controller.impressionAndPlanList[index] =
                                    impressionModel;
                                controller.impressionAndPlanList.refresh();
                                controller.updateImpressionAndPlan();
                              },
                              toggleCallBack: (impressionModel) {
                                controller.resetImpressionAndPlanList();
                                impressionModel.isEditing = true;
                                controller.impressionAndPlanList[index] =
                                    impressionModel;
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ContainerButton(
              backgroundColor: AppColors.white,
              textColor: AppColors.black,
              borderColor: AppColors.appbarBorder,
              onPressed: () {
                controller.impressionAndPlanList.add(
                  ImpresionAndPlanViewModel(
                    htmlEditorController: HtmlEditorController(),
                    siblingIcd10: [],
                    htmlContent: "<br> <br>",
                    isEditing: false,
                    siblingIcd10FullNote: [],
                    title: null,
                  ),
                );
                controller.impressionAndPlanList.refresh();
              },
              text: " + Add Section ",
            ),
          ),
        ],
      );
    });
  }
}
