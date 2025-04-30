import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/diagnosis_model.dart';
import 'InlineEditableText.dart';
import 'drop_drown_search_table.dart';

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
  int? selectedRowIndex;

  int? draggedRowIndex;
  int? draggedColumnIndex;
  int? draggedDiagnosisIndex;

  bool isDragging = false;

  NestedDraggableTableState();

  @override
  void initState() {
    super.initState();

    print("tableModel is ${widget.tableModel.rows.length}");
    print("possibleDignosisProcedureTableModel is ${widget.possibleDignosisProcedureTableModel.rows.length}");

    calculateTotalOnly();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(child: SingleChildScrollView(child: Column(children: [...List.generate(widget.tableModel.rows.length, _buildRow), _buildNewProcedureAlternative(), _buildFooterRow()]))),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Table(
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      columnWidths: const {0: FractionColumnWidth(0.30), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.10)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppColors.white),
          children:
              ['Procedure', 'Diagnosis', 'Units', 'Unit Charge'].map((col) {
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text(col, textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black)));
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooterRow() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)), border: Border.all(color: AppColors.buttonBackgroundGrey, width: 1)),
      child: Row(
        children: [
          Expanded(
            flex: 92,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              decoration: BoxDecoration(border: Border(right: BorderSide(color: AppColors.buttonBackgroundGrey, width: 1))),
              child: Text("Total", textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black)),
            ),
          ),
          Expanded(
            flex: 10,
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
    return Container(
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
                      Expanded(
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
                        Expanded(
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
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.isPossibleAlternativeShow) ...[buildPossibleAddition()],
        ],
      ),
    );
  }

  // A widget that builds a row with drag-and-drop functionality
  Widget _buildRow(int rowIndex) {
    return GestureDetector(
      onTap: () => setState(() => selectedRowIndex = rowIndex),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // DragTarget widget to allow other widgets to drag and drop
          DragTarget<int>(
            onWillAccept: (data) => data != rowIndex,
            onAccept: (fromRow) {
              print("_buildRow onAccept");

              _swapRows(fromRow, rowIndex);
              Future.delayed(const Duration(milliseconds: 500), () {
                calculateTotal();
              });
            },
            builder: (context, candidateData, rejectedData) {
              // Gesture detector to select the row when tapped
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRowIndex = rowIndex;
                  });
                },
                child: _buildRowContent(rowIndex), // Content of the row (define elsewhere)
              );
            },
          ),
          // Show the row selection UI only if this row is selected
          if (selectedRowIndex == rowIndex)
            Positioned(
              left: -10, // Position the selected UI a bit outside the row
              top: 0,
              bottom: 0,
              child: Container(
                color: Colors.transparent, // Transparent background
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the actions
                  children: [
                    // Draggable widget that allows the row to be dragged
                    LongPressDraggable<int>(
                      data: rowIndex,
                      feedback: Material(child: Opacity(opacity: 1, child: Container(width: MediaQuery.of(context).size.width - 50, child: _buildRowContent(rowIndex)))),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3)), // changes position of shadow
                          ],
                        ),
                        child: SvgPicture.asset(ImagePath.drag_button, height: 30, width: 30),
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.tableModel.rows.removeAt(rowIndex);
                          selectedRowIndex = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3)), // changes position of shadow
                          ],
                        ),
                        child: SvgPicture.asset(ImagePath.delete_table_icon, height: 30, width: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Builds the content for each row, including drag-and-drop functionality for table cells.
  Widget _buildRowContent(int rowIndex) {
    return Table(
      // Border styling for the table
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1),
      columnWidths: const {0: FractionColumnWidth(0.30), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.10)},
      children: [
        TableRow(
          children: List.generate(4, (colIndex) {
            return colIndex == 1 ? _buildCell(rowIndex, colIndex, isDiagnosis: true) : _buildCell(rowIndex, colIndex);
          }),
        ),
      ],
    );
  }

  Widget _buildCell(int row, int col, {bool isDiagnosis = false}) {
    final items = widget.tableModel.rows[row].cells[col].items;

    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () => setState(() => selectedRowIndex = row),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minHeight: 100),
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(items.length, (i) {
                final GlobalKey _procedureGestureKey = GlobalKey();
                final Orientation orientation = MediaQuery.of(context).orientation;
                final bool isPortrait = orientation == Orientation.portrait;
                final bool isIPad = Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRowIndex = row;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child:
                        (col == 2)
                            ? InlineEditableText(
                              onChanged: (p0) {
                                widget.tableModel.rows[row].cells[col].items[i].unit = p0;
                                items[i].unit = p0;
                                calculateTotal();
                              },
                              initialText: "${items[i].unit}",
                              textStyle: AppFonts.regular(14, AppColors.textGreyTable),
                              onSubmitted: (newText) {
                                items[i].unit = newText;
                                calculateTotal();
                              },
                            )
                            : (col == 3)
                            ? InlineEditableText(
                              onChanged: (p0) {
                                widget.tableModel.rows[row].cells[col].items[i].unitPrice = p0;
                                items[i].unitPrice = p0;
                                calculateTotal();
                              },
                              initialText: "${items[i].unitPrice}",
                              textStyle: AppFonts.regular(14, AppColors.textGreyTable),
                              onSubmitted: (newText) {
                                items[i].unitPrice = newText;
                                calculateTotal();
                              },
                            )
                            : isDiagnosis
                            ? DragTarget<Map<String, dynamic>>(
                              builder: (context, candidateData, rejectedData) {
                                bool isEmptyItems = items[i].diagnosisModelList?.isNotEmpty ?? false;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: isEmptyItems ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    if (isEmptyItems)
                                      Container(
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: candidateData.isNotEmpty ? Colors.transparent : Colors.transparent, width: 2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        width: double.maxFinite,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                            items[i].diagnosisModelList?.length ?? 0,
                                            (subIndex) => LongPressDraggable<Map<String, int>>(
                                              data: {'row': row, 'col': col, 'itemIndex': i, 'subIndex': subIndex},
                                              feedback: IntrinsicHeight(
                                                child: IntrinsicWidth(
                                                  child: Container(
                                                    decoration: BoxDecoration(color: AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              showPopover(
                                                                barrierColor: Colors.transparent,
                                                                bodyBuilder:
                                                                    (context) => DiagnosisDropDrownSearchTable(
                                                                      items:
                                                                          (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? [])
                                                                              .map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description, isPin: item.isPin ?? false))
                                                                              .toList(),
                                                                      onItemSelected: (value, index) {
                                                                        Navigator.pop(context);

                                                                        if (value.description != "No data found") {
                                                                          print("called diagnosis");

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
                                                                        setState(() {
                                                                          items[i].diagnosisModelList?[subIndex].code = p0;
                                                                          items[i].diagnosisModelList?[subIndex].description = p1;
                                                                          calculateTotal();
                                                                        });
                                                                      },
                                                                    ),
                                                                onPop: () => print('Popover was popped!'),
                                                                direction: PopoverDirection.bottom,
                                                                width: 350,
                                                                barrierDismissible: true,
                                                                arrowHeight: 0,
                                                                arrowWidth: 0,
                                                                context: context,
                                                              );
                                                            },
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(text: " ${items[i].diagnosisModelList?[subIndex].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                                                  TextSpan(text: '${items[i].diagnosisModelList?[subIndex].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
                                                        SizedBox(width: 3),
                                                        GestureDetector(onTap: () => _deleteItem(row, col, i, subIndex), child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              childWhenDragging: Container(),
                                              onDragEnd: (details) {
                                                print("isDiagnosis onDragEnd");
                                              },
                                              onDragStarted: () {
                                                print("isDiagnosis onDragStarted");

                                                setState(() {
                                                  draggedRowIndex = row;
                                                  draggedColumnIndex = col;
                                                  draggedDiagnosisIndex = subIndex;
                                                  isDragging = true;
                                                });
                                              },
                                              onDragCompleted: () {
                                                print("isDiagnosis onDragCompleted");
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

                                                  print("drag val is:- ${data}");
                                                  print("drop val row is:- $row col is:- $col i is:- $i subIndex is:- $subIndex ");

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

                                                  Future.delayed(const Duration(milliseconds: 500), () {
                                                    calculateTotal();
                                                  });
                                                },
                                                builder: (context, candidateData, __) {
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.1) : AppColors.tableItem,
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              showPopover(
                                                                context: context,
                                                                barrierColor: Colors.transparent,
                                                                bodyBuilder:
                                                                    (context) => DiagnosisDropDrownSearchTable(
                                                                      items:
                                                                          (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? [])
                                                                              .map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description, isPin: item.isPin ?? false))
                                                                              .toList(),
                                                                      onItemSelected: (value, index) {
                                                                        Navigator.pop(context);

                                                                        if (value.description != "No data found") {
                                                                          print("called diagnosis");

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
                                                                        setState(() {
                                                                          items[i].diagnosisModelList?[subIndex].code = p0;
                                                                          items[i].diagnosisModelList?[subIndex].description = p1;
                                                                          calculateTotal();
                                                                        });
                                                                      },
                                                                    ),
                                                                onPop: () => print('Popover was popped!'),
                                                                direction: PopoverDirection.bottom,
                                                                width: 350,
                                                                barrierDismissible: true,
                                                                arrowHeight: 0,
                                                                arrowWidth: 0,
                                                              );
                                                            },
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(text: " ${items[i].diagnosisModelList?[subIndex].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                                                  TextSpan(text: '${items[i].diagnosisModelList?[subIndex].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        GestureDetector(onTap: () => _deleteItem(row, col, i, subIndex), child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30)),
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
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomAnimatedButton(
                                                height: 40,
                                                text: "+ Diagnosis",
                                                enabledColor: AppColors.orange,
                                                enabledTextColor: AppColors.orangeText,
                                                onPressed: () {
                                                  _addItemAtIndex(row, col, i);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              onWillAcceptWithDetails: (data) => true,
                              onAccept: (data) {
                                int oldfromRow = data['row']!;
                                int oldfromCol = data['col']!;
                                int olditemIndex = data['itemIndex']!;
                                int oldsubIndex = data['subIndex']!;

                                print("outer drag val is:- ${data}");
                                print("outer drop val row is:- $row col is:- $col i is:- $i");

                                if (oldfromRow == row && oldfromCol == col && olditemIndex == i) {
                                  DiagnosisModel oldDiagnosis = widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex];

                                  widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList?.removeAt(oldsubIndex);
                                  widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.add(oldDiagnosis);
                                } else {
                                  DiagnosisModel oldDiagnosis = widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList![oldsubIndex];

                                  widget.tableModel.rows[oldfromRow].cells[oldfromCol].items[olditemIndex].diagnosisModelList?.removeAt(oldsubIndex);
                                  widget.tableModel.rows[row].cells[col].items[i].diagnosisModelList?.add(oldDiagnosis);
                                }

                                setState(() {});
                              },
                            )
                            : col == 0
                            ? GestureDetector(
                              key: _procedureGestureKey,
                              onTap: () {
                                final RenderBox? renderBox = _procedureGestureKey.currentContext?.findRenderObject() as RenderBox?;
                                final position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
                                final size = renderBox?.size ?? Size.zero;

                                print("position is :- ${position}");

                                showPopover(
                                  context: _procedureGestureKey.currentContext!,

                                  barrierColor: Colors.transparent,
                                  bodyBuilder:
                                      (context) => DropDrownSearchTable(
                                        items: items[i].procedurePossibleAlternatives ?? [],
                                        onItemSelected: (value, index) {
                                          Navigator.pop(context);
                                          setState(() {
                                            print("is procedure changes");

                                            String localCode = widget.tableModel.rows[row].cells[col].items[i].code ?? "";
                                            String localDescription = widget.tableModel.rows[row].cells[col].items[i].description ?? "";

                                            widget.tableModel.rows[row].cells[col].items[i].code = value.code;
                                            widget.tableModel.rows[row].cells[col].items[i].description = value.description;

                                            widget.tableModel.rows[row].cells[col].items[i].procedurePossibleAlternatives?[index].code = localCode;
                                            widget.tableModel.rows[row].cells[col].items[i].procedurePossibleAlternatives?[index].description = localDescription;

                                            calculateTotal();
                                            // tableModel.rows[row].cells[col].items[index] = value;
                                          });
                                        },
                                      ),
                                  onPop: () => print('Popover was popped!'),
                                  direction: PopoverDirection.bottom,
                                  width: 190,
                                  barrierDismissible: true,
                                  arrowHeight: isPortrait ? 60 : 40,
                                  arrowDyOffset: isPortrait ? -50 : -30,
                                  arrowWidth: 0,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      (items[i].modifiers != "" && items[i].modifiers != null)
                                          ? TextSpan(text: " ${items[i].code} (${items[i].modifiers}) ", style: AppFonts.semiBold(14, AppColors.black))
                                          : TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                      TextSpan(text: ' ${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            : RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)),
                                  TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                ],
                              ),
                            ),
                  ),
                );
              }),
            ),
          ),
        );
      },
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (data) {
        print("outer onAccept data :- ${data}");
        setState(() {});
      },
    );
  }

  Widget buildPossibleAddition() {
    return Container(color: AppColors.white, child: Column(children: [...List.generate(widget.possibleDignosisProcedureTableModel.rows.length, _buildPossibleAdditionRowContent)]));
  }

  Widget _buildPossibleAdditionRowContent(int rowIndex) {
    return Table(
      // Border styling for the table
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1),
      columnWidths: const {0: FractionColumnWidth(0.30), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.10)},
      children: [
        TableRow(
          children: List.generate(4, (colIndex) {
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
      // decoration: BoxDecoration(border: Border.all(color: candidateData.isNotEmpty ? Colors.blue : Colors.grey, width: 2), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 100),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (i) {
          final GlobalKey _procedureGestureKey = GlobalKey();
          final Orientation orientation = MediaQuery.of(context).orientation;
          final bool isPortrait = orientation == Orientation.portrait;
          final bool isIPad = Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child:
                (col == 2)
                    ? InlineEditableText(onChanged: (p0) {}, initialText: "${items[i].unit}", textStyle: AppFonts.regular(14, AppColors.textGreyTable), onSubmitted: (newText) {})
                    : (col == 3)
                    ? InlineEditableText(
                      onChanged: (p0) {},
                      initialText: "${items[i].unitPrice}",
                      textStyle: AppFonts.regular(14, AppColors.textGreyTable),
                      onSubmitted: (newText) {
                        // items[i].unitPrice = newText;
                      },
                    )
                    : isDiagnosis
                    ? Container(
                      child: Column(
                        children: List.generate((items[i].diagnosisModelList?.length ?? 0), (subIndex) {
                          return Container(
                            decoration: BoxDecoration(color: AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(text: " ${items[i].diagnosisModelList?[subIndex].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                          TextSpan(text: '${items[i].diagnosisModelList?[subIndex].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                        (items[i].modifiers != "" && items[i].modifiers != null)
                                            ? TextSpan(text: " ${items[i].code} (${items[i].modifiers}) ", style: AppFonts.semiBold(14, AppColors.black))
                                            : TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                        TextSpan(text: ' ${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: CustomAnimatedButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.possibleDignosisProcedureTableModel.rows.removeAt(row);
                                        calculateTotal();
                                      });
                                    },
                                    height: 35,
                                    text: "Cancel",
                                    enabledColor: AppColors.white,
                                    enabledTextColor: AppColors.textDarkGrey,
                                    isOutline: true,
                                    outlineColor: AppColors.textBlackDark.withValues(alpha: 0.5),
                                  ),
                                ),
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
                    : RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)),
                          TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                        ],
                      ),
                    ),
          );
        }),
      ),
    );
  }

  // Future<void> calculateTotal() async {
  //   widget.totalUnitCharge.value = 0;
  //
  //   List<Map<String, dynamic>> mainDic = [];
  //
  //   print("widget total is :- ${widget.totalUnitCharge} ");
  // }

  Future<void> calculateTotal() async {
    widget.totalUnitCharge.value = 0;

    List<Map<String, dynamic>> mainDic = [];
    List<Map<String, dynamic>> possibleAdditionDic = [];

    for (var row in widget.tableModel.rows) {
      print("procedure data:- ${row.cells.first.items[0].code}, ${row.cells.first.items[0].description}, , ${row.cells.first.items[0].procedurePossibleAlternatives}");
      print("-------------------------------------------");

      List<Map<String, String>> procedureListPossibleAlternatives = [];

      List<Map<String, dynamic>> diagnosisList1 = [];

      if (row.cells.first.items[0].code != "0") {
        for (ProcedurePossibleAlternatives procedurePossibleAlternatives in row.cells.first.items[0].procedurePossibleAlternatives ?? []) {
          procedureListPossibleAlternatives.add({'code': procedurePossibleAlternatives.code ?? "", 'description': procedurePossibleAlternatives.description ?? ""});
        }

        final procedure1 = createProcedure(
          code: row.cells.first.items[0].code ?? "",
          description: row.cells.first.items[0].description ?? "",
          modifier: "",
          possibleAlternatives: procedureListPossibleAlternatives,
        );

        for (var item in row.cells[1].items[0].diagnosisModelList ?? []) {
          List<Map<String, String>> diagnosisListListPossibleAlternatives = [];

          for (DiagnosisPossibleAlternatives diagnosisPossibleAlternatives in item.diagnosisPossibleAlternatives ?? []) {
            diagnosisListListPossibleAlternatives.add({'code': diagnosisPossibleAlternatives.code ?? "", 'description': diagnosisPossibleAlternatives.description ?? ""});
          }

          final localdiagnosisList = createDiagnosis(
            code: item.code ?? "",
            description: item.description ?? "",
            icd10: item.code ?? "",
            confidenceScore: item.confidence ?? "",
            possibleAlternatives: diagnosisListListPossibleAlternatives,
          );

          diagnosisList1.add(localdiagnosisList);
          // print("${item.code}, ${item.description}, ${item.diagnosisPossibleAlternatives}");
          print("*******");
        }

        Map<String, dynamic> arrAiagnosis_codes_procedures = {};

        arrAiagnosis_codes_procedures["procedure"] = procedure1;
        arrAiagnosis_codes_procedures["diagnosis"] = diagnosisList1;
        arrAiagnosis_codes_procedures["units"] = row.cells[2].items[0].unit;
        arrAiagnosis_codes_procedures["unit_charge"] = row.cells[3].items[0].unitPrice;
        arrAiagnosis_codes_procedures["modifier"] = null;
        arrAiagnosis_codes_procedures["total_charge"] = "0";

        print("arrAiagnosis_codes_procedures is:- ${arrAiagnosis_codes_procedures}");

        mainDic.add(arrAiagnosis_codes_procedures);
      }

      print("-------------------------------------------");
      // widget.updateResponse(mainDic, );

      print("e is :- ${row.cells[2].items[0].unit} ${row.cells[3].items[0].unitPrice}");
      widget.totalUnitCharge.value += int.parse(row.cells[2].items[0].unit ?? "0") * int.parse(row.cells[3].items[0].unitPrice?.replaceAll("\$", "") ?? "0");
      print("--------------------------------");
    }

    for (var row in widget.possibleDignosisProcedureTableModel.rows) {
      print("procedure data:- ${row.cells.first.items[0].code}, ${row.cells.first.items[0].description}, , ${row.cells.first.items[0].procedurePossibleAlternatives}");
      print("-------------------------------------------");

      // List<Map<String, String>> procedureListPossibleAlternatives = [];

      List<Map<String, dynamic>> diagnosisList1 = [];

      // for (ProcedurePossibleAlternatives procedurePossibleAlternatives in row.cells.first.items[0].procedurePossibleAlternatives ?? []) {
      //   procedureListPossibleAlternatives.add({'code': procedurePossibleAlternatives.code ?? "", 'description': procedurePossibleAlternatives.description ?? ""});
      // }

      final procedure1 = createProcedure(
        code: row.cells.first.items[0].code ?? "",
        description: row.cells.first.items[0].description ?? "",
        modifier: "",
        // possibleAlternatives: procedureListPossibleAlternatives,
      );

      for (var item in row.cells[1].items[0].diagnosisModelList ?? []) {
        // List<Map<String, String>> diagnosisListListPossibleAlternatives = [];
        //
        // for (DiagnosisPossibleAlternatives diagnosisPossibleAlternatives in item.diagnosisPossibleAlternatives ?? []) {
        //   diagnosisListListPossibleAlternatives.add({'code': diagnosisPossibleAlternatives.code ?? "", 'description': diagnosisPossibleAlternatives.description ?? ""});
        // }

        final localdiagnosisList = createDiagnosis(
          code: item.code ?? "",
          description: item.description ?? "",
          icd10: item.code ?? "",
          confidenceScore: item.confidence ?? "",
          // possibleAlternatives: diagnosisListListPossibleAlternatives,
        );

        diagnosisList1.add(localdiagnosisList);
        // print("${item.code}, ${item.description}, ${item.diagnosisPossibleAlternatives}");
        print("*******");
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

    print("widget total is :- ${widget.totalUnitCharge} ");
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

  Map<String, dynamic> createProcedure({required String code, required String description, String? modifier, String confidenceScore = "", List<Map<String, dynamic>> possibleAlternatives = const []}) {
    return {"code": code, "description": description, "modifier": modifier, "confidence_score": confidenceScore, "possible_alternatives": possibleAlternatives};
  }

  // Create a dynamic diagnosis
  Map<String, dynamic> createDiagnosis({
    required String code,
    required String description,
    required String icd10,
    String confidenceScore = "",
    List<Map<String, dynamic>> possibleAlternatives = const [],
  }) {
    return {"code": code, "description": description, "icd_10_code": icd10, "confidence_score": confidenceScore, "possible_alternatives": possibleAlternatives};
  }
}
