import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

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
        return controller.scheduleVisitList.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "No Patients Found",
                  style: AppFonts.medium(20, AppColors.black),
                ),
              )
            : CustomTable(
                rows: _getTableRows(controller.scheduleVisitList),
                cellBuilder: (context, rowIndex, colIndex, cellData) {
                  return colIndex == 0 && rowIndex != 0
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.VISIT_MAIN, arguments: {
                                  "visitId": controller.scheduleVisitList[rowIndex - 1].visitId.toString(),
                                });
                              },
                              child: RoundedImageWidget(
                                size: 28,
                                imagePath: "assets/images/user.png",
                              ),
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
                                        padding: EdgeInsets.zero,
                                        onTap: () {
                                          print(
                                              "visite is is ${controller.scheduleVisitList[rowIndex - 1].visitId.toString()}");

                                          Get.toNamed(Routes.PATIENT_PROFILE, arguments: {
                                            "patientData":
                                                controller.scheduleVisitList[rowIndex - 1].visitId.toString(),
                                            "fromSchedule": false
                                          });
                                        },
                                        value: "",
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "View",
                                            style: AppFonts.regular(14, AppColors.textBlack),
                                          ),
                                        )),
                                    PopupMenuItem(
                                        padding: EdgeInsets.zero,
                                        value: "",
                                        onTap: () async {
                                          final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {
                                            "patientData":
                                                controller.scheduleVisitList[rowIndex - 1].visitId.toString(),
                                            "fromSchedule": true
                                          });

                                          if (result == 1) {
                                            controller.getScheduleVisitList();
                                            controller.getPastVisitList();
                                            controller.getPatientList();
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: AppColors.appbarBorder,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Edit",
                                                style: AppFonts.regular(14, AppColors.textBlack),
                                              ),
                                            ),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        padding: EdgeInsets.zero,
                                        value: "",
                                        onTap: () {
                                          controller
                                              .deletePatientById(controller.scheduleVisitList[rowIndex - 1].visitId);
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: AppColors.appbarBorder,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Delete",
                                                style: AppFonts.regular(14, AppColors.textBlack),
                                              ),
                                            ),
                                          ],
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
                columnWidths: [0.38, 0.20, 0.07, 0.1, 0.15, 0.10],
                onLoadMore: () {
                  controller.getScheduleVisitListFetchMore();
                },
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
      // Parse the string to DateTime
      DateTime parsedDate = DateTime.parse(patient.visitDate ?? "").toLocal(); // Convert to local time if needed

      // Define the desired format
      String formattedDate = DateFormat('MM/dd hh:mm a').format(parsedDate);
      rows.add([
        "${patient.lastName}, ${patient.firstName}",
        formattedDate ?? "N/A", // Last Visit Date// Patient Name
        patient.age.toString(), // Age
        patient.gender ?? "N/A", // Gender
        patient.previousVisitCount.toString() ?? "0", // Previous Visits
        "Action", // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
