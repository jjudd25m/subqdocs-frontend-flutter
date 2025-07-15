import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../../modules/patient_info/model/patient_fullnote_model.dart';
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
                for (var item in controller.impressionAndPlanListFullNote) {
                  item.slidableController?.close();
                  item.isOpened?.value = false;
                }

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
                        motion: const ScrollMotion(),
                        extentRatio: 0.11,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.2)), color: AppColors.backgroundPurple.withValues(alpha: 0.1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                GestureDetector(
                                  // onTap: () {
                                  //   controller.resetImpressionAndPlanList();
                                  //   model.popoverController.toggle();
                                  // },
                                  child: SvgPicture.asset(ImagePath.dragAndDrop),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    controller.impressionAndPlanListFullNote.insert(index + 1, ImpresionAndPlanViewModel(htmlEditorController: HtmlEditorController(), siblingIcd10: [], htmlContent: null, isEditing: false, siblingIcd10FullNote: [], title: null, attachments: []));
                                    controller.impressionAndPlanListFullNote.refresh();
                                    // controller.addImpressionPlanItems(index);
                                  },
                                  child: SvgPicture.asset(ImagePath.plus),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: Get.context!,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text("Alert"),
                                            content: const Text("Are you sure you want to delete this Impression and Plan?"),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
                                              TextButton(
                                                onPressed: () {
                                                  controller.impressionAndPlanListFullNote.removeAt(index);
                                                  controller.impressionAndPlanListFullNote.refresh();
                                                  controller.updateImpressionAndPlanFullNote();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  child: SvgPicture.asset(ImagePath.trash, colorFilter: const ColorFilter.mode(AppColors.textPurple, BlendMode.srcIn), fit: BoxFit.cover),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: Builder(
                        builder: (context) {
                          const _openThreshold = 0.03;
                          model.slidableController?.animation.addListener(() {
                            if (model.slidableController?.animation.status == AnimationStatus.dismissed) {
                              model.isOpened?.value = false;
                              return;
                            }

                            final rawValue = model.slidableController?.animation.value ?? 0;
                            final isOpen = rawValue > _openThreshold; // Explicit boolean conversion
                            customPrint("message:SlidableState raw $rawValue: isOpen $isOpen");

                            if (isOpen != model.isOpened?.value) {
                              customPrint("message:SlidableState isOpen $isOpen: isOpen ${model.isOpened?.value}");
                              model.isOpened?.value = isOpen; // No need for cast, isOpen is already bool
                              controller.impressionAndPlanListFullNote.refresh();
                            }
                            customPrint("message:SlidableState  ${model.isOpened?.value}");
                          });
                          return GestureDetector(
                            onTap: () {
                              model.slidableController?.openStartActionPane();
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: model.isOpened?.value ?? false ? MediaQuery.of(context).size.width * 0.82 : MediaQuery.of(context).size.width),
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
                                        // model.popoverController.toggle();
                                        // model.slidableController?.openStartActionPane();
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
                                          InkResponse(
                                            radius: 20, // Large touch radius
                                            onTap: () {
                                              controller.resetImpressionAndPlanList();
                                              model.popoverController.toggle();
                                              model.slidableController?.openStartActionPane();
                                            },
                                            child: Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0), child: const Icon(Icons.arrow_drop_down_sharp, size: 40)),
                                          ),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
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
                                        const SizedBox(height: 10),
                                        Padding(padding: const EdgeInsets.only(left: 15, right: 10), child: Text("Add Attachments", style: AppFonts.medium(14, Colors.black))),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, right: 10),
                                          child: DragTarget<Map<String, dynamic>>(
                                            onWillAcceptWithDetails: (data) {
                                              // Always accept from General Images (where isGeneral = true)
                                              if (data.data['isGeneral'] == true) return true;
                                              // For other cases, maintain original logic
                                              return data.data['fromListIndex'] != index;
                                            },
                                            onAcceptWithDetails: (details) {
                                              final attachment = details.data['attachment'];
                                              final fromListIndex = details.data['fromListIndex'];
                                              final fromImageIndex = details.data['fromImageIndex'];
                                              final isGeneral = details.data['isGeneral'] ?? false;
                                              final toListIndex = index;
                                              if (controller.impressionAndPlanListFullNote[toListIndex].attachments == null) {
                                                controller.impressionAndPlanListFullNote[toListIndex].attachments = [];
                                              }
                                              final targetList = controller.impressionAndPlanListFullNote[toListIndex].attachments!;
                                              final dropIndex = _getDropIndex(context, details.offset, targetList);
                                              // if (isGeneral) {
                                              //   // Coming from general images
                                              //   final dropIndex = _getDropIndex(context, details.offset, targetList);
                                              //   targetList.insert(dropIndex, attachment);
                                              //   controller.generalAttachments.removeAt(fromImageIndex);
                                              // } else {
                                              //   if (targetList.isEmpty) {
                                              //     targetList.add(attachment);
                                              //   } else {
                                              //     // final dropIndex = _getDropIndex(context, details.offset, targetList);
                                              //     targetList.insert(dropIndex, attachment);
                                              //   }
                                              //   controller.impressionAndPlanListFullNote[fromListIndex].attachments?.removeAt(fromImageIndex);
                                              // }
                                              if (isGeneral) {
                                                // From General Images → Expansion Tile
                                                targetList.insert(dropIndex, attachment);
                                                controller.generalAttachments.removeAt(fromImageIndex);
                                              } else {
                                                // From Expansion Tile → Expansion Tile
                                                targetList.insert(dropIndex, attachment);
                                                controller.impressionAndPlanListFullNote[fromListIndex].attachments?.removeAt(fromImageIndex);
                                              }

                                              controller.impressionAndPlanListFullNote.refresh();
                                              controller.generalAttachments.refresh();
                                              controller.isFullNoteAttachment.value = true;
                                              controller.updateImpressionAndPlanFullNote();
                                            },
                                            builder: (context, candidateData, rejectedData) {
                                              if (model.attachments == null || model.attachments!.isEmpty) {
                                                return const SizedBox(width: double.infinity, height: 100, child: Center(child: Text("No Attachments")));
                                              }
                                              return Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(top: 10),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                child: Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: List.generate(model.attachments?.length ?? 0, (imageIndex) {
                                                    return LongPressDraggable<Map<String, dynamic>>(
                                                      hitTestBehavior: HitTestBehavior.translucent,
                                                      onDraggableCanceled: (velocity, offset) {
                                                        controller.impressionAndPlanListFullNote.refresh();
                                                        controller.generalAttachments.refresh();
                                                        controller.updateImpressionAndPlanFullNote();
                                                      },
                                                      onDragEnd: (details) {
                                                        controller.impressionAndPlanListFullNote.refresh();
                                                        controller.generalAttachments.refresh();
                                                      },
                                                      data: {'attachment': model.attachments?[imageIndex], 'fromListIndex': index, 'fromImageIndex': imageIndex, 'isGeneral': false},
                                                      feedback: Material(elevation: 4.0, child: _imageContainer(model.attachments?[imageIndex] ?? Attachments(), context, imageIndex, index, false, dragging: true)),
                                                      childWhenDragging: Opacity(opacity: 0.3, child: _imageContainer(model.attachments?[imageIndex] ?? Attachments(), context, imageIndex, index, false)),
                                                      child: DragTarget<Map<String, dynamic>>(
                                                        onWillAcceptWithDetails: (data) => true,
                                                        onAcceptWithDetails: (details) {
                                                          final draggedImage = details.data['attachment'];
                                                          final fromListIndex = details.data['fromListIndex'];
                                                          final fromImageIndex = details.data['fromImageIndex'];
                                                          final isGeneral = details.data['isGeneral'] ?? false;
                                                          int insertIndex = imageIndex;
                                                          final dropIndex = _getDropIndex(context, details.offset, model.attachments ?? []);
                                                          if (isGeneral) {
                                                            // Coming from general images
                                                            if (model.attachments == null) {
                                                              model.attachments = [];
                                                            }
                                                            model.attachments!.insert(insertIndex, draggedImage);
                                                            controller.generalAttachments.removeAt(fromImageIndex);
                                                          } else if (fromListIndex == index) {
                                                            if (fromImageIndex < imageIndex) {
                                                              insertIndex -= 1;
                                                            }
                                                            final attachments = List<Attachments?>.from(model.attachments ?? []);
                                                            attachments.removeAt(fromImageIndex);
                                                            attachments.insert(insertIndex, draggedImage);
                                                            model.attachments = attachments.cast<Attachments>();
                                                          } else {
                                                            controller.impressionAndPlanListFullNote[index].attachments?.insert(insertIndex, draggedImage);
                                                            controller.impressionAndPlanListFullNote[fromListIndex].attachments?.removeAt(fromImageIndex);
                                                          }
                                                          controller.impressionAndPlanListFullNote.refresh();
                                                          controller.generalAttachments.refresh();
                                                          controller.isFullNoteAttachment.value = true;
                                                          controller.updateImpressionAndPlanFullNote();
                                                        },
                                                        builder: (context, candidateData, rejectedData) {
                                                          return _imageContainer(model.attachments?[imageIndex] ?? Attachments(), context, imageIndex, index, false);
                                                        },
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (controller.impressionAndPlanListFullNote.length - 1 == index) ...[
                                    const SizedBox(height: 10),
                                    Divider(height: 1, color: AppColors.textGrey.withValues(alpha: 0.2)),
                                    const SizedBox(height: 16),
                                    Padding(padding: const EdgeInsets.only(left: 15, right: 10), child: Align(alignment: Alignment.topLeft, child: Text("General Images", style: AppFonts.medium(14, AppColors.black)))),
                                    const SizedBox(height: 8),
                                    DragTarget<Map<String, dynamic>>(
                                      onWillAcceptWithDetails: (data) => true,
                                      onAcceptWithDetails: (details) {
                                        final attachment = details.data['attachment'];
                                        final fromListIndex = details.data['fromListIndex'];
                                        final fromImageIndex = details.data['fromImageIndex'];
                                        final isGeneral = details.data['isGeneral'] ?? false;

                                        final dropIndex = _getDropIndex(context, details.offset, controller.generalAttachments);

                                        if (isGeneral) {
                                          // Reordering within general images

                                          controller.generalAttachments.removeAt(fromImageIndex);
                                          controller.generalAttachments.insert(dropIndex, attachment);
                                        } else {
                                          // Coming from expansion tile attachments
                                          controller.generalAttachments.insert(dropIndex, attachment);
                                          controller.impressionAndPlanListFullNote[fromListIndex].attachments?.removeAt(fromImageIndex);
                                        }

                                        controller.impressionAndPlanListFullNote.refresh();
                                        controller.generalAttachments.refresh();
                                        controller.isFullNoteAttachment.value = true;
                                        controller.updateImpressionAndPlanFullNote();
                                      },
                                      builder: (context, candidateData, rejectedData) {
                                        if (controller.generalAttachments.isEmpty) {
                                          return const SizedBox(width: double.infinity, height: 100, child: Center(child: Text("Drag attachments here")));
                                        }
                                        return Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                          padding: const EdgeInsets.only(left: 15, right: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: List.generate(controller.generalAttachments.length, (imageIndex) {
                                                  return LongPressDraggable<Map<String, dynamic>>(
                                                    hitTestBehavior: HitTestBehavior.translucent,
                                                    onDraggableCanceled: (velocity, offset) {
                                                      controller.impressionAndPlanListFullNote.refresh();
                                                      controller.generalAttachments.refresh();
                                                      controller.updateImpressionAndPlanFullNote();
                                                    },
                                                    onDragEnd: (details) {
                                                      controller.impressionAndPlanListFullNote.refresh();
                                                      controller.generalAttachments.refresh();
                                                    },
                                                    data: {
                                                      'attachment': controller.generalAttachments[imageIndex],
                                                      'fromListIndex': index,
                                                      'fromImageIndex': imageIndex,
                                                      'isGeneral': true, // Mark as from general container
                                                    },
                                                    feedback: Material(elevation: 4.0, child: _imageContainer(controller.generalAttachments[imageIndex], context, imageIndex, index, true, dragging: true)),
                                                    childWhenDragging: Opacity(opacity: 0.3, child: _imageContainer(controller.generalAttachments[imageIndex], context, imageIndex, index, true)),
                                                    child: DragTarget<Map<String, dynamic>>(
                                                      onWillAcceptWithDetails: (data) => true,
                                                      onAcceptWithDetails: (details) {
                                                        final draggedImage = details.data['attachment'];
                                                        final fromImageIndex = details.data['fromImageIndex'];
                                                        final isGeneral = details.data['isGeneral'] ?? false;
                                                        final fromListIndex = details.data['fromListIndex'];

                                                        final dropIndex = _getDropIndex(context, details.offset, controller.generalAttachments);
                                                        int insertIndex = imageIndex;
                                                        if (isGeneral) {
                                                          // Reordering within general images
                                                          if (fromImageIndex < imageIndex) {
                                                            insertIndex -= 1;
                                                          }
                                                          controller.generalAttachments.removeAt(fromImageIndex);
                                                          controller.generalAttachments.insert(insertIndex, draggedImage);
                                                        } else {
                                                          // Coming from expansion tile
                                                          controller.generalAttachments.insert(insertIndex, draggedImage);
                                                          controller.impressionAndPlanListFullNote[fromListIndex].attachments?.removeAt(fromImageIndex);
                                                        }

                                                        controller.impressionAndPlanListFullNote.refresh();
                                                        controller.generalAttachments.refresh();
                                                        controller.isFullNoteAttachment.value = true;
                                                        controller.updateImpressionAndPlanFullNote();
                                                      },
                                                      builder: (context, candidateData, rejectedData) {
                                                        return _imageContainer(controller.generalAttachments[imageIndex], context, imageIndex, index, true);
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
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

  Widget _imageContainer(Attachments attachment, BuildContext context, int imageIndex, int listIndex, bool isGeneral, {bool dragging = false}) {
    const double cardSize = 160.0; // Fixed card and image size as in impression_and_plan.dart
    return Container(
      width: (context.width / 2) - 50,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 16, offset: const Offset(0, 6))], border: Border.all(color: Colors.grey.shade200, width: 1)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 3.0, bottom: 3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InlineEditingDropdown(
                    focusNode: attachment.focusNode,
                    textStyle: AppFonts.medium(16, AppColors.textPurple),
                    initialText: "${attachment.fileName?.split(".").first}",
                    toggle: () {},
                    maxLines: 1,
                    onSubmitted: (_) {},
                    onChanged: (title, isApiCall) {
                      attachment.fileName = title;
                      if (isApiCall) {
                        controller.updateImpressionAndPlanFullNoteAttachmentName(title, attachment.id);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    if (isGeneral) {
                      controller.generalAttachments.removeAt(imageIndex);
                    } else {
                      controller.impressionAndPlanListFullNote[listIndex].attachments?.removeAt(imageIndex);
                    }
                    controller.impressionAndPlanListFullNote.refresh();
                    controller.generalAttachments.refresh();
                    controller.isFullNoteAttachment.value = false;
                    controller.updateImpressionAndPlanFullNote();
                  },
                  child: Container(decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.0)), child: SvgPicture.asset(ImagePath.delete_black, height: 40, width: 50)),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            child: Container(
              width: (context.width / 2) - 50,
              height: cardSize - 20,
              color: Colors.grey[100],
              child: CachedNetworkImage(
                width: cardSize,
                height: cardSize - 20,
                imageUrl: attachment.filePath ?? "",
                errorWidget: (context, url, error) {
                  return Image.asset(ImagePath.file_placeHolder, width: cardSize, height: cardSize, fit: BoxFit.cover);
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getDropIndex(BuildContext context, Offset dropOffset, List<Attachments?> attachments) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(dropOffset);

    // Your item dimensions and spacing (adjust these to match your actual values)
    const itemWidth = 200.0;
    const itemHeight = 200.0;
    const spacing = 8.0;

    // Calculate which column and row the drop occurred in
    final col = (localPosition.dx / (itemWidth + spacing)).floor();
    final row = (localPosition.dy / (itemHeight + spacing)).floor();

    // Calculate how many items fit in a row
    final itemsPerRow = (renderBox.size.width / (itemWidth + spacing)).floor();

    // Calculate the index
    int calculatedIndex = row * itemsPerRow + col;

    // Ensure the index is within bounds
    return calculatedIndex.clamp(0, attachments.length);
  }
}
