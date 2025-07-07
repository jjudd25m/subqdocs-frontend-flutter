import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_colors.dart';

class CustomTable extends StatelessWidget {
  final List<List<String>> rows;
  final Widget Function(BuildContext, int, int, String) cellBuilder;
  final int columnCount;
  BuildContext context;

  CustomTable({super.key, required this.rows, required this.cellBuilder, required this.columnCount, required this.context});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 0.8, color: AppColors.textDarkGrey)),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) Column(children: [_buildTableRow(rowIndex), _buildDivider()]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(int rowIndex) {
    List<String> rowData = rows[rowIndex];
    return Container(
      decoration: BoxDecoration(color: rowIndex == 0 ? Colors.white : Colors.white, border: const Border(bottom: BorderSide(color: AppColors.textDarkGrey, width: 0.5))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int colIndex = 0; colIndex < columnCount; colIndex++)
            Container(
              width: 150, // Set a fixed width for columns
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: cellBuilder(context, rowIndex, colIndex, rowData.length > colIndex ? rowData[colIndex] : ''),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 0, color: Colors.black);
  }
}
