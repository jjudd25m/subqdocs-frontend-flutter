import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:subqdocs/widgets/empty_patient_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/custom_table.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../visit_main/views/delete_schedule_visit.dart';
import '../controllers/home_controller.dart';
import '../model/schedule_visit_list_model.dart';
import 'customFilterListing.dart';
import 'home_reschedule_patient_dialog.dart';

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
            if (controller.globalController.scheduleFilterListingModel.isNotEmpty) const SizedBox(height: 15),
            controller.scheduleVisitList.isEmpty
                ? controller.isHomeScheduleListLoading.value
                    ? const Padding(padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10), child: Center(child: CircularProgressIndicator()))
                    : Padding(
                      padding: const EdgeInsets.all(10),
                      child: EmptyPatientScreen(
                        onBtnPress: () async {
                          controller.globalController.addRoute(Routes.ADD_PATIENT);
                          final result = await Get.toNamed(Routes.ADD_PATIENT);

                          controller.getPastVisitList();
                          controller.getScheduleVisitList();
                          controller.getPatientList();
                        },
                        buttonTitle: "Schedule Visit",
                        title: "Your Schedule Visits List is Empty",
                        description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place",
                      ),
                    )
                : Expanded(
                  child: CustomTable(
                    onRefresh: () async {
                      controller.getScheduleVisitList(isFist: true);
                      customPrint("refresh schedule list view");
                    },
                    scrollController: controller.scrollControllerSchedulePatientList,
                    physics: const AlwaysScrollableScrollPhysics(),
                    rows: _getTableRows(controller.scheduleVisitList),
                    cellBuilder: (context, rowIndex, colIndex, cellData, profileImage) {
                      return colIndex == 0
                          ? Row(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(imageUrl: profileImage, height: 28, width: 28, nameLetters: cellData, fontSize: 12)),
                              const SizedBox(width: 10),
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
                          : colIndex == 6
                          ? PullDownButton(
                            routeTheme: const PullDownMenuRouteTheme(backgroundColor: AppColors.white),
                            itemBuilder:
                                (context) => [
                                  PullDownMenuItem(
                                    title: 'Start Visit',
                                    onTap: () async {
                                      // controller.globalController.addRoute(Routes.VISIT_MAIN);
                                      // dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": controller.scheduleVisitList[rowIndex].visitId.toString(), "patientId": controller.scheduleVisitList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});
                                      //
                                      // controller.globalController.isStartTranscript.refresh();

                                      controller.startVisit(controller.scheduleVisitList[rowIndex].id.toString(), controller.scheduleVisitList[rowIndex].visitId.toString(), controller.scheduleVisitList[rowIndex].firstName ?? "", controller.scheduleVisitList[rowIndex].lastName ?? "");

                                      customPrint("back from response");

                                      controller.getPastVisitList();
                                      controller.getScheduleVisitList();
                                      controller.getPatientList();
                                    },
                                  ),
                                  PullDownMenuItem(
                                    title: 'View Patient',
                                    onTap: () async {
                                      customPrint("visite is is ${controller.scheduleVisitList[rowIndex].visitId.toString()}");
                                      controller.globalController.addRoute(Routes.PATIENT_PROFILE);
                                      await Get.toNamed(Routes.PATIENT_PROFILE, arguments: {"patientData": controller.scheduleVisitList[rowIndex].id.toString(), "visitId": controller.scheduleVisitList[rowIndex].visitId.toString(), "fromSchedule": false});

                                      controller.getScheduleVisitList();
                                    },
                                  ),
                                  if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                                    PullDownMenuItem(
                                      title: 'Reschedule',
                                      onTap: () {
                                        customPrint("visit time is :- ${controller.scheduleVisitList[rowIndex].visitTime}");
                                        DateTime visitdate = DateTime.parse(controller.scheduleVisitList[rowIndex].visitTime ?? "");
                                        DateTime visitTimeS = DateTime.parse(controller.scheduleVisitList[rowIndex].visitTime ?? ""); // Parsing the string to DateTime
                                        // Formatting to "hh:mm a" format
                                        String formattedTime = DateFormat('hh:mm a').format(visitTimeS.toLocal());

                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          // Allows dismissing the dialog by tapping outside
                                          builder: (BuildContext context) {
                                            print("medical record is :- ${controller.globalController.selectedMedicalModel.value}");

                                            return HomeReschedulePatientDialog(
                                              receiveParam: (p0, p1, doctorId, medicalId) {
                                                customPrint("p0 is $p0 p1 is $p1");

                                                Map<String, dynamic> param = {};

                                                param['visit_date'] = p1;
                                                param['visit_time'] = p0;

                                                if (doctorId != -1) {
                                                  param['doctor_id'] = doctorId;
                                                }

                                                if (medicalId != -1) {
                                                  param['medical_assistant_id'] = medicalId;
                                                }
                                                controller.patientReScheduleCreate(visitDate: p1, visitTime: p0, rowIndex: rowIndex, doctorId: doctorId, param: param, visitId: controller.scheduleVisitList[rowIndex].visitId.toString());
                                              },
                                              visitDate: Rxn(visitdate),
                                              selectedDoctorValueSchedule: controller.scheduleVisitList[rowIndex].doctorName,

                                              selectedMedicalValueSchedule: controller.scheduleVisitList[rowIndex].medicalAssistantName,

                                              selectedVisitTimeValue: RxnString(formattedTime),
                                            ); // Our custom dialog
                                          },
                                        );
                                      },
                                    ),
                                    PullDownMenuItem(
                                      title: 'Cancel Visit',
                                      onTap: () {
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
                                      },
                                    ),
                                  ],
                                ],
                            buttonBuilder: (context, showMenu) => CupertinoButton(onPressed: showMenu, padding: EdgeInsets.zero, child: SvgPicture.asset("assets/images/logo_threedots.svg", width: 20, height: 20)),
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
                    columnWidths: const [0.23, 0.20, 0.15, 0.08, 0.10, 0.16, 0.08],
                    onRowSelected: (rowIndex, rowData) async {
                      customPrint("row index is :- $rowIndex");
                      controller.globalController.addRoute(Routes.VISIT_MAIN);
                      dynamic response = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": controller.scheduleVisitList[rowIndex].visitId.toString(), "patientId": controller.scheduleVisitList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});
                      controller.globalController.valueOfx.refresh();

                      controller.globalController.isStartTranscript.refresh();
                      customPrint("back from response");

                      controller.getPastVisitList();
                      controller.getScheduleVisitList();
                      controller.getPatientList();
                      // }
                    },
                    onLoadMore: () async {
                      controller.getScheduleVisitListFetchMore();
                    },
                    headerBuilder: (context, colIndex) {
                      List<String> headers = ['Patient Name', 'Visit Date & Time', 'Provider', 'Age', "Gender", "Previous Visits", "Action"];
                      return GestureDetector(
                        onTap: () {
                          if (colIndex != 6) {
                            controller.scheduleSorting(cellData: headers[colIndex], colIndex: colIndex);
                          }
                        },
                        child: Obx(() {
                          return Container(
                            color: AppColors.backgroundWhite,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    headers[colIndex],
                                    textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                    style: AppFonts.medium(12, AppColors.black),
                                    // softWrap: true,
                                    maxLines: 2,
                                    // Allows text to wrap
                                    // overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                  ),
                                ),
                                colIndex == controller.globalController.homeScheduleListSortingModel.value?.colIndex && controller.globalController.homeScheduleListSortingModel.value!.isAscending && colIndex != 6
                                    ? const Icon(CupertinoIcons.down_arrow, size: 15)
                                    : colIndex == controller.globalController.homeScheduleListSortingModel.value?.colIndex && !controller.globalController.homeScheduleListSortingModel.value!.isAscending && colIndex != 6
                                    ? const Icon(CupertinoIcons.up_arrow, size: 15)
                                    : const SizedBox(),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                    isLoading: controller.isLoading.value,
                    isNoData: controller.noMoreDataSchedulePatientList.value,
                  ),
                ),
          ],
        );
      }),
    );
  }

  List<List<String>> _getTableRows(List<ScheduleVisitListData> patients) {
    List<List<String>> rows = [];

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
        formatedDateTime,
        // Last Visit Date// Patient Name
        patient.doctorName?.trim() == "" ? 'N/A' : "Dr. ${patient.doctorName}" ?? "",
        patient.age != null ? patient.age.toString() : "N/A",
        // Age
        patient.gender.toString()[0],
        // Gender
        patient.previousVisitCount.toString(),
        // Previous Visits
        "Action",
        patient.profileImage ?? "",
        // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
