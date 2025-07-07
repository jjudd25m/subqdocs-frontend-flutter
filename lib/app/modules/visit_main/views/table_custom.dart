import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';

class TableCustom extends StatelessWidget {
  final List<List<String>> rows;
  final Widget Function(BuildContext, int, int, String, String) cellBuilder;
  final int columnCount;
  BuildContext context;

  final VoidCallback? onLoadMore;
  ScrollPhysics? physics = const BouncingScrollPhysics();

  List<double> columnWidths;

  final void Function(int rowIndex, List<String> rowData)? onRowSelected;

  TableCustom({super.key, required this.rows, this.onLoadMore, required this.cellBuilder, required this.columnCount, required this.context, required this.columnWidths, this.onRowSelected, this.physics});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width - 100;

    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent) {
            // customPrint("Load more: listview end");

            onLoadMore != null ? onLoadMore!() : null;
          }
        }
        return false;
      },
      child: ListView(
        physics: physics,
        shrinkWrap: true,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: AppColors.appbarBorder)),
            padding: const EdgeInsets.all(2),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildTableRow(index, screenWidth);
              },
              itemCount: rows.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(int rowIndex, double screenWidth) {
    List<String> rowData = rows[rowIndex];

    // Column width percentages (for example, 20%, 25%, 15%, etc.)

    return GestureDetector(
      onTap: () {
        onRowSelected?.call(rowIndex, rowData);
      },
      child: Container(
        decoration: BoxDecoration(color: rowIndex == 0 ? Colors.white : Colors.white, border: rowIndex != 0 ? const Border(top: BorderSide(color: AppColors.appbarBorder, width: 1)) : null),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int colIndex = 0; colIndex < columnCount; colIndex++)
              Container(
                width: screenWidth * columnWidths[colIndex],
                // Set the width based on percentage
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: cellBuilder(context, rowIndex, colIndex, rowData.length > colIndex ? rowData[colIndex] : '', rowData.last),
              ),
          ],
        ),
      ),
    );
  }
}
