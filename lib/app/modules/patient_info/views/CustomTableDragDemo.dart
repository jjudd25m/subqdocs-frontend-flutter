import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/diagnosis_model.dart';
import 'InlineEditableText.dart';
import 'icd_procedure_popover/diagnosis_drop_drown_search_table.dart';
import 'icd_procedure_popover/drop_drown_search_table.dart';
import 'icd_procedure_popover/modifier_drop_down_search_table.dart';

class DiagnosisDragData {
  final DiagnosisModel diagnosis;
  final int fromRow;
  final int fromCol;
  final int fromItemIndex;
  final int fromSubIndex;

  DiagnosisDragData({required this.diagnosis, required this.fromRow, required this.fromCol, required this.fromItemIndex, required this.fromSubIndex});
}

class NestedDraggableTable extends StatefulWidget {
  PatientInfoController controller;
  TableModel tableModel;
  TableModel possibleDignosisProcedureTableModel;
  RxInt totalUnitCharge = RxInt(0);
  final Function(List<Map<String, dynamic>>, List<Map<String, dynamic>>) updateResponse;

  bool isPossibleAlternativeShow = false;

  NestedDraggableTable({super.key, required this.controller, required this.tableModel, required this.possibleDignosisProcedureTableModel, required this.updateResponse});

  @override
  NestedDraggableTableState createState() => NestedDraggableTableState();
}

class NestedDraggableTableState extends State<NestedDraggableTable> {
  final GlobalController globalController = Get.find();
  int? draggedRowIndex;
  int? draggedColumnIndex;
  int? draggedDiagnosisIndex;

  bool isDragging = false;

  NestedDraggableTableState();

