import 'package:easy_popover/easy_popover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/patient_info/model/get_doctor_list_by_role_model.dart';
import 'package:subqdocs/app/modules/patient_info/views/doctor_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/full_note_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/patient_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/visit_data_view.dart';
import 'package:subqdocs/app/modules/sign_finalize_authenticate_view/controllers/sign_finalize_authenticate_view_controller.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/logger.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../../routes/app_pages.dart';
import '../../doctor_to_doctor_sign_finalize_authenticate_view/controllers/doctor_to_doctor_sign_finalize_authenticate_view_controller.dart';
import '../../doctor_to_doctor_sign_finalize_authenticate_view/views/doctor_to_doctor_sign_finalize_authenticate_view_view.dart';
import '../../home/views/container_view_dropdown.dart';
import '../../home/views/drop_down_with_search_popup.dart';
import '../../sign_finalize_authenticate_view/views/sign_finalize_authenticate_view_view.dart';
import '../controllers/patient_info_controller.dart';
import 'confirm_finalize_dialog.dart';
import 'full_transcript_view.dart';

class PatientInfoView extends StatefulWidget {
  const PatientInfoView({super.key});

  @override
  State<PatientInfoView> createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  PatientInfoController controller = Get.find<PatientInfoController>(tag: Get.arguments["unique_tag"]);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String formatDateTime({required String firstDate, required String secondDate}) {
    if (firstDate != "" && secondDate != "") {
      // Parse the first and second arguments to DateTime objects
      DateTime firstDateTime = DateTime.parse(firstDate);
      DateTime secondDateTime = DateTime.parse(secondDate);

      // Format the first date (for month/day/year format)
      String formattedDate = DateFormat('MM/dd/yyyy').format(firstDateTime);

      // Format the second time (for hours and minutes with am/pm)
      String formattedTime = DateFormat('h:mm a').format(secondDateTime.toLocal());

      // Return the formatted string in the desired format
      return '$formattedDate $formattedTime';
    } else {
      return "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onPopCallBack: () {
        controller.closeDoctorPopOverController();

        if (controller.globalController.getKeyByValue(controller.globalController.breadcrumbHistory.last) == Routes.PATIENT_INFO) {
          controller.globalController.popRoute();
        }
      },
      onDrawerChanged: (status) {
        customPrint("drawer status is :- $status");

        if (status) {
          controller.closeAllProcedureDiagnosisPopover();
        }
      },
      resizeToAvoidBottomInset: true,
      onItemSelected: (index) async {
        if (index == 0) {
          final result = await Get.toNamed(Routes.ADD_PATIENT);
          _key.currentState!.closeDrawer();
        } else if (index == 1) {
          Get.offNamed(Routes.HOME, arguments: {"tabIndex": 1});
          _key.currentState!.closeDrawer();
        } else if (index == 2) {
          Get.offNamed(Routes.HOME, arguments: {"tabIndex": 2});
          _key.currentState!.closeDrawer();
        } else if (index == 3) {
          Get.offNamed(Routes.HOME, arguments: {"tabIndex": 0});
          _key.currentState!.closeDrawer();
        } else if (index == 4) {
          _key.currentState!.closeDrawer();
          final result = await Get.toNamed(Routes.PERSONAL_SETTING);
        }
      },
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            customPrint("called main GestureDetector");
            controller.closeAllProcedureDiagnosisPopover();
            // FocusScope.of(context).unfocus();
            controller.resetImpressionAndPlanList();
          },
          child: Obx(() {
            return Column(
              children: [
                if (!controller.isKeyboardVisible.value) ...[CustomAppBar(drawerkey: _key)],
                Expanded(
                  child: Container(
                    color: AppColors.ScreenBackGround1,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RefreshIndicator(
                      onRefresh: controller.onRefresh, // Trigger the refresh
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Obx(() {
                              return BreadcrumbWidget(
                                breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                                onBack: (breadcrumb) {
                                  controller.globalController.popUntilRoute(breadcrumb);
                                  while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                                    Get.back(); // Pop the current screen
                                  }
                                },
                              );
                            }),
                            const SizedBox(height: 10),
                            Column(
                              children: <Widget>[
                                Container(width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Padding(padding: const EdgeInsets.all(14), child: Text("Patient Visit Record", style: AppFonts.regular(17, AppColors.textBlack)))),
                                const SizedBox(height: 15.0),
                                Obx(() {
                                  return Theme(
                                    data: ThemeData(
                                      splashColor: Colors.transparent,
                                      // Remove splash color
                                      highlightColor: Colors.transparent, // Remove highlight color
                                    ),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      onExpansionChanged: (value) {
                                        controller.closeAllProcedureDiagnosisPopover();
                                      },
                                      collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                      shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                      backgroundColor: AppColors.backgroundWhite,
                                      collapsedBackgroundColor: AppColors.backgroundWhite,
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.until((route) => Get.currentRoute == Routes.HOME);
                                                controller.globalController.breadcrumbHistory.clear();
                                                controller.globalController.addRoute(Routes.HOME);

                                                // Get.back();
                                              },
                                              child: Container(color: AppColors.white, padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0, right: 20.0), child: SvgPicture.asset(ImagePath.logo_back, height: 20, width: 20)),
                                            ),
                                            ClipRRect(borderRadius: BorderRadius.circular(30), child: BaseImageView(imageUrl: controller.patientData.value?.responseData?.profileImage ?? "", height: 60, width: 60, nameLetters: "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}", fontSize: 14)),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(textAlign: TextAlign.center, "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""} ", style: AppFonts.medium(16, AppColors.textBlack)),
                                                const SizedBox(width: 15),
                                                Text(textAlign: TextAlign.center, controller.patientData.value?.responseData?.patientId ?? "", style: AppFonts.regular(11, AppColors.textGrey)),
                                              ],
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      children: <Widget>[
                                        Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(textAlign: TextAlign.center, "Age", style: AppFonts.regular(12, AppColors.textBlack)),
                                                  const SizedBox(height: 6),
                                                  Text(textAlign: TextAlign.center, (controller.patientData.value?.responseData?.age.toString() ?? "") == "null" ? "N/A" : controller.patientData.value?.responseData?.age.toString() ?? "", style: AppFonts.regular(14, AppColors.textGrey)),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(children: [Text(textAlign: TextAlign.center, "Gender", style: AppFonts.regular(12, AppColors.textBlack)), const SizedBox(height: 6), Text(textAlign: TextAlign.center, controller.patientData.value?.responseData?.gender ?? "N/A", style: AppFonts.regular(14, AppColors.textGrey))]),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  Text(textAlign: TextAlign.center, "Visit Date & Time", style: AppFonts.regular(12, AppColors.textBlack)),
                                                  const SizedBox(height: 6),
                                                  Text(textAlign: TextAlign.center, formatDateTime(firstDate: controller.patientData.value?.responseData?.visitDate ?? "-", secondDate: controller.patientData.value?.responseData?.visitTime ?? ""), style: AppFonts.regular(14, AppColors.textGrey)),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [Text(textAlign: TextAlign.center, "Medical Assistant", style: AppFonts.regular(12, AppColors.textBlack)), const SizedBox(height: 6), Text(textAlign: TextAlign.center, controller.medicationValue.value ?? "N/A", style: AppFonts.regular(14, AppColors.textGrey))]),
                                              const Spacer(),
                                              IgnorePointer(
                                                ignoring: controller.patientData.value?.responseData?.thirdPartyId != null || controller.patientData.value?.responseData?.visitStatus?.toLowerCase() == "finalized",
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(textAlign: TextAlign.start, "Doctor", style: AppFonts.regular(12, AppColors.textBlack)),
                                                    // const SizedBox(height: 6),
                                                    Popover(
                                                      key: ValueKey(controller.doctorPopoverController),
                                                      context,
                                                      controller: controller.doctorPopoverController,
                                                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                      scrollEnabled: true,
                                                      hideArrow: true,
                                                      applyActionWidth: false,
                                                      alignment: PopoverAlignment.bottomCenter,
                                                      contentWidth: 170,
                                                      action: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(textAlign: TextAlign.start, "Doctor", style: AppFonts.regular(12, AppColors.textBlack)),
                                                            const SizedBox(height: 6),
                                                            SizedBox(
                                                              width: 170,
                                                              child: ContainerDropdownViewPopUp(
                                                                receiveParam: (isExpand) {
                                                                  // isExpandedMedicalAssistant.value = isExpand;
                                                                },
                                                                name: controller.doctorValue.value,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      content: Padding(
                                                        padding: const EdgeInsets.all(0),
                                                        child: SizedBox(
                                                          width: 160,
                                                          // height: 309,
                                                          child: DropDownWithSearchPopup(
                                                            // key: UniqueKey(),
                                                            // key: controller.doctorSearchBarKey,
                                                            searchScrollKey: controller.doctorSearchBarKey,
                                                            onChanged: (value, index, selectedId, name) {
                                                              print("print the doctor view ");

                                                              controller.doctorPopoverController.close();
                                                              controller.doctorValue.value = name;
                                                              // Get.back();
                                                              controller.updateDoctorView(selectedId);
                                                            },
                                                            list: controller.globalController.selectedDoctorModel.value,
                                                            receiveParam: (String value) {},
                                                            selectedId: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                  child: Obx(() {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                      height: 45,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            IntrinsicWidth(
                                              child: CustomAnimatedButton(
                                                onPressed: () {
                                                  // controller.closeAllProcedureDiagnosisPopover();
                                                  // controller.resetImpressionAndPlanList();
                                                  controller.closeAllProcedureDiagnosisPopover();

                                                  controller.resetImpressionAndPlanList();

                                                  controller.tableModel.value?.rows.forEach((e) {
                                                    e.popoverController = PopoverController();
                                                    e.modifierPopoverController = PopoverController();
                                                  });

                                                  controller.tabIndex.value = 0;
                                                },
                                                isDoctorView: true,
                                                text: " Power View ",
                                                isOutline: true,
                                                paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 0 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: CustomAnimatedButton(
                                                onPressed: () async {
                                                  // controller.closeAllProcedureDiagnosisPopover();
                                                  // controller.resetImpressionAndPlanList();
                                                  controller.closeAllProcedureDiagnosisPopover();
                                                  controller.resetImpressionAndPlanList();
                                                  // await controller.closeOnlyDoctorviewPopover();

                                                  Future.delayed(const Duration(milliseconds: 200), () {
                                                    controller.tabIndex.value = 3;
                                                  });
                                                },
                                                text: " Full Note ",
                                                isOutline: true,
                                                paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 3 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 3 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 3 ? AppColors.backgroundPurple : AppColors.clear,
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: CustomAnimatedButton(
                                                onPressed: () async {
                                                  controller.closeAllProcedureDiagnosisPopover();
                                                  controller.resetImpressionAndPlanList();
                                                  await controller.closeOnlyDoctorviewPopover();
                                                  Future.delayed(const Duration(milliseconds: 200), () {
                                                    controller.tabIndex.value = 2;
                                                  });
                                                },
                                                text: " Patient Note ",
                                                isOutline: true,
                                                paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 2 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: CustomAnimatedButton(
                                                onPressed: () async {
                                                  // controller.closeAllProcedureDiagnosisPopover();
                                                  controller.closeAllProcedureDiagnosisPopover();
                                                  controller.resetImpressionAndPlanList();

                                                  controller.closeOnlyDoctorviewPopover();

                                                  Future.delayed(const Duration(milliseconds: 200), () {
                                                    controller.tabIndex.value = 1;
                                                  });
                                                },
                                                text: " Full Transcript ",
                                                isOutline: true,
                                                paddingText: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 1 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                                  child: Obx(() {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        if (controller.tabIndex.value == 0) ...[DoctorView(controller: controller)],
                                        if (controller.tabIndex.value == 1) ...[FullTranscriptView(controller: controller)],
                                        if (controller.tabIndex.value == 2) ...[PatientView(controller: controller)],
                                        if (controller.tabIndex.value == 3) ...[FullNoteView(controller: controller)],
                                        if (controller.tabIndex.value == 6) ...[VisitDataView(controller: controller)],
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  }),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!controller.keyboardController.isKeyboardOpen.value) ...[
                  Container(
                    color: AppColors.ScreenBackGround1,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      // color: AppColors.backgroundWhite,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Obx(() {
                        return Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (controller.isSignatureDone.value) ...[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 95,
                                        decoration: BoxDecoration(border: Border.all(color: AppColors.backgroundPurple), color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(ImagePath.signature, height: 30, width: 30),
                                                const SizedBox(height: 10),
                                                Text(textAlign: TextAlign.center, "Digitally Signed by Dr.${controller.patientData.value?.responseData?.doctorName}", style: AppFonts.medium(16, AppColors.textWhite)),
                                                Text(textAlign: TextAlign.center, formatDateTime(firstDate: controller.patientData.value?.responseData?.finalize_date_time ?? "", secondDate: controller.patientData.value?.responseData?.finalize_date_time ?? ""), style: AppFonts.medium(16, AppColors.textWhite)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(textAlign: TextAlign.center, "Amend Note", style: AppFonts.medium(15, AppColors.textGrey).copyWith(decoration: TextDecoration.underline)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (controller.isSignatureDone.value == false) ...[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.closeDoctorPopOverController();
                                  },
                                  child: Container(
                                    height: 81,
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)), color: AppColors.backgroundLightGrey, borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(ImagePath.add_photo, height: 30, width: 30), const SizedBox(height: 10), Text(textAlign: TextAlign.center, "Add Photo or Document", style: AppFonts.medium(16, AppColors.textBlack))]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (controller.patientData.value?.responseData?.visitStatus == "Pending") ...[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      print(controller.loginData.value?.responseData?.user?.role?.toLowerCase());
                                      controller.closeDoctorPopOverController();

                                      if (controller.globalController.getEMAOrganizationDetailModel.value?.responseData?.isEmaIntegration ?? false) {
                                        //

                                        if (controller.loginData.value?.responseData?.user?.role?.toLowerCase() != "doctor") {
                                          bool isThirdParty = controller.patientData.value?.responseData?.thirdPartyId != null ? true : false;

                                          if (isThirdParty) {
                                            dynamic encounterModel = await controller.hasEncounter(id: controller.visitId);
                                            if (encounterModel["response_type"] == "Failure") {
                                              Map<String, dynamic> responseData = encounterModel["responseData"];

                                              String modeMedUrl = responseData["url"];
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return HasEncounterDialog(
                                                    onCounter: () async {
                                                      final url = modeMedUrl;
                                                      if (await canLaunchUrl(Uri.parse(url))) {
                                                        await launchUrl(Uri.parse(url));
                                                        Get.back();
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            } else {
                                              showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                            }
                                          } else {
                                            showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                          }

                                          // showDialog(
                                          //   context: context,
                                          //   barrierDismissible: true,
                                          //   builder: (BuildContext context) {
                                          //     return ConfirmFinalizeDialog(
                                          //       onDelete: () {
                                          //         showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                          //       },
                                          //     );
                                          //   },
                                          // );
                                        } else {
                                          if (controller.loginData.value?.responseData?.user?.id == controller.patientData.value?.responseData?.doctorId) {
                                            if (controller.patientData.value?.responseData?.thirdPartyId != null) {
                                              dynamic encounterModel = await controller.hasEncounter(id: controller.visitId);

                                              if (encounterModel["response_type"] == "Failure") {
                                                Map<String, dynamic> responseData = encounterModel["responseData"];

                                                String modeMedUrl = responseData["url"];
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (BuildContext context) {
                                                    return HasEncounterDialog(
                                                      onCounter: () async {
                                                        final url = modeMedUrl;
                                                        if (await canLaunchUrl(Uri.parse(url))) {
                                                          await launchUrl(Uri.parse(url));
                                                          Get.back();
                                                        } else {
                                                          throw 'Could not launch $url';
                                                        }
                                                      },
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                              }
                                            } else {
                                              showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                            }
                                          } else {
                                            if (controller.patientData.value?.responseData?.thirdPartyId != null) {
                                              CustomToastification().showToast("You don't have permission to finalize this visit!", type: ToastificationType.error);
                                            } else {
                                              showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                            }
                                          }
                                        }
                                      } else {
                                        // For Non-EMA

                                        if (controller.loginData.value?.responseData?.user?.role?.toLowerCase() == "doctor") {
                                          showDoctorToDoctorSignFinalizeAutheticateViewDialog();
                                        } else {
                                          showSignFinalizeAutheticateViewDialog();
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 81,
                                      decoration: BoxDecoration(border: Border.all(color: AppColors.backgroundPurple), color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(ImagePath.signature, height: 30, width: 30), const SizedBox(height: 10), Text(textAlign: TextAlign.center, "Sign and Finalize", style: AppFonts.medium(16, AppColors.textWhite))]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ],
            );
          }),
        ),
      ),
      globalKey: _key,
    );
  }

  void showSignFinalizeAutheticateViewDialog() {
    SignFinalizeAuthenticateViewController con = Get.put(SignFinalizeAuthenticateViewController());
    con.visitId = controller.visitId;

    print("doctor name:- ${controller.patientData.value?.responseData?.doctorName}");
    print("doctorId:- ${controller.patientData.value?.responseData?.doctorId}");
    con.selectedDoctorValueModel = Rxn(GetDoctorListByRoleResponseData(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null));
    con.selectedDoctorValue.value = controller.patientData.value?.responseData?.doctorName ?? "";

    print("dialog response data:- ${controller.patientData.value?.responseData?.toJson()}");

    print("third:- ${controller.patientData.value?.responseData?.thirdPartyId}");

    con.isThirdParty = controller.patientData.value?.responseData?.thirdPartyId ?? "";

    con.setDoctor(Rxn(GetDoctorListByRoleResponseData(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null)));

    con.setThirdParty(controller.patientData.value?.responseData?.thirdPartyId ?? "");
    // con.getDoctorList();

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn),
          child: FadeTransition(
            opacity: animation1,
            child: Dialog(
              backgroundColor: AppColors.backgroundMobileAppbar,
              surfaceTintColor: AppColors.backgroundMobileAppbar,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                child: ClipRRect(
                  // Additional clipping for safety
                  borderRadius: BorderRadius.circular(16.0),
                  child: IntrinsicHeight(child: SignFinalizeAuthenticateViewView(controller: con)),
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) async {
      await Get.delete<SignFinalizeAuthenticateViewController>();
      controller.getPatientDetails();
    });
  }

  void showDoctorToDoctorSignFinalizeAutheticateViewDialog() {
    DoctorToDoctorSignFinalizeAuthenticateViewController con = Get.put(DoctorToDoctorSignFinalizeAuthenticateViewController());
    con.visitId = controller.visitId;
    con.selectedDoctorValueModel = Rxn(GetDoctorListByRoleResponseData(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null));
    con.selectedDoctorValue.value = controller.patientData.value?.responseData?.doctorName ?? "";

    print("dialog response data:- ${controller.patientData.value?.responseData?.toJson()}");

    print("third:- ${controller.patientData.value?.responseData?.thirdPartyId}");

    con.isThirdParty = controller.patientData.value?.responseData?.thirdPartyId ?? "";

    con.setDoctor(Rxn(GetDoctorListByRoleResponseData(name: controller.patientData.value?.responseData?.doctorName, id: controller.patientData.value?.responseData?.doctorId, profileImage: null)));
    con.setThirdParty(controller.patientData.value?.responseData?.thirdPartyId ?? "");
    // con.getDoctorList();

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn),
          child: FadeTransition(
            opacity: animation1,
            child: Dialog(
              backgroundColor: AppColors.backgroundMobileAppbar,
              surfaceTintColor: AppColors.backgroundMobileAppbar,
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                child: ClipRRect(
                  // Additional clipping for safety
                  borderRadius: BorderRadius.circular(16.0),
                  child: IntrinsicHeight(child: DoctorToDoctorSignFinalizeAuthenticateView()),
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) async {
      await Get.delete<DoctorToDoctorSignFinalizeAuthenticateViewController>();
      controller.getPatientDetails();
    });
  }
}

class CustomSearchDropdown<T extends SelectedDoctorModel> extends StatefulWidget {
  final List<T> items;
  final String currentValue;
  final Function(T value, int index, int selectedId, String name) onChanged;
  final int selectedId;
  final double? dropdownWidth;

  const CustomSearchDropdown({Key? key, required this.items, required this.currentValue, required this.onChanged, required this.selectedId, this.dropdownWidth}) : super(key: key);

  @override
  _CustomSearchDropdownState<T> createState() => _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T extends SelectedDoctorModel> extends State<CustomSearchDropdown<T>> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.currentValue, style: const TextStyle(fontSize: 14)), Icon(_isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey)]),
      ),
    );
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      Navigator.of(context).pop();
      _isDropdownOpen = false;
    } else {
      _showDialog();
      _isDropdownOpen = true;
    }
  }

  void _showDialog() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            // Transparent barrier
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _isDropdownOpen = false;
                },
                behavior: HitTestBehavior.translucent,
              ),
            ),
            // Dropdown positioned under the button
            Positioned(
              left: position.dx,
              top: position.dy + size.height + 4,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: widget.dropdownWidth ?? size.width,
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                  child: SingleChildScrollView(
                    child: DropDownWithSearchPopup(
                      key: UniqueKey(),
                      onChanged: (value, index, selectedId, name) {
                        widget.onChanged(value as T, index, selectedId, name);
                        Navigator.of(context).pop();
                        _isDropdownOpen = false;
                      },
                      list: widget.items,
                      receiveParam: (String value) {},
                      selectedId: widget.selectedId,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isDropdownOpen = false;
    });
  }
}
