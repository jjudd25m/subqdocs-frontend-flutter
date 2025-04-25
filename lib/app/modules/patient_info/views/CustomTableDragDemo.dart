// your imports remain unchanged
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:popover/popover.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../visit_main/model/doctor_view_model.dart';
import 'InlineEditableText.dart';
import 'drop_drown_search_table.dart';

class DiagnosisModel {
  String? description;
  String? code;
  String? confidence;

  List<DiagnosisPossibleAlternatives>? diagnosisPossibleAlternatives;

  DiagnosisModel({this.description, this.code, this.confidence, this.diagnosisPossibleAlternatives});
}

class SingleCellModel {
  String? description;
  String? code;
  String? unit;
  String? modifiers;

  List<ProcedurePossibleAlternatives>? procedurePossibleAlternatives;

  List<DiagnosisModel>? diagnosisModelList;

  String? unitPrice;

  SingleCellModel({this.description, this.code, this.unit, this.modifiers, this.procedurePossibleAlternatives, this.unitPrice, this.diagnosisModelList});
}

class TableCellModel {
  List<SingleCellModel> items;

  TableCellModel({required this.items});
}

class TableRowModel {
  List<TableCellModel> cells;

  TableRowModel({required this.cells});
}

class TableModel {
  List<TableRowModel> rows;

  TableModel({required this.rows});

  void addRow() {
    rows.add(
      TableRowModel(
        cells: List.generate(
          4,
          (index) => TableCellModel(
            items: [
              SingleCellModel(code: "0", unit: "0", description: "select item ", unitPrice: "0", diagnosisModelList: [DiagnosisModel(description: "selected item ", code: "", confidence: "high ")]),
            ],
          ),
        ),
      ),
    );
  }

  void addItemAtIndex(int row, int col, int index) {
    rows[row].cells[1].items[0].diagnosisModelList?.add(DiagnosisModel(description: "selected item ", code: "", confidence: "high "));
  }

  void addItem(int row, int col) {
    rows[row].cells[col].items.add(SingleCellModel(code: "", unit: "0", description: "select item ", unitPrice: "0"));
  }

  void swapDiagnosisItems({required int fromRow, required int fromCol, required int fromItemIndex, required int fromDiagnosisIndex, required int toRow, required int toCol, required int toItemIndex}) {
    print("fromrow is :- ${fromRow}");
    print("fromCol is :- ${fromCol}");
    print("fromItemIndex is :- ${fromItemIndex}");
    print("fromDiagnosisIndex is :- ${fromDiagnosisIndex}");

    print("---------------------------");
    print("toRow is :- ${toRow}");
    print("toCol is :- ${toCol}");
    print("toItemIndex is :- ${toItemIndex}");

    final fromItem = rows[fromRow].cells[fromCol].items[fromItemIndex];
    final toItem = rows[toRow].cells[toCol].items[toItemIndex];

    final fromList = fromItem.diagnosisModelList;
    if (fromList == null || fromList.length <= fromDiagnosisIndex) return;

    final diagnosis = fromList.removeAt(fromDiagnosisIndex);

    toItem.diagnosisModelList ??= [];

    print("toItem lenth :- ${toItem.diagnosisModelList?.length ?? 0}");

    if (toItem.diagnosisModelList?.length == 0) {
      toItem.diagnosisModelList!.add(diagnosis);
    } else {
      print("toItemIndex is :- ${toItemIndex}");
      toItem.diagnosisModelList?.insert(toItemIndex, diagnosis);
    }
  }

  void deleteItem(int row, int col, int itemIndex) {
    print("row is :- $row col is:- $col and item index:- $itemIndex");
    rows[row].cells[1].items[0].diagnosisModelList?.removeAt(itemIndex);
  }

  void swapRows(int fromRowIndex, int toRowIndex) {
    print("it's me swapRows");
    final row = rows.removeAt(fromRowIndex);
    rows.insert(toRowIndex, row);
  }

  void swapItems(int row, int col, int fromIndex, int toIndex) {
    print("it's me");

    final item = rows[row].cells[col].items.removeAt(fromIndex);
    rows[row].cells[col].items.insert(toIndex, item);
  }

