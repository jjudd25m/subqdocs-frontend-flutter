import 'package:flutter/material.dart';

import '../app/core/common/logger.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CustomTable extends StatelessWidget {
  final Widget Function(BuildContext, int) headerBuilder;
  final List<List<String>> rows;
  final Widget Function(BuildContext, int, int, String, String) cellBuilder;
  final int columnCount;
  final Future<void> Function()? onLoadMore;
  final bool isLoading; // Add isLoading to track loading state
  final bool isNoData; // Add isLoading to track loading state
  final ScrollPhysics? physics;
  final List<double> columnWidths;
  final void Function(int rowIndex, List<String> rowData)? onRowSelected;

  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh; // Add onRefresh for pull-to-refresh

  const CustomTable({
    super.key,
    required this.headerBuilder,
    required this.rows,
    required this.cellBuilder,
    required this.columnCount,
    required this.columnWidths,
    this.onRowSelected,
    this.isNoData = false,
    this.onLoadMore,
    required this.isLoading, // Accept isLoading
    this.physics = const BouncingScrollPhysics(),
    required BuildContext context,
    this.onRefresh,
    this.scrollController, // Accept onRefresh function
  });

  @override
  Widget build(BuildContext context) {
    print("CustomTable called ");

    double screenWidth = MediaQuery.of(context).size.width - 100;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: Column(
        children: [
          // Sticky Header Row
          _buildHeaderRow(context, screenWidth),

          // Scrollable Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh ?? () async {}, // Use onRefresh if provided, // Use onRefresh if provided
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  if (notification.metrics.atEdge) {
                    customPrint("notification.metrics.atEdge");
                  }

                  // If user reaches the bottom and no data is being loaded
                  if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading) {
                    customPrint("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");
                    onLoadMore?.call(); // Call the onLoadMore function
                  }
                  return false; // Allow other notifications to propagate
                },
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  physics: physics,
                  itemCount:
                      rows.length +
                      (isNoData
                          ? 1
                          : isLoading
                          ? 1
                          : 0), // Add an extra item for loader
                  itemBuilder: (context, index) {
                    if (index == rows.length && isNoData) {
                      return Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text("No more records to load", style: AppFonts.bold(13, AppColors.textGrey))));
                    } else {
                      if (index == rows.length && isLoading) {
                        // Show loading spinner at the bottom when loading
                        return const Center(child: CircularProgressIndicator(color: AppColors.buttonBackgroundGrey));
                      } else {
                        // Build and return the actual table row
                        return _buildTableRow(context, index, screenWidth);
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  // Builds the Sticky Header Row
  Widget _buildHeaderRow(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [for (int colIndex = 0; colIndex < columnCount; colIndex++) Container(width: screenWidth * columnWidths[colIndex], padding: const EdgeInsets.symmetric(horizontal: 5), child: headerBuilder(context, colIndex))]),
    );
  }

  // Builds each row
  Widget _buildTableRow(BuildContext context, int rowIndex, double screenWidth) {
    List<String> rowData = rows[rowIndex];

    return GestureDetector(
      onTap: () {
        onRowSelected?.call(rowIndex, rowData);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade300, width: rowIndex == 0 ? 0 : 1))),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int colIndex = 0; colIndex < columnCount; colIndex++)
              Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                //   // border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
                // ),
                color: AppColors.white,
                width: screenWidth * columnWidths[colIndex],
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: cellBuilder(context, rowIndex, colIndex, rowData.length > colIndex ? rowData[colIndex] : '', rowData.last),
              ),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------

class VisitCustomTable extends StatelessWidget {
  final List<List<String>> rows;
  final Widget Function(BuildContext, int, int, String, String) cellBuilder;
  final int columnCount;
  final VoidCallback? onLoadMore;
  final ScrollPhysics? physics;
  final List<double> columnWidths;
  final void Function(int rowIndex, List<String> rowData)? onRowSelected;

  const VisitCustomTable({super.key, required this.rows, this.onLoadMore, required this.cellBuilder, required this.columnCount, required this.columnWidths, this.onRowSelected, this.physics = const BouncingScrollPhysics(), required BuildContext context});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 100;

    return Column(
      children: [
        /// Sticky Header Row
        _buildHeaderRow(context, screenWidth),

        /// Scrollable Content
        Expanded(
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent) {
                onLoadMore?.call();
              }
              return false;
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: physics,
              itemCount: rows.length,
              itemBuilder: (context, index) {
                return _buildTableRow(context, index, screenWidth);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the Sticky Header Row
  Widget _buildHeaderRow(BuildContext context, double screenWidth) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int colIndex = 0; colIndex < columnCount; colIndex++)
            Container(
              width: screenWidth * columnWidths[colIndex],
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Header $colIndex", // Replace with dynamic headers if needed
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds each row
  Widget _buildTableRow(BuildContext context, int rowIndex, double screenWidth) {
    List<String> rowData = rows[rowIndex];

    return GestureDetector(
      onTap: () {
        onRowSelected?.call(rowIndex, rowData);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1))),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [for (int colIndex = 0; colIndex < columnCount; colIndex++) Container(width: screenWidth * columnWidths[colIndex], padding: const EdgeInsets.symmetric(horizontal: 5), child: cellBuilder(context, rowIndex, colIndex, rowData.length > colIndex ? rowData[colIndex] : '', rowData.last))]),
      ),
    );
  }
}
