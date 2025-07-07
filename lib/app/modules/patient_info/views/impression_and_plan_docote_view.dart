import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/app/modules/patient_info/views/EditableViews/CommonContainer.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../core/common/html_editor_container.dart';
import '../../../core/common/logger.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/impresion_and_plan_view_model.dart';
import 'full_note_view.dart';
import 'icd_procedure_popover/diagnosis_drop_drown_search_table.dart';
import 'inline_editing_dropdown.dart';

class ImpressionAndPlanDoctorView extends StatelessWidget {
  PatientInfoController controller;

  ImpressionAndPlanDoctorView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CommonContainer(title: "Impressions and Plan", child: (controller.doctorViewList.value?.responseData?.impressionsAndPlan == null) ? const ImpressionPlanSkeleton() : _taskListSection(context));
    });
  }

  //
  // Widget _taskListSection() {
  Widget _taskListSection(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Container(
            child: ReorderableListView(
              padding: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                controller.resetImpressionAndPlanList();
                if (newIndex > oldIndex) newIndex -= 1;
                final item = controller.impressionAndPlanList.removeAt(oldIndex);
                controller.impressionAndPlanList.insert(newIndex, item);
                controller.impressionAndPlanList.refresh();

                controller.updateImpressionAndPlan();
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
                      child: Slidable(
                        key: ValueKey(model),
                        controller: model.slidableController,
                        startActionPane: ActionPane(
                          motion: ScrollMotion(),
                          extentRatio: 0.06,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.2)), color: AppColors.backgroundPurple.withValues(alpha: 0.1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    // onTap: () {
                                    //   controller.resetImpressionAndPlanList();
                                    //   model.popoverController.toggle();
                                    // },
                                    child: SvgPicture.asset(ImagePath.dragAndDrop),
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      controller.impressionAndPlanList.insert(index + 1, ImpresionAndPlanViewModel(htmlEditorController: HtmlEditorController(), siblingIcd10: [], htmlContent: null, isEditing: false, siblingIcd10FullNote: [], title: null));
                                      controller.impressionAndPlanList.refresh();
                                    },
                                    child: SvgPicture.asset(ImagePath.plus),
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      controller.impressionAndPlanList.removeAt(index);
                                      controller.impressionAndPlanList.refresh();
                                      controller.updateImpressionAndPlan();
                                    },
                                    child: SvgPicture.asset(ImagePath.trash, colorFilter: ColorFilter.mode(AppColors.textPurple, BlendMode.srcIn), fit: BoxFit.cover),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            model.slidableController?.openStartActionPane();
                          },
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            enabled: false,
                            tilePadding: const EdgeInsets.only(right: 20, bottom: 0),
                            visualDensity: const VisualDensity(vertical: -4),
                            childrenPadding: const EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide(color: AppColors.textGrey.withValues(alpha: 0.2)), borderRadius: BorderRadius.circular(8)),
                            // backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                            showTrailingIcon: false,
                            collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                            title: Popover(
                              key: ValueKey(model.popoverController),
                              // key: UniqueKey(),
                              context,
                              controller: model.popoverController,
                              // controller: PopoverController(),
                              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                              scrollEnabled: true,
                              hideArrow: true,
                              alignment: PopoverAlignment.leftTop,

                              applyActionWidth: false,
                              contentWidth: 500,
                              action: GestureDetector(
                                onTap: () {
                                  controller.resetImpressionAndPlanList();
                                  model.popoverController.toggle();
                                  model.slidableController?.openStartActionPane();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 0),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      // SvgPicture.asset(ImagePath.dragAndDrop),
                                      // const SizedBox(width: 10),
                                      Expanded(
                                        child: IntrinsicWidth(
                                          key: model.diagnosisContainerKey,
                                          child: InlineEditingDropdown(
                                            width: 500,
                                            key: ValueKey(model.popoverController),
                                            focusNode: model.focusNode,
                                            textStyle: AppFonts.medium(16, AppColors.textPurple),
                                            initialText: "${index + 1} ${model.title ?? "Select Icd10 Code"}",
                                            toggle: () async {
                                              // controller
                                              //     .closeAllProcedureDiagnosisPopover();
                                              //
                                              // // controller.impressionAndPlanList.forEach((element) {
                                              // //   element.popoverController.close();
                                              // // });
                                              // controller.resetImpressionAndPlanList();
                                              //
                                              // Future.delayed(
                                              //   Duration(milliseconds: 200),
                                              // ).then((value) {
                                              //   model.popoverController.toggle();
                                              // });
                                            },
                                            onTap: () {
                                              model.slidableController?.openStartActionPane();
                                            },
                                            onSubmitted: (_) {},
                                            onChanged: (title, isApiCall) {
                                              model.title = title;

                                              if (isApiCall) {
                                                controller.updateImpressionAndPlan();
                                              }

                                              // popoverController.open();
                                            },
                                          ),
                                        ),
                                      ),
                                      // const Spacer(),
                                      // Container(),
                                      const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.only(right: 0), child: Icon(Icons.arrow_drop_down_sharp, size: 40))),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     controller.impressionAndPlanList.removeAt(index);
                                      //     controller.impressionAndPlanList.refresh();
                                      //     controller.updateImpressionAndPlan();
                                      //   },
                                      //   child: Container(child: Padding(padding: const EdgeInsets.only(left: 20, right: 5), child: SvgPicture.asset(ImagePath.delete_black))),
                                      // ),
                                      // Drag icon
                                    ],
                                  ),
                                ),
                              ),
                              content: DiagnosisDropDrownSearchTable(
                                key: ValueKey(model.popoverController),
                                diagnosisContainerKey: model.diagnosisContainerKey,
                                items:
                                    (model.siblingIcd10 ?? []).map((e) {
                                      return ProcedurePossibleAlternatives(code: e.code, description: e.name, isPin: true);
                                    }).toList(),

                                onItemSelected: (value, _) {
                                  model.popoverController.close();
                                  customPrint("called ");

                                  controller.impressionAndPlanList[index].title = "${value.description} (${value.code})";
                                  controller.impressionAndPlanList.refresh();
                                  controller.updateImpressionAndPlan();
                                },
                                controller: controller,
                                onSearchItemSelected: (p0, p1) {
                                  model.popoverController.close();
                                  controller.impressionAndPlanList[index].title = "$p1 ($p0)";
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
                                child: GestureDetector(
                                  onTap: () {
                                    model.slidableController?.openStartActionPane();
                                    // Slidable.of(context)?.openStartActionPane();
                                  },
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
                                      controller.closeAllProcedureDiagnosisPopover();
                                      controller.resetImpressionAndPlanList();
                                      impressionModel.isEditing = true;
                                      controller.impressionAndPlanList[index] = impressionModel;
                                      controller.impressionAndPlanList.refresh();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //   child: ContainerButton(
          //     backgroundColor: AppColors.white,
          //     textColor: AppColors.black,
          //     borderColor: AppColors.appbarBorder,
          //     onPressed: () {
          //       controller.impressionAndPlanList.add(ImpresionAndPlanViewModel(htmlEditorController: HtmlEditorController(), siblingIcd10: [], htmlContent: null, isEditing: false, siblingIcd10FullNote: [], title: null));
          //       controller.impressionAndPlanList.refresh();
          //     },
          //     text: " + Add Section ",
          //   ),
          // ),
        ],
      );
    });
  }
}