  void moveDiagnosisItem({required int fromRow, required int fromCol, required int fromItemIndex, required int fromDiagnosisIndex, required int toRow, required int toCol, required int toItemIndex}) {
    final fromList = rows[fromRow].cells[fromCol].items[fromItemIndex].diagnosisModelList;
    if (fromList == null || fromList.length <= fromDiagnosisIndex) return;

    final diagnosis = fromList.removeAt(fromDiagnosisIndex);
    final toList = rows[toRow].cells[toCol].items[toItemIndex].diagnosisModelList ??= [];
    toList.add(diagnosis);
  }

  // void swapDiagnosisItems(int fromRow, int fromCol, int fromItemIndex, int toItemIndex, int subIndex) {
  //   final fromList = rows[fromRow].cells[fromCol].items[fromItemIndex].diagnosisModelList;
  //   if (fromList == null || fromList.length <= subIndex) return;
  //
  //   final diagnosis = fromList.removeAt(subIndex);
  //
  //   // Add to target item
  //   final toList = rows[fromRow].cells[fromCol].items[0].diagnosisModelList ??= [];
  //   toList.add(diagnosis);
  // }

  // void swapDiagnosisItems(int row, int col, int fromIndex, int toIndex, int subIndex) {
  //   print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  //   print("row val:- $row");
  //   print("col val:- $col");
  //   print("-------------");
  //   print("from Index val:- $fromIndex");
  //   print("to Index val:- $toIndex");
  //   print("-------------");
  //   print("subIndex val:- $subIndex");
  //   print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  //
  //   final sourceDiagnosisList = rows[row].cells[col].items[fromIndex].diagnosisModelList;
  //   if (sourceDiagnosisList == null || sourceDiagnosisList.length <= subIndex) return;
  //
  //   final diagnosis = sourceDiagnosisList.removeAt(subIndex);
  //   rows[row].cells[col].items[toIndex].diagnosisModelList ??= [];
  //   rows[row].cells[col].items[toIndex].diagnosisModelList!.add(diagnosis);
  //
  //   // final item = rows[row].cells[1].items[0].diagnosisModelList?.removeAt(fromIndex);
  //   // rows[row].cells[1].items[0].diagnosisModelList?.add(item!);
  //
  //   // final item = rows[row].cells[col].items.removeAt(fromIndex);
  //   // rows[row].cells[col].items.insert(toIndex, item);
  // }

  void moveItem(int fromRow, int fromCol, int itemIndex, int toRow, int toCol) {
    print("it's me moveItem");
    final item = rows[fromRow].cells[fromCol].items.removeAt(itemIndex);
    rows[toRow].cells[toCol].items.add(item);
  }

  void moveCell(int fromRow, int fromCol, int toRow, int toCol) {
    print("it's me moveCell");
    final temp = rows[toRow].cells[toCol];
    rows[toRow].cells[toCol] = rows[fromRow].cells[fromCol];
    rows[fromRow].cells[fromCol] = temp;
  }
}

class NestedDraggableTable extends StatefulWidget {
  TableModel tableModel;
  RxInt totalUnitCharge = RxInt(0);
  final Function(List<Map<String, dynamic>>) updateResponse;

  NestedDraggableTable({super.key, required this.tableModel, required this.updateResponse});

  @override
  _NestedDraggableTableState createState() => _NestedDraggableTableState();
}

class _NestedDraggableTableState extends State<NestedDraggableTable> {
  int? selectedRowIndex;

  _NestedDraggableTableState();

  @override
  void initState() {
    super.initState();

    calculateTotalOnly();
  }

  void _addItemAtIndex(int row, int col, int index) => setState(() => widget.tableModel.addItemAtIndex(row, col, index));

  void _addRow() => setState(() => widget.tableModel.addRow());

  void _deleteItem(int row, int col, int index) => setState(() => widget.tableModel.deleteItem(row, col, index));

  void _swapRows(int from, int to) => setState(() => widget.tableModel.swapRows(from, to));

