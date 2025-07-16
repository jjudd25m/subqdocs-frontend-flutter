import 'dart:io';

import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:subqdocs/app/core/common/global_controller.dart';
import 'package:subqdocs/app/modules/home/controllers/home_controller.dart';
import 'package:subqdocs/app/modules/visit_main/views/view_attchment_image.dart';
import 'package:subqdocs/app/modules/visit_main/views/visit_main_attachment_filter.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widgets/base_dropdown2.dart';
import '../../../../widgets/customPermission.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/logger.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../../models/audio_wave.dart';
import '../../../routes/app_pages.dart';
import '../../home/views/container_view_dropdown.dart';
import '../../home/views/drop_down_with_search_popup.dart';
import '../../home/views/home_reschedule_patient_dialog.dart';
import '../../patient_info/views/EditableViews/CommonContainer.dart';
import '../controllers/visit_main_controller.dart';
import 'delete_image_dialog.dart';
import 'delete_schedule_visit.dart';
import 'editable_views/allergies_editable.dart';
import 'editable_views/cance_history_editable.dart';
import 'editable_views/medication_history_editable.dart';
import 'editable_views/persnoal_note_editable.dart';
import 'editable_views/skin_history_editable.dart';
import 'editable_views/social_history_editable.dart';
import 'editable_views/visit_snap_shot_editbale.dart';

class VisitMainView extends StatefulWidget {
  const VisitMainView({super.key});

  @override
  State<VisitMainView> createState() => _VisitMainViewState();
}

