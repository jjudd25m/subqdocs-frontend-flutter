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

class HomeScheduleListView extends GetView<HomeController> {
  const HomeScheduleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Obx(() {
        return CustomTable(
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
          columnCount: 6,
          context: context,
          columnWidths: [0.43, 0.20, 0.05, 0.1, 0.15, 0.07],
        );
      }),
    );
  }

  List<List<String>> _getTableRows(List<ScheduleVisitListData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    rows.add(
      ['Patient Name', 'Visit Date & Time', 'Age', "Gender", "Previous Visits", "Action"],
    );

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      rows.add([
        "${patient.lastName}, ${patient.firstName}",
        patient.visits?.last.visitDate ?? "N/A", // Last Visit Date// Patient Name
        patient.age.toString(), // Age
        patient.gender ?? "N/A", // Gender
        patient.pastVisitCount?.toString() ?? "0", // Previous Visits
        "Action", // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