  void _swapDiagnosisItems({
    required int fromRow,
    required int fromCol,
    required int fromItemIndex,
    required int fromDiagnosisIndex,
    required int toRow,
    required int toCol,
    required int toItemIndex,
  }) {
    setState(() {
      widget.tableModel.swapDiagnosisItems(
        fromRow: fromRow,
        fromCol: fromCol,
        fromItemIndex: fromItemIndex,
        fromDiagnosisIndex: fromDiagnosisIndex,
        toRow: toRow,
        toCol: toCol,
        toItemIndex: toItemIndex,
      );
    });
  }

  // void _swapDiagnosisItems(int row, int col, int from, int to, int subIndex) => setState(() => widget.tableModel.swapDiagnosisItems(row, col, from, to, subIndex));

  void _swapItems(int row, int col, int from, int to) => setState(() => widget.tableModel.swapItems(row, col, from, to));

  void _moveItem({required int fromRow, required int fromCol, required int itemIndex, required int toRow, required int toCol}) =>
      setState(() => widget.tableModel.moveItem(fromRow, fromCol, itemIndex, toRow, toCol));

  void _moveCell(int fromRow, int fromCol, int toRow, int toCol) => setState(() => widget.tableModel.moveCell(fromRow, fromCol, toRow, toCol));

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

