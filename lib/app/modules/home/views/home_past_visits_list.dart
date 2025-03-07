import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/views/schedule_patient_dialog.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/empty_patient_screen.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../model/schedule_visit_list_model.dart';

class HomePastVisitsList extends GetView<HomeController> {
  const HomePastVisitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: controller.pastVisitList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: EmptyPatientScreen(
                      onBtnPress: () async {
                        final result = await Get.toNamed(Routes.ADD_PATIENT);

                        controller.getPastVisitList();
                        controller.getScheduleVisitList();
                        controller.getPatientList();
                      },
                      title: "Your Past Visit List is Empty",
                      description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place"),
                )
              : CustomTable(
                  onLoadMore: () => controller.getPastVisitListFetchMore(),
                  rows: _getTableRows(controller.pastVisitList),
                  onRowSelected: (rowIndex, rowData) {
                    customPrint("row index is :- $rowIndex");

                    Get.toNamed(Routes.PATIENT_INFO, arguments: {
                      "visitId": controller.pastVisitList[rowIndex - 1].visitId.toString(),
                    });
                  },
                  cellBuilder: (context, rowIndex, colIndex, cellData, profileImage) {
                    return colIndex == 0 && rowIndex != 0
                        ? Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: BaseImageView(
                                    imageUrl: profileImage,
                                    height: 28,
                                    width: 28,
                                    nameLetters: cellData,
                                    fontSize: 12,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  cellData,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: AppFonts.regular(14, AppColors.textDarkGrey),
                                  softWrap: true, // Allows text to wrap
                                  overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                ),
                              ),
                            ],
                          )
                        : colIndex == 5 && rowIndex != 0
                            ? Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightgreenPastVisit,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 6),
                                    child: Text(
                                      cellData,
                                      textAlign: TextAlign.center,
                                      style: AppFonts.medium(13, AppColors.greenPastVisit),
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
                                              padding: EdgeInsets.zero,
                                              onTap: () {
                                                customPrint("visite is is ${controller.pastVisitList[rowIndex - 1].visitId.toString()}");

                                                Get.toNamed(Routes.PATIENT_PROFILE, arguments: {
                                                  "patientData": controller.pastVisitList[rowIndex - 1].id.toString(),
                                                  "visitId": controller.pastVisitList[rowIndex - 1].visitId.toString(),
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
                                                // Get.toNamed(Routes.EDIT_PATENT_DETAILS);

                                                final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {
                                                  "patientData": controller.pastVisitList[rowIndex - 1].id.toString(),
                                                  "visitId": controller.pastVisitList[rowIndex - 1].visitId.toString(),
                                                  "fromSchedule": false
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
                                              // value: "",
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                  builder: (BuildContext context) {
                                                    return SchedulePatientDialog(
                                                      receiveParam: (p0, p1) {
                                                        customPrint("p0 is $p0 p1 is $p1");
                                                        controller
                                                            .patientScheduleCreate(param: {"patient_id": controller.pastVisitList[rowIndex - 1].id.toString(), "visit_date": p1, "visit_time": p0});
                                                      },
                                                    ); // Our custom dialog
                                                  },
                                                );
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
                                                      "Schedule",
                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              // value: "",
                                              onTap: () async {
                                                dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {
                                                  "visitId": controller.pastVisitList[rowIndex - 1].visitId.toString(),
                                                  "patientId": controller.pastVisitList[rowIndex - 1].id.toString(),
                                                });

                                                print("back from response");

                                                // showDialog(
                                                //   context: context,
                                                //   barrierDismissible:
                                                //   true, // Allows dismissing the dialog by tapping outside
                                                //   builder: (BuildContext context) {
                                                //     return SchedulePatientDialog(
                                                //       receiveParam: (p0, p1) {
                                                //         customPrint("p0 is $p0 p1 is $p1");
                                                //         controller.patientScheduleCreate(param: {
                                                //           "patient_id":
                                                //           controller.pastVisitList[rowIndex - 1].id.toString(),
                                                //           "visit_date": p1,
                                                //           "visit_time": p0
                                                //         });
                                                //       },
                                                //     ); // Our custom dialog
                                                //   },
                                                // );
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
                                                      "Medical record",
                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          // PopupMenuItem(
                                          //     padding: EdgeInsets.zero,
                                          //     value: "",
                                          //     onTap: () {},
                                          //     child: Column(
                                          //       crossAxisAlignment: CrossAxisAlignment.start,
                                          //       children: [
                                          //         Container(
                                          //           width: double.infinity,
                                          //           height: 1,
                                          //           color: AppColors.appbarBorder,
                                          //         ),
                                          //         Padding(
                                          //           padding: const EdgeInsets.all(8.0),
                                          //           child: Text(
                                          //             "Delete",
                                          //             style: AppFonts.regular(14, AppColors.textBlack),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ))
                                        ],
                                    child: SvgPicture.asset(
                                      "assets/images/logo_threedots.svg",
                                      width: 20,
                                      height: 20,
                                    ))
                                : rowIndex == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          customPrint(" data is the $cellData");
                                          controller.getPastVisitList(sortingName: cellData);
                                          controller.colIndex.value = colIndex;

                                          controller.isAsending.value = controller.getDescValue(controller.sortingPastPatient, cellData) ?? false;
                                          controller.colIndex.refresh();
                                          controller.isAsending.refresh();
                                          customPrint("col index is the $colIndex");
                                          customPrint(controller.getDescValue(controller.sortingPastPatient, cellData));
                                        },
                                        child: Row(
                                          mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cellData,
                                              maxLines: 2,
                                              textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                              style: AppFonts.regular(12, AppColors.black),
                                              softWrap: true, // Allows text to wrap
                                              overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                            ),
                                            colIndex == controller.colIndex.value && controller.isAsending.value && colIndex != 6
                                                ? Icon(
                                                    CupertinoIcons.down_arrow,
                                                    size: 15,
                                                  )
                                                : colIndex == controller.colIndex.value && !controller.isAsending.value && colIndex != 6
                                                    ? Icon(
                                                        CupertinoIcons.up_arrow,
                                                        size: 15,
                                                      )
                                                    : SizedBox()
                                          ],
                                        ),
                                      )
                                    : Text(
                                        cellData,
                                        maxLines: 2,
                                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                        style: AppFonts.regular(14, AppColors.textDarkGrey),
                                        softWrap: true, // Allows text to wrap
                                        overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                      );
                  },
                  columnCount: 7,
                  context: context,
                  columnWidths: [0.20, 0.17, 0.08, 0.11, 0.14, 0.19, 0.10],
                ),
        );
      },
    );
  }

  List<List<String>> _getTableRows(List<ScheduleVisitListData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    rows.add(['Patient Name', 'Visit Date', 'Age', "Gender", "Previous \nVisits", "Status", "Action"]);

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      String formatedDateTime = "N/A";

      if (patient.appointmentTime != null && patient.visitDate != null) {
        DateTime dateTime = DateTime.parse(patient.appointmentTime ?? "").toLocal();
        DateTime formatdateLocal = DateTime.parse(patient.visitDate ?? "");

        formatedDateTime = "${DateFormat('MM/dd').format(formatdateLocal)} ${DateFormat('h:mm a').format(dateTime)}";
      }

      // if (patient.appointmentTime != null) {
      //   DateTime dateTime = DateTime.parse(patient.appointmentTime ?? "");
      //
      //   DateTime formatdateLocal = DateTime.parse(patient.visitDate ?? "");
      //
      //   formatedDateTime = "${DateFormat('MM/dd').format(formatdateLocal)} ${DateFormat('h:mm a').format(dateTime)}";
      // }

      String getFirstLetter(String input) {
        return input.isNotEmpty ? input[0] : '';
      }

      rows.add([
        "${patient.firstName} ${patient.lastName}", // Patient Name
        formatedDateTime, // Last Visit Date
        patient.age.toString(), // Age
        patient.gender.toString()[0], // Gender
        patient.previousVisitCount.toString(), // Last Visit Date
        patient.visitStatus ?? "0", // Previous Visits
        "Action",
        patient.profileImage ?? ""

        // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