  @override
  void initState() {
    super.initState();

    print("loader response:- ${widget.controller.isDoctorViewLoading.value || widget.controller.doctorViewList.value?.responseData == null}");

    customPrint("tableModel is ${widget.tableModel.rows.length}");
    customPrint("possibleDignosisProcedureTableModel is ${widget.possibleDignosisProcedureTableModel.rows.length}");
    calculateTotalOnly();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NestedDraggableTable oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    print("NestedDraggableTable updated");
    print("loader status:- ${(widget.controller.isDoctorViewLoading.value || widget.controller.doctorViewList.value?.responseData == null)}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(child: SingleChildScrollView(child: Column(children: [...List.generate(widget.tableModel.rows.length, _buildRow), _buildNewProcedureAlternative()]))),
        ],
      ),
    );
  }

  // A widget that builds a row with drag-and-drop functionality
  Widget _buildRow(int rowIndex) {
    return Obx(() {
      globalController.selectedRowIndex.value;
      return Skeletonizer(
        enabled: (widget.controller.isDoctorViewLoading.value || widget.controller.doctorViewList.value?.responseData == null),
        child: GestureDetector(
          onTap: () => globalController.selectedRowIndex.value = rowIndex,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // DragTarget widget to allow other widgets to drag and drop
              DragTarget<int>(
                onWillAccept: (data) => data != rowIndex,
                onAccept: (fromRow) {
                  customPrint("_buildRow onAccept");
                  customPrint("from row :- $fromRow");
                  customPrint("to row :- $rowIndex");

                  setState(() {
                    _swapRows(fromRow, rowIndex);
                  });

                  Future.delayed(const Duration(milliseconds: 500), () {
                    calculateTotal();
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  // Gesture detector to select the row when tapped
                  return GestureDetector(
                    onTap: () {
                      globalController.selectedRowIndex.value = rowIndex;
                    },
                    child: _buildRowContent(rowIndex, false), // Content of the row (define elsewhere)
                  );
                },
              ),

              // Show the row selection UI only if this row is selected
              globalController.selectedRowIndex.value == rowIndex
                  ? Positioned(
                    left: -10, // Position the selected UI a bit outside the row
                    top: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.transparent, // Transparent background
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the actions
                        children: [
                          // Draggable widget that allows the row to be dragged
                          LongPressDraggable<int>(
                            data: rowIndex,
                            onDragStarted: () {
                              customPrint("close popover start while drag");
                              closeAllPopOver();
                            },
                            onDraggableCanceled: (velocity, offset) {
                              customPrint("onDraggableCanceled $rowIndex");

                              widget.tableModel.rows[rowIndex].popoverController = PopoverController();
                              for (TableCellModel tcm in widget.tableModel.rows[rowIndex].cells) {
                                for (SingleCellModel scm in tcm.items) {
                                  for (DiagnosisModel dm in scm.diagnosisModelList ?? []) {
                                    dm.popoverController = PopoverController();
                                  }
                                }
                              }
                              globalController.selectedRowIndex.refresh();
                            },
                            feedback: Material(color: AppColors.white, child: Opacity(opacity: 1, child: Container(width: MediaQuery.of(context).size.width - 50, child: _buildRowContent(rowIndex, true)))),
                            child: Container(margin: const EdgeInsets.all(5.0), decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))]), child: SvgPicture.asset(ImagePath.drag_button, height: 35, width: 35)),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () async {
                              globalController.selectedRowIndex.value = -1;

                              List<DiagnosisModel>? diagnosisModelList = [];

                              TableRowModel tempdata = TableRowModel(cells: widget.tableModel.rows[rowIndex].cells);

                              widget.tableModel.rows.removeAt(rowIndex);

                              if (tempdata.cells[0].items[0].code != "0") {
                                customPrint("sgfgdfgdfg");
                                for (DiagnosisModel diagnosisModel in tempdata.cells[1].items[0].diagnosisModelList ?? []) {
                                  if (diagnosisModel.popoverController.opened) {
                                    diagnosisModel.popoverController.close();
                                  }

                                  diagnosisModelList.add(DiagnosisModel(confidence: diagnosisModel.confidence, code: diagnosisModel.code, description: diagnosisModel.description, diagnosisPossibleAlternatives: diagnosisModel.diagnosisPossibleAlternatives));
                                }
                                widget.possibleDignosisProcedureTableModel.rows.add(
                                  TableRowModel(
                                    cells: [
                                      TableCellModel(items: [SingleCellModel(code: tempdata.cells[0].items[0].code, unit: tempdata.cells[0].items[0].unit, modifiers: tempdata.cells[0].items[0].modifiers, description: tempdata.cells[0].items[0].description ?? "", unitPrice: "0", procedurePossibleAlternatives: tempdata.cells[0].items[0].procedurePossibleAlternatives)]),
                                      TableCellModel(items: [SingleCellModel(diagnosisModelList: diagnosisModelList)]),
                                      TableCellModel(items: [SingleCellModel(unit: tempdata.cells[2].items[0].unit)]),
                                      TableCellModel(items: [SingleCellModel(unitPrice: tempdata.cells[3].items[0].unitPrice)]),
                                    ],
                                  ),
                                );
                              }
                              calculateTotal();
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
                                  // changes position of shadow
                                ],
                              ),
                              child: SvgPicture.asset(ImagePath.delete_table_icon, height: 35, width: 35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }

  // Builds the content for each row, including drag-and-drop functionality for table cells.
  Widget _buildRowContent(int rowIndex, bool isDrag) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      // Border styling for the table
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1),
      columnWidths: const {0: FractionColumnWidth(0.36), 1: FractionColumnWidth(0.54), 2: FractionColumnWidth(0.10)},
      children: [
        TableRow(
          children: List.generate(3, (colIndex) {
            return GestureDetector(
              onTap: () {
                widget.controller.closeDoctorPopOverController();
                customPrint("on build row content");
                if (colIndex == 3) {
                  closeAllPopOver();
                  TableCellModel cell = widget.tableModel.rows[rowIndex].cells[colIndex];
                  if (cell.items.isNotEmpty && !cell.items[0].focusNode.hasFocus) {
                    cell.items[0].focusNode.requestFocus();
                  }
                }

                if (colIndex == 2) {
                  closeAllPopOver();
                  TableCellModel cell = widget.tableModel.rows[rowIndex].cells[colIndex];
                  if (cell.items.isNotEmpty && !cell.items[0].unitFocusNode.hasFocus) {
                    cell.items[0].unitFocusNode.requestFocus();
                  }
                }

                if (colIndex == 1) {
                  closeAllPopOver();
                }

                globalController.selectedRowIndex.value = rowIndex;
                if (colIndex == 0) {
                  if (widget.tableModel.rows[rowIndex].popoverController.opened) {
                    customPrint(widget.tableModel.rows[rowIndex].popoverController);
                    widget.tableModel.rows[rowIndex].popoverController.close();
                  } else {}
                }
              },

              child: _buildCell(rowIndex, colIndex, isDiagnosis: colIndex == 1, isDrag: isDrag),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCell(int row, int col, {bool isDiagnosis = false, bool isDrag = false}) {
    final items = widget.tableModel.rows[row].cells[col].items;

    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minHeight: 100),
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(items.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child:
                    (col == 2)
                        ? Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            // key: UniqueKey(),
                            controller: isDrag ? null : widget.tableModel.rows[row].cells[col].items[i].unitTextfield,
                            focusNode: isDrag ? null : widget.tableModel.rows[row].cells[col].items[i].unitFocusNode,
                            initialValue: !isDrag ? null : widget.tableModel.rows[row].cells[col].items[i].unit?.toString(),
                            readOnly: isDrag,
                            autofocus: false,
                            onTap: () {
                              closeAllPopOver();
                            },
                            keyboardType: TextInputType.number,
                            // Show numeric keyboard
                            inputFormatters: [OneToNineDigitsFormatter()],
                            decoration: const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              customPrint("onchanged called for col == 2");

                              String updatedText = value;

                              setState(() {
                                widget.tableModel.rows[row].cells[col].items[i].unit = updatedText;
                                items[i].unit = updatedText;
                              });

                              calculateTotal();
                            },
                          ),
                        )
                        : (col == 3)
                        ? Container(
                          width: double.maxFinite,
                          height: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            // key: UniqueKey(),
                            controller: isDrag ? null : widget.tableModel.rows[row].cells[col].items[i].unitChargeTextfield,
                            focusNode: isDrag ? null : widget.tableModel.rows[row].cells[col].items[i].focusNode,
                            initialValue: !isDrag ? null : widget.tableModel.rows[row].cells[col].items[i].unitPrice?.toString(),
                            readOnly: isDrag,
                            autofocus: false,
                            onTap: () {
                              closeAllPopOver();
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              // First filter to digits only
                              CurrencyInputFormatter(),
                              // Then apply our custom formatter
                            ],
                            decoration: const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              String updatedText = value;

                              // If the input doesn't start with "$", prepend "$"
                              if (!updatedText.startsWith('\$')) {
                                updatedText = '\$${updatedText.replaceAll('\$', '')}'; // Remove any existing "$" and add it back
                              }

                              setState(() {
                                widget.tableModel.rows[row].cells[col].items[i].unitPrice = updatedText;
                                items[i].unitPrice = updatedText;
                              });

                              customPrint("onChanged updated unit price.. ${items[i].unitPrice}");

                              calculateTotal();
                            },
                          ),
                        )
                        : isDiagnosis
                        ? SizedBox(
                          child: DragTarget<Map<String, dynamic>>(
                            builder: (context, candidateData, rejectedData) {
                              bool isEmptyItems = items[i].diagnosisModelList?.isNotEmpty ?? false;
                              return GestureDetector(
                                onTap: () {
                                  closeAllPopOver();
                                },
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: isEmptyItems ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      if (isEmptyItems)
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(border: Border.all(color: candidateData.isNotEmpty ? Colors.transparent : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(8)),
                                          width: double.maxFinite,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(
                                              items[i].diagnosisModelList?.length ?? 0,
                                              (subIndex) => LongPressDraggable<Map<String, int>>(
                                                onDraggableCanceled: (velocity, offset) {
                                                  customPrint("onDraggableCanceled $row");

                                                  widget.tableModel.rows[row].popoverController = PopoverController();
                                                  for (TableCellModel tcm in widget.tableModel.rows[row].cells) {
                                                    for (SingleCellModel scm in tcm.items) {
                                                      for (DiagnosisModel dm in scm.diagnosisModelList ?? []) {
                                                        dm.popoverController = PopoverController();
                                                      }
                                                    }
                                                  }
                                                  globalController.selectedRowIndex.refresh();
                                                },
                                                data: {'row': row, 'col': col, 'itemIndex': i, 'subIndex': subIndex},
                                                feedback: IntrinsicHeight(
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      decoration: BoxDecoration(color: AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
                                                      padding: const EdgeInsets.all(6.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            child: Builder(
                                                              builder: (context) {
                                                                return Expanded(
                                                                  child: Popover(
                                                                    key: ValueKey(widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController),
                                                                    context,
                                                                    controller: widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController,
                                                                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                                    scrollEnabled: true,
                                                                    hideArrow: true,
                                                                    applyActionWidth: false,
                                                                    alignment: PopoverAlignment.rightTop,
                                                                    contentWidth: MediaQuery.of(context).size.width * 0.4,
                                                                    action: RichText(
                                                                      key: isDrag ? null : items[i].diagnosisModelList?[subIndex].diagnosisContainerKey,
                                                                      text: TextSpan(children: [TextSpan(text: " ${items[i].diagnosisModelList?[subIndex].code} ", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].diagnosisModelList?[subIndex].description}', style: AppFonts.regular(14, AppColors.textGreyTable))]),
                                                                    ),
                                                                    content: DiagnosisDropDrownSearchTable(
                                                                      diagnosisContainerKey: items[i].diagnosisModelList![subIndex].diagnosisContainerKey,
                                                                      items: (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? []).map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description, isPin: item.isPin ?? false)).toList(),
                                                                      onItemSelected: (value, index) {
                                                                        widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController.close();
                                                                        if (value.description != "No data found") {
                                                                          customPrint("called diagnosis");

                                                                          setState(() {
                                                                            String localCode = items[i].diagnosisModelList?[subIndex].code ?? "";
                                                                            String localDescription = items[i].diagnosisModelList?[subIndex].description ?? "";
                                                                            items[i].diagnosisModelList?[subIndex].code = value.code;
                                                                            items[i].diagnosisModelList?[subIndex].description = value.description;

                                                                            items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives?[index].code = localCode;
                                                                            items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives?[index].description = localDescription;

                                                                            calculateTotal();
                                                                          });
                                                                        }
                                                                      },
                                                                      controller: widget.controller,
                                                                      onSearchItemSelected: (p0, p1) {
                                                                        widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController.close();

                                                                        setState(() {
                                                                          items[i].diagnosisModelList?[subIndex].code = p0;
                                                                          items[i].diagnosisModelList?[subIndex].description = p1;
                                                                          calculateTotal();
                                                                        });
                                                                      },
                                                                      onInitCallBack: () {
                                                                        widget.controller.closeDoctorPopOverController();

                                                                        widget.controller.impressionAndPlanListFullNote.forEach((element) {
                                                                          element.popoverController.close();
                                                                        });

                                                                        widget.controller.impressionAndPlanList.forEach((element) {
                                                                          element.popoverController.close();
                                                                        });

                                                                        for (int s = 0; s < widget.tableModel.rows.length; s++) {
                                                                          widget.tableModel.rows[row].modifierPopoverController.close();
                                                                          widget.tableModel.rows[s].popoverController.close();
                                                                        }

                                                                        for (int rows = 0; rows < widget.tableModel.rows.length; rows++) {
                                                                          for (int cols = 0; cols < widget.tableModel.rows[rows].cells.length; cols++) {
                                                                            for (int newItems = 0; newItems < widget.tableModel.rows[rows].cells[cols].items.length; newItems++) {
                                                                              for (int diag = 0; diag < (widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
                                                                                if (rows == row && cols == col && newItems == i && diag == subIndex) {
                                                                                } else {
                                                                                  widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                      },
                                                                      tableRowIndex: row,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Obx(() {
                                                            return (widget.controller.isDoctorViewLoading.value || widget.controller.doctorViewList.value?.responseData == null) ? GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)) : SizedBox.shrink();
                                                          }),
                                                          const SizedBox(width: 3),
                                                          GestureDetector(
                                                            onTap: () {
                                                              _deleteItem(row, col, i, subIndex);

                                                              Future.delayed(const Duration(milliseconds: 500), () {
                                                                calculateTotal();
                                                              });
                                                            },
                                                            child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                childWhenDragging: Container(),
                                                onDragEnd: (details) {
                                                  customPrint("isDiagnosis onDragEnd");
                                                },
                                                onDragStarted: () {
                                                  customPrint("isDiagnosis onDragStarted");

                                                  setState(() {
                                                    draggedRowIndex = row;
                                                    draggedColumnIndex = col;
                                                    draggedDiagnosisIndex = subIndex;
                                                    isDragging = true;
                                                  });
                                                },
                                                onDragCompleted: () {
                                                  customPrint("isDiagnosis onDragCompleted");
                                                  setState(() {
                                                    isDragging = false;
                                                  });
                                                },
                                                child: DragTarget<Map<String, int>>(
                                                  onWillAcceptWithDetails: (data) => true,
                                                  onAccept: (data) {
                                                    int oldfromRow = data['row']!;
                                                    int oldfromCol = data['col']!;
                                                    int olditemIndex = data['itemIndex']!;
                                                    int oldsubIndex = data['subIndex']!;

                                                    customPrint("drag val is:- $data");
                                                    customPrint("drop val row is:- $row col is:- $col i is:- $i subIndex is:- $subIndex ");

                                                    setState(() {
                                                      if (oldfromRow == row && oldfromCol == col && olditemIndex == i) {
                                                        DiagnosisModel oldDiagnosis = widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex];
                                                        DiagnosisModel newDiagnosis = widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList![subIndex];

                                                        widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex] = oldDiagnosis;
                                                        widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex] = newDiagnosis;
                                                      } else {
                                                        DiagnosisModel diagnosis = widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex];
                                                        widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.insert(subIndex, diagnosis);
                                                        widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList?.removeAt(oldsubIndex);
                                                      }
                                                    });

                                                    Future.delayed(const Duration(milliseconds: 500), () {
                                                      calculateTotal();
                                                    });
                                                  },
                                                  builder: (context, candidateData, __) {
                                                    return Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                                      decoration: BoxDecoration(color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.1) : AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            child: Builder(
                                                              builder: (context) {
                                                                return Expanded(
                                                                  child: Popover(
                                                                    key: ValueKey(widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController),
                                                                    context,
                                                                    controller: widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController,
                                                                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                                    scrollEnabled: true,
                                                                    hideArrow: true,
                                                                    applyActionWidth: false,
                                                                    alignment: PopoverAlignment.rightTop,
                                                                    contentWidth: MediaQuery.of(context).size.width * 0.4,
                                                                    action: RichText(
                                                                      key: isDrag ? null : items[i].diagnosisModelList?[subIndex].diagnosisContainerKey,
                                                                      text: TextSpan(children: [TextSpan(text: " ${items[i].diagnosisModelList?[subIndex].code} ", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].diagnosisModelList?[subIndex].description}', style: AppFonts.regular(14, AppColors.textGreyTable))]),
                                                                    ),
                                                                    content: DiagnosisDropDrownSearchTable(
                                                                      diagnosisContainerKey: items[i].diagnosisModelList![subIndex].diagnosisContainerKey,
                                                                      items: (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? []).map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description, isPin: item.isPin ?? false)).toList(),
                                                                      onItemSelected: (value, index) {
                                                                        widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController.close();

                                                                        if (value.description != "No data found") {
                                                                          customPrint("called diagnosis");

                                                                          setState(() {
                                                                            String localCode = items[i].diagnosisModelList?[subIndex].code ?? "";
                                                                            String localDescription = items[i].diagnosisModelList?[subIndex].description ?? "";

                                                                            items[i].diagnosisModelList?[subIndex].code = value.code;
                                                                            items[i].diagnosisModelList?[subIndex].description = value.description;

                                                                            items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives?[index].code = localCode;
                                                                            items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives?[index].description = localDescription;

                                                                            calculateTotal();
                                                                          });
                                                                        }
                                                                      },
                                                                      controller: widget.controller,
                                                                      onSearchItemSelected: (p0, p1) {
                                                                        widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?[subIndex].popoverController.close();

                                                                        // Navigator.pop(context);
                                                                        setState(() {
                                                                          items[i].diagnosisModelList?[subIndex].code = p0;
                                                                          items[i].diagnosisModelList?[subIndex].description = p1;
                                                                          calculateTotal();
                                                                        });
                                                                      },
                                                                      onInitCallBack: () {
                                                                        widget.controller.closeDoctorPopOverController();

                                                                        widget.controller.impressionAndPlanListFullNote.forEach((element) {
                                                                          element.popoverController.close();
                                                                        });

                                                                        widget.controller.impressionAndPlanList.forEach((element) {
                                                                          element.popoverController.close();
                                                                        });

                                                                        for (int s = 0; s < widget.tableModel.rows.length; s++) {
                                                                          widget.tableModel.rows[row].modifierPopoverController.close();
                                                                          widget.tableModel.rows[s].popoverController.close();
                                                                        }

                                                                        for (int rows = 0; rows < widget.tableModel.rows.length; rows++) {
                                                                          for (int cols = 0; cols < widget.tableModel.rows[rows].cells.length; cols++) {
                                                                            for (int newItems = 0; newItems < widget.tableModel.rows[rows].cells[cols].items.length; newItems++) {
                                                                              for (int diag = 0; diag < (widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
                                                                                if (rows == row && cols == col && newItems == i && diag == subIndex) {
                                                                                } else {
                                                                                  widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                      },
                                                                      tableRowIndex: row,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10),

                                                          Obx(() {
                                                            return !(widget.controller.isDoctorViewLoading.value || widget.controller.doctorViewList.value?.responseData == null)
                                                                ? GestureDetector(
                                                                  onTap: () {
                                                                    _deleteItem(row, col, i, subIndex);

                                                                    Future.delayed(const Duration(milliseconds: 500), () {
                                                                      calculateTotal();
                                                                    });
                                                                  },
                                                                  child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30),
                                                                )
                                                                : SizedBox.shrink();
                                                          }),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: isEmptyItems ? 10 : 40),
                                      if (widget.controller.doctorViewList.value?.responseData != null) ...[
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                closeAllPopOver();

                                                if (widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.isEmpty ?? false) {
                                                  _addItemAtIndex(row, col, i);
                                                } else {
                                                  if (widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.last.description != "select code") {
                                                    _addItemAtIndex(row, col, i);
                                                  } else {
                                                    CustomToastification().showToast("Please select code then add new diagnosis code", type: ToastificationType.error);
                                                  }
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      decoration: BoxDecoration(border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1.5), borderRadius: BorderRadius.circular(6)),
                                                      // height: 40,
                                                      child: SvgPicture.asset(ImagePath.diagnosis_plus, width: 25, height: 25),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                            onWillAcceptWithDetails: (data) => true,
                            onAccept: (data) {
                              int oldfromRow = data['row']!;
                              int oldfromCol = data['col']!;
                              int olditemIndex = data['itemIndex']!;
                              int oldsubIndex = data['subIndex']!;

                              customPrint("outer drag val is:- $data");
                              customPrint("outer drop val row is:- $row col is:- $col i is:- $i");

                              setState(() {
                                if (oldfromRow == row && oldfromCol == col && olditemIndex == i) {
                                  DiagnosisModel oldDiagnosis = widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex];

                                  widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList?.removeAt(oldsubIndex);
                                  widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.add(oldDiagnosis);
                                } else {
                                  DiagnosisModel oldDiagnosis = widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex];

                                  widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList?.removeAt(oldsubIndex);
                                  widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.add(oldDiagnosis);
                                }
                              });

                              calculateTotal();
                            },
                          ),
                        )
                        : col == 0
                        ? Container(
                          child: Builder(
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  key: isDrag ? null : items[i].procedureContainerKey,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (!widget.tableModel.rows[row].popoverController.opened) {
                                              for (int s = 0; s < widget.tableModel.rows.length; s++) {
                                                widget.tableModel.rows[s].modifierPopoverController.close();
                                              }
                                              widget.tableModel.rows[row].popoverController.open();
                                            }
                                          },
                                          child: Text(items[i].code ?? "", style: AppFonts.semiBold(14, AppColors.black)),
                                        ),
                                        const SizedBox(width: 10),
                                        const Spacer(),

                                        Popover(
                                          key: ValueKey(widget.tableModel.rows[row].modifierPopoverController),
                                          context,
                                          controller: widget.tableModel.rows[row].modifierPopoverController,
                                          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                          scrollEnabled: true,
                                          hideArrow: true,
                                          // horizontalPadding: 100,
                                          applyActionWidth: false,
                                          alignment: PopoverAlignment.rightTop,
                                          contentWidth: MediaQuery.of(context).size.width * 0.4,
                                          action: Text((items[i].modifiers != "" && items[i].modifiers != null) ? items[i].modifiers ?? "+ Modifier" : "+ Modifier", style: (items[i].modifiers != "" && items[i].modifiers != null) ? AppFonts.semiBold(14, AppColors.black) : AppFonts.regular(14, AppColors.black)),

                                          content: ModifierDropDrownSearchTable(
                                            procedureContainerKey: items[i].procedureContainerKey,
                                            items: items[i].procedurePossibleAlternatives ?? [],
                                            onInitCallBack: () {
                                              customPrint("ModifierDropDrownSearchTable called");

                                              widget.controller.closeDoctorPopOverController();
                                              customPrint("row $row col $col i $i");

                                              widget.controller.impressionAndPlanListFullNote.forEach((element) {
                                                element.popoverController.close();
                                              });

                                              widget.controller.impressionAndPlanList.forEach((element) {
                                                element.popoverController.close();
                                              });

                                              for (int rows = 0; rows < widget.tableModel.rows.length; rows++) {
                                                for (int cols = 0; cols < widget.tableModel.rows[rows].cells.length; cols++) {
                                                  for (int newItems = 0; newItems < widget.tableModel.rows[rows].cells[cols].items.length; newItems++) {
                                                    for (int diag = 0; diag < (widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
                                                      widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
                                                    }
                                                  }
                                                }
                                              }

                                              for (int s = 0; s < widget.tableModel.rows.length; s++) {
                                                customPrint("$s is ${widget.tableModel.rows[s].popoverController.opened}");
                                                widget.tableModel.rows[s].popoverController.close();
                                                if (row != s) {
                                                  widget.tableModel.rows[s].modifierPopoverController.close();
                                                }
                                              }

                                              customPrint("onInitCallBack");
                                            },
                                            tableRowIndex: row,
                                            controller: widget.controller,
                                            onSearchItemSelected: (p0, p1) {
                                              customPrint("po :- $p0 ,p1 :- $p1 ");
                                              setState(() {
                                                widget.tableModel.rows[row].cells[col].items[i].modifiers = p0;
                                              });
                                              widget.tableModel.rows[row].modifierPopoverController.close();
                                              calculateTotal();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Popover(
                                      key: ValueKey(widget.tableModel.rows[row].popoverController),
                                      context,
                                      controller: widget.tableModel.rows[row].popoverController,
                                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                      scrollEnabled: true,
                                      hideArrow: true,
                                      // horizontalPadding: 100,
                                      applyActionWidth: false,
                                      alignment: PopoverAlignment.rightTop,
                                      contentWidth: MediaQuery.of(context).size.width * 0.4,
                                      action: Row(children: [Expanded(child: Text(items[i].shortDescription?.isNotEmpty ?? false ? items[i].shortDescription ?? "" : items[i].description ?? "", style: AppFonts.regular(14, AppColors.textGreyTable)))]),

                                      content: DropDrownSearchTable(
                                        procedureContainerKey: items[i].procedureContainerKey,
                                        items: items[i].procedurePossibleAlternatives ?? [],
                                        onItemSelected: (value, index) {
                                          widget.tableModel.rows[row].popoverController.close();
                                          setState(() {
                                            customPrint("is procedure changes");

                                            String localCode = widget.tableModel.rows[row].cells[col].items[i].code ?? "";

                                            String? localDescription = (widget.tableModel.rows[row].cells[col].items[i].shortDescription?.isNotEmpty ?? false) ? widget.tableModel.rows[row].cells[col].items[i].shortDescription : widget.tableModel.rows[row].cells[col].items[i].description ?? "";

                                            widget.tableModel.rows[row].cells[col].items[i].code = value.code;
                                            widget.tableModel.rows[row].cells[col].items[i].shortDescription = (value.shortDescription?.isNotEmpty ?? false) ? value.shortDescription : value.description;

                                            widget.tableModel.rows[row].cells[col].items[i].procedurePossibleAlternatives?[index].code = localCode;
                                            widget.tableModel.rows[row].cells[col].items[i].procedurePossibleAlternatives?[index].shortDescription = localDescription;
                                            calculateTotal();
                                          });
                                        },
                                        onInitCallBack: () {
                                          customPrint("row $row col $col i $i");

                                          widget.controller.closeDoctorPopOverController();

                                          widget.controller.impressionAndPlanListFullNote.forEach((element) {
                                            element.popoverController.close();
                                          });

                                          widget.controller.impressionAndPlanList.forEach((element) {
                                            element.popoverController.close();
                                          });

                                          for (int rows = 0; rows < widget.tableModel.rows.length; rows++) {
                                            for (int cols = 0; cols < widget.tableModel.rows[rows].cells.length; cols++) {
                                              for (int newItems = 0; newItems < widget.tableModel.rows[rows].cells[cols].items.length; newItems++) {
                                                for (int diag = 0; diag < (widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
                                                  widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
                                                }
                                              }
                                            }
                                          }

                                          for (int s = 0; s < widget.tableModel.rows.length; s++) {
                                            customPrint("$s is ${widget.tableModel.rows[s].popoverController.opened}");

                                            widget.tableModel.rows[row].modifierPopoverController.close();
                                            if (row != s) {
                                              widget.tableModel.rows[s].popoverController.close();
                                            }
                                          }

                                          customPrint("onInitCallBack");
                                        },
                                        tableRowIndex: row,
                                        controller: widget.controller,
                                        onSearchItemSelected: (p0, p1) {
                                          customPrint("onSearchItemSelected $p0 $p1");

                                          widget.tableModel.rows[row].popoverController.close();
                                          setState(() {
                                            widget.tableModel.rows[row].cells[col].items[i].code = p0;
                                            widget.tableModel.rows[row].cells[col].items[i].shortDescription = p1;
                                            calculateTotal();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                        : RichText(text: TextSpan(children: [TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable))])),
              );
            }),
          ),
        );
      },
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (data) {
        customPrint("outer onAccept data :- $data");
      },
    );
  }

  Widget _buildTableHeader() {
    return Table(
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1, borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      columnWidths: const {0: FractionColumnWidth(0.36), 1: FractionColumnWidth(0.54), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.12)},
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppColors.white),
          children:
              ['E&M / Procedure (CPT) codes', 'Diagnosis', 'Units'].map((col) {
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text(col, textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black)));
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooterRow() {
    return Container(
      decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)), border: Border.all(color: AppColors.buttonBackgroundGrey, width: 1)),
      child: Row(
        children: [
          Expanded(flex: 90, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8), decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.buttonBackgroundGrey, width: 1))), child: Text("Total", textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black)))),
          Expanded(
            flex: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Obx(() {
                return Text("\$ ${widget.totalUnitCharge.toString()}", textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black));
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewProcedureAlternative() {
    return Skeletonizer(
      enabled: (widget.controller.isDoctorViewLoading.value || widget.controller.doctorViewList.value?.responseData == null),
      child: Container(
        decoration: BoxDecoration(color: AppColors.backgroundLightGrey, border: Border.all(color: AppColors.buttonBackgroundGrey, width: 1)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
                    child: Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 200,
                          child: CustomAnimatedButton(
                            onPressed: () {
                              _addRow();
                            },
                            height: 40,
                            text: "+ New Procedure",
                            enabledColor: AppColors.white,
                            enabledTextColor: AppColors.textDarkGrey,
                            isOutline: true,
                            outlineColor: AppColors.textBlackDark.withValues(alpha: 0.5),
                          ),
                        ),
                        if (widget.possibleDignosisProcedureTableModel.rows.isNotEmpty) ...[
                          SizedBox(
                            width: 200,
                            child: CustomAnimatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.isPossibleAlternativeShow = !widget.isPossibleAlternativeShow;
                                });
                              },
                              height: 40,
                              text: "${widget.possibleDignosisProcedureTableModel.rows.length} Possible Additions",
                              enabledColor: widget.isPossibleAlternativeShow ? AppColors.orange : AppColors.white,
                              enabledTextColor: widget.isPossibleAlternativeShow ? AppColors.orangeText : AppColors.textDarkGrey,
                              isOutline: true,
                              outlineColor: AppColors.textBlackDark.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.isPossibleAlternativeShow) ...[buildPossibleAddition()],
          ],
        ),
      ),
    );
  }

  Future<void> closeAllPopOver() async {
    widget.controller.closeDoctorPopOverController();

    for (int s = 0; s < widget.tableModel.rows.length; s++) {
      widget.tableModel.rows[s].popoverController.close();
    }

    for (int rows = 0; rows < widget.tableModel.rows.length; rows++) {
      for (int cols = 0; cols < widget.tableModel.rows[rows].cells.length; cols++) {
        for (int newItems = 0; newItems < widget.tableModel.rows[rows].cells[cols].items.length; newItems++) {
          for (int diag = 0; diag < (widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?.length ?? 0); diag++) {
            widget.tableModel.rows[rows].cells[cols].items[newItems].diagnosisModelList?[diag].popoverController.close();
          }
        }
      }
    }
  }

  Widget buildPossibleAddition() {
    return Container(color: AppColors.white, child: Column(children: [...List.generate(widget.possibleDignosisProcedureTableModel.rows.length, _buildPossibleAdditionRowContent)]));
  }

  Widget _buildPossibleAdditionRowContent(int rowIndex) {
    return Table(
      // Border styling for the table
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1),
      columnWidths: const {0: FractionColumnWidth(0.36), 1: FractionColumnWidth(0.54), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.12)},
      // columnWidths: const {0: FractionColumnWidth(0.30), 1: FractionColumnWidth(0.48), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.12)},
      children: [
        TableRow(
          children: List.generate(3, (colIndex) {
            return colIndex == 1 ? _buildPossibleAdditionCell(rowIndex, colIndex, isDiagnosis: true) : _buildPossibleAdditionCell(rowIndex, colIndex);
          }),
        ),
      ],
    );
  }

  Widget _buildPossibleAdditionCell(int row, int col, {bool isDiagnosis = false}) {
    final items = widget.possibleDignosisProcedureTableModel.rows[row].cells[col].items;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 100),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (i) {
          final GlobalKey _procedureGestureKey = GlobalKey();
          return Padding(
            padding: EdgeInsets.zero,
            child:
                (col == 2)
                    ? IgnorePointer(child: Padding(padding: const EdgeInsets.all(8.0), child: InlineEditableText(onChanged: (p0) {}, initialText: "${items[i].unit}", textStyle: AppFonts.regular(14, AppColors.black), onSubmitted: (newText) {})))
                    : (col == 3)
                    ? IgnorePointer(child: InlineEditableText(onChanged: (p0) {}, initialText: "${items[i].unitPrice}", textStyle: AppFonts.regular(14, AppColors.textGreyTable), onSubmitted: (newText) {}))
                    : isDiagnosis
                    ? Container(
                      child: Column(
                        children: List.generate((items[i].diagnosisModelList?.length ?? 0), (subIndex) {
                          return Container(
                            decoration: BoxDecoration(color: AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.all(6.0),
                            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Row(
                              children: [
                                Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: " ${items[i].diagnosisModelList?[subIndex].code} ", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].diagnosisModelList?[subIndex].description}', style: AppFonts.regular(14, AppColors.textGreyTable))]))),
                              ],
                            ),
                          );
                        }),
                      ),
                    )
                    : col == 0
                    ? GestureDetector(
                      key: _procedureGestureKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        (items[i].modifiers != "" && items[i].modifiers != null) ? TextSpan(text: " ${items[i].code} (${items[i].modifiers}) ", style: AppFonts.semiBold(14, AppColors.black)) : TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                        const TextSpan(text: "\n"),
                                        TextSpan(text: items[i].shortDescription?.isNotEmpty ?? false ? items[i].shortDescription ?? "" : items[i].description ?? "", style: AppFonts.regular(14, AppColors.textGreyTable)),
                                        // ' ${items[i].description}'
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: CustomAnimatedButton(
                                    height: 35,
                                    text: "Add",
                                    enabledColor: AppColors.orange,
                                    enabledTextColor: AppColors.textOrangle,
                                    onPressed: () {
                                      setState(() {
                                        widget.tableModel.rows.add(widget.possibleDignosisProcedureTableModel.rows[row]);
                                        widget.possibleDignosisProcedureTableModel.rows.removeAt(row);

                                        calculateTotal();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    : RichText(text: TextSpan(children: [TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable))])),
          );
        }),
      ),
    );
  }

  Future<void> calculateTotal() async {
    widget.totalUnitCharge.value = 0;

    List<Map<String, dynamic>> mainDic = [];
    List<Map<String, dynamic>> possibleAdditionDic = [];

    for (var row in widget.tableModel.rows) {
      customPrint("procedure data:- ${row.cells.first.items[0].code}, ${row.cells.first.items[0].description}, , ${row.cells.first.items[0].procedurePossibleAlternatives}");
      customPrint("-------------------------------------------");

      List<Map<String, String>> procedureListPossibleAlternatives = [];

      List<Map<String, dynamic>> diagnosisList1 = [];

      if (row.cells.first.items[0].code != "+ Procedure") {
        for (ProcedurePossibleAlternatives procedurePossibleAlternatives in row.cells.first.items[0].procedurePossibleAlternatives ?? []) {
          procedureListPossibleAlternatives.add({'code': procedurePossibleAlternatives.code ?? "", 'description': procedurePossibleAlternatives.description ?? ""});
        }

        final procedure1 = createProcedure(code: row.cells.first.items[0].code ?? "", description: row.cells.first.items[0].description ?? "", shortDescription: row.cells.first.items[0].shortDescription ?? "", modifier: row.cells.first.items[0].modifiers ?? "", possibleAlternatives: procedureListPossibleAlternatives);

        for (DiagnosisModel item in row.cells[1].items[0].diagnosisModelList ?? []) {
          List<Map<String, String>> diagnosisListListPossibleAlternatives = [];

          for (DiagnosisPossibleAlternatives diagnosisPossibleAlternatives in item.diagnosisPossibleAlternatives ?? []) {
            diagnosisListListPossibleAlternatives.add({'code': diagnosisPossibleAlternatives.code ?? "", 'description': diagnosisPossibleAlternatives.description ?? ""});
          }

          if (item.description != "select code") {
            final localdiagnosisList = createDiagnosis(code: item.code ?? "", description: item.description ?? "", icd10: item.code ?? "", confidenceScore: item.confidence ?? "", possibleAlternatives: diagnosisListListPossibleAlternatives);

            diagnosisList1.add(localdiagnosisList);
          } else {
            customPrint("found empty diagnosis");
          }
          customPrint("*******");
        }

        Map<String, dynamic> arrAiagnosis_codes_procedures = {};

        arrAiagnosis_codes_procedures["procedure"] = procedure1;
        arrAiagnosis_codes_procedures["diagnosis"] = diagnosisList1;
        arrAiagnosis_codes_procedures["units"] = row.cells[2].items[0].unit;
        arrAiagnosis_codes_procedures["unit_charge"] = row.cells[3].items[0].unitPrice;
        arrAiagnosis_codes_procedures["modifier"] = null;
        arrAiagnosis_codes_procedures["total_charge"] = "0";

        customPrint("arrAiagnosis_codes_procedures is:- $arrAiagnosis_codes_procedures");

        mainDic.add(arrAiagnosis_codes_procedures);
      }

      customPrint("-------------------------------------------");
      // widget.updateResponse(mainDic, );

      customPrint("e is :- ${row.cells[2].items[0].unit} ${row.cells[3].items[0].unitPrice}");
      widget.totalUnitCharge.value += int.parse(row.cells[2].items[0].unit ?? "0") * int.parse(row.cells[3].items[0].unitPrice?.replaceAll("\$", "") ?? "0");
      customPrint("--------------------------------");
    }

    for (var row in widget.possibleDignosisProcedureTableModel.rows) {
      customPrint("procedure data:- ${row.cells.first.items[0].code}, ${row.cells.first.items[0].description}, , ${row.cells.first.items[0].procedurePossibleAlternatives}");
      customPrint("-------------------------------------------");

      List<Map<String, dynamic>> diagnosisList1 = [];

      final procedure1 = createProcedure(code: row.cells.first.items[0].code ?? "", description: row.cells.first.items[0].description ?? "", shortDescription: row.cells.first.items[0].shortDescription ?? "", modifier: "");

      for (var item in row.cells[1].items[0].diagnosisModelList ?? []) {
        final localdiagnosisList = createDiagnosis(code: item.code ?? "", description: item.description ?? "", icd10: item.code ?? "", confidenceScore: item.confidence ?? "");

        diagnosisList1.add(localdiagnosisList);
        customPrint("*******");
      }

      Map<String, dynamic> arrAiagnosis_codes_procedures = {};

      arrAiagnosis_codes_procedures["procedure"] = procedure1;
      arrAiagnosis_codes_procedures["diagnosis"] = diagnosisList1;
      arrAiagnosis_codes_procedures["units"] = row.cells[2].items[0].unit;
      arrAiagnosis_codes_procedures["unit_charge"] = row.cells[3].items[0].unitPrice;
      arrAiagnosis_codes_procedures["modifier"] = null;
      arrAiagnosis_codes_procedures["total_charge"] = "0";

      possibleAdditionDic.add(arrAiagnosis_codes_procedures);
    }

    widget.updateResponse(mainDic, possibleAdditionDic);

    customPrint("widget total is :- ${widget.totalUnitCharge} ");
  }

  Future<void> calculateTotalOnly() async {
    widget.totalUnitCharge.value = 0;

    for (var row in widget.tableModel.rows) {
      widget.totalUnitCharge.value += int.parse(row.cells[2].items[0].unit ?? "0") * int.parse(row.cells[3].items[0].unitPrice?.replaceAll("\$", "") ?? "0");
    }
  }

  void _addItemAtIndex(int row, int col, int index) => setState(() => widget.tableModel.addItemAtIndex(row, col, index));

  void _addRow() => setState(() => widget.tableModel.addRow());

  void _deleteItem(int row, int col, int index, int subIndex) => setState(() => widget.tableModel.deleteItem(row, col, index, subIndex));

  void _swapRows(int from, int to) => setState(() => widget.tableModel.swapRows(from, to));

  Map<String, dynamic> createProcedure({required String code, required String description, required String shortDescription, String? modifier, String confidenceScore = "", List<Map<String, dynamic>> possibleAlternatives = const []}) {
    return {"code": code, "description": description, "short_description": shortDescription, "modifier": modifier, "confidence_score": confidenceScore, "possible_alternatives": possibleAlternatives};
  }

  // Create a dynamic diagnosis
  Map<String, dynamic> createDiagnosis({required String code, required String description, required String icd10, String confidenceScore = "", List<Map<String, dynamic>> possibleAlternatives = const []}) {
    return {"code": code, "description": description, "icd_10_code": icd10, "confidence_score": confidenceScore, "possible_alternatives": possibleAlternatives};
  }
}

class OneToNineDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If new value is empty, allow it
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Check if the new value contains only digits 1-9
    final regex = RegExp(r'^[1-9]*$');
    if (!regex.hasMatch(newValue.text)) {
      return oldValue; // Reject the change if invalid characters
    }

    // Limit to 9 digits
    if (newValue.text.length > 9) {
      return oldValue;
    }

    return newValue;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, just return with the dollar sign
    if (newValue.text.isEmpty) {
      return const TextEditingValue(text: '\$', selection: TextSelection.collapsed(offset: 1));
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (newText.isEmpty) {
      return newValue;
    }

    if (!newText.startsWith("\$")) {
      newText = '\$$newText';
    }

    int selectionIndex = newValue.selection.end;
    int offset = newText.length - newValue.text.length;
    selectionIndex += offset;

    if (selectionIndex < 1) {
      selectionIndex = 1;
    }

    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: selectionIndex));
  }
}