  Widget _buildRow(int rowIndex) {
    return GestureDetector(
      onTap: () => setState(() => selectedRowIndex = rowIndex),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DragTarget<int>(
            onWillAccept: (data) => data != rowIndex,
            onAccept: (fromRow) => _swapRows(fromRow, rowIndex),
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: () {
                  selectedRowIndex = rowIndex;
                },
                child: _buildRowContent(rowIndex),
              );
            },
          ),
          if (selectedRowIndex == rowIndex)
            Positioned(
              left: -10,
              top: 0,
              bottom: 0,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      onTap: _addRow,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3)), // changes position of shadow
                          ],
                        ),
                        child: SvgPicture.asset(ImagePath.plus_icon_table, height: 30, width: 30),
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

  Widget _buildRowContent(int rowIndex) {
    return Table(
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1),
      columnWidths: const {0: FractionColumnWidth(0.30), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.10)},

      // columnWidths: const {0: FractionColumnWidth(0.25), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.15)},
      children: [
        TableRow(
          children: List.generate(4, (colIndex) {
            return DragTarget<Map<String, int>>(
              onWillAccept: (data) => data != null,
              onAccept: (data) {
                if ((data?['isCell'] ?? 0) == 1) {
                  _moveCell(data!['row']!, data['col']!, rowIndex, colIndex);
                } else {
                  print(" %%%%%%%% data val is:- ${data}");

                  int subIndex = data['subIndex'] ?? -1;

                  if (subIndex != -1) {
                    _swapDiagnosisItems(
                      fromRow: data['row']!,
                      fromCol: data['col']!,
                      fromItemIndex: data['itemIndex']!,
                      fromDiagnosisIndex: data['subIndex']!,
                      toRow: rowIndex,
                      toCol: colIndex,
                      toItemIndex: 0,
                    );

                    Future.delayed(const Duration(milliseconds: 500), () {
                      // calculateTotal();
                    });
                  }
                }
              },
              builder: (context, candidate, rejected) {
                return colIndex == 1 ? _buildCell(rowIndex, colIndex, isDiagnosis: true) : _buildCell(rowIndex, colIndex);
              },
            );
          }),
        ),
      ],
    );
  }

  // void _swapDiagnosisItems({
  //   required int fromRow,
  //   required int fromCol,
  //   required int fromItemIndex,
  //   required int fromDiagnosisIndex,
  //   required int toRow,
  //   required int toCol,
  //   required int toItemIndex,
  // }) {
  //   setState(() {
  //     widget.tableModel.swapDiagnosisItems(
  //       fromRow: fromRow,
  //       fromCol: fromCol,
  //       fromItemIndex: fromItemIndex,
  //       fromDiagnosisIndex: fromDiagnosisIndex,
  //       toRow: toRow,
  //       toCol: toCol,
  //       toItemIndex: toItemIndex,
  //     );
  //   });
  // }

  Widget _buildCell(int row, int col, {bool isDiagnosis = false}) {
    final items = widget.tableModel.rows[row].cells[col].items;

    return GestureDetector(
      onTap: () => setState(() => selectedRowIndex = row),
      child: Container(
        // height: double.maxFinite,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (i) {
            return DragTarget<Map<String, int>>(
              onWillAccept: (data) => data != null && data['row'] == row && data['col'] == col && data['itemIndex'] != null && data['itemIndex'] != i,
              onAcceptWithDetails: (details) {
                print("onAcceptWithDetails :- ${details}");
              },
              onAccept: (data) {
                print(" &&&&&&&&& data val is:- ${data}");

                _swapDiagnosisItems(fromRow: data['row']!, fromCol: data['col']!, fromItemIndex: data['itemIndex']!, fromDiagnosisIndex: data['subIndex']!, toRow: row, toCol: col, toItemIndex: i);
                Future.delayed(const Duration(milliseconds: 500), () {
                  // calculateTotal();
                });
                // _swapDiagnosisItems(
                //   fromRow: data['row']!,
                //   fromCol: data['col']!,
                //   fromItemIndex: data['itemIndex']!,
                //   fromDiagnosisIndex: data['subIndex']!,
                //   toRow: row,
                //   toCol: col,
                //   toItemIndex: i,
                // );

                // final fromIndex = data['itemIndex'];
                // if (fromIndex != null) {
                //   _swapItems(row, col, fromIndex, i);
                // }
              },
              builder: (context, candidateData, __) {
                GlobalKey _procedureGestureKey = GlobalKey();

                final Orientation orientation = MediaQuery.of(context).orientation;
                final bool isPortrait = orientation == Orientation.portrait;
                final bool isIPad = Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;

                return LongPressDraggable<Map<String, int>>(
                  data: {'row': row, 'col': col, 'itemIndex': i},
                  feedback: Material(
                    child: IntrinsicHeight(
                      child: IntrinsicWidth(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child:
                              (col == 2)
                                  ? InlineEditableText(
                                    onChanged: (p0) {
                                      widget.tableModel.rows[row].cells[col].items[i].unitPrice = p0;
                                      items[i].unitPrice = p0;
                                      calculateTotal();
                                    },
                                    initialText: "${items[i].unit}",
                                    textStyle: AppFonts.regular(14, AppColors.textGreyTable),
                                    onSubmitted: (newText) {
                                      items[i].unitPrice = newText;
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
                                    },
                                  )
                                  : isDiagnosis
                                  ? Container(
                                    decoration: BoxDecoration(color: AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
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
                                                    (context) => DropDrownSearchTable(
                                                      items: [],
                                                      onItemSelected: (value, index) {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          // tableModel.rows[row].cells[col].items[index] = value;
                                                        });
                                                      },
                                                    ),
                                                onPop: () => print('Popover was popped!'),
                                                direction: PopoverDirection.bottom,

                                                barrierDismissible: true,
                                                arrowHeight: 0,
                                                arrowWidth: 0,
                                              );
                                            },
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                                  TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
                                        SizedBox(width: 3),
                                        GestureDetector(onTap: () => _deleteItem(row, col, i), child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30)),
                                      ],
                                    ),
                                  )
                                  : col == 0
                                  ? GestureDetector(
                                    onTap: () {
                                      showPopover(
                                        context: context,

                                        barrierColor: Colors.transparent,
                                        bodyBuilder:
                                            (context) => DropDrownSearchTable(
                                              items: [],
                                              // items[i].procedurePossibleAlternatives?.map((e) {
                                              //       DiagnosisPossibleAlternatives.fromJson(e.toJson());
                                              //     }).toList()
                                              //     as List<DiagnosisPossibleAlternatives>,
                                              onItemSelected: (value, index) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  // tableModel.rows[row].cells[col].items[index] = value;
                                                });
                                              },
                                            ),
                                        onPop: () => print('Popover was popped!'),
                                        contentDxOffset: -200,

                                        barrierDismissible: true,
                                        arrowHeight: 0,
                                        arrowWidth: 0,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
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
                      ),
                    ),
                  ),
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
                              },
                            )
                            : isDiagnosis
                            ? Column(
                              spacing: 10,
                              children: List.generate(items[i].diagnosisModelList?.length ?? 0, (subIndex) {
                                // print("subIndex is :- $subIndex");

                                return DragTarget<Map<String, int>>(
                                  onWillAccept:
                                      (data) => data != null && data['row'] == row && data['col'] == col && data['itemIndex'] != null && data['itemIndex'] != i && data['subIndex'] != subIndex,
                                  onAcceptWithDetails: (details) {
                                    print("diagnosisModelList data is :- ${details}");
                                  },
                                  onAccept: (data) {
                                    print(" ********** data val is:- ${data}");

                                    _swapDiagnosisItems(
                                      fromRow: data['row']!,
                                      fromCol: data['col']!,
                                      fromItemIndex: data['itemIndex']!,
                                      fromDiagnosisIndex: data['subIndex']!,
                                      toRow: row,
                                      toCol: col,
                                      toItemIndex: i,
                                    );
                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      // calculateTotal();
                                    });

                                    // int fromRow = data['row']!;
                                    // int fromCol = data['col']!;
                                    // int fromItemIndex = data['itemIndex']!;
                                    // int fromDiagnosisIndex = data['subIndex']!;
                                    //
                                    // int toItemIndex = i; // <- target item
                                    // _swapDiagnosisItems(fromRow, fromCol, fromItemIndex, toItemIndex, fromDiagnosisIndex);

                                    // final fromIndex = data['itemIndex'];
                                    //
                                    // print("diagnosisModelList data is :- ${data}");
                                    //
                                    // if (fromIndex != null) {
                                    //   _swapDiagnosisItems(row, col, fromIndex, i, subIndex);
                                    //
                                    //   // _swapItems(row, col, fromIndex, i);
                                    // }
                                  },
                                  builder: (context, candidateData, __) {
                                    return LongPressDraggable<Map<String, int>>(
                                      data: {'row': row, 'col': col, 'itemIndex': i, 'subIndex': subIndex},
                                      onDragEnd: (details) {
                                        print("onDragEnd :- $subIndex");
                                      },
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
                                                            (context) => DropDrownSearchTable(
                                                              items:
                                                                  (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? [])
                                                                          .map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description))
                                                                          .toList()
                                                                          .isNotEmpty
                                                                      ? (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? [])
                                                                          .map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description))
                                                                          .toList()
                                                                      : [ProcedurePossibleAlternatives(code: "", description: "No data found")],
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
                                                // GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
                                                SizedBox(width: 3),
                                                GestureDetector(onTap: () => _deleteItem(row, col, i), child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(color: AppColors.tableItem, borderRadius: BorderRadius.circular(6)),
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
                                                        (context) => DropDrownSearchTable(
                                                          items:
                                                              (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? [])
                                                                      .map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description))
                                                                      .toList()
                                                                      .isNotEmpty
                                                                  ? (items[i].diagnosisModelList?[subIndex].diagnosisPossibleAlternatives ?? [])
                                                                      .map((item) => ProcedurePossibleAlternatives(code: item.code, description: item.description))
                                                                      .toList()
                                                                  : [ProcedurePossibleAlternatives(code: "", description: "No data found")],
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
                                            // GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
                                            SizedBox(width: 3),
                                            GestureDetector(onTap: () => _deleteItem(row, col, i), child: SvgPicture.asset(ImagePath.delete_table_icon, width: 30, height: 30)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
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
                                  // contentDxOffset: 100,
                                  // Align popover horizontally
                                  // contentDyOffset: position.dy + size.height,
                                  // Align popover vertically below the widget
                                  // Align popover with GestureDetector
                                  // contentDxOffset: -100,
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
              },
            );
          }),
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(child: SingleChildScrollView(child: Column(children: [...List.generate(widget.tableModel.rows.length, _buildRow), _buildFooterRow()]))),
        ],
      ),
    );
  }

  Future<void> calculateTotal() async {
    widget.totalUnitCharge.value = 0;

    List<Map<String, dynamic>> mainDic = [];

    for (var row in widget.tableModel.rows) {
      print("procedure data:- ${row.cells.first.items[0].code}, ${row.cells.first.items[0].description}, , ${row.cells.first.items[0].procedurePossibleAlternatives}");
      print("-------------------------------------------");

      List<Map<String, String>> procedureListPossibleAlternatives = [];

      List<Map<String, dynamic>> diagnosisList1 = [];

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

      mainDic.add(arrAiagnosis_codes_procedures);

      print("-------------------------------------------");
      widget.updateResponse(mainDic);

      print("e is :- ${row.cells[2].items[0].unit} ${row.cells[3].items[0].unitPrice}");
      widget.totalUnitCharge.value += int.parse(row.cells[2].items[0].unit ?? "0") * int.parse(row.cells[3].items[0].unitPrice?.replaceAll("\$", "") ?? "0");
      print("--------------------------------");
    }

    print("widget total is :- ${widget.totalUnitCharge} ");
  }

  Future<void> calculateTotalOnly() async {
    widget.totalUnitCharge.value = 0;

    for (var row in widget.tableModel.rows) {
      widget.totalUnitCharge.value += int.parse(row.cells[2].items[0].unit ?? "0") * int.parse(row.cells[3].items[0].unitPrice?.replaceAll("\$", "") ?? "0");
    }
  }
}

