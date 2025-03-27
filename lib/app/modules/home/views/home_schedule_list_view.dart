import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/home/views/reschedule_patient_dialog.dart';
import 'package:subqdocs/app/modules/visit_main/controllers/visit_main_controller.dart';
import 'package:subqdocs/widgets/empty_patient_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../../visit_main/views/delete_schedule_visit.dart';
import '../controllers/home_controller.dart';
import '../model/schedule_visit_list_model.dart';
import 'customFilterListing.dart';

class HomeScheduleListView extends GetView<HomeController> {
  const HomeScheduleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Obx(() {
        return Column(
          children: [
            if (controller.globalController.scheduleFilterListingModel.isNotEmpty)
              CustomFilterListing(
                items: controller.globalController.scheduleFilterListingModel,
                oneClearAll: () {
                  controller.globalController.removeScheduleFilter();
                  controller.scheduleTriggeredIndexes.clear();
                  controller.getScheduleVisitList();
                },
                onDeleteItem: (value) {
                  controller.globalController.removeScheduleFilter(keyName: value);
                  controller.scheduleTriggeredIndexes.clear();
                  controller.getScheduleVisitList();
                },
              ),
            if (controller.globalController.scheduleFilterListingModel.isNotEmpty)
              SizedBox(
                height: 15,
              ),

            // Text("total data is the ${controller.scheduleVisitList.length}" , style: TextStyle( fontSize: 20),),
            controller.scheduleVisitList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: EmptyPatientScreen(
                        onBtnPress: () async {
                          controller.globalController.addRoute(Routes.ADD_PATIENT);
                          final result = await Get.toNamed(Routes.ADD_PATIENT);

                          controller.getPastVisitList();
                          controller.getScheduleVisitList();
                          controller.getPatientList();
                        },
                        title: "Your Schedule Visits List is Empty",
                        description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place"),
                  )
                : Expanded(
                    child: CustomTable(
                      onRefresh: () async {
                        controller.getScheduleVisitList(isFist: true);
                        print("refresh schedule list view");
                      },
                      scrollController: controller.scrollControllerSchedulePatientList,
                      physics: AlwaysScrollableScrollPhysics(),
                      rows: _getTableRows(controller.scheduleVisitList),
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
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      cellData,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      style: AppFonts.regular(14, AppColors.textDarkGrey),
                                      softWrap: true,
                                      // Allows text to wrap
                                      overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                    ),
                                  ),
                                ],
                              )
                            : colIndex == 5
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
                                              onTap: () async {
                                                customPrint("visite is is ${controller.scheduleVisitList[rowIndex].visitId.toString()}");
                                                controller.globalController.addRoute(Routes.PATIENT_PROFILE);
                                                await Get.toNamed(Routes.PATIENT_PROFILE, arguments: {
                                                  "patientData": controller.scheduleVisitList[rowIndex].id.toString(),
                                                  "visitId": controller.scheduleVisitList[rowIndex].visitId.toString(),
                                                  "fromSchedule": false
                                                });

                                                controller.getScheduleVisitList();
                                              },
                                              value: "",
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "View Patient",
                                                  style: AppFonts.regular(14, AppColors.textBlack),
                                                ),
                                              )),
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              value: "",
                                              onTap: () async {
                                                controller.globalController.addRoute(Routes.VISIT_MAIN);
                                                dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {
                                                  "visitId": controller.scheduleVisitList[rowIndex].visitId.toString(),
                                                  "patientId": controller.scheduleVisitList[rowIndex].id.toString(),
                                                  "unique_tag": DateTime.now().toString(),
                                                });

                                                print("back from response");

                                                controller.getPastVisitList();
                                                controller.getScheduleVisitList();
                                                controller.getPatientList();

                                                // final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {
                                                //   "patientData": controller.scheduleVisitList[rowIndex].id.toString(),
                                                //   "visitId": controller.scheduleVisitList[rowIndex].visitId.toString(),
                                                //   "fromSchedule": true
                                                // });
                                                //
                                                // if (result == 1) {
                                                //   controller.getScheduleVisitList();
                                                //   controller.getPastVisitList();
                                                //   controller.getPatientList();
                                                // }
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
                                                      "Start Visit",
                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              value: "",
                                              onTap: () async {
                                                // if (rowIndex != 0) {
                                                print("visit time is :- ${controller.scheduleVisitList[rowIndex].visitTime}");
                                                DateTime visitdate = DateTime.parse(controller.scheduleVisitList[rowIndex].visitTime ?? "");
                                                DateTime visitTimeS = DateTime.parse(controller.scheduleVisitList[rowIndex].visitTime ?? ""); // Parsing the string to DateTime
                                                // Formatting to "hh:mm a" format
                                                String formattedTime = DateFormat('hh:mm a').format(visitTimeS.toLocal());

                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                  builder: (BuildContext context) {
                                                    return HomeReschedulePatientDialog(
                                                      receiveParam: (p0, p1) {
                                                        customPrint("p0 is $p0 p1 is $p1");
                                                        controller
                                                            .patientReScheduleCreate(param: {"visit_date": p1, "visit_time": p0}, visitId: controller.scheduleVisitList[rowIndex].visitId.toString());
                                                      },
                                                      visitDate: visitdate,
                                                      selectedVisitTimeValue: RxnString(formattedTime),
                                                    ); // Our custom dialog
                                                  },
                                                );
                                                // }

                                                // final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {
                                                //   "patientData": controller.scheduleVisitList[rowIndex - 1].id.toString(),
                                                //   "visitId": controller.scheduleVisitList[rowIndex - 1].visitId.toString(),
                                                //   "fromSchedule": true
                                                // });
                                                //
                                                // if (result == 1) {
                                                //   controller.getScheduleVisitList();
                                                //   controller.getPastVisitList();
                                                //   controller.getPatientList();
                                                // }
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
                                                      "Reschedule",
                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                    ),
                                                  ),
                                                ],
                                              )),

                                          // PopupMenuItem(
                                          //     padding: EdgeInsets.zero,
                                          //     value: "",
                                          //     onTap: () async {
                                          //       final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {
                                          //         "patientData": controller.scheduleVisitList[rowIndex].id.toString(),
                                          //         "visitId": controller.scheduleVisitList[rowIndex].visitId.toString(),
                                          //         "fromSchedule": true
                                          //       });
                                          //
                                          //       if (result == 1) {
                                          //         controller.getScheduleVisitList();
                                          //         controller.getPastVisitList();
                                          //         controller.getPatientList();
                                          //       }
                                          //     },
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
                                          //             "Edit",
                                          //             style: AppFonts.regular(14, AppColors.textBlack),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     )),
                                          // PopupMenuItem(
                                          //     padding: EdgeInsets.zero,
                                          //     value: "",
                                          //     onTap: () {
                                          //       if (rowIndex != 0) {
                                          //         showDialog(
                                          //           context: context,
                                          //           barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                          //           builder: (BuildContext context) {
                                          //             return DeletePatientDialog(
                                          //               title: "Are you sure want to delete schedule",
                                          //               onDelete: () {
                                          //                 print("delete id is :- ${controller.patientList[rowIndex].id}");
                                          //                 Get.back();
                                          //                 controller.deletePatientById(controller.scheduleVisitList[rowIndex].id);
                                          //               },
                                          //               header: "Delete Schedule",
                                          //             ); // Our custom dialog
                                          //           },
                                          //         );
                                          //       }
                                          //     },
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
                                          //     )),
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              value: "",
                                              onTap: () {
                                                // if (rowIndex != 0) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext context) {
                                                    // return SizedBox();
                                                    return DeleteScheduleVisit(
                                                      onDelete: () {
                                                        controller.changeStatus("Cancelled", controller.scheduleVisitList[rowIndex].visitId.toString());
                                                        // controller.deletePatientVisit(id: controller.scheduleVisitList[rowIndex].visitId.toString());
                                                      },
                                                    );
                                                  },
                                                );

                                                // showDialog(
                                                //   context: context,
                                                //   barrierDismissible:
                                                //   true, // Allows dismissing the dialog by tapping outside
                                                //   builder: (BuildContext context) {
                                                //     return DeletePatientDialog(
                                                //       title: "Are you sure want to delete schedule",
                                                //       onDelete: () {
                                                //         print("delete id is :- ${controller.patientList[rowIndex - 1].id}");
                                                //         Get.back();
                                                //         controller.deletePatientById(
                                                //             controller.scheduleVisitList[rowIndex - 1].id);
                                                //       },
                                                //       header: "Delete Schedule",
                                                //     ); // Our custom dialog
                                                //   },
                                                // );
                                                // }
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
                                                      "Cancel Visit",
                                                      style: AppFonts.regular(14, AppColors.textBlack),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                    child: Container(
                                      color: AppColors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                                        child: SvgPicture.asset(
                                          "assets/images/logo_threedots.svg",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ))
                                : Text(
                                    cellData,
                                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                                    softWrap: true, // Allows text to wrap
                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                  );

                        // rowIndex == 0
                        //             ? GestureDetector(
                        //                 onTap: () {
                        //                   customPrint(cellData);
                        //
                        //                   controller.scheduleSorting(cellData: cellData, colIndex: colIndex);
                        //                 },
                        //                 child: Row(
                        //                   mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       cellData,
                        //                       textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                        //                       style: AppFonts.regular(12, AppColors.black),
                        //                       softWrap: true, // Allows text to wrap
                        //                       overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                        //                     ),
                        //                     colIndex == controller.colindexSchedule.value && controller.isAsendingSchedule.value && colIndex != 5
                        //                         ? Icon(
                        //                             CupertinoIcons.down_arrow,
                        //                             size: 15,
                        //                           )
                        //                         : colIndex == controller.colindexSchedule.value && !controller.isAsendingSchedule.value && colIndex != 5
                        //                             ? Icon(
                        //                                 CupertinoIcons.up_arrow,
                        //                                 size: 15,
                        //                               )
                        //                             : SizedBox()
                        //                   ],
                        //                 ),
                        //               )
                        //             : Text(
                        //                 cellData,
                        //                 textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                        //                 style: AppFonts.regular(14, AppColors.textDarkGrey),
                        //                 softWrap: true, // Allows text to wrap
                        //                 overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                        //               );
                      },
                      columnCount: 6,
                      context: context,
                      columnWidths: [0.30, 0.20, 0.10, 0.12, 0.19, 0.09],
                      onRowSelected: (rowIndex, rowData) async {
                        // if (rowIndex != 0) {
                        customPrint("row index is :- $rowIndex");

                        // Get.delete<VisitMainController>();
                        controller.globalController.addRoute(Routes.VISIT_MAIN);
                        dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {
                          "visitId": controller.scheduleVisitList[rowIndex].visitId.toString(),
                          "patientId": controller.scheduleVisitList[rowIndex].id.toString(),
                          "unique_tag": DateTime.now().toString(),
                        });

                        print("back from response");

                        controller.getPastVisitList();
                        controller.getScheduleVisitList();
                        controller.getPatientList();
                        // }
                      },
                      onLoadMore: () async {
                        controller.getScheduleVisitListFetchMore();
                      },
                      headerBuilder: (context, colIndex) {
                        List<String> headers = ['Patient Name', 'Visit Date & Time', 'Age', "Gender", "Previous Visits", "Action"];
                        return GestureDetector(
                          onTap: () {
                            // customPrint(cellData);
                            if (colIndex != 5) {
                              controller.scheduleSorting(cellData: headers[colIndex], colIndex: colIndex);

                              // controller.globalController.homeScheduleListSortingModel.value?.colIndex = colIndex;
                              // controller.globalController.homeScheduleListSortingModel.value?.isAscending =
                              //     controller.getDescValue(controller.globalController.sortingSchedulePatient, headers[colIndex], 1) ?? false;
                            }
                          },
                          child: Obx(() {
                            return Container(
                              color: AppColors.backgroundWhite,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                children: [
                                  Text(
                                    headers[colIndex],
                                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                    style: AppFonts.medium(12, AppColors.black),
                                    softWrap: true, // Allows text to wrap
                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                  ),
                                  colIndex == controller.globalController.homeScheduleListSortingModel.value?.colIndex &&
                                          controller.globalController.homeScheduleListSortingModel.value!.isAscending &&
                                          colIndex != 5
                                      ? Icon(
                                          CupertinoIcons.down_arrow,
                                          size: 15,
                                        )
                                      : colIndex == controller.globalController.homeScheduleListSortingModel.value?.colIndex &&
                                              !controller.globalController.homeScheduleListSortingModel.value!.isAscending &&
                                              colIndex != 5
                                          ? Icon(
                                              CupertinoIcons.up_arrow,
                                              size: 15,
                                            )
                                          : SizedBox()
                                ],
                              ),
                            );
                          }),
                        );
                      },
                      isLoading: controller.isLoading.value,
                      isNoData: controller.noMoreDataSchedulePatientList.value,
                      // headerRows: ['Patient Name', 'Visit Date & Time', 'Age', "Gender", "Previous Visits", "Action"],
                    ),
                  ),
          ],
        );
      }),
    );
  }

  List<List<String>> _getTableRows(List<ScheduleVisitListData> patients) {
    List<List<String>> rows = [];

    // Add header row first
    // rows.add(
    //   ['Patient Name', 'Visit Date & Time', 'Age', "Gender", "Previous Visits", "Action"],
    // );

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      // Parse the string to DateTime

      String formatedDateTime = "";

      if (patient.appointmentTime != null && patient.visitDate != null) {
        DateTime dateTime = DateTime.parse(patient.appointmentTime ?? "").toLocal();
        DateTime formatdateLocal = DateTime.parse(patient.visitDate ?? "");

        formatedDateTime = "${DateFormat('MM/dd').format(formatdateLocal)} ${DateFormat('h:mm a').format(dateTime)}";
      }

      rows.add([
        "${patient.firstName} ${patient.lastName}",
        formatedDateTime, // Last Visit Date// Patient Name
        patient.age.toString(), // Age
        patient.gender.toString()[0], // Gender
        patient.previousVisitCount.toString(), // Previous Visits
        "Action",
        patient.profileImage ?? "" // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
