import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:subqdocs/app/mobile_modules/patient_info_mobile_view/controllers/patient_info_mobile_view_controller.dart';
import 'package:subqdocs/app/mobile_modules/patient_info_mobile_view/widget/diagnosis_dropDrown_search_table_mobile_view.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_fonts.dart';
import '../../../../core/common/html_editor_container.dart';
import '../../../../core/common/logger.dart';
import '../../../../core/common/mobile_html_note_item.dart';
import '../../../../modules/patient_info/model/impresion_and_plan_view_model.dart';
import '../../../../modules/patient_info/views/full_note_view.dart';
import '../../../../modules/patient_info/views/inline_editing_dropdown.dart';
import '../../../../modules/visit_main/model/doctor_view_model.dart';

class ImpressionAndPlanMobileView extends StatelessWidget {
  // PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  PatientInfoMobileViewController controller;

  ImpressionAndPlanMobileView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FullNoteCommonContainer(title: "Impressions and Plan", child: (controller.patientFullNoteModel.value?.responseData?.fullNoteDetails?.impressionsAndPlan == null) ? const ImpressionPlanSkeleton() : _taskListSection(context));
  }

  Widget _taskListSection(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ReorderableListView(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                controller.resetImpressionAndPlanList();
                if (newIndex > oldIndex) newIndex -= 1;
                final item = controller.impressionAndPlanListFullNote.removeAt(oldIndex);
                controller.impressionAndPlanListFullNote.insert(newIndex, item);
                controller.impressionAndPlanListFullNote.refresh();
                controller.updateImpressionAndPlanFullNote();
              },
              children: List.generate(controller.impressionAndPlanListFullNote.length, (index) {
                final model = controller.impressionAndPlanListFullNote[index];
                return Padding(
                  key: ValueKey(index),
                  padding: const EdgeInsets.only(top: 5),
                  child: Theme(
                    // Required for ReorderableListView
                    data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                    child: Slidable(
                      key: ValueKey(model),
                      controller: model.slidableController,
                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.11,
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
                                    controller.impressionAndPlanListFullNote.insert(index + 1, ImpresionAndPlanViewModel(htmlEditorController: HtmlEditorController(), siblingIcd10: [], htmlContent: null, isEditing: false, siblingIcd10FullNote: [], title: null));
                                    controller.impressionAndPlanListFullNote.refresh();
                                    // controller.addImpressionPlanItems(index);
                                  },
                                  child: SvgPicture.asset(ImagePath.plus),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    controller.impressionAndPlanListFullNote.removeAt(index);
                                    controller.impressionAndPlanListFullNote.refresh();
                                    controller.updateImpressionAndPlanFullNote();
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
                          enabled: false,
                          initiallyExpanded: true,
                          visualDensity: const VisualDensity(vertical: -4),
                          tilePadding: const EdgeInsets.only(left: 0, right: 0),
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
                            contentWidth: 350,
                            action: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 0),
                              child: GestureDetector(
                                onTap: () {
                                  controller.resetImpressionAndPlanList();
                                  model.popoverController.toggle();
                                  model.slidableController?.openStartActionPane();
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),

                                    // SvgPicture.asset(ImagePath.dragAndDrop),
                                    // const SizedBox(width: 5),
                                    Expanded(
                                      key: model.diagnosisContainerKey,
                                      child: GestureDetector(
                                        child: InlineEditingDropdown(
                                          width: double.maxFinite,
                                          focusNode: model.focusNode,
                                          key: ValueKey(model.popoverController),
                                          maxLines: null,
                                          textStyle: AppFonts.medium(16, AppColors.textPurple),
                                          initialText: "${index + 1} ${model.title ?? "Select Icd10 Code"}",
                                          toggle: () {},
                                          onSubmitted: (_) {},
                                          onChanged: (title, isApiCall) {
                                            model.title = title;
                                            if (isApiCall) {
                                              controller.updateImpressionAndPlanFullNote();
                                            }
                                          },
                                          onTap: () {
                                            model.slidableController?.openStartActionPane();
                                          },
                                        ),
                                      ),
                                    ),
                                    // Container(),
                                    // Spacer(),
                                    const Icon(Icons.arrow_drop_down_sharp, size: 40),
                                    //
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     controller.impressionAndPlanListFullNote.removeAt(index);
                                    //     controller.impressionAndPlanListFullNote.refresh();
                                    //     controller.updateImpressionAndPlanFullNote();
                                    //   },
                                    //   child: Container(child: Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: SvgPicture.asset(ImagePath.delete_black))),
                                    // ),
                                    // Drag icon
                                  ],
                                ),
                              ),
                            ),
                            content: DiagnosisDropdrownSearchTableMobileView(
                              diagnosisContainerKey: model.diagnosisContainerKey,
                              items:
                                  (model.siblingIcd10FullNote ?? []).map((e) {
                                    return ProcedurePossibleAlternatives(code: e.code, description: e.name, isPin: true);
                                  }).toList(),

                              onItemSelected: (value, _) {
                                customPrint("called ");
                                model.popoverController.close();
                                controller.impressionAndPlanListFullNote[index].title = "${value.description} (${value.code})";
                                controller.impressionAndPlanListFullNote.refresh();
                                controller.updateImpressionAndPlanFullNote();
                              },
                              controller: controller,
                              onSearchItemSelected: (p0, p1) {
                                model.popoverController.close();
                                controller.impressionAndPlanListFullNote[index].title = "$p1 ($p0)";
                                controller.impressionAndPlanListFullNote.refresh();
                                controller.updateImpressionAndPlanFullNote();
                              },
                              onInitCallBack: () {},
                              tableRowIndex: -1,
                            ),
                          ),
                          children: [
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
                                  padding: const EdgeInsets.only(left: 15, right: 10),
                                  impresionAndPlanViewModel: model,
                                  index: index + 1,
                                  onUpdateCallBack: (impressionModel, content) {
                                    impressionModel.htmlContent = content;
                                    controller.impressionAndPlanListFullNote[index] = impressionModel;
                                    controller.impressionAndPlanListFullNote.refresh();
                                    controller.updateImpressionAndPlanFullNote();
                                  },
                                  toggleCallBack: (impressionModel) {
                                    controller.closeAllProcedureDiagnosisPopover();
                                    controller.resetImpressionAndPlanList();
                                    impressionModel.isEditing = true;
                                    controller.impressionAndPlanListFullNote[index] = impressionModel;
                                    controller.impressionAndPlanListFullNote.refresh();
                                    impressionModel.htmlEditorController.setFocus();
                                  },
                                ),
                              ),
                            ),
                          ],
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
          //       controller.impressionAndPlanListFullNote.add(ImpresionAndPlanViewModel(htmlEditorController: HtmlEditorController(), siblingIcd10: [], htmlContent: null, isEditing: false, siblingIcd10FullNote: [], title: null));
          //       controller.impressionAndPlanListFullNote.refresh();
          //     },
          //     text: "+ Add Section ",
          //   ),
          // ),
        ],
      );
    });
  }
}