// for (var row in widget.tableModel.rows) {
//   for (var cell in row.cells) {
//     for (var item in cell.items) {
//       List<Map<String, String>> procedureListPossibleAlternatives = [];
//
//       for (ProcedurePossibleAlternatives procedurePossibleAlternatives in item.procedurePossibleAlternatives ?? []) {
//         procedureListPossibleAlternatives.add({'code': procedurePossibleAlternatives.code ?? "", 'description': procedurePossibleAlternatives.description ?? ""});
//       }
//
//       // List<Map<String, String>> procedureListPossibleAlternatives = List<Map<String, String>>.from(
//       //   item.procedurePossibleAlternatives!.map((item) => {'code': item.code, 'description': item.description}),
//       // );
//
//       print("procedure code :- ${item.code}");
//       print("procedure description :- ${item.description}");
//
//       final procedure1 = createProcedure(code: item.code ?? "", description: item.code ?? "", modifier: "", possibleAlternatives: procedureListPossibleAlternatives);
//
//       List<Map<String, dynamic>> diagnosisList1 = [];
//
//       for (DiagnosisModel diagnosisList in item.diagnosisModelList ?? []) {
//         List<Map<String, String>> diagnosisListListPossibleAlternatives = [];
//
//         for (DiagnosisPossibleAlternatives diagnosisPossibleAlternatives in diagnosisList.diagnosisPossibleAlternatives ?? []) {
//           diagnosisListListPossibleAlternatives.add({'code': diagnosisPossibleAlternatives.code ?? "", 'description': diagnosisPossibleAlternatives.description ?? ""});
//         }
//
//         // List<Map<String, String>> diagnosisListListPossibleAlternatives = List<Map<String, String>>.from(
//         //   diagnosisList.diagnosisPossibleAlternatives!.map((item) => {'code': item.code, 'description': item.description}),
//         // );
//
//         final localdiagnosisList = createDiagnosis(
//           code: diagnosisList.code ?? "",
//           description: diagnosisList.description ?? "",
//           icd10: diagnosisList.code ?? "",
//           confidenceScore: diagnosisList.confidence ?? "",
//           possibleAlternatives: diagnosisListListPossibleAlternatives,
//         );
//
//         diagnosisList1.add(localdiagnosisList);
//       }
//
//       Map<String, dynamic> arrAiagnosis_codes_procedures = {};
//
//       arrAiagnosis_codes_procedures["procedure"] = procedure1;
//       arrAiagnosis_codes_procedures["diagnosis"] = diagnosisList1;
//       arrAiagnosis_codes_procedures["units"] = row.cells[2].items[0].unit;
//       arrAiagnosis_codes_procedures["unit_charge"] = row.cells[3].items[0].unitPrice;
//       arrAiagnosis_codes_procedures["modifier"] = null;
//       arrAiagnosis_codes_procedures["total_charge"] = "0";
//
//       mainDic.add(arrAiagnosis_codes_procedures);
//     }
//   }

