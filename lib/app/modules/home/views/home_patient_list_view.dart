import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../routes/app_pages.dart';
import '../model/patient_list_model.dart';

class HomePatientListView extends GetView<HomeController> {
  const HomePatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
          controller.patientLoadMore();
        }
        return false;
      },
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CustomTable(
              rows: _getTableRows(controller.patientList),
              columnCount: 6,
              // Number of columns in the table (for example, 6 here)
              cellBuilder: _buildTableCell,
              context: context,
              columnWidths: [0.44, 0.05, 0.10, 0.15, 0.15, 0.10], // Set the column widths based on your needs
            ),
            // CustomTable(
            //   rows: [
            //     ['Patient Name', 'Age', "Gender", 'Last Visit Date', "Previous Visits", "Action"],
            //     ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
            //     ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
            //     ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
            //     ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
            //     ["Jones, Don", '52', 'Male', '10/12/2024', '2', "Action"],
            //   ],
            //   cellBuilder: (context, rowIndex, colIndex, cellData) {
            //     return colIndex == 0 && rowIndex != 0
            //         ? Row(
            //             children: [
            //               RoundedImageWidget(
            //                 size: 28,
            //                 imagePath: "assets/images/user.png",
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 cellData,
            //                 textAlign: TextAlign.center,
            //                 style: AppFonts.regular(14, AppColors.textDarkGrey),
            //                 softWrap: true, // Allows text to wrap
            //                 overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
            //               ),
            //             ],
            //           )
            //         : colIndex == 5 && rowIndex != 0
            //             ? PopupMenuButton<String>(
            //                 offset: const Offset(0, 8),
            //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            //                 color: AppColors.white,
            //                 position: PopupMenuPosition.under,
            //                 padding: EdgeInsetsDirectional.zero,
            //                 menuPadding: EdgeInsetsDirectional.zero,
            //                 onSelected: (value) {},
            //                 style: const ButtonStyle(
            //                     padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
            //                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //                     maximumSize: WidgetStatePropertyAll(Size.zero),
            //                     visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
            //                 itemBuilder: (context) => [
            //                       PopupMenuItem(
            //                           onTap: () {
            //                             Get.toNamed(Routes.PATIENT_PROFILE);
            //                           },
            //                           value: "",
            //                           child: Text(
            //                             "View",
            //                             style: AppFonts.regular(14, AppColors.textBlack),
            //                           )),
            //                       PopupMenuDivider(),
            //                       PopupMenuItem(
            //                           value: "",
            //                           onTap: () {
            //                             Get.toNamed(Routes.EDIT_PATENT_DETAILS);
            //                           },
            //                           child: Text(
            //                             "Edit",
            //                             style: AppFonts.regular(14, AppColors.textBlack),
            //                           )),
            //                       PopupMenuDivider(),
            //                       PopupMenuItem(
            //                           value: "",
            //                           onTap: () {},
            //                           child: Text(
            //                             "Delete",
            //                             style: AppFonts.regular(14, AppColors.textBlack),
            //                           ))
            //                     ],
            //                 child: SvgPicture.asset(
            //                   "assets/images/logo_threedots.svg",
            //                   width: 20,
            //                   height: 20,
            //                 ))
            //             : rowIndex == 0
            //                 ? Text(
            //                     cellData,
            //                     textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
            //                     style: AppFonts.regular(12, AppColors.black),
            //                     softWrap: true, // Allows text to wrap
            //                     overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
            //                   )
            //                 : Text(
            //                     cellData,
            //                     textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
            //                     style: AppFonts.regular(14, AppColors.textDarkGrey),
            //                     softWrap: true, // Allows text to wrap
            //                     overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
            //                   );
            //   },
            //   columnCount: 6,
            //   context: context,
            //   columnWidths: [0.37, 0.1, 0.08, 0.15, 0.20, 0.1],
            // ),
          ),
        );
      }),
    );
  }

  // This function creates rows from the API model
  // This function creates rows from the API model
  List<List<String>> _getTableRows(List<PatientListData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    rows.add(['Patient Name', 'Age', 'Gender', 'Last Visit Date', 'Previous Visits', 'Action']);

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      rows.add([
        "${patient.lastName}, ${patient.firstName}", // Patient Name
        patient.age.toString(), // Age
        patient.gender ?? "N/A", // Gender
        patient.visits?.last.visitDate ?? "N/A", // Last Visit Date
        patient.pastVisitCount?.toString() ?? "0", // Previous Visits
        "Action", // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }

  // This is the cell builder function where you can customize how each cell is built.
  Widget _buildTableCell(BuildContext context, int rowIndex, int colIndex, String cellData) {
    return colIndex == 0 && rowIndex != 0
        ? Row(
            children: [
              RoundedImageWidget(
                size: 28,
                imagePath: "assets/images/user.png",
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                cellData,
                textAlign: TextAlign.center,
                style: AppFonts.regular(14, AppColors.textDarkGrey),
                softWrap: true, // Allows text to wrap
                overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
              ),
            ],
          )
        : colIndex == 5 && rowIndex != 0
            ? PopupMenuButton<String>(
                offset: const Offset(0, 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                color: AppColors.white,
                position: PopupMenuPosition.under,
                padding: EdgeInsetsDirectional.zero,
                menuPadding: EdgeInsetsDirectional.zero,
                onSelected: (value) {},
                style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    maximumSize: WidgetStatePropertyAll(Size.zero),
                    visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            Get.toNamed(Routes.PATIENT_PROFILE, arguments: {
                              "patientData": controller.patientList[rowIndex - 1].patientId.toString(),
                            });
                          },
                          // value: "",
                          child: Text(
                            "View",
                            style: AppFonts.regular(14, AppColors.textBlack),
                          )),
                      PopupMenuDivider(),
                      PopupMenuItem(
                          // value: "",
                          onTap: () {
                            print("row index is :- ${rowIndex}");
                            print("column index is :- ${colIndex}");

                            Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {
                              "patientData": controller.patientList[rowIndex - 1].patientId.toString(),
                            });
                          },
                          child: Text(
                            "Edit",
                            style: AppFonts.regular(14, AppColors.textBlack),
                          )),
                      PopupMenuDivider(),
                      PopupMenuItem(
                          // value: "",
                          onTap: () {},
                          child: Text(
                            "Delete",
                            style: AppFonts.regular(14, AppColors.textBlack),
                          ))
                    ],
                child: SvgPicture.asset(
                  "assets/images/logo_threedots.svg",
                  width: 20,
                  height: 20,
                ))
            : rowIndex == 0
                ? Text(
                    cellData,
                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                    style: AppFonts.regular(12, AppColors.black),
                    softWrap: true, // Allows text to wrap
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                  )
                : Text(
                    cellData,
                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                    softWrap: true, // Allows text to wrap
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                  );
  }
}
