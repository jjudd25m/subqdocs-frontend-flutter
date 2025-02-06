import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../model/schedule_visit_list_model.dart';

class HomePastVisitsList extends GetView<HomeController> {
  const HomePastVisitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomTable(
        rows: _getTableRows(controller.scheduleVisitList),
        cellBuilder: (context, rowIndex, colIndex, cellData) {
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
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 6),
                          child: Text(
                            cellData,
                            textAlign: TextAlign.center,
                            style: AppFonts.medium(14, AppColors.orangeText),
                          ),
                        ),
                      ),
                    )
                  : colIndex == 6 && rowIndex != 0
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
                                      Get.toNamed(Routes.PATIENT_PROFILE);
                                    },
                                    value: "",
                                    child: Text(
                                      "View",
                                      style: AppFonts.regular(14, AppColors.textBlack),
                                    )),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                    value: "",
                                    onTap: () {
                                      Get.toNamed(Routes.EDIT_PATENT_DETAILS);
                                    },
                                    child: Text(
                                      "Edit",
                                      style: AppFonts.regular(14, AppColors.textBlack),
                                    )),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                    value: "",
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
        },
        columnCount: 7,
        context: context,
        columnWidths: [0.23, 0.15, 0.08, 0.09, 0.16, 0.19, 0.10],
      ),
    );
  }

  List<List<String>> _getTableRows(List<ScheduleVisitListData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    rows.add(['Patient Name', 'Visit Date', 'Age', "Gender", "Previous Visits", "Status", "Action"]);

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      rows.add([
        "${patient.lastName}, ${patient.firstName}", // Patient Name
        patient.visitDate ?? "N/A", // Last Visit Date
        patient.age.toString(), // Age
        patient.gender ?? "N/A", // Gender
        patient.previousVisitCount.toString() ?? "N/A", // Last Visit Date
        patient.status ?? "0", // Previous Visits
        "Action", // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
