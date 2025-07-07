import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:subqdocs/app/modules/home/views/schedule_patient_dialog.dart';
import 'package:subqdocs/app/modules/patient_info/controllers/patient_info_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/empty_patient_screen.dart';
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
      child: Obx(() {
        return Column(
          children: [
            // if (controller.pastVisitList.isNotEmpty)
            if (controller.globalController.pastFilterListingModel.isNotEmpty)
              CustomFilterListing(
                items: controller.globalController.pastFilterListingModel,
                onDeleteItem: (value) {
                  controller.globalController.removePastFilter(keyName: value);
                  controller.pastTriggeredIndexes.clear();

                  controller.getPastVisitList();
                },
                oneClearAll: () {
                  controller.globalController.removePastFilter();
                  controller.pastTriggeredIndexes.clear();
                  controller.getPastVisitList();
                },
              ),
            if (controller.globalController.pastFilterListingModel.isNotEmpty) const SizedBox(height: 15),
            controller.pastVisitList.isEmpty
                ? controller.isHomePastPatientListLoading.value
                    ? const Padding(padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10), child: Center(child: CircularProgressIndicator()))
                    : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: EmptyPatientScreen(
                        onBtnPress: () async {
                          controller.globalController.addRoute(Routes.ADD_PATIENT);
                          final result = await Get.toNamed(Routes.ADD_PATIENT);

                          controller.getPastVisitList();
                          controller.getScheduleVisitList();
                          controller.getPatientList();
                        },
                        buttonTitle: "Schedule Visit",
                        title: "Your Past Visit List is Empty",
                        description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place",
                      ),
                    )
                : Expanded(
                  child: CustomTable(
                    scrollController: controller.scrollControllerPastPatientList,
                    physics: const AlwaysScrollableScrollPhysics(),
                    onRefresh: () async {
                      controller.getPastVisitList(isFist: true);
                      print("refresh past list view");
                      controller.pagePast = 1;
                    },
                    onLoadMore: () => controller.getPastVisitListFetchMore(),
                    rows: _getTableRows(controller.pastVisitList),
                    onRowSelected: (rowIndex, rowData) async {
                      customPrint("row index is :- $rowIndex");
                      Get.delete<PatientInfoController>();
                      controller.globalController.addRoute(Routes.PATIENT_INFO);
                      await Get.toNamed(Routes.PATIENT_INFO, arguments: {"visitId": controller.pastVisitList[rowIndex].visitId.toString(), "patientId": controller.pastVisitList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});
                      controller.getPastVisitList();
                      controller.getScheduleVisitList();
                      controller.getPatientList();
                    },
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
                          ? Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              decoration: BoxDecoration(color: controller.getStatusColor(cellData).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text(cellData, maxLines: 2, overflow: TextOverflow.visible, textAlign: TextAlign.center, style: AppFonts.medium(13, controller.getStatusColor(cellData)))),
                            ),
                          )
                          : colIndex == 7
                          ? PullDownButton(
                            routeTheme: const PullDownMenuRouteTheme(backgroundColor: AppColors.white),
                            itemBuilder:
                                (context) => [
                                  if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                                    PullDownMenuItem(
                                      title: 'Start Visit',
                                      onTap: () async {
                                        String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                        controller.pastPatientStartNow(controller.pastVisitList[rowIndex].id.toString(), controller.pastVisitList[rowIndex].firstName ?? "", controller.pastVisitList[rowIndex].lastName ?? "", param: {"patient_id": controller.pastVisitList[rowIndex].id.toString(), "visit_date": date, "visit_time": controller.getNextRoundedTimeHHForStartNow()});
                                      },
                                    ),
                                  ],

                                  PullDownMenuItem(
                                    title: 'View Patient',
                                    onTap: () async {
                                      customPrint("visite is is ${controller.pastVisitList[rowIndex].visitId.toString()}");
                                      controller.globalController.addRoute(Routes.PATIENT_PROFILE);
                                      await Get.toNamed(Routes.PATIENT_PROFILE, arguments: {"patientData": controller.pastVisitList[rowIndex].id.toString(), "visitId": controller.pastVisitList[rowIndex].visitId.toString(), "fromSchedule": false});

                                      controller.getPastVisitList();
                                    },
                                  ),
                                  if (controller.pastVisitList[rowIndex].visitStatus == "In-Exam" || controller.pastVisitList[rowIndex].visitStatus == "Pending" || controller.pastVisitList[rowIndex].visitStatus == "Finalized") ...[
                                    PullDownMenuItem(
                                      title: 'View Document',
                                      onTap: () async {
                                        customPrint("row index is :- $rowIndex");

                                        // if (controller.pastVisitList[rowIndex].visitStatus == "In-Exam" || controller.pastVisitList[rowIndex].visitStatus == "Pending" || controller.pastVisitList[rowIndex].visitStatus == "Finalized") {
                                        Get.delete<PatientInfoController>();
                                        controller.globalController.addRoute(Routes.PATIENT_INFO);
                                        await Get.toNamed(Routes.PATIENT_INFO, arguments: {"visitId": controller.pastVisitList[rowIndex].visitId.toString(), "patientId": controller.pastVisitList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});

                                        controller.getPastVisitList();
                                        controller.getScheduleVisitList();
                                        controller.getPatientList();
                                      },
                                    ),
                                  ],
                                  if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                                    PullDownMenuItem(
                                      title: 'Schedule',
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          // Allows dismissing the dialog by tapping outside
                                          builder: (BuildContext context) {
                                            return SchedulePatientDialog(
                                              receiveParam: (p0, p1, doctorId, medicalId) {
                                                Map<String, dynamic> param = {};

                                                param['patient_id'] = controller.pastVisitList[rowIndex].id.toString();
                                                param['visit_date'] = p1;
                                                param['visit_time'] = p0;

                                                if (doctorId != -1) {
                                                  param['doctor_id'] = doctorId;
                                                }

                                                if (medicalId != -1) {
                                                  param['medical_assistant_id'] = medicalId;
                                                }
                                                customPrint("p0 is $p0 p1 is $p1");
                                                controller.patientScheduleCreate(param: param);
                                              },
                                            ); // Our custom dialog
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
                            maxLines: 2,
                            textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                            style: AppFonts.regular(14, AppColors.textDarkGrey),
                            softWrap: true,
                            // Allows text to wrap
                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                          );
                    },
                    columnCount: 8,
                    context: context,
                    columnWidths: const [0.17, 0.14, 0.07, 0.12, 0.10, 0.13, 0.18, 0.09],
                    headerBuilder: (context, colIndex) {
                      List<String> headers = ['Patient Name', 'Visit Date', 'Age', 'Provider', "Gender", "Previous \nVisits", "Status", "Action"];
                      return GestureDetector(
                        onTap: () {
                          if (colIndex != 7) {
                            customPrint(" data is the ${headers[colIndex]}");
                            controller.getPastVisitList(sortingName: headers[colIndex]);

                            controller.globalController.homePastPatientListSortingModel.value?.colIndex = colIndex;
                            controller.globalController.homePastPatientListSortingModel.value?.isAscending = controller.getDescValue(controller.globalController.sortingPastPatient, headers[colIndex], 2) ?? false;

                            controller.pastTriggeredIndexes.clear();

                            customPrint("col index is the $colIndex");
                          }
                        },
                        child: Container(
                          color: AppColors.backgroundWhite,
                          height: 40,
                          // color: AppColors.backgroundPurple,
                          child: Row(
                            mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  headers[colIndex],
                                  maxLines: 2,
                                  textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                  style: AppFonts.medium(12, AppColors.black),
                                  // softWrap: true,
                                  // Allows text to wrap
                                  // overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                ),
                              ),
                              colIndex == controller.globalController.homePastPatientListSortingModel.value?.colIndex && controller.globalController.homePastPatientListSortingModel.value!.isAscending && colIndex != 7
                                  ? const Icon(CupertinoIcons.down_arrow, size: 15)
                                  : colIndex == controller.globalController.homePastPatientListSortingModel.value?.colIndex && !controller.globalController.homePastPatientListSortingModel.value!.isAscending && colIndex != 7
                                  ? const Icon(CupertinoIcons.up_arrow, size: 15)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                    isLoading: controller.isLoading.value,
                    isNoData: controller.noMoreDataPastPatientList.value,
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
      String formatedDateTime = "N/A";

      if (patient.appointmentTime != null && patient.visitDate != null) {
        DateTime dateTime = DateTime.parse(patient.appointmentTime ?? "").toLocal();
        DateTime formatdateLocal = DateTime.parse(patient.visitDate ?? "");

        formatedDateTime = "${DateFormat('MM/dd').format(formatdateLocal)} ${DateFormat('h:mm a').format(dateTime)}";
      }

      rows.add([
        "${patient.firstName} ${patient.lastName}", // Patient Name
        formatedDateTime, // Last Visit Date
        patient.age != null ? patient.age.toString() : "N/A", // Age
        patient.doctorName?.trim() == "" ? 'N/A' : "Dr. ${patient.doctorName}" ?? "",
        patient.gender.toString()[0], // Gender
        patient.previousVisitCount.toString(), // Last Visit Date
        patient.visitStatus ?? "0", // Previous Visits
        "Action",
        patient.profileImage ?? "",

        // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
