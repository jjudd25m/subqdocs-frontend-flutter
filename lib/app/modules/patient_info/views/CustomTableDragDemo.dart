// your imports remain unchanged
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

class NestedDraggableTable extends StatefulWidget {
  TableModel tableModel;
  RxInt totalUnitCharge = RxInt(0);

  NestedDraggableTable({super.key, required this.tableModel});

  @override
  _NestedDraggableTableState createState() => _NestedDraggableTableState();
}

class DiagnosisModel {
  String? description;
  String? code;
  String? confidence;

  DiagnosisModel({this.description, this.code, this.confidence});
}

class SingleCellModel {
  String? description;
  String? code;
  String? unit;

  List<DiagnosisModel>? diagnosisModelList;

  String? unitPrice;

  SingleCellModel({this.description, this.code, this.unit, this.unitPrice, this.diagnosisModelList});
}

class TableCellModel {
  List<SingleCellModel> items;

  TableCellModel({required this.items});
}

class TableRowModel {
  List<TableCellModel> cells;
  List<ProcedurePossibleAlternatives>? procedurePossibleAlternatives;
  List<DiagnosisPossibleAlternatives>? diagnosisPossibleAlternatives;

  TableRowModel({required this.cells, this.procedurePossibleAlternatives, this.diagnosisPossibleAlternatives});
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
    rows[row].cells[col].items.insert(index + 1, SingleCellModel(code: "", unit: "0", description: "select item ", unitPrice: "0"));
  }

  void addItem(int row, int col) {
    rows[row].cells[col].items.add(SingleCellModel(code: "", unit: "0", description: "select item ", unitPrice: "0"));
  }

  void deleteItem(int row, int col, int itemIndex) {
    if (rows[row].cells[col].items.length > itemIndex) {
      rows[row].cells[col].items.removeAt(itemIndex);
    }
  }

  void swapRows(int fromRowIndex, int toRowIndex) {
    final row = rows.removeAt(fromRowIndex);
    rows.insert(toRowIndex, row);
  }

  void swapItems(int row, int col, int fromIndex, int toIndex) {
    final item = rows[row].cells[col].items.removeAt(fromIndex);
    rows[row].cells[col].items.insert(toIndex, item);
  }

  void moveItem(int fromRow, int fromCol, int itemIndex, int toRow, int toCol) {
    final item = rows[fromRow].cells[fromCol].items.removeAt(itemIndex);
    rows[toRow].cells[toCol].items.add(item);
  }

  void moveCell(int fromRow, int fromCol, int toRow, int toCol) {
    final temp = rows[toRow].cells[toCol];
    rows[toRow].cells[toCol] = rows[fromRow].cells[fromCol];
    rows[fromRow].cells[fromCol] = temp;
  }
}

class _NestedDraggableTableState extends State<NestedDraggableTable> {
  int? selectedRowIndex;

  _NestedDraggableTableState();

  @override
  void initState() {
    super.initState();
  }

  void _addItemAtIndex(int row, int col, int index) => setState(() => widget.tableModel.addItemAtIndex(row, col, index));

  void _addRow() => setState(() => widget.tableModel.addRow());

  void _deleteItem(int row, int col, int index) => setState(() => widget.tableModel.deleteItem(row, col, index));

  void _swapRows(int from, int to) => setState(() => widget.tableModel.swapRows(from, to));

  void _swapItems(int row, int col, int from, int to) => setState(() => widget.tableModel.swapItems(row, col, from, to));

  void _moveItem({required int fromRow, required int fromCol, required int itemIndex, required int toRow, required int toCol}) =>
      setState(() => widget.tableModel.moveItem(fromRow, fromCol, itemIndex, toRow, toCol));

  void _moveCell(int fromRow, int fromCol, int toRow, int toCol) => setState(() => widget.tableModel.moveCell(fromRow, fromCol, toRow, toCol));