// print(
//   "diagnosis data:- ${row.cells[1].items[0].diagnosisModelList?.first.code}, ${row.cells[1].items[0].diagnosisModelList?.first.description}, ${row.cells[1].items[0].diagnosisModelList?.first.diagnosisPossibleAlternatives}",
// );

// for (var cell in row.cells) {
// print("procedure data:- ${cell.items[0].code}, ${cell.items[0].description}");
// print("procedure data:- ${cell.items[0]}, ${cell.items[1]} , ${cell.items[2]}, ${cell.items[3]}");

//   for (var item in cell.items) {
//     List<Map<String, String>> procedureListPossibleAlternatives = [];
//
//     for (ProcedurePossibleAlternatives procedurePossibleAlternatives in item.procedurePossibleAlternatives ?? []) {
//       procedureListPossibleAlternatives.add({'code': procedurePossibleAlternatives.code ?? "", 'description': procedurePossibleAlternatives.description ?? ""});
//     }
//
//     // List<Map<String, String>> procedureListPossibleAlternatives = List<Map<String, String>>.from(
//     //   item.procedurePossibleAlternatives!.map((item) => {'code': item.code, 'description': item.description}),
//     // );
//
//     print("procedure code :- ${item.code}");
//     print("procedure description :- ${item.description}");
//
//     final procedure1 = createProcedure(code: item.code ?? "", description: item.code ?? "", modifier: "", possibleAlternatives: procedureListPossibleAlternatives);
//
//     List<Map<String, dynamic>> diagnosisList1 = [];
//
//     for (DiagnosisModel diagnosisList in item.diagnosisModelList ?? []) {
//       List<Map<String, String>> diagnosisListListPossibleAlternatives = [];
//
//       for (DiagnosisPossibleAlternatives diagnosisPossibleAlternatives in diagnosisList.diagnosisPossibleAlternatives ?? []) {
//         diagnosisListListPossibleAlternatives.add({'code': diagnosisPossibleAlternatives.code ?? "", 'description': diagnosisPossibleAlternatives.description ?? ""});
//       }
//
//       // List<Map<String, String>> diagnosisListListPossibleAlternatives = List<Map<String, String>>.from(
//       //   diagnosisList.diagnosisPossibleAlternatives!.map((item) => {'code': item.code, 'description': item.description}),
//       // );
//
//       final localdiagnosisList = createDiagnosis(
//         code: diagnosisList.code ?? "",
//         description: diagnosisList.description ?? "",
//         icd10: diagnosisList.code ?? "",
//         confidenceScore: diagnosisList.confidence ?? "",
//         possibleAlternatives: diagnosisListListPossibleAlternatives,
//       );
//
//       diagnosisList1.add(localdiagnosisList);
//     }
//
//     Map<String, dynamic> arrAiagnosis_codes_procedures = {};
//
//     arrAiagnosis_codes_procedures["procedure"] = procedure1;
//     arrAiagnosis_codes_procedures["diagnosis"] = diagnosisList1;
//     arrAiagnosis_codes_procedures["units"] = row.cells[2].items[0].unit;
//     arrAiagnosis_codes_procedures["unit_charge"] = row.cells[3].items[0].unitPrice;
//     arrAiagnosis_codes_procedures["modifier"] = null;
//     arrAiagnosis_codes_procedures["total_charge"] = "0";
//
//     mainDic.add(arrAiagnosis_codes_procedures);
//   }
// }

// print("possible_diagnosis_codes_procedures is:- ${patientInfoController.doctorViewList.value?.responseData?.mainDiagnosisCodesProcedures?.possibleDiagnosisCodesProcedures.toString()}");
