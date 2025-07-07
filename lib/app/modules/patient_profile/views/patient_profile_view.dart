import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/visit_main/views/delete_schedule_visit.dart';
import 'package:subqdocs/app/modules/visit_main/views/table_custom.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widget/base_image_view.dart';
import 'package:subqdocs/widgets/base_screen.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../home/views/schedule_patient_dialog.dart';
import '../controllers/patient_profile_controller.dart';
import '../widgets/common_patient_data.dart';

class PatientProfileView extends GetView<PatientProfileController> {
  PatientProfileView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return BaseScreen(
      onItemSelected: (index) async {
        if (index == 0) {
          final result = await Get.toNamed(Routes.ADD_PATIENT);

          _key.currentState!.closeDrawer();
        } else if (index == 1) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 1});

          _key.currentState!.closeDrawer();
        } else if (index == 2) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 2});
          _key.currentState!.closeDrawer();
        } else if (index == 3) {
          Get.toNamed(Routes.HOME, arguments: {"tabIndex": 0});
          _key.currentState!.closeDrawer();
        } else if (index == 4) {
          _key.currentState!.closeDrawer();
          final result = await Get.toNamed(Routes.PERSONAL_SETTING);
        }
      },
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        color: AppColors.ScreenBackGround,
                        child: SingleChildScrollView(
                          child: Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 7),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                  child: BreadcrumbWidget(
                                    breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                    onBack: (breadcrumb) {
                                      controller.globalController.popUntilRoute(breadcrumb);
                                      while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                        Get.back(); // Pop the current screen
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                  child: Container(
                                    padding: const EdgeInsets.all(Dimen.margin16),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(color: AppColors.white, padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0), child: SvgPicture.asset(ImagePath.logo_back, height: 20, width: 20)),
                                            ),
                                            const SizedBox(width: Dimen.margin8),
                                            Text("Patient Details", style: AppFonts.regular(16, AppColors.textBlack)),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  ClipRRect(borderRadius: BorderRadius.circular(100), child: BaseImageView(height: 50, width: 50, fontSize: 16, imageUrl: controller.patientDetailModel.value?.responseData?.profileImage ?? "", nameLetters: "${controller.patientDetailModel.value?.responseData?.firstName} ${controller.patientDetailModel.value?.responseData?.lastName} ")),
                                                  const SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {"patientData": controller.patientId, "visitId": controller.visitId, "fromSchedule": true});
                                                      controller.globalController.addRoute(Routes.EDIT_PATENT_DETAILS);
                                                      controller.onReady();
                                                    },
                                                    child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26, fit: BoxFit.cover),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  ContainerButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        // Allows dismissing the dialog by tapping outside
                                                        builder: (BuildContext context) {
                                                          return SchedulePatientDialog(
                                                            receiveParam: (p0, p1, doctorId, medicalId) {
                                                              Map<String, dynamic> param = {};

                                                              param['patient_id'] = controller.patientId;
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
                                                    text: 'Schedule Visit',

                                                    borderColor: AppColors.backgroundPurple,
                                                    // Custom border color
                                                    backgroundColor: AppColors.backgroundPurple,
                                                    // Custom background color
                                                    needBorder: true,
                                                    // Show border
                                                    textColor: AppColors.white,
                                                    // Custom text color
                                                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                                    // Custom padding
                                                    radius: 6, // Custom border radius
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: Dimen.margin16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CommonPatientData(label: "Patient ID", data: controller.patientDetailModel.value?.responseData?.patientId ?? "N/A"), const SizedBox(height: 30), CommonPatientData(label: "Date of Birth", data: controller.dob.value ?? "N/A")]),
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CommonPatientData(label: "First Name", data: controller.patientDetailModel.value?.responseData?.firstName ?? "N/A"), const SizedBox(height: 30), CommonPatientData(label: "Sex", data: controller.patientDetailModel.value?.responseData?.gender ?? "N/A")]),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [CommonPatientData(label: "Middle Name", data: controller.patientDetailModel.value?.responseData?.middleName ?? "N/A"), const SizedBox(width: 120), CommonPatientData(label: "Last Name", data: controller.patientDetailModel.value?.responseData?.lastName ?? "N/A")]),
                                                const SizedBox(height: 30),
                                                CommonPatientData(label: "Email Address", data: controller.patientDetailModel.value?.responseData?.email ?? "N/A"),
                                              ],
                                            ),
                                            const Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [CommonPatientData(label: "", data: ""), CommonPatientData(label: "", data: "")]),
                                                SizedBox(height: 30),
                                                CommonPatientData(label: "", data: ""),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: Dimen.margin16),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 0.5, color: AppColors.lightpurpule)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: ExpansionTile(
                                        initiallyExpanded: true,
                                        shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                        collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                        backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                        collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                        title: Container(child: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Scheduled Visit", style: AppFonts.medium(16, AppColors.backgroundPurple))])),
                                        children: <Widget>[
                                          controller.patientDetailModel.value?.responseData?.scheduledVisits?.length != 0
                                              ? Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
                                                  child: TableCustom(
                                                    rows: _getTableRows(controller.patientDetailModel.value?.responseData?.scheduledVisits ?? []),
                                                    cellBuilder: (context, rowIndex, colIndex, cellData, profileImage) {
                                                      bool isAccessible = false;

                                                      if (rowIndex != 0) {
                                                        isAccessible = (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) && (controller.patientDetailModel.value?.responseData?.scheduledVisits?[rowIndex - 1].thirdPartyId != null);
                                                      }

                                                      return colIndex == 2 && rowIndex != 0
                                                          ? GestureDetector(
                                                            onTap: () async {
                                                              customPrint("row index is :- $rowIndex");

                                                              await Get.toNamed(Routes.VISIT_MAIN, arguments: {"visitId": controller.patientDetailModel.value?.responseData?.scheduledVisits?[rowIndex - 1].id.toString(), "patientId": controller.patientId, "unique_tag": DateTime.now().toString()})?.then((value) {
                                                                customPrint("controller.globalController.addRoute(Routes.VISIT_MAIN)");
                                                                controller.globalController.addRoute(Routes.VISIT_MAIN);
                                                              });

                                                              controller.getPatient(controller.patientId, controller.visitId);
                                                            },
                                                            child: Text(
                                                              cellData,
                                                              textAlign: TextAlign.center,
                                                              style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                              softWrap: true,
                                                              // Allows text to wrap
                                                              overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                            ),
                                                          )
                                                          : (colIndex == 3 || colIndex == 4) && rowIndex != 0
                                                          ? Row(
                                                            children: [
                                                              Text("|  ", style: AppFonts.regular(12, AppColors.appbarBorder)),
                                                              IgnorePointer(
                                                                ignoring: isAccessible,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    if (colIndex == 3) {
                                                                      showDialog(
                                                                        context: context,
                                                                        barrierDismissible: true,
                                                                        // Allows dismissing the dialog by tapping outside
                                                                        builder: (BuildContext context) {
                                                                          return SchedulePatientDialog(
                                                                            receiveParam: (p0, p1, doctorId, medicalAssistantId) {
                                                                              customPrint("p0 is $p0 p1 is $p1");
                                                                              customPrint("row index is :- $rowIndex");
                                                                              customPrint("visit id :- ${controller.patientDetailModel.value?.responseData?.scheduledVisits?[rowIndex - 1].id.toString()}");

                                                                              Map<String, dynamic> param = {};

                                                                              param['visit_date'] = p1;
                                                                              param['visit_time'] = p0;

                                                                              if (doctorId != -1) {
                                                                                param['doctor_id'] = doctorId;
                                                                              }

                                                                              if (medicalAssistantId != -1) {
                                                                                param['medical_assistant_id'] = medicalAssistantId;
                                                                              }
                                                                              controller.patientReScheduleCreate(param: {"visit_date": p1, "visit_time": p0}, visitId: controller.patientDetailModel.value?.responseData?.scheduledVisits![rowIndex - 1].id.toString() ?? "-1");
                                                                            },
                                                                          ); // Our custom dialog
                                                                        },
                                                                      );
                                                                    } else if (colIndex == 4) {
                                                                      showDialog(
                                                                        context: context,
                                                                        barrierDismissible: true,
                                                                        builder: (BuildContext context) {
                                                                          return DeleteScheduleVisit(
                                                                            onDelete: () {
                                                                              customPrint("id is:- ${controller.patientDetailModel.value?.responseData?.scheduledVisits?[rowIndex - 1].id}");

                                                                              controller.changeStatus("Cancelled", controller.patientDetailModel.value?.responseData?.scheduledVisits![rowIndex - 1].id.toString() ?? "-1");
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                    customPrint("col index is :- $colIndex");
                                                                  },
                                                                  child: Text(
                                                                    cellData ?? "",
                                                                    textAlign: TextAlign.center,
                                                                    style: AppFonts.regular(14, isAccessible ? AppColors.backgroundPurple.withValues(alpha: 0.5) : AppColors.backgroundPurple),
                                                                    softWrap: true,
                                                                    // Allows text to wrap
                                                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : rowIndex == 0
                                                          ? Text(
                                                            cellData ?? "",
                                                            textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                            style: AppFonts.regular(12, AppColors.black),
                                                            softWrap: true,
                                                            // Allows text to wrap
                                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                          )
                                                          : Text(
                                                            cellData ?? "",
                                                            textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                            style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                            softWrap: true,
                                                            // Allows text to wrap
                                                            overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                          );
                                                    },
                                                    columnCount: 5,
                                                    context: context,
                                                    columnWidths: isPortrait ? [0.23, 0.21, 0.17, 0.17, 0.18] : [0.25, 0.10, 0.17, 0.13, 0.12],
                                                    // columnWidths: isPortrait ? [0.25, 0.29, 0.11, 0.17, 0.18] : [0.30, 0.10, 0.15, 0.13, 0.12],
                                                  ),
                                                ),
                                              )
                                              : Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(ImagePath.noVisitFound),
                                                      const SizedBox(width: 16),
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("No Visit Found", style: AppFonts.regular(16, AppColors.black)), const SizedBox(height: 4), Text("Your scheduled visits will show here", style: AppFonts.regular(12, AppColors.black))]),
                                                      const Spacer(),
                                                      ContainerButton(
                                                        onPressed: () async {
                                                          // Your onPressed function
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            // Allows dismissing the dialog by tapping outside
                                                            builder: (BuildContext context) {
                                                              return SchedulePatientDialog(
                                                                receiveParam: (p0, p1, doctorId, medicalAssistantId) {
                                                                  Map<String, dynamic> param = {};

                                                                  param['patient_id'] = controller.patientId;
                                                                  param['visit_date'] = p1;
                                                                  param['visit_time'] = p0;

                                                                  if (doctorId != -1) {
                                                                    param['doctor_id'] = doctorId;
                                                                  }

                                                                  if (medicalAssistantId != -1) {
                                                                    param['medical_assistant_id'] = medicalAssistantId;
                                                                  }
                                                                  customPrint("p0 is $p0 p1 is $p1");
                                                                  controller.patientScheduleCreate(param: param);
                                                                },
                                                              ); // Our custom dialog
                                                            },
                                                          );
                                                        },
                                                        text: 'Schedule Visit',

                                                        borderColor: AppColors.backgroundPurple,
                                                        // Custom border color
                                                        backgroundColor: AppColors.backgroundPurple,
                                                        // Custom background color
                                                        needBorder: false,
                                                        // Show border
                                                        textColor: AppColors.white,
                                                        // Custom text color
                                                        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                                        // Custom padding
                                                        radius: 6, // Custom border radius
                                                      ),
                                                      const SizedBox(width: 16),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 0.5, color: AppColors.lightpurpule)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Theme(
                                        data: ThemeData(
                                          splashColor: Colors.transparent,
                                          // Remove splash color
                                          highlightColor: Colors.transparent, // Remove highlight color
                                        ),
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                          collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                          backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                          collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                          title: Container(child: Row(children: [const SizedBox(width: 10), Text(textAlign: TextAlign.center, "Visit Recaps", style: AppFonts.medium(16, AppColors.backgroundPurple))])),
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                child:
                                                    controller.patientDetailModel.value?.responseData?.pastVisits?.isNotEmpty ?? false
                                                        ? ListView.builder(
                                                          padding: EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) => InkWell(
                                                                onTap: () {},
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(height: 10),
                                                                      Row(
                                                                        children: [
                                                                          Text(textAlign: TextAlign.start, _getDate(controller.patientDetailModel.value?.responseData?.pastVisits?[index].visitDate), style: AppFonts.regular(15, AppColors.textGrey)),
                                                                          const SizedBox(width: 20),
                                                                          Expanded(child: Text(maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, controller.patientDetailModel.value?.responseData?.pastVisits?[index].summary ?? "", style: AppFonts.regular(15, AppColors.textGrey))),
                                                                          const SizedBox(width: 30),
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              Get.toNamed(Routes.PATIENT_INFO, arguments: {"visitId": controller.patientDetailModel.value?.responseData?.pastVisits?[index].id.toString(), "patientId": controller.patientId, "unique_tag": DateTime.now().toString()});

                                                                              controller.globalController.addRoute(Routes.PATIENT_INFO);
                                                                            },
                                                                            child: Text(textAlign: TextAlign.center, "View", style: AppFonts.regular(16, AppColors.textPurple)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 10),
                                                                      if (index != 7) ...[const Divider(height: 1, color: AppColors.appbarBorder)],
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                          itemCount: controller.patientDetailModel.value?.responseData?.pastVisits?.length,
                                                        )
                                                        : Container(
                                                          width: double.infinity,
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(ImagePath.noVisitFound),
                                                                const SizedBox(width: 16),
                                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("No Visit Found", style: AppFonts.regular(16, AppColors.black)), const SizedBox(height: 4), Text("Your scheduled visits will show here", style: AppFonts.regular(12, AppColors.black))]),
                                                                const Spacer(),
                                                                ContainerButton(
                                                                  onPressed: () async {
                                                                    showDialog(
                                                                      context: context,
                                                                      barrierDismissible: true,
                                                                      // Allows dismissing the dialog by tapping outside
                                                                      builder: (BuildContext context) {
                                                                        return SchedulePatientDialog(
                                                                          receiveParam: (p0, p1, doctorId, medicalAssistantId) {
                                                                            Map<String, dynamic> param = {};

                                                                            param['patient_id'] = controller.patientId;
                                                                            param['visit_date'] = p1;
                                                                            param['visit_time'] = p0;

                                                                            if (doctorId != -1) {
                                                                              param['doctor_id'] = doctorId;
                                                                            }

                                                                            if (medicalAssistantId != -1) {
                                                                              param['medical_assistant_id'] = medicalAssistantId;
                                                                            }
                                                                            customPrint("p0 is $p0 p1 is $p1");
                                                                            controller.patientScheduleCreate(param: param);
                                                                          },
                                                                        ); // Our custom dialog
                                                                      },
                                                                    );
                                                                    // Your onPressed function
                                                                  },
                                                                  text: 'Schedule Visit',

                                                                  borderColor: AppColors.backgroundPurple,
                                                                  // Custom border color
                                                                  backgroundColor: AppColors.backgroundPurple,
                                                                  // Custom background color
                                                                  needBorder: false,
                                                                  // Show border
                                                                  textColor: AppColors.white,
                                                                  // Custom text color
                                                                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                                                  // Custom padding
                                                                  radius: 6, // Custom border radius
                                                                ),
                                                                const SizedBox(width: 16),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      globalKey: _key,
    );
  }
}

String _getDate(String? date) {
  String visitDate = "N/A";

  if (date != null) {
    DateTime visitdateTime = DateTime.parse(date ?? "").toLocal();

    // Create a DateFormat to format the date
    DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

    // Format the DateTime object to the desired format
    String visitformattedDate = visitdateFormat.format(visitdateTime);

    visitDate = visitformattedDate;
  }
  return visitDate;
}

List<List<String>> _getTableRows(List<ScheduledVisits> patients) {
  List<List<String>> rows = [];

  // Add header row first
  rows.add(['Visit Date', 'Time', "", "Action"]);

  // Iterate over each patient and extract data for each row
  for (var patient in patients) {
    String visitDate = "N/A";
    String visitTime = "N/A";

    if (patient.visitDate != null) {
      DateTime visitdateTime = DateTime.parse(patient.visitDate ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitDate = visitformattedDate;
    }

    if (patient.visitTime != null) {
      DateTime visitdateTime = DateTime.parse(patient.visitTime ?? "").toLocal();

      // Create a DateFormat to format the date
      DateFormat visitdateFormat = DateFormat('hh:mm: a');

      // Format the DateTime object to the desired format
      String visitformattedDate = visitdateFormat.format(visitdateTime);

      visitTime = visitformattedDate;
    }

    rows.add([
      visitDate,
      visitTime,
      'Start visit now ',
      "Reschedule",
      "Cancel visit",

      // Action (could be a button or some interaction)
    ]);
  }
  return rows;
}