  Widget _buildTableHeader() {
    return Table(
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      columnWidths: const {0: FractionColumnWidth(0.25), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.15)},
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
            flex: 17,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              decoration: BoxDecoration(border: Border(right: BorderSide(color: AppColors.buttonBackgroundGrey, width: 1))),
              child: Text("Total", textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black)),
            ),
          ),
          Expanded(
            flex: 3,
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
              return _buildRowContent(rowIndex);
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
      columnWidths: const {0: FractionColumnWidth(0.25), 1: FractionColumnWidth(0.50), 2: FractionColumnWidth(0.10), 3: FractionColumnWidth(0.15)},
      children: [
        TableRow(
          children: List.generate(4, (colIndex) {
            return DragTarget<Map<String, int>>(
              onWillAccept: (data) => data != null,
              onAccept: (data) {
                if ((data?['isCell'] ?? 0) == 1) {
                  _moveCell(data!['row']!, data['col']!, rowIndex, colIndex);
                } else {
                  _moveItem(fromRow: data!['row']!, fromCol: data['col']!, itemIndex: data['itemIndex']!, toRow: rowIndex, toCol: colIndex);
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

  Widget _buildCell(int row, int col, {bool isDiagnosis = false}) {
    final items = widget.tableModel.rows[row].cells[col].items;

    return LongPressDraggable<Map<String, int>>(
      data: {'row': row, 'col': col, 'isCell': 1},
      feedback: Material(
        color: Colors.white,
        child: IntrinsicHeight(
          child: IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(items.length, (i) {
                  return DragTarget<Map<String, int>>(
                    onWillAccept: (data) => data != null && data['row'] == row && data['col'] == col && data['itemIndex'] != null && data['itemIndex'] != i,
                    onAccept: (data) {
                      final fromIndex = data['itemIndex'];
                      if (fromIndex != null) {
                        _swapItems(row, col, fromIndex, i);
                      }
                    },
                    builder: (context, _, __) {
                      return LongPressDraggable<Map<String, int>>(
                        data: {'row': row, 'col': col, 'itemIndex': i},
                        feedback: Material(child: Text(items[i].description ?? "", style: AppFonts.regular(14, AppColors.textGreyTable))),
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
                                      print("onSubmitted :- ${newText}");
                                      calculateTotal();
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
                                      print("onSubmitted :- ${newText}");
                                      calculateTotal();
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
                                                      items: [
                                                        "Cryotherapy for the destruction of benign lesions (first lesion)",
                                                        "Destruction of benign lesions (first lesion)",
                                                        "Another Procedure Option",
                                                      ],
                                                      onItemSelected: (value) {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          // tableModel.rows[row].cells[col].items[index] = value;
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
                                                  TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                                  TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: AppColors.lightgreenPastVisit, borderRadius: BorderRadius.circular(8)),
                                          child: Text("high", style: AppFonts.regular(14, AppColors.greenPastVisit)),
                                        ),
                                        SizedBox(width: 8),
                                        GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
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
                                        constraints: BoxConstraints(maxWidth: 400),
                                        barrierColor: Colors.transparent,
                                        bodyBuilder:
                                            (context) => DropDrownSearchTable(
                                              items: ["dsgfdgd", "gdsgdfgfd", "fdsgdsgds"],
                                              onItemSelected: (value) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  // tableModel.rows[row].cells[col].items[index] = value;
                                                });
                                              },
                                            ),
                                        onPop: () => print('Popover was popped!'),
                                        direction: PopoverDirection.bottom,
                                        width: 150,
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
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ),

      child: GestureDetector(
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
                onAccept: (data) {
                  final fromIndex = data['itemIndex'];
                  if (fromIndex != null) {
                    _swapItems(row, col, fromIndex, i);
                  }
                },
                builder: (context, _, __) {
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
                                                        items: [
                                                          "Cryotherapy for the destruction of benign lesions (first lesion)",
                                                          "Destruction of benign lesions (first lesion)",
                                                          "Another Procedure Option",
                                                        ],
                                                        onItemSelected: (value) {
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
                                          SizedBox(width: 10),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: AppColors.lightgreenPastVisit, borderRadius: BorderRadius.circular(8)),
                                            child: Text("high", style: AppFonts.regular(14, AppColors.greenPastVisit)),
                                          ),
                                          SizedBox(width: 8),
                                          GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
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
                                                items: ["Cryotherapy for the destruction of benign lesions (first lesion)", "Destruction of benign lesions (first lesion)", "Another Procedure Option"],
                                                onItemSelected: (value) {
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
                                                  items: [
                                                    "Cryotherapy for the destruction of benign lesions (first lesion)",
                                                    "Destruction of benign lesions (first lesion)",
                                                    "Another Procedure Option",
                                                  ],
                                                  onItemSelected: (value) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      // tableModel.rows[row].cells[col].items[index] = value;
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
                                              TextSpan(text: " ${items[i].code} ", style: AppFonts.semiBold(14, AppColors.black)),
                                              TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.lightgreenPastVisit, borderRadius: BorderRadius.circular(8)),
                                      child: Text("high", style: AppFonts.regular(14, AppColors.greenPastVisit)),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table, width: 30, height: 30)),
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
                                          items: ["Cryotherapy for the destruction of benign lesions (first lesion)", "Destruction of benign lesions (first lesion)", "Another Procedure Option"],
                                          onItemSelected: (value) {
                                            Navigator.pop(context);
                                            setState(() {
                                              // tableModel.rows[row].cells[col].items[index] = value;
                                            });
                                          },
                                        ),
                                    onPop: () => print('Popover was popped!'),
                                    direction: PopoverDirection.bottom,
                                    width: 190,
                                    barrierDismissible: true,
                                    contentDxOffset: -100,

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
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> calculateTotal() async {
    print("dgjbdfgju");
    for (var row in widget.tableModel.rows) {
      print("e is :- ${row.cells[2].items[0].unit} ${row.cells[3].items[0].unitPrice}");

      widget.totalUnitCharge.value = int.parse(row.cells[2].items[0].unit ?? "0") * int.parse(row.cells[3].items[0].unitPrice?.replaceAll("\$", "") ?? "0");

      // for (var cell in row.cells) {
      //   print(
      //     cell.items.map((e) {
      //       print("e is :- ${e.unit} ${e.unitPrice}");
      //     }),
      //   );
      // }
      print("--------------------------------");
    }

    print("widget total is :- ${widget.totalUnitCharge} ");
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
}