class _VisitMainViewState extends State<VisitMainView> {
  VisitMainController controller = Get.find<VisitMainController>(tag: Get.arguments["unique_tag"]);
  final ScrollController scrollController = ScrollController();
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
      isVisibleModel: true,
      onPlayCallBack: () {
        if (controller.globalController.visitId.isEmpty && controller.globalController.patientId.isEmpty) {
          controller.globalController.visitId = controller.visitId;
          controller.globalController.patientId = controller.patientId;
        }
      },
      globalKey: _key,
      body: Obx(() {
        return GestureDetector(
          onTap: () {
            controller.resetImpressionAndPlanList();
          },
          child: Column(
            children: [
              if (!controller.isKeyboardVisible.value) ...[CustomAppBar(drawerkey: _key)],
              Expanded(
                child: Container(
                  color: AppColors.ScreenBackGround1,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RefreshIndicator(
                    onRefresh: controller.onRefresh, // Trigger the refresh
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          BreadcrumbWidget(
                            breadcrumbHistory: controller.globalController.breadcrumbHistory,
                            onBack: (breadcrumb) {
                              // Remove all breadcrumbs after the selected one
                              controller.globalController.popUntilRoute(breadcrumb);

                              final targetRoute = controller.globalController.getKeyByValue(breadcrumb);

                              if (Get.currentRoute == targetRoute) return;

                              bool found = false;
                              Get.until((route) {
                                if (route.settings.name == targetRoute) {
                                  found = true;
                                }
                                return found;
                              });

                              if (!found) {
                                // Pass correct arguments for HOME and VISIT_MAIN
                                if (targetRoute == Routes.HOME) {
                                  Get.offAllNamed(Routes.HOME);
                                  Get.find<HomeController>();
                                }
                                else if (targetRoute == Routes.VISIT_MAIN) {
                                  Get.offAllNamed(
                                    Routes.VISIT_MAIN,
                                    arguments: {
                                      "visitId": controller.visitId.value,
                                      "patientId": controller.patientId.value,
                                      "unique_tag": DateTime.now().toString(),
                                    },
                                  );
                                }
                                else {
                                  Get.offAllNamed(targetRoute);
                                }
                                controller.globalController.popRoute();
                              }
                            },
                          ),
                          const SizedBox(height: 10.0),
                          Theme(
                            data: ThemeData(
                              splashColor: Colors.transparent,
                              // Remove splash color
                              highlightColor: Colors.transparent, // Remove highlight color
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.only(left: 17, right: 21),
                              initiallyExpanded: true,
                              collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              backgroundColor: AppColors.backgroundWhite,
                              collapsedBackgroundColor: AppColors.backgroundWhite,
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.until((route) => Get.currentRoute == Routes.HOME);
                                        controller.globalController.breadcrumbHistory.clear();
                                        Get.offAllNamed(Routes.HOME);
                                        Get.find<HomeController>();
                                      },
                                      child: Container(color: AppColors.white, padding: const EdgeInsets.only(right: 11), child: SvgPicture.asset(ImagePath.logo_back, height: 20, width: 20)),
                                    ),
                                    ClipRRect(borderRadius: BorderRadius.circular(30), child: BaseImageView(imageUrl: controller.patientData.value.responseData?.profileImage ?? "", height: 60, width: 60, nameLetters: "${controller.patientData.value.responseData?.patientFirstName ?? ""} ${controller.patientData.value.responseData?.patientLastName ?? ""}", fontSize: 14)),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(textAlign: TextAlign.center, "${controller.patientData.value.responseData?.patientFirstName ?? ""} ${controller.patientData.value.responseData?.patientLastName ?? ""} ", style: AppFonts.regular(16, AppColors.textBlack)),
                                        const SizedBox(width: 15),
                                        Text(textAlign: TextAlign.center, controller.patientData.value.responseData?.patientId ?? "", style: AppFonts.regular(11, AppColors.textGrey)),
                                      ],
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await Get.toNamed(Routes.EDIT_PATENT_DETAILS, arguments: {"patientData": controller.patientId.value, "visitId": controller.visitId.value, "fromSchedule": true});
                                        controller.globalController.addRoute(Routes.EDIT_PATENT_DETAILS);
                                        controller.getPatientDetails();
                                      },
                                      child: SvgPicture.asset(ImagePath.edit, width: 26, height: 26, fit: BoxFit.cover),
                                    ),
                                  ],
                                ),
                              ),
                              children: <Widget>[
                                Container(width: double.infinity, height: 1, color: AppColors.borderTable),
                                const SizedBox(height: 10),
                                // Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                // SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 18),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Age", style: AppFonts.regular(12, AppColors.textBlack)),
                                          const SizedBox(height: 6),
                                          Text(textAlign: TextAlign.center, (controller.patientData.value.responseData?.age.toString() ?? "") == "null" ? "N/A" : controller.patientData.value.responseData?.age.toString() ?? "", style: AppFonts.regular(14, AppColors.textGreyTable)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(children: [Text(textAlign: TextAlign.center, "Gender", style: AppFonts.regular(12, AppColors.textBlack)), const SizedBox(height: 6), Text(textAlign: TextAlign.center, controller.patientData.value.responseData?.gender ?? "", style: AppFonts.regular(14, AppColors.textGreyTable))]),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Text(textAlign: TextAlign.center, "Visit Date & Time", style: AppFonts.regular(12, AppColors.textBlack)),
                                          const SizedBox(height: 6),
                                          Text(textAlign: TextAlign.start, controller.visitId.value == "null" ? "-" : controller.formatDateTime(firstDate: controller.patientData.value.responseData?.visitDate ?? "", secondDate: controller.patientData.value.responseData?.visitTime ?? ""), style: AppFonts.regular(14, AppColors.textGreyTable)),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(textAlign: TextAlign.start, "Medical Assistant", style: AppFonts.regular(12, AppColors.textBlack)),
                                          const SizedBox(height: 6),
                                          if (controller.visitId.value != "null")
                                            PopupMenuButton<String>(
                                              offset: const Offset(0, 8),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                              color: AppColors.white,
                                              position: PopupMenuPosition.under,
                                              padding: EdgeInsetsDirectional.zero,
                                              menuPadding: EdgeInsetsDirectional.zero,
                                              onSelected: (value) {},
                                              style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                              itemBuilder:
                                                  (context) => [
                                                    PopupMenuItem(
                                                      padding: EdgeInsets.zero,
                                                      onTap: () async {},
                                                      value: "",
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(0),
                                                        child: SizedBox(
                                                          width: 165,
                                                          child: DropDownWithSearchPopup(
                                                            key: UniqueKey(),
                                                            onChanged: (value, index, selectedId, name) {
                                                              customPrint("hello");

                                                              controller.medicationValue.value = name;
                                                              Get.back();
                                                              controller.updateMedicalView(selectedId);
                                                            },
                                                            list: controller.globalController.selectedMedicalModel.toList(),
                                                            receiveParam: (String value) {},
                                                            selectedId: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                              child: IntrinsicWidth(child: ContainerDropdownViewPopUp(receiveParam: (isExpand) {}, name: controller.medicationValue.value)),
                                            ),
                                          if (controller.visitId.value == "null") const Text(textAlign: TextAlign.center, "-"),
                                        ],
                                      ),

                                      const Spacer(),
                                      // if (controller.visitId.value != "null") const SizedBox(width: 30),
                                      // if (controller.visitId.value == "null") Spacer(),
                                      IgnorePointer(
                                        ignoring: controller.patientData.value.responseData?.thirdPartyId != null,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Doctor", style: AppFonts.regular(12, AppColors.textBlack)),
                                            const SizedBox(height: 6),
                                            if (controller.visitId.value == "null") const Text(textAlign: TextAlign.center, "-"),
                                            if (controller.visitId.value != "null")
                                              SizedBox(
                                                height: 25,
                                                child: Obx(() {
                                                  return BaseDropdown2<SelectedDoctorModel>(
                                                    isRequired: true,
                                                    width: 170,
                                                    focusNode: controller.doctorFocusNode,
                                                    controller: controller.doctorController,
                                                    scrollController: scrollController,
                                                    direction: VerticalDirection.down,
                                                    inputDecoration: InputDecoration(
                                                      suffixIcon: const Padding(padding: EdgeInsets.all(0), child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey)),
                                                      fillColor: AppColors.white,
                                                      filled: true,
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                      hintText: controller.doctorValue.value.isEmpty ? "Select" : controller.doctorValue.value,
                                                      hintStyle: controller.doctorValue.value.isEmpty ? AppFonts.regular(14, AppColors.textDarkGrey) : AppFonts.regular(14, AppColors.textBlack),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.white)),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.white)),
                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(width: 0, color: AppColors.white)),
                                                    ),
                                                    valueAsString: (SelectedDoctorModel? model) => model?.name ?? "",
                                                    items: controller.globalController.selectedDoctorModel.toList(),
                                                    selectedValue: controller.selectedDoctorValueModel.value,
                                                    itemBuilder: (p0) {
                                                      return Container(
                                                        color: Colors.white,
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: BaseImageView(height: 32, width: 32, nameLetters: p0.name ?? "", fontSize: 12, imageUrl: p0.profileImage ?? ""))),
                                                            const SizedBox(width: 10),
                                                            Expanded(child: Container(color: AppColors.white, child: Text(p0.name ?? "", style: AppFonts.medium(14, AppColors.black)))),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    onChanged: (SelectedDoctorModel? model) {
                                                      controller.doctorValue.value = model?.name ?? "";
                                                      controller.doctorValue.refresh();
                                                      controller.updateDoctorView(model?.id ?? -1);
                                                    },
                                                    selectText: controller.doctorValue.value,
                                                    isSearchable: true,
                                                  );
                                                }),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (controller.visitId.value != "null")
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                // Remove splash color
                                highlightColor: Colors.transparent, // Remove highlight color
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                tilePadding: const EdgeInsets.only(left: 16, right: 16),
                                childrenPadding: const EdgeInsets.all(0),
                                collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.backgroundWhite,
                                collapsedBackgroundColor: AppColors.backgroundWhite,
                                title: Row(children: [Text(textAlign: TextAlign.center, "Patient Summery", style: AppFonts.regular(16, AppColors.textBlack)), const Spacer()]),
                                children: <Widget>[controller.editableVisitSnapShot.isEmpty ? patientMedicalHistoryEmptyWidget("Patient summery found") : VisitSnapShotEditbale(controller: controller), const SizedBox(height: 10)],
                              ),
                            ),
                          if (controller.visitId.value != "null") const SizedBox(height: 10.0),
                          if (controller.visitId.value != "null")
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                // Remove splash color
                                highlightColor: Colors.transparent, // Remove highlight color
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                childrenPadding: const EdgeInsets.all(0),
                                tilePadding: const EdgeInsets.only(left: 16, right: 16),
                                collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.backgroundWhite,
                                collapsedBackgroundColor: AppColors.backgroundWhite,
                                title: Row(children: [Text(textAlign: TextAlign.center, "Personal Note", style: AppFonts.regular(16, AppColors.textBlack)), const Spacer()]),
                                children: <Widget>[controller.editablePersnoalNote.isEmpty ? patientMedicalHistoryEmptyWidget("No personal note found") : PersnoalNoteEditable(controller: controller), const SizedBox(height: 10)],
                              ),
                            ),
                          if (controller.visitId.value != "null") const SizedBox(height: 10.0),
                          if (controller.visitId.value != "null")
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                // Remove splash color
                                highlightColor: Colors.transparent, // Remove highlight color
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                childrenPadding: const EdgeInsets.all(0),
                                tilePadding: const EdgeInsets.only(left: 16, right: 16),
                                collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.backgroundWhite,
                                collapsedBackgroundColor: AppColors.backgroundWhite,
                                title: Row(children: [Text(textAlign: TextAlign.center, "Patient Medical History", style: AppFonts.regular(16, AppColors.textBlack)), const Spacer()]),
                                children: <Widget>[
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Cancer History", child: controller.editableCancerHistory.isEmpty ? patientMedicalHistoryEmptyWidget("No cancer history found") : CancerHistoryEditable(controller: controller))),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Medications History", child: controller.editableMedicationHistory.isEmpty ? patientMedicalHistoryEmptyWidget("No medications history found") : MedicationHistoryEditable(controller: controller))),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Skin History", child: controller.editableSkinHistory.isEmpty ? patientMedicalHistoryEmptyWidget("No skin history found") : SkinHistoryEditable(controller: controller))),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Social History", child: controller.editableSocialHistory.isEmpty ? patientMedicalHistoryEmptyWidget("No social history found") : SocialHistoryEditable(controller: controller))),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Allergies", child: controller.editableAllergies.isEmpty ? patientMedicalHistoryEmptyWidget("No allergies found") : AllergiesEditable(controller: controller))),
                                  const SizedBox(height: 2),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          Theme(
                            data: ThemeData(
                              splashColor: Colors.transparent,
                              // Remove splash color
                              highlightColor: Colors.transparent, // Remove highlight color
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              childrenPadding: const EdgeInsets.all(0),
                              tilePadding: const EdgeInsets.only(left: 16, right: 16),
                              collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              backgroundColor: AppColors.backgroundWhite,
                              collapsedBackgroundColor: AppColors.backgroundWhite,
                              title: Row(children: [Text(textAlign: TextAlign.start, "Scheduled Visits", style: AppFonts.regular(16, AppColors.textBlack)), const Spacer()]),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      bool isAccessible = (controller.patientDetailModel.value?.responseData!.scheduledVisits?[index].thirdPartyId != null);

                                      return InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  // Fixed width Date column
                                                  SizedBox(
                                                    width: 100, // Fixed width for date
                                                    child: Align(alignment: Alignment.centerLeft, child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, controller.visitDate(controller.patientDetailModel.value?.responseData!.scheduledVisits?[index].visitDate), style: AppFonts.regular(14, AppColors.textGrey))),
                                                  ),

                                                  const SizedBox(width: 15), // Spacing between date and time
                                                  // Fixed width Time column
                                                  SizedBox(
                                                    width: 80, // Fixed width for time
                                                    child: Align(alignment: Alignment.center, child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, controller.visitTime(controller.patientDetailModel.value?.responseData!.scheduledVisits?[index].visitTime), style: AppFonts.regular(14, AppColors.textGrey))),
                                                  ),

                                                  // Spacer to push actions to the right
                                                  const Expanded(child: SizedBox()),

                                                  // Action Buttons (right-aligned)
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    spacing: 10,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString() != controller.visitId.value) {
                                                            customPrint("print");
                                                            controller.globalController.breadcrumbHistory.removeLast();
                                                            controller.globalController.addRoute(Routes.VISIT_MAIN);
                                                            Get.toNamed(Routes.VISIT_MAIN, preventDuplicates: false, arguments: {"visitId": controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString(), "patientId": controller.patientId.value, "unique_tag": DateTime.now().toString()})?.then((value) => Get.back());
                                                          } else {
                                                            if (controller.globalController.visitId.isNotEmpty) {
                                                              CustomToastification().showToast("Recording is already in progress", type: ToastificationType.info);
                                                            } else {
                                                              final btGranted = Platform.isAndroid ? await Permission.bluetoothConnect.request().isGranted : true;
                                                              if (await controller.globalController.recorderService.audioRecorder.hasPermission() && btGranted) {
                                                                controller.globalController.isStartTranscript.value = true;
                                                                controller.globalController.patientFirstName.value = controller.patientData.value.responseData?.patientFirstName ?? "";
                                                                controller.globalController.attachmentId.value = controller.patientId.value;
                                                                controller.globalController.patientLsatName.value = controller.patientData.value.responseData?.patientLastName ?? "";
                                                                controller.globalController.valueOfx.value = 0;
                                                                controller.globalController.valueOfy.value = 0;
                                                                controller.globalController.visitId = controller.visitId;
                                                                controller.globalController.patientId = controller.patientId;
                                                                controller.globalController.changeStatus("In-Room");
                                                                controller.globalController.startAudioWidget();
                                                                controller.globalController.recorderService.audioRecorder = AudioRecorder();
                                                                controller.globalController.getConnectedInputDevices();

                                                                controller.globalController.samples.assignAll(
                                                                  List.generate(
                                                                    30,
                                                                    (index) => AudioWaveBar(
                                                                      heightFactor: 0.4, // Creates a repeating pattern
                                                                      color: AppColors.backgroundPurple,
                                                                    ),
                                                                  ),
                                                                );

                                                                await controller.globalController.recorderService.startRecording(context);
                                                              } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && (await Permission.bluetoothConnect.isPermanentlyDenied || await Permission.bluetoothConnect.isDenied)) {
                                                                showDialog(barrierDismissible: false, context: context, builder: (context) => PermissionAlert(permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.", permissionTitle: "Microphone permission request", isMicPermission: true));
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text((controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString() != controller.visitId.value) ? "Start visit now" : "Start Transcribing", style: AppFonts.regular(14, AppColors.backgroundPurple))),
                                                      ),
                                                      IgnorePointer(
                                                        ignoring: isAccessible,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (controller.isConnected.value) {
                                                              DateTime visitdate = DateTime.parse(controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].visitTime ?? "");
                                                              DateTime visitTimeS = DateTime.parse(controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].visitTime ?? "");
                                                              String formattedTime = DateFormat('hh:mm a').format(visitTimeS.toLocal());

                                                              showDialog(
                                                                context: context,
                                                                barrierDismissible: true,
                                                                builder: (BuildContext context) {
                                                                  return HomeReschedulePatientDialog(
                                                                    receiveParam: (p0, p1, doctorId, medicalId) {
                                                                      Map<String, dynamic> param = {};
                                                                      param['visit_date'] = p1;
                                                                      param['visit_time'] = p0;
                                                                      if (doctorId != -1) param['doctor_id'] = doctorId;
                                                                      if (medicalId != -1) param['medical_assistant_id'] = medicalId;
                                                                      controller.patientReScheduleCreate(param: param, visitId: controller.patientDetailModel.value?.responseData?.scheduledVisits![index].id.toString() ?? "-1");
                                                                    },
                                                                    visitDate: Rxn(visitdate),
                                                                    selectedDoctorValueSchedule: null,
                                                                    selectedMedicalValueSchedule: null,
                                                                    selectedVisitTimeValue: RxnString(formattedTime),
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              CustomToastification().showToast("Internet is required for this feature", type: ToastificationType.info);
                                                            }
                                                          },
                                                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("Reschedule", style: AppFonts.regular(14, isAccessible ? AppColors.backgroundPurple.withValues(alpha: 0.5) : AppColors.backgroundPurple))),
                                                        ),
                                                      ),
                                                      IgnorePointer(
                                                        ignoring: isAccessible,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (controller.isConnected.value) {
                                                              showDialog(
                                                                context: context,
                                                                barrierDismissible: true,
                                                                builder: (BuildContext context) {
                                                                  return DeleteScheduleVisit(
                                                                    onDelete: () {
                                                                      controller.changeStatus("Cancelled", controller.patientDetailModel.value?.responseData?.scheduledVisits![index].id.toString() ?? "");
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              CustomToastification().showToast("Internet is required for this feature", type: ToastificationType.info);
                                                            }
                                                          },
                                                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("Cancel visit", style: AppFonts.regular(14, isAccessible ? AppColors.backgroundPurple.withValues(alpha: 0.5) : AppColors.backgroundPurple))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              if (index != 7) ...[const Divider(height: 1, color: AppColors.appbarBorder)],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: controller.patientDetailModel.value?.responseData?.scheduledVisits?.length ?? 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Theme(
                            data: ThemeData(
                              splashColor: Colors.transparent,
                              // Remove splash color
                              highlightColor: Colors.transparent, // Remove highlight color
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              tilePadding: const EdgeInsets.only(left: 16, right: 16),
                              childrenPadding: const EdgeInsets.all(0),
                              collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              backgroundColor: AppColors.backgroundWhite,
                              collapsedBackgroundColor: AppColors.backgroundWhite,
                              title: Row(children: [Text(textAlign: TextAlign.start, "Visit Recaps ( ${controller.visitRecapList.value?.responseData?.length ?? 0} Visits)", style: AppFonts.regular(16, AppColors.textBlack)), const Spacer()]),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
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
                                                    Text(textAlign: TextAlign.center, controller.visitRecapformatDate(firstDate: controller.visitRecapList.value?.responseData?[index].visitDate ?? ""), style: AppFonts.medium(14, AppColors.textGrey)),
                                                    const SizedBox(width: 15),
                                                    Expanded(child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, controller.visitRecapList.value?.responseData?[index].summary ?? "", style: AppFonts.regular(14, AppColors.textGrey))),
                                                    // Spacer(),
                                                    const SizedBox(width: 5),
                                                    GestureDetector(
                                                      onTap: () {
                                                        customPrint("vid:- ${controller.visitRecapList.value?.responseData?[index].id} pid:- ${controller.patientId.value}");
                                                        controller.globalController.addRoute(Routes.PATIENT_INFO);
                                                        Get.toNamed(Routes.PATIENT_INFO, arguments: {"visitId": controller.visitRecapList.value?.responseData?[index].id.toString(), "patientId": controller.patientId.value, "unique_tag": DateTime.now().toString()});
                                                      },
                                                      child: Text(textAlign: TextAlign.center, "View", style: AppFonts.medium(12, AppColors.textPurple)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                if (index != 7) ...[const Divider(height: 1, color: AppColors.appbarBorder)],
                                              ],
                                            ),
                                          ),
                                        ),
                                    itemCount: controller.visitRecapList.value?.responseData?.length ?? 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Theme(
                            data: ThemeData(
                              splashColor: Colors.transparent,
                              // Remove splash color
                              highlightColor: Colors.transparent, // Remove highlight color
                            ),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              tilePadding: const EdgeInsets.only(left: 16, right: 16),
                              childrenPadding: const EdgeInsets.all(0),
                              collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                              backgroundColor: AppColors.backgroundWhite,
                              collapsedBackgroundColor: AppColors.backgroundWhite,
                              title: Row(
                                children: [
                                  Text(textAlign: TextAlign.center, "Attachments", style: AppFonts.regular(16, AppColors.textBlack)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      if (controller.isConnected.value) {
                                        controller.globalController.addRoute(Routes.ALL_ATTACHMENT);
                                        var result = await Get.toNamed(Routes.ALL_ATTACHMENT, arguments: {"visit_id": controller.patientId.value});

                                        if (result != null) {
                                          controller.getPatientAttachment();
                                        }
                                      } else {
                                        CustomToastification().showToast("Internet is require for this feature", type: ToastificationType.info);
                                      }
                                    },
                                    child: Text(textAlign: TextAlign.center, "View All Attachments", style: AppFonts.regular(15, AppColors.textPurple)),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    child: SvgPicture.asset(ImagePath.logo_filter, width: 40, height: 40),
                                    onTap: () {
                                      // Get.put(VisitMainController());
                                      aweSideSheet(
                                        header: const SizedBox(),
                                        footer: const SizedBox(),
                                        showActions: false,
                                        backgroundColor: AppColors.white,
                                        barrierDismissible: true,
                                        showCloseButton: false,
                                        showBackButton: true,
                                        context: context,
                                        body: VisitMainAttachmentFilter(
                                          onTap: () {
                                            customPrint("on tap VisitMainAttachmentFilter");
                                            // controller.getPatientAttachment();
                                            // controller.getPastVisitList(isFist: true);
                                          },
                                        ),
                                        sheetPosition: SheetPosition.right,
                                      ).then((value) {
                                        customPrint("on then VisitMainAttachmentFilter");
                                        // controller.getPatientAttachment();
                                        // controller.getPastVisitList(isFist: true);
                                        customPrint("value");
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              children: <Widget>[
                                Obx(() {
                                  return Container(
                                    color: Colors.white,
                                    child:
                                        controller.patientAttachmentList.isNotEmpty
                                            ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: Obx(() {
                                                  customPrint("Obx called-----------------");
                                                  return ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    padding: const EdgeInsets.only(top: 20),
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        height: 200,
                                                        width: 140,
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(height: 10),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Stack(
                                                                  clipBehavior: Clip.none,
                                                                  alignment: Alignment.topRight,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(color: AppColors.appbarBorder, borderRadius: BorderRadius.circular(10)),
                                                                      width: 120,
                                                                      height: 120,
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          customPrint(controller.patientAttachmentList[index].fileType?.contains("image"));

                                                                          final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));

                                                                          if (controller.patientAttachmentList[index].fileType?.contains("image") ?? false) {
                                                                            showDialog(
                                                                              context: context,
                                                                              barrierDismissible: true,
                                                                              // Allows dismissing the dialog by tapping outside
                                                                              builder: (BuildContext context) {
                                                                                return ViewAttachmentImage(imageUrl: controller.patientAttachmentList[index].filePath ?? "", attachmentUrl: '');

                                                                                // return ViewAttachmentImage(imageUrl: controller.patientAttachmentList[index].filePath ?? "", attchmentUrl: '');
                                                                              },
                                                                            );
                                                                          } else {
                                                                            Uri attchmentUri = Uri.parse(controller.patientAttachmentList[index].filePath ?? "");
                                                                            customPrint("attchmentUri is :- $attchmentUri");
                                                                            controller.launchInAppWithBrowserOptions(attchmentUri);
                                                                          }
                                                                        },
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          // Set the radius here
                                                                          child: CachedNetworkImage(
                                                                            imageUrl: controller.patientAttachmentList[index].filePath ?? "",
                                                                            width: 120,
                                                                            height: 120,
                                                                            errorWidget: (context, url, error) {
                                                                              return Image.asset(ImagePath.file_placeHolder);
                                                                            },
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: -10,
                                                                      // Align at the top of the first container
                                                                      right: -10,
                                                                      child: Container(
                                                                        width: 40,
                                                                        height: 40,
                                                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 2.2, offset: const Offset(0.2, 0))]),
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            showDialog(
                                                                              context: context,
                                                                              barrierDismissible: true,
                                                                              builder: (BuildContext context) {
                                                                                // return SizedBox();
                                                                                return DeleteImageDialog(
                                                                                  onDelete: () {
                                                                                    controller.deleteAttachments(controller.patientAttachmentList[index].id ?? 0);
                                                                                  },
                                                                                  extension: controller.patientAttachmentList[index].fileType,
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: SvgPicture.asset(ImagePath.delete_black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 6),
                                                                Text(maxLines: 1, controller.patientAttachmentList[index].fileName ?? "", style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                                const SizedBox(height: 6),
                                                                Text(DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.patientAttachmentList[index].createdAt ?? "").toLocal()), style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder: (context, index) => const SizedBox(width: Dimen.margin15),
                                                    itemCount: controller.patientAttachmentList.length,
                                                  );
                                                }),
                                              ),
                                            )
                                            : Container(width: double.infinity, height: 200, child: const Center(child: Text("Attachments Not available"))),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (!controller.keyboardController.isKeyboardOpen.value) ...[
                Obx(() {
                  return Container(
                    color: AppColors.ScreenBackGround1,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      // color: AppColors.backgroundWhite,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                      child: Row(
                        spacing: 15,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: PopupMenuButton<String>(
                              offset: const Offset(0, -290),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              color: AppColors.white,
                              position: PopupMenuPosition.under,
                              padding: EdgeInsetsDirectional.zero,
                              menuPadding: EdgeInsetsDirectional.zero,
                              onSelected: (value) {},
                              style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero), tapTargetSize: MaterialTapTargetSize.shrinkWrap, maximumSize: WidgetStatePropertyAll(Size.zero), visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      padding: EdgeInsets.zero,
                                      onTap: () {
                                        controller.captureImage(context);
                                      },
                                      // value: "",
                                      child: Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.camera, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Take Photo or Video", style: AppFonts.regular(16, AppColors.textBlack))])),
                                    ),
                                    PopupMenuItem(
                                      padding: EdgeInsets.zero,
                                      onTap: () async {
                                        controller.captureImage(context, fromCamera: false);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: double.infinity, height: 1, color: AppColors.textDarkGrey),
                                          Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Choose Photo", style: AppFonts.regular(16, AppColors.textBlack))])),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      // value: "",
                                      padding: EdgeInsets.zero,
                                      onTap: () async {
                                        // controller.captureProfileImage();
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                          Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.document_scanner_sharp, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Scan Documents", style: AppFonts.regular(16, AppColors.textDarkGrey))])),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      // value: "",
                                      padding: EdgeInsets.zero,
                                      onTap: () async {
                                        controller.pickFilesForDoc();
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                                          Padding(padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10), child: Row(children: [const Icon(Icons.file_copy_rounded, color: AppColors.textDarkGrey), const SizedBox(width: 10), Text("Attach File", style: AppFonts.regular(16, AppColors.textBlack))])),
                                        ],
                                      ),
                                    ),
                                  ],
                              child: Container(
                                height: 81,
                                decoration: BoxDecoration(border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)), color: AppColors.backgroundLightGrey, borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(ImagePath.add_photo, height: 30, width: 30),
                                        const SizedBox(height: 10),
                                        Text(textAlign: TextAlign.center, "Add a Photo ", style: AppFonts.medium(16, AppColors.textBlack)),
                                        // SvgPicture.asset(ImagePath.add_photo, height: 30, width: 30),
                                        // SizedBox(height: 10),
                                        // Text(textAlign: TextAlign.center, "Add a Photo ", style: AppFonts.medium(16, AppColors.textBlack)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (controller.globalController.isStartRecording.value == false) ...[
                            if (controller.patientData.value.responseData?.visitStatus == "Scheduled") ...[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (controller.globalController.visitId.isNotEmpty) {
                                      CustomToastification().showToast("Recording is already in progress", type: ToastificationType.info);
                                    } else {
                                      final btGranted = Platform.isAndroid ? await Permission.bluetoothConnect.request().isGranted : true;
                                      if (await controller.globalController.recorderService.audioRecorder.hasPermission() && btGranted) {
                                        controller.globalController.isStartTranscript.value = true;

                                        // controller.globalController.patientId.value = controller.patientId.value;
                                        // controller.globalController.visitId.value = controller.visitId.value;

                                        controller.globalController.patientFirstName.value = controller.patientData.value.responseData?.patientFirstName ?? "";
                                        controller.globalController.attachmentId.value = controller.patientId.value;
                                        controller.globalController.patientLsatName.value = controller.patientData.value.responseData?.patientLastName ?? "";
                                        controller.globalController.patientFirstName.value = controller.patientData.value.responseData?.patientFirstName ?? "";
                                        controller.globalController.patientLsatName.value = controller.patientData.value.responseData?.patientLastName ?? "";

                                        controller.globalController.valueOfx.value = 0;
                                        controller.globalController.valueOfy.value = 0;

                                        controller.globalController.visitId = controller.visitId;
                                        controller.globalController.patientId = controller.patientId;

                                        controller.globalController.selectedLanguageValue = RxnString("English");

                                        controller.globalController.changeStatus("In-Room");
                                        // If not recording, start the recording
                                        controller.globalController.startAudioWidget();
                                        controller.globalController.recorderService.audioRecorder = AudioRecorder();
                                        controller.globalController.getConnectedInputDevices();

                                        controller.globalController.samples.assignAll(
                                          List.generate(
                                            30,
                                            (index) => AudioWaveBar(
                                              heightFactor: 0.4, // Creates a repeating pattern
                                              color: AppColors.backgroundPurple,
                                            ),
                                          ),
                                        );

                                        await controller.globalController.recorderService.startRecording(context);
                                        controller.updateData();
                                      } else if ((await Permission.microphone.isPermanentlyDenied || await Permission.microphone.isDenied) && (await Permission.bluetoothConnect.isPermanentlyDenied || await Permission.bluetoothConnect.isDenied)) {
                                        // Handle permission denial here

                                        showDialog(barrierDismissible: false, context: context, builder: (context) => PermissionAlert(permissionDescription: "To record audio, the app needs access to your microphone. Please enable the microphone permission in your app settings.", permissionTitle: " Microphone  permission request", isMicPermission: true));
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 81,
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.backgroundPurple), color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(ImagePath.ai_white, height: 30, width: 30),
                                            const SizedBox(height: 10),

                                            Obx(() {
                                              return Text(
                                                textAlign: TextAlign.center,
                                                (controller.globalController.visitId.value != controller.visitId.value)
                                                    ? "Start Transcribing"
                                                    : (controller.globalController.visitId.isNotEmpty)
                                                    ? "Recording in progress "
                                                    : "Start Transcribing",
                                                style: AppFonts.medium(16, AppColors.textWhite),
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                          if (controller.globalController.isStartRecording.value) ...[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Get.toNamed(Routes.PATIENT_INFO);
                                },
                                child: Container(
                                  height: 81,
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.buttonBackgroundGreen), color: AppColors.buttonBackgroundGreen, borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(ImagePath.pause, height: 30, width: 30),
                                          const SizedBox(height: 10),
                                          Text(textAlign: TextAlign.center, "Pause", style: AppFonts.medium(16, AppColors.textWhite)),
                                          SvgPicture.asset(ImagePath.pause, height: 30, width: 30),
                                          const SizedBox(height: 10),
                                          Text(textAlign: TextAlign.center, "Pause", style: AppFonts.medium(16, AppColors.textWhite)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.globalController.isStartRecording.value = false;
                                },
                                child: Container(
                                  height: 81,
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.buttonBackgroundred), color: AppColors.buttonBackgroundred, borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(ImagePath.stop_transcript, height: 30, width: 30),
                                          const SizedBox(height: 10),
                                          Text(textAlign: TextAlign.center, "Stop Transcribing", style: AppFonts.medium(16, AppColors.textWhite)),
                                          SvgPicture.asset(ImagePath.stop_transcript, height: 30, width: 30),
                                          const SizedBox(height: 10),
                                          Text(textAlign: TextAlign.center, "Stop Transcribing", style: AppFonts.medium(16, AppColors.textWhite)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget patientMedicalHistoryEmptyWidget(String message) {
    return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Row(children: [Expanded(child: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 16)))])));
  }
}
