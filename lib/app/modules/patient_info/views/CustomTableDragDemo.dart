// your imports remain unchanged
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popover/popover.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import 'InlineEditableText.dart';
import 'drop_drown_search_table.dart';

class NestedDraggableTable extends StatefulWidget {
  @override
  _NestedDraggableTableState createState() => _NestedDraggableTableState();
}

class SingleCellModel {
  String? description;
  int? code;
  int? unit;
  int? unitPrice;

  SingleCellModel({this.description, this.code, this.unit, this.unitPrice});
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
    rows.add(TableRowModel(cells: List.generate(4, (index) => TableCellModel(items: [SingleCellModel(code: 0, unit: 0, description: "select item ", unitPrice: 0)]))));
  }

  void addItemAtIndex(int row, int col, int index) {
    rows[row].cells[col].items.insert(index + 1, SingleCellModel(code: 0, unit: 0, description: "select item ", unitPrice: 0));
  }

  void addItem(int row, int col) {
    rows[row].cells[col].items.add(SingleCellModel(code: 0, unit: 0, description: "select item ", unitPrice: 0));
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
  late TableModel tableModel;
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    tableModel = TableModel(
      rows: [
        TableRowModel(
          cells: [
            TableCellModel(items: [SingleCellModel(code: 40, unit: 0, description: "this the  procedure code ", unitPrice: 0)]),
            TableCellModel(items: [SingleCellModel(code: 10, unit: 0, description: "this is the daignosis ", unitPrice: 0)]),
            TableCellModel(items: [SingleCellModel(unit: 10)]),
            TableCellModel(items: [SingleCellModel(unitPrice: 20)]),
          ],
        ),
        TableRowModel(
          cells: [
            TableCellModel(items: [SingleCellModel(code: 40, unit: 0, description: "this the  procedure code ", unitPrice: 0)]),
            TableCellModel(items: [SingleCellModel(code: 10, unit: 0, description: "this is the daignosis ", unitPrice: 0)]),
            TableCellModel(items: [SingleCellModel(unit: 10)]),
            TableCellModel(items: [SingleCellModel(unitPrice: 20)]),
          ],
        ),
      ],
    );
  }

  void _addItemAtIndex(int row, int col, int index) => setState(() => tableModel.addItemAtIndex(row, col, index));

  void _addRow() => setState(() => tableModel.addRow());

  void _deleteItem(int row, int col, int index) => setState(() => tableModel.deleteItem(row, col, index));

  void _swapRows(int from, int to) => setState(() => tableModel.swapRows(from, to));

  void _swapItems(int row, int col, int from, int to) => setState(() => tableModel.swapItems(row, col, from, to));

  void _moveItem({required int fromRow, required int fromCol, required int itemIndex, required int toRow, required int toCol}) => setState(() => tableModel.moveItem(fromRow, fromCol, itemIndex, toRow, toCol));

  void _moveCell(int fromRow, int fromCol, int toRow, int toCol) => setState(() => tableModel.moveCell(fromRow, fromCol, toRow, toCol));

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
      decoration: BoxDecoration(border: Border.all(color: AppColors.buttonBackgroundGrey, width: 1)),
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
          Expanded(flex: 3, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text("100", textAlign: TextAlign.left, style: AppFonts.medium(14, AppColors.black)))),
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
              left: -18,
              top: 0,
              bottom: 0,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LongPressDraggable<int>(
                      data: rowIndex,
                      feedback: Material(child: Opacity(opacity: 0.7, child: Container(width: MediaQuery.of(context).size.width, child: _buildRowContent(rowIndex)))),
                      child: SvgPicture.asset(ImagePath.drag_button),
                    ),
                    GestureDetector(onTap: _addRow, child: SvgPicture.asset(ImagePath.plus_icon_table, height: 40, width: 40)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tableModel.rows.removeAt(rowIndex);
                          selectedRowIndex = null;
                        });
                      },
                      child: SvgPicture.asset(ImagePath.delete_table_icon),
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
      border: TableBorder.all(color: AppColors.buttonBackgroundGrey, width: 1, borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
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
    final items = tableModel.rows[row].cells[col].items;

    return LongPressDraggable<Map<String, int>>(
      data: {'row': row, 'col': col, 'isCell': 1},
      feedback: Material(
        child: Container(
          width: 100,
          padding: EdgeInsets.all(8),
          color: Colors.orangeAccent,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: items.map((e) => Text(e.description ?? "", style: TextStyle(color: Colors.white))).toList()),
        ),
      ),
      child: GestureDetector(
        onTap: () => setState(() => selectedRowIndex = row),
        child: Container(
          // height: double.maxFinite,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: AppColors.redText)),
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
                                initialText: "${items[i].unit}",
                                textStyle: AppFonts.regular(14, AppColors.textGreyTable),
                                onSubmitted: (newText) {
                                  items[i].description = newText;
                                },
                              )
                              : (col == 3)
                              ? InlineEditableText(
                                initialText: "${items[i].unitPrice}",
                                textStyle: AppFonts.regular(14, AppColors.textGreyTable),
                                onSubmitted: (newText) {
                                  items[i].description = newText;
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
                                            width: 300,
                                            barrierDismissible: true,
                                            arrowHeight: 0,
                                            arrowWidth: 0,
                                          );
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)),
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
                                    GestureDetector(onTap: () => _addItemAtIndex(row, col, i), child: SvgPicture.asset(ImagePath.plus_icon_table)),
                                    SizedBox(width: 3),
                                    GestureDetector(onTap: () => _deleteItem(row, col, i), child: SvgPicture.asset(ImagePath.delete_table_icon)),
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
                                    width: 300,
                                    barrierDismissible: true,
                                    arrowHeight: 0,
                                    arrowWidth: 0,
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable))],
                                  ),
                                ),
                              )
                              : RichText(
                                text: TextSpan(
                                  children: [TextSpan(text: "${items[i].code}", style: AppFonts.semiBold(14, AppColors.black)), TextSpan(text: '${items[i].description}', style: AppFonts.regular(14, AppColors.textGreyTable))],
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(child: SingleChildScrollView(child: Column(children: [...List.generate(tableModel.rows.length, _buildRow), _buildFooterRow()]))),
        ],
      ),
    );
  }
}
