import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/model/FilterListingModel.dart';
import 'package:subqdocs/app/modules/home/views/schedule_patient_dialog.dart';
import 'package:subqdocs/app/modules/patient_info/controllers/patient_info_controller.dart';

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
import 'customFilterListing.dart';

class HomePastVisitsList extends GetView<HomeController> {
  const HomePastVisitsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Obx(
        () {
   return Column(
                children: [

                  if(controller.globalController.pastFilterListingModel.isNotEmpty)
                  CustomFilterListing(items: controller.globalController.pastFilterListingModel,
                  onDeleteItem: (value) {
                    controller.globalController.removePastFilter(keyName: value);
                    controller.getPastVisitList();
                  },
                    oneClearAll: () {
                      controller.globalController.removePastFilter();
                      controller.getPastVisitList();
                    },
                  ),
                  if(controller.globalController.pastFilterListingModel.isNotEmpty)
                  SizedBox(height: 15,),

                  controller.pastVisitList.isEmpty
                  ? Padding(
                  padding: const EdgeInsets.all(10.0),
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
                      :
                  Expanded(
                    child: CustomTable(
                        onLoadMore: () => controller.getPastVisitListFetchMore(),
                        rows: _getTableRows(controller.pastVisitList),
                        onRowSelected: (rowIndex, rowData) async {
                          customPrint("row index is :- $rowIndex");

                          Get.delete<PatientInfoController>();

                          await Get.toNamed(Routes.PATIENT_INFO, arguments: {
                            "visitId": controller.pastVisitList[rowIndex].visitId.toString(),
                            "patientId": controller.pastVisitList[rowIndex].id.toString(),
                            "unique_tag": DateTime.now().toString(),
                          });

                          controller.getPastVisitList();
                          controller.getScheduleVisitList();
                          controller.getPatientList();
                        },
                        cellBuilder: (context, rowIndex, colIndex, cellData, profileImage) {
                          return colIndex == 0
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
                              : colIndex == 5
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: cellData == "Finalized" ? AppColors.lightgreenPastVisit : AppColors.orange,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 6),
                                          child: Text(
                                            cellData,
                                            textAlign: TextAlign.center,
                                            style: AppFonts.medium(13, cellData == "Finalized" ? AppColors.greenPastVisit : AppColors.orangeText),
                                          ),
                                        ),
                                      ),
                                    )
                                  : colIndex == 6
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
                                                      customPrint("visite is is ${controller.pastVisitList[rowIndex].visitId.toString()}");

                                                      Get.toNamed(Routes.PATIENT_PROFILE, arguments: {
                                                        "patientData": controller.pastVisitList[rowIndex].id.toString(),
                                                        "visitId": controller.pastVisitList[rowIndex].visitId.toString(),
                                                        "fromSchedule": false
                                                      });
                                                    },
                                                    value: "",
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Patient Details",
                                                        style: AppFonts.regular(14, AppColors.textBlack),
                                                      ),
                                                    )),
                                                PopupMenuItem(
                                                    padding: EdgeInsets.zero,
                                                    value: "",
                                                    onTap: () async {
                        customPrint("row index is :- $rowIndex");

                        Get.delete<PatientInfoController>();

                        await Get.toNamed(Routes.PATIENT_INFO, arguments: {
                        "visitId": controller.pastVisitList[rowIndex].visitId.toString(),
                        "patientId": controller.pastVisitList[rowIndex].id.toString(),
                        "unique_tag": DateTime.now().toString(),
                        });

                        controller.getPastVisitList();
                        controller.getScheduleVisitList();
                        controller.getPatientList();

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
                                                            "view visit",
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
                                                              controller.patientScheduleCreate(param: {"patient_id": controller.pastVisitList[rowIndex].id.toString(), "visit_date": p1, "visit_time": p0});
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


                                                      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                                      controller.patientScheduleCreate(param: {"patient_id": controller.pastVisitList[rowIndex].id.toString(), "visit_date": date, "visit_time": controller.getNextRoundedTimeHH()});
                                                      // dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {
                                                      //   "visitId": controller.pastVisitList[rowIndex].visitId.toString(),
                                                      //   "patientId": controller.pastVisitList[rowIndex].id.toString(),
                                                      //   "unique_tag": DateTime.now().toString(),
                                                      // });
                                                      //
                                                      // print("back from response");

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
                                                            "start now",
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
                                      : Text(
                                          cellData,
                                          maxLines: 2,
                                          textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                          style: AppFonts.regular(14, AppColors.textDarkGrey),
                                          softWrap: true, // Allows text to wrap
                                          overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                        );

                          // rowIndex == 0
                          //                 ? GestureDetector(
                          //                     onTap: () {
                          //                       customPrint(" data is the $cellData");
                          //                       controller.getPastVisitList(sortingName: cellData);
                          //                       controller.colIndex.value = colIndex;
                          //
                          //                       controller.isAsending.value = controller.getDescValue(controller.sortingPastPatient, cellData) ?? false;
                          //                       controller.colIndex.refresh();
                          //                       controller.isAsending.refresh();
                          //                       customPrint("col index is the $colIndex");
                          //                       // customPrint(controller.getDescValue(controller.sortingPastPatient, cellData));
                          //                     },
                          //                     child: Row(
                          //                       mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                          //                       children: [
                          //                         Text(
                          //                           cellData,
                          //                           maxLines: 2,
                          //                           textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                          //                           style: AppFonts.regular(12, AppColors.black),
                          //                           softWrap: true, // Allows text to wrap
                          //                           overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                          //                         ),
                          //                         colIndex == controller.colIndex.value && controller.isAsending.value && colIndex != 6
                          //                             ? Icon(
                          //                                 CupertinoIcons.down_arrow,
                          //                                 size: 15,
                          //                               )
                          //                             : colIndex == controller.colIndex.value && !controller.isAsending.value && colIndex != 6
                          //                                 ? Icon(
                          //                                     CupertinoIcons.up_arrow,
                          //                                     size: 15,
                          //                                   )
                          //                                 : SizedBox()
                          //                       ],
                          //                     ),
                          //                   )
                          //                 : Text(
                          //                     cellData,
                          //                     maxLines: 2,
                          //                     textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                          //                     style: AppFonts.regular(14, AppColors.textDarkGrey),
                          //                     softWrap: true, // Allows text to wrap
                          //                     overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                          //                   );
                        },
                        columnCount: 7,
                        context: context,
                        columnWidths: [0.20, 0.17, 0.08, 0.11, 0.14, 0.19, 0.10],
                        headerBuilder: (context, colIndex) {
                          List<String> headers = ['Patient Name', 'Visit Date', 'Age', "Gender", "Previous \nVisits", "Status", "Action"];
                          return GestureDetector(
                            onTap: () {
                              if (colIndex != 6) {
                                customPrint(" data is the ${headers[colIndex]}");
                                controller.getPastVisitList(sortingName: headers[colIndex]);

                                controller.globalController.homePastPatientListSortingModel.value?.colIndex = colIndex;
                                controller.globalController.homePastPatientListSortingModel.value?.isAscending =
                                    controller.getDescValue(controller.globalController.sortingPastPatient, headers[colIndex], 2) ?? false;

                                // controller.colIndex.value = colIndex;

                                // controller.isAsending.value = controller.getDescValue(controller.globalController.sortingPastPatient, headers[colIndex], 2) ?? false;
                                // controller.colIndex.refresh();
                                // controller.isAsending.refresh();
                                customPrint("col index is the $colIndex");
                              }

                              // customPrint(controller.getDescValue(controller.sortingPastPatient, cellData));
                            },
                            child: Container(
                              color: AppColors.backgroundWhite,
                              height: 40,
                              // color: AppColors.backgroundPurple,
                              child: Row(
                                mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                children: [
                                  Text(
                                    headers[colIndex],
                                    maxLines: 2,
                                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                    style: AppFonts.medium(12, AppColors.black),
                                    softWrap: true, // Allows text to wrap
                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                  ),
                                  colIndex == controller.globalController.homePastPatientListSortingModel.value?.colIndex &&
                                          controller.globalController.homePastPatientListSortingModel.value!.isAscending &&
                                          colIndex != 6
                                      ? Icon(
                                          CupertinoIcons.down_arrow,
                                          size: 15,
                                        )
                                      : colIndex == controller.globalController.homePastPatientListSortingModel.value?.colIndex &&
                                              !controller.globalController.homePastPatientListSortingModel.value!.isAscending &&
                                              colIndex != 6
                                          ? Icon(
                                              CupertinoIcons.up_arrow,
                                              size: 15,
                                            )
                                          : SizedBox()
                                ],
                              ),
                            ),
                          );
                        },
                        isLoading: controller.isLoading.value,
                        // headerRows: ['Patient Name', 'Visit Date', 'Age', "Gender", "Previous \nVisits", "Status", "Action"],
                      ),
                  ),
                ],
              );
        },
      ),
    );
  }

  List<List<String>> _getTableRows(List<ScheduleVisitListData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    // rows.add(['Patient Name', 'Visit Date', 'Age', "Gender", "Previous \nVisits", "Status", "Action"]);

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
