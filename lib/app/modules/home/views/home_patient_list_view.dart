import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/app/modules/home/views/schedule_patient_dialog.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/empty_patient_screen.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../model/patient_list_model.dart';

class HomePatientListView extends GetView<HomeController> {
  const HomePatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Obx(() {
        return controller.patientList.isEmpty
            ? controller.isHomePatientListLoading.value
                ? const Padding(padding: EdgeInsets.all(10), child: Center(child: CircularProgressIndicator()))
                : Padding(
                  padding: const EdgeInsets.all(10),
                  child: EmptyPatientScreen(
                    onBtnPress: () async {
                      controller.globalController.addRoute(Routes.ADD_PATIENT);
                      final _ = await Get.toNamed(Routes.ADD_PATIENT);

                      controller.getPastVisitList(isFist: true);
                      controller.getScheduleVisitList();
                      controller.getPatientList();
                    },
                    buttonTitle: "Add New Patient",
                    title: "Your Patient List is Empty",
                    description: "Start by adding your first patient to manage appointments, view medical history, and keep track of visits—all in one place",
                  ),
                )
            : Column(
              children: [
                // Text("total data is the ${controller.patientList.length}" , style: TextStyle( fontSize: 20),),
                Expanded(
                  child: CustomTable(
                    scrollController: controller.scrollControllerPatientList,
                    physics: const AlwaysScrollableScrollPhysics(),
                    onRefresh: () async {
                      controller.pagePatient = 1;

                      controller.getPatientList();
                      customPrint("refresh patient list view");
                    },
                    rows: _getTableRows(controller.patientList),
                    columnCount: 6,
                    cellBuilder: _buildTableCell,
                    context: context,
                    onRowSelected: (rowIndex, rowData) {},
                    onLoadMore: () async {
                      controller.patientLoadMore();
                    },
                    columnWidths: const [0.25, 0.11, 0.14, 0.18, 0.18, 0.14],
                    headerBuilder: (context, colIndex) {
                      List<String> headers = ['Patient Name', 'Age', 'Gender', 'Last Visit Date', 'Previous Visits', 'Action'];
                      return GestureDetector(
                        onTap: () {
                          if (colIndex != 5) {
                            controller.patientSorting(colIndex: colIndex, cellData: headers[colIndex]);
                          }
                        },
                        child: Container(
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
                              colIndex == controller.globalController.homePatientListSortingModel.value?.colIndex && controller.globalController.homePatientListSortingModel.value!.isAscending && colIndex != 5
                                  ? const Icon(CupertinoIcons.down_arrow, size: 15)
                                  : colIndex == controller.globalController.homePatientListSortingModel.value?.colIndex && !controller.globalController.homePatientListSortingModel.value!.isAscending && colIndex != 5
                                  ? const Icon(CupertinoIcons.up_arrow, size: 15)
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                    isLoading: controller.isLoading.value,
                    isNoData: controller.noMoreDataPatientList.value,
                  ),
                ),
              ],
            );
      }),
    );
  }

  // This function creates rows from the API model
  List<List<String>> _getTableRows(List<PatientListData> patients) {
    List<List<String>> rows = [];

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      rows.add([
        "${patient.firstName} ${patient.lastName}", // Patient Name
        patient.age != null ? patient.age.toString() : "N/A", // Age
        patient.gender.toString()[0], // Gender
        patient.lastVisitDate ?? "N/A",
        patient.pastVisitCount?.toString() ?? "0", // Previous Visits
        "Action",
        patient.profileImage ?? "", // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }

  // This is the cell builder function where you can customize how each cell is built.
  Widget _buildTableCell(BuildContext context, int rowIndex, int colIndex, String cellData, String profileImage) {
    return colIndex == 0
        ? GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(imageUrl: profileImage, height: 28, width: 28, nameLetters: cellData, fontSize: 12)),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // if (rowIndex != 0) {

                    controller.globalController.addRoute(Routes.VISIT_MAIN);
                    dynamic _ = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": controller.patientList[rowIndex].visitId.toString(), "patientId": controller.patientList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});
                    controller.getPatientList();
                    customPrint("back from response");
                    // controller.globalController.addRoute(Routes.PATIENT_PROFILE);
                    // await Get.toNamed(Routes.PATIENT_PROFILE, arguments: {"patientData": controller.patientList[rowIndex].id.toString(), "visitId": "", "fromSchedule": false});
                    //
                    // controller.getPatientList();
                    // }
                  },
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
              ),
            ],
          ),
        )
        : colIndex == 5
        ? PullDownButton(
          routeTheme: const PullDownMenuRouteTheme(backgroundColor: AppColors.white, width: 200),
          itemBuilder:
              (context) => [
                if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                  PullDownMenuItem(
                    title: 'Start Visit',
                    onTap: () async {
                      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      controller.pastPatientStartNow(controller.patientList[rowIndex].id.toString(), controller.patientList[rowIndex].firstName ?? "", controller.patientList[rowIndex].lastName ?? "", param: {"patient_id": controller.patientList[rowIndex].id.toString(), "visit_date": date, "visit_time": controller.getNextRoundedTimeHHForStartNow()});
                    },
                  ),
                ],
                if (controller.patientList[rowIndex].visitId != null) ...[
                  PullDownMenuItem(
                    title: 'Medical record',
                    onTap: () async {
                      controller.globalController.addRoute(Routes.VISIT_MAIN);
                      dynamic _ = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": controller.patientList[rowIndex].visitId.toString(), "patientId": controller.patientList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});
                      controller.getPatientList();
                    },
                  ),
                ],
                if (controller.patientList[rowIndex].visitId == null) ...[
                  PullDownMenuItem(
                    title: 'Medical record',
                    onTap: () async {
                      controller.globalController.addRoute(Routes.VISIT_MAIN);
                      dynamic _ = await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": "null", "patientId": controller.patientList[rowIndex].id.toString(), "unique_tag": DateTime.now().toString()});
                      controller.getPatientList();
                    },
                  ),
                ],
                if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration == false) ...[
                  PullDownMenuItem(
                    title: 'Schedule',
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        // Allows dismissing the dialog by tapping outside
                        builder: (BuildContext context) {
                          return SchedulePatientDialog(
                            receiveParam: (p0, p1, doctorId, medicalId) {
                              customPrint("p0 is $p0 p1 is $p1 doctorid $doctorId medicalid $medicalId");
                              Map<String, dynamic> param = {};

                              param['patient_id'] = controller.patientList[rowIndex].id.toString();
                              param['visit_date'] = p1;
                              param['visit_time'] = p0;

                              if (doctorId != -1) {
                                param['doctor_id'] = doctorId;
                              }

                              if (medicalId != -1) {
                                param['medical_assistant_id'] = medicalId;
                              }

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
          textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
          style: AppFonts.regular(14, AppColors.textDarkGrey),
          softWrap: true, // Allows text to wrap
          overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
        );
  }
}
