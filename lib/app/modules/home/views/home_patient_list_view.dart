import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/app/modules/home/views/schedule_patient_dialog.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/empty_patient_screen.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../routes/app_pages.dart';
import '../model/patient_list_model.dart';

class HomePatientListView extends GetView<HomeController> {
  const HomePatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.patientList.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: EmptyPatientScreen(
                  onBtnPress: () async {
                    final result = await Get.toNamed(Routes.ADD_PATIENT);

                    if (result == 1) {
                      controller.getPastVisitList();
                      controller.getScheduleVisitList();
                      controller.getPatientList();
                    }
                  },
                  title: "Your Patient List is Empty",
                  description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place"),
            )
          : CustomTable(
              rows: _getTableRows(controller.patientList),
              columnCount: 6,
              // Number of columns in the table (for example, 6 here)
              cellBuilder: _buildTableCell,
              context: context,
              onLoadMore: () => controller.patientLoadMore(),
              columnWidths: [0.30, 0.09, 0.13, 0.18, 0.19, 0.10], // Set the column widths based on your needs
            );
    });
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
        patient.visits?.lastOrNull?.visitDate ?? "N/A", // Last Visit Date
        patient.pastVisitCount?.toString() ?? "0", // Previous Visits
        "Action",
        patient.profileImage ?? "" // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }

  // This is the cell builder function where you can customize how each cell is built.
  Widget _buildTableCell(BuildContext context, int rowIndex, int colIndex, String cellData, String profileImage) {
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
                            print(" patient id is ${controller.patientList[rowIndex - 1].id}");
                            Get.toNamed(Routes.PATIENT_PROFILE, arguments: {"patientData": controller.patientList[rowIndex - 1].id.toString(), "visitId": "", "fromSchedule": false});
                          },
                          // value: "",
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "View",
                              style: AppFonts.regular(14, AppColors.textBlack),
                            ),
                          )),
                      PopupMenuItem(
                          // value: "",
                          padding: EdgeInsets.zero,
                          onTap: () async {
                            print("row index is :- ${rowIndex}");
                            print("column index is :- ${colIndex}");
                            print(" patient id is  ${controller.patientList[rowIndex - 1].visits?.firstOrNull?.id.toString()} ");

                            // print(" our element is $");

                            final result =
                                await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {"patientData": controller.patientList[rowIndex - 1].id.toString(), "visitId": "", "fromSchedule": false});
                            print("our result is $result");

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
                                    print("p0 is $p0 p1 is $p1");
                                    controller.patientScheduleCreate(param: {"patient_id": controller.patientList[rowIndex - 1].id.toString(), "visit_date": p1, "visit_time": p0});
                                  },
                                ); // Our custom dialog
                              },
                            );

                            // controller.deletePatientById(controller.patientList[rowIndex - 1].visits!.first.id);
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
                          onTap: () {
                            controller.deletePatientById(controller.patientList[rowIndex - 1].visits!.first.id);
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
                ? GestureDetector(
                    onTap: () {
                      // controller.sortingSchedulePatient();
                      controller.patientSorting(colIndex: colIndex, cellData: cellData);
                      print(cellData);
                    },
                    child: Row(
                      mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: [
                        Text(
                          cellData,
                          textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                          style: AppFonts.regular(12, AppColors.black),
                          softWrap: true, // Allows text to wrap
                          overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                        ),
                        colIndex == controller.colIndexPatient.value && controller.isAsendingPatient.value && colIndex != 5
                            ? Icon(
                                CupertinoIcons.up_arrow,
                                size: 15,
                              )
                            : colIndex == controller.colIndexPatient.value && !controller.isAsendingPatient.value && colIndex != 5
                                ? Icon(
                                    CupertinoIcons.down_arrow,
                                    size: 15,
                                  )
                                : SizedBox()
                      ],
                    ),
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
