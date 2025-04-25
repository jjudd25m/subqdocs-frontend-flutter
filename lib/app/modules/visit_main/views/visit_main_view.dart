import 'dart:io';
import 'dart:ui';

import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:subqdocs/app/modules/home/views/search_drop_down.dart';
import 'package:subqdocs/app/modules/visit_main/views/table_custom.dart';
import 'package:subqdocs/app/modules/visit_main/views/view_attchment_image.dart';
import 'package:subqdocs/app/modules/visit_main/views/visit_main_attachment_filter.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widgets/base_screen.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/bredcums.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/custom_table.dart';
import '../../../core/common/common_service.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';
import '../../home/views/container_view_dropdown.dart';
import '../../home/views/drop_down_with_search_popup.dart';
import '../../home/views/in_search_drop_down.dart';
import '../../home/views/reschedule_patient_dialog.dart';
import '../../home/views/schedule_patient_dialog.dart';
import '../controllers/visit_main_controller.dart';
import '../model/patient_attachment_list_model.dart';
import 'delete_image_dialog.dart';
import 'delete_schedule_visit.dart';

class VisitMainView extends StatefulWidget {
  const VisitMainView({super.key});

  @override
  State<VisitMainView> createState() => _VisitMainViewState();
}

class _VisitMainViewState extends State<VisitMainView> {
  VisitMainController controller = Get.find<VisitMainController>(tag: Get.arguments["unique_tag"]);

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
        return Column(
          children: [
            CustomAppBar(drawerkey: _key),
            Expanded(
              child: Container(
                color: AppColors.ScreenBackGround1,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: RefreshIndicator(
                  onRefresh: controller.onRefresh, // Trigger the refresh
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BreadcrumbWidget(
                          breadcrumbHistory: controller.globalController.breadcrumbHistory.value,
                          onBack: (breadcrumb) {
                            controller.globalController.popUntilRoute(breadcrumb);
                            // Get.offAllNamed(globalController.getKeyByValue(breadcrumb));

                            while (Get.currentRoute != controller.globalController.getKeyByValue(breadcrumb)) {
                              Get.back(); // Pop the current screen
                            }
                          },
                        ),
                        SizedBox(height: 0.0),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
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
                                      Get.back();
                                    },
                                    child: Container(color: AppColors.white, padding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0, right: 20.0), child: SvgPicture.asset(ImagePath.logo_back, height: 20, width: 20)),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: BaseImageView(
                                      imageUrl: controller.patientData.value?.responseData?.profileImage ?? "",
                                      height: 60,
                                      width: 60,
                                      nameLetters: "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}",
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""} ",
                                        style: AppFonts.medium(16, AppColors.textBlack),
                                      ),
                                      SizedBox(width: 15),
                                      Text(textAlign: TextAlign.center, controller.patientData.value?.responseData?.patientId ?? "", style: AppFonts.regular(11, AppColors.textGrey)),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Container(width: double.infinity, height: 1, color: AppColors.appbarBorder),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(textAlign: TextAlign.center, "Age", style: AppFonts.regular(12, AppColors.textBlack)),
                                        SizedBox(height: 6),
                                        Text(
                                          textAlign: TextAlign.center,
                                          (controller.patientData.value?.responseData?.age.toString() ?? "") == "null" ? "N/A" : controller.patientData.value?.responseData?.age.toString() ?? "",
                                          style: AppFonts.regular(14, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(textAlign: TextAlign.center, "Gender", style: AppFonts.regular(12, AppColors.textBlack)),
                                        SizedBox(height: 6),
                                        Text(textAlign: TextAlign.center, controller.patientData.value?.responseData?.gender ?? "", style: AppFonts.regular(14, AppColors.textGrey)),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(textAlign: TextAlign.center, "Visit Date & Time", style: AppFonts.regular(12, AppColors.textBlack)),
                                        SizedBox(height: 6),
                                        Text(
                                          textAlign: TextAlign.center,
                                          controller.formatDateTime(firstDate: controller.patientData.value?.responseData?.visitDate ?? "", secondDate: controller.patientData.value?.responseData?.visitTime ?? ""),
                                          style: AppFonts.regular(14, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(textAlign: TextAlign.start, "Medical Assistant", style: AppFonts.regular(12, AppColors.textBlack)),
                                        SizedBox(height: 6),
                                        PopupMenuButton<String>(
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
                                            visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                                          ),
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  padding: EdgeInsets.zero,
                                                  onTap: () async {},
                                                  value: "",
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: SizedBox(
                                                      width: 160,
                                                      child: DropDownWithSearchPopup(
                                                        key: UniqueKey(),
                                                        onChanged: (value, index, selectedId, name) {
                                                          print("hello");

                                                          controller.medicationValue.value = name;
                                                          Get.back();
                                                          controller.updateMedicalView(selectedId);
                                                        },
                                                        list: controller.globalController.selectedMedicalModel.value,
                                                        receiveParam: (String value) {},
                                                        selectedId: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                          child: SizedBox(width: 170, child: ContainerDropdownViewPopUp(receiveParam: (isExpand) {}, name: controller.medicationValue.value)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 30),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(textAlign: TextAlign.center, "Doctor", style: AppFonts.regular(12, AppColors.textBlack)),
                                        SizedBox(height: 6),
                                        PopupMenuButton<String>(
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
                                            visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                                          ),
                                          itemBuilder:
                                              (context) => [
                                                PopupMenuItem(
                                                  padding: EdgeInsets.zero,
                                                  onTap: () async {},
                                                  value: "",
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: SizedBox(
                                                      width: 160,
                                                      child: DropDownWithSearchPopup(
                                                        key: UniqueKey(),
                                                        onChanged: (value, index, selectedId, name) {
                                                          print("print the doctor view ");

                                                          controller.doctorValue.value = name;
                                                          Get.back();
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
                                          child: SizedBox(width: 170, child: ContainerDropdownViewPopUp(receiveParam: (isExpand) {}, name: controller.doctorValue.value)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Row(children: [Text(textAlign: TextAlign.center, "Next Visit Snapshot", style: AppFonts.regular(16, AppColors.textBlack)), Spacer()]),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(8)),
                                  child:
                                      (controller.patientData.value?.responseData?.visitSnapshot?.visitSnapshot ?? []).isEmpty
                                          ? Padding(padding: const EdgeInsets.all(8.0), child: Text("Visit Snapshot Not Found"))
                                          : Column(
                                            children: [
                                              for (String note in controller.patientData.value?.responseData?.visitSnapshot?.visitSnapshot ?? [])
                                                Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    if (controller.patientData.value?.responseData?.visitSnapshot?.visitSnapshot != 1) Text("•", style: AppFonts.regular(24, AppColors.textDarkGrey)),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        textAlign: TextAlign.start,
                                                        maxLines: 2,
                                                        note,
                                                        // "He enjoys fishing and gardening. His wife's name is Julie.",
                                                        style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                      ),
                                                    ),
                                                    SizedBox(width: 7),
                                                    SizedBox(width: 7),
                                                  ],
                                                ),
                                            ],
                                          ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Row(children: [Text(textAlign: TextAlign.center, "Personal Note", style: AppFonts.regular(16, AppColors.textBlack)), Spacer()]),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                    color: AppColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child:
                                      (controller.patientData.value?.responseData?.personalNote?.personalNote ?? []).isEmpty
                                          ? Padding(padding: const EdgeInsets.all(8.0), child: Text("Personal Note Not Found"))
                                          : Column(
                                            children: [
                                              for (String note in controller.patientData.value?.responseData?.personalNote?.personalNote ?? [])
                                                Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    if (controller.patientData.value?.responseData?.personalNote?.personalNote?.length != 1) Text("•", style: AppFonts.regular(24, AppColors.textDarkGrey)),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        textAlign: TextAlign.start,
                                                        maxLines: 2,
                                                        note,
                                                        // "He enjoys fishing and gardening. His wife's name is Julie.",
                                                        style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                      ),
                                                    ),
                                                    SizedBox(width: 7),
                                                    SizedBox(width: 7),
                                                  ],
                                                ),
                                            ],
                                          ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Row(children: [Text(textAlign: TextAlign.center, "Patient Medical History", style: AppFonts.regular(16, AppColors.textBlack)), Spacer()]),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                        color: AppColors.white,
                                        border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), topRight: Radius.circular(6)),
                                              color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                            ),
                                            // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [Text(textAlign: TextAlign.center, "Cancer History", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child:
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistory != null ?? false
                                                    ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) => InkWell(
                                                            onTap: () {},
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                                    crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                                    children: [
                                                                      SizedBox(width: 10),
                                                                      Text("•", style: AppFonts.regular(24, AppColors.textGrey)),
                                                                      SizedBox(width: 10),
                                                                      Expanded(child: Text(controller.medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistory ?? "", style: AppFonts.regular(14, AppColors.textGrey))),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 0),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      itemCount: 1,
                                                    )
                                                    : Row(children: [Text(textAlign: TextAlign.left, "No data available", style: AppFonts.medium(16, AppColors.textBlack)), Spacer()]),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                        color: AppColors.white,
                                        border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                              color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                            ),
                                            // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [Text(textAlign: TextAlign.center, "Medication History", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications != null
                                                    ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                      crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                      children: [
                                                        SizedBox(width: 7),
                                                        SizedBox(width: Get.width * .25, child: Text("Medication Name", style: AppFonts.regular(14, AppColors.black))),
                                                        SizedBox(width: 7),
                                                        SizedBox(width: Get.width * .45, child: Text("Purpose", style: AppFonts.regular(14, AppColors.black))),
                                                        SizedBox(width: 7),
                                                        SizedBox(width: Get.width * .15, child: Text("Dosage", style: AppFonts.regular(14, AppColors.black))),
                                                        SizedBox(width: 7),
                                                      ],
                                                    )
                                                    : SizedBox(),
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications != null ? SizedBox(height: 10) : SizedBox(),
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications != null ? Container(height: 0.5, width: double.infinity, color: AppColors.textGrey) : SizedBox(),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child:
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?.isNotEmpty ?? false
                                                    ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) => InkWell(
                                                            onTap: () {},
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                                    crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                                    children: [
                                                                      SizedBox(width: 7),
                                                                      SizedBox(
                                                                        width: Get.width * .25,
                                                                        child:
                                                                            (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].title ?? "") != ""
                                                                                ? Text(
                                                                                  controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].title ?? "-",
                                                                                  style: AppFonts.regular(14, AppColors.textGrey),
                                                                                )
                                                                                : Text("-", style: AppFonts.regular(14, AppColors.textGrey)),
                                                                      ),
                                                                      SizedBox(width: 7),
                                                                      SizedBox(
                                                                        width: Get.width * .45,
                                                                        child:
                                                                            (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].purpose ?? "") != ""
                                                                                ? Text(
                                                                                  (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].purpose ?? "-"),
                                                                                  style: AppFonts.regular(14, AppColors.textGrey),
                                                                                )
                                                                                : Text("-", style: AppFonts.regular(14, AppColors.textGrey)),
                                                                      ),
                                                                      SizedBox(width: 7),
                                                                      SizedBox(
                                                                        width: Get.width * .15,
                                                                        child:
                                                                            (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].dosage ?? "") != ""
                                                                                ? Text(
                                                                                  controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].dosage ?? "-",
                                                                                  style: AppFonts.regular(14, AppColors.textGrey),
                                                                                )
                                                                                : Text("-", style: AppFonts.regular(14, AppColors.textGrey)),
                                                                      ),
                                                                      SizedBox(width: 7),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 0),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      itemCount: controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?.length ?? 0,
                                                    )
                                                    : Row(children: [Text(textAlign: TextAlign.left, "No data available", style: AppFonts.medium(16, AppColors.textBlack)), Spacer()]),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                        color: AppColors.white,
                                        border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                              color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                            ),
                                            // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [Text(textAlign: TextAlign.center, "Skin History", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child:
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.skinHistory != null
                                                    ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) => InkWell(
                                                            onTap: () {},
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                                    crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                                    children: [
                                                                      SizedBox(width: 10),
                                                                      Text("•", style: AppFonts.regular(24, AppColors.black)),
                                                                      SizedBox(width: 10),
                                                                      Expanded(child: Text(controller.medicalRecords.value?.responseData?.fullNoteDetails?.skinHistory ?? "", style: AppFonts.regular(14, AppColors.textGrey))),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 0),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      itemCount: 1,
                                                    )
                                                    : Row(children: [Text(textAlign: TextAlign.left, "No data available", style: AppFonts.medium(16, AppColors.textBlack)), Spacer()]),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                        color: AppColors.white,
                                        border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                              color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                            ),
                                            // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [Text(textAlign: TextAlign.center, "Social History", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child:
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.socialHistory != null ?? false
                                                    ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) => InkWell(
                                                            onTap: () {},
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                                    crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                                    children: [
                                                                      SizedBox(width: 10),
                                                                      Text("•", style: AppFonts.regular(24, AppColors.black)),
                                                                      SizedBox(width: 10),
                                                                      Expanded(child: Text(controller.medicalRecords.value?.responseData?.fullNoteDetails?.socialHistory ?? "", style: AppFonts.regular(14, AppColors.textGrey))),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 0),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      itemCount: 1,
                                                    )
                                                    : Row(children: [Text(textAlign: TextAlign.left, "No data available", style: AppFonts.medium(16, AppColors.textBlack)), Spacer()]),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                        color: AppColors.white,
                                        border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                              color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                              border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                            ),
                                            // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [Text(textAlign: TextAlign.center, "Allergies", style: AppFonts.medium(16, AppColors.textPurple)), Spacer()]),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child:
                                                controller.medicalRecords.value?.responseData?.fullNoteDetails?.allergies != null ?? false
                                                    ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) => InkWell(
                                                            onTap: () {},
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                                                    crossAxisAlignment: CrossAxisAlignment.center, // Align the content vertically centered
                                                                    children: [
                                                                      SizedBox(width: 10),
                                                                      Text("•", style: AppFonts.regular(24, AppColors.black)),
                                                                      SizedBox(width: 10),
                                                                      Expanded(child: Text(controller.medicalRecords.value?.responseData?.fullNoteDetails?.allergies ?? "", style: AppFonts.regular(14, AppColors.textGrey))),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 0),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      itemCount: 1,
                                                    )
                                                    : Row(children: [Text(textAlign: TextAlign.left, "No data available", style: AppFonts.medium(16, AppColors.textBlack)), Spacer()]),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Row(
                              children: [
                                Text(textAlign: TextAlign.start, "Scheduled Visits", style: AppFonts.regular(16, AppColors.textBlack)),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                    // color: AppColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(ImagePath.search, height: 14, width: 14),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 194,
                                        height: 25,
                                        child: TextField(
                                          maxLines: 1,
                                          textAlignVertical: TextAlignVertical.center, // Centers the text vertically
                                          decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                              ],
                            ),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (context, index) => InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      controller.visitDate(controller.patientDetailModel.value?.responseData!.scheduledVisits?[index].visitDate),
                                                      style: AppFonts.regular(14, AppColors.textGrey),
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      controller.visitTime(controller.patientDetailModel.value?.responseData!.scheduledVisits?[index].visitTime),
                                                      style: AppFonts.regular(14, AppColors.textGrey),
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                  SizedBox(width: 5),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("print");
                                                          Get.back();
                                                          controller.globalController.addRoute(Routes.VISIT_MAIN);
                                                          Get.toNamed(
                                                            Routes.VISIT_MAIN,
                                                            arguments: {
                                                              "visitId": controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString(),
                                                              "patientId": controller.patientId.value,
                                                              "unique_tag": DateTime.now().toString(),
                                                            },
                                                          );
                                                        },
                                                        child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, "Start visit now", style: AppFonts.regular(14, AppColors.backgroundPurple)),
                                                      ),
                                                      SizedBox(width: 30),
                                                      GestureDetector(
                                                        onTap: () {
                                                          controller.isConnected.value
                                                              ? showDialog(
                                                                context: context,
                                                                barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                builder: (BuildContext context) {
                                                                  return ReschedulePatientDialog(
                                                                    receiveParam: (p0, p1) {
                                                                      customPrint("p0 is $p0 p1 is $p1");
                                                                      customPrint("row index is :- ${index}");
                                                                      customPrint("visit id :- ${controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString()}");
                                                                      controller.patientReScheduleCreate(
                                                                        param: {"visit_date": p1, "visit_time": p0},
                                                                        visitId: controller.patientDetailModel.value?.responseData?.scheduledVisits![index].id.toString() ?? "-1",
                                                                      );
                                                                    },
                                                                  ); // Our custom dialog
                                                                },
                                                              )
                                                              : CustomToastification().showToast("Internet is require for this feature", type: ToastificationType.info);
                                                        },
                                                        child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, "Reschedule", style: AppFonts.regular(14, AppColors.backgroundPurple)),
                                                      ),
                                                      SizedBox(width: 30),
                                                      GestureDetector(
                                                        onTap: () {
                                                          controller.isConnected.value
                                                              ? showDialog(
                                                                context: context,
                                                                barrierDismissible: true,
                                                                builder: (BuildContext context) {
                                                                  // return SizedBox();
                                                                  return DeleteScheduleVisit(
                                                                    onDelete: () {
                                                                      controller.changeStatus("Cancelled", controller.patientDetailModel.value?.responseData?.scheduledVisits![index].id.toString() ?? "");

                                                                      // controller.globalController.changeStatus("Cancelled");

                                                                      // controller.deletePatientVisit(
                                                                      //     id: controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString() ?? "");
                                                                    },
                                                                  );
                                                                },
                                                              )
                                                              : CustomToastification().showToast("Internet is require for this feature", type: ToastificationType.info);
                                                        },
                                                        child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, "Cancel visit", style: AppFonts.regular(14, AppColors.backgroundPurple)),
                                                      ),
                                                      SizedBox(width: 60),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              if (index != 7) ...[Divider(height: 1, color: AppColors.appbarBorder)],
                                            ],
                                          ),
                                        ),
                                      ),
                                  itemCount: controller.patientDetailModel.value?.responseData?.scheduledVisits?.length ?? 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Row(
                              children: [
                                Text(textAlign: TextAlign.start, "Visit Recaps ( ${controller.visitRecapList.value?.responseData?.length ?? 0} Visits)", style: AppFonts.regular(16, AppColors.textBlack)),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                    // color: AppColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(ImagePath.search, height: 14, width: 14),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 194,
                                        height: 25,
                                        child: TextField(
                                          maxLines: 1,
                                          textAlignVertical: TextAlignVertical.center, // Centers the text vertically
                                          decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                              ],
                            ),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (context, index) => InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    controller.visitRecapformatDate(firstDate: controller.visitRecapList.value?.responseData?[index].visitDate ?? ""),
                                                    style: AppFonts.medium(14, AppColors.textGrey),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      controller.visitRecapList.value?.responseData?[index].summary?.firstOrNull ?? "",
                                                      style: AppFonts.regular(14, AppColors.textGrey),
                                                    ),
                                                  ),
                                                  // Spacer(),
                                                  SizedBox(width: 5),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print("vid:- ${controller.visitRecapList.value?.responseData?[index].id} pid:- ${controller.patientId.value}");
                                                      controller.globalController.addRoute(Routes.PATIENT_INFO);
                                                      Get.toNamed(
                                                        Routes.PATIENT_INFO,
                                                        arguments: {"visitId": controller.visitRecapList.value?.responseData?[index].id.toString(), "patientId": controller.patientId.value, "unique_tag": DateTime.now().toString()},
                                                      );
                                                    },
                                                    child: Text(textAlign: TextAlign.center, "View", style: AppFonts.medium(12, AppColors.textPurple)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              if (index != 7) ...[Divider(height: 1, color: AppColors.appbarBorder)],
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
                        SizedBox(height: 10),
                        Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent, // Remove splash color
                            highlightColor: Colors.transparent, // Remove highlight color
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.all(0),
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Row(
                              children: [
                                Text(textAlign: TextAlign.center, "Attachments", style: AppFonts.regular(16, AppColors.textBlack)),
                                Spacer(),
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
                                SizedBox(width: 10),
                                GestureDetector(
                                  child: SvgPicture.asset(ImagePath.logo_filter, width: 40, height: 40),
                                  onTap: () {
                                    // Get.put(VisitMainController());
                                    aweSideSheet(
                                      header: SizedBox(),
                                      footer: SizedBox(),
                                      showActions: false,
                                      backgroundColor: AppColors.white,
                                      barrierDismissible: true,
                                      showCloseButton: false,
                                      showBackButton: true,
                                      context: context,
                                      body: VisitMainAttachmentFilter(
                                        onTap: () {
                                          print("on tap VisitMainAttachmentFilter");
                                          // controller.getPatientAttachment();
                                          // controller.getPastVisitList(isFist: true);
                                        },
                                      ),
                                      sheetPosition: SheetPosition.right,
                                    ).then((value) {
                                      print("on then VisitMainAttachmentFilter");
                                      // controller.getPatientAttachment();
                                      // controller.getPastVisitList(isFist: true);
                                      print("value");
                                    });
                                  },
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                    // color: AppColors.backgroundWhite,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(ImagePath.search, height: 25, width: 25),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 120,
                                        child: TextField(
                                          controller: controller.searchController,
                                          onChanged: (value) {
                                            controller.getPatientAttachment();
                                          },
                                          maxLines: 1, //or null
                                          decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                SvgPicture.asset(ImagePath.edit_outline, height: 40, width: 40),
                              ],
                            ),
                            children: <Widget>[
                              Obx(() {
                                return Container(
                                  color: Colors.white,
                                  child:
                                      controller.patientAttachmentList.isNotEmpty
                                          ? Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: SizedBox(
                                              height: 200,
                                              width: double.infinity,
                                              child: Obx(() {
                                                print("Obx called-----------------");
                                                return ListView.separated(
                                                  scrollDirection: Axis.horizontal,
                                                  padding: EdgeInsets.only(top: 20),
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                      height: 200,
                                                      width: 140,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 10),
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

                                                                        if (controller.patientAttachmentList[index].fileType?.contains("image") ?? false) {
                                                                          showDialog(
                                                                            context: context,
                                                                            barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                            builder: (BuildContext context) {
                                                                              return ViewAttchmentImage(imageUrl: controller.patientAttachmentList[index].filePath ?? "", attchmentUrl: '');
                                                                            },
                                                                          );
                                                                        } else {
                                                                          Uri attchmentUri = Uri.parse(controller.patientAttachmentList[index].filePath ?? "");
                                                                          customPrint("attchmentUri is :- ${attchmentUri}");
                                                                          controller.launchInAppWithBrowserOptions(attchmentUri);
                                                                        }
                                                                      },
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(10), // Set the radius here
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
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.white,
                                                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2.2, offset: Offset(0.2, 0))],
                                                                      ),
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
                                                              SizedBox(height: 6),
                                                              Text(maxLines: 1, controller.patientAttachmentList[index].fileName ?? "", style: AppFonts.regular(12, AppColors.textDarkGrey)),
                                                              SizedBox(height: 6),
                                                              Text(
                                                                DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.patientAttachmentList[index].createdAt ?? "").toLocal()),
                                                                style: AppFonts.regular(12, AppColors.textDarkGrey),
                                                              ),
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
                                          : Container(width: double.infinity, height: 200, child: Center(child: Text("Attachments Not available"))),
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
            Obx(() {
              return Container(
                color: AppColors.ScreenBackGround1,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  // color: AppColors.backgroundWhite,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            maximumSize: WidgetStatePropertyAll(Size.zero),
                            visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                          ),
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  onTap: () {
                                    controller.captureImage(context);
                                  },
                                  // value: "",
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                    child: Row(children: [Icon(CupertinoIcons.camera, color: AppColors.textDarkGrey), SizedBox(width: 10), Text("Take Photo or Video", style: AppFonts.regular(16, AppColors.textBlack))]),
                                  ),
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
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                        child: Row(
                                          children: [Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: AppColors.textDarkGrey), SizedBox(width: 10), Text("Choose Photo", style: AppFonts.regular(16, AppColors.textBlack))],
                                        ),
                                      ),
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
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                        child: Row(children: [Icon(Icons.document_scanner_sharp, color: AppColors.textDarkGrey), SizedBox(width: 10), Text("Scan Documents", style: AppFonts.regular(16, AppColors.textDarkGrey))]),
                                      ),
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
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                        child: Row(children: [Icon(Icons.file_copy_rounded, color: AppColors.textDarkGrey), SizedBox(width: 10), Text("Attach File", style: AppFonts.regular(16, AppColors.textBlack))]),
                                      ),
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
                                  children: [SvgPicture.asset(ImagePath.add_photo, height: 30, width: 30), SizedBox(height: 10), Text(textAlign: TextAlign.center, "Add a Photo ", style: AppFonts.medium(16, AppColors.textBlack))],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (controller.globalController.isStartRecording.value == false) ...[
                        if (controller.patientData.value?.responseData?.visitStatus == "Scheduled") ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (controller.globalController.visitId.isNotEmpty) {
                                  CustomToastification().showToast("Recording is already in progress", type: ToastificationType.info);
                                } else {
                                  controller.globalController.isStartTranscript.value = true;

                                  controller.globalController.patientFirstName.value = controller.patientData.value?.responseData?.patientFirstName ?? "";
                                  controller.globalController.patientLsatName.value = controller.patientData.value?.responseData?.patientLastName ?? "";
                                }
                                // controller.isStartRecording.value = true;
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
                                        SizedBox(height: 10),
                                        Text(textAlign: TextAlign.center, "Start Transcribing", style: AppFonts.medium(16, AppColors.textWhite)),
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
                                    children: [SvgPicture.asset(ImagePath.pause, height: 30, width: 30), SizedBox(height: 10), Text(textAlign: TextAlign.center, "Pause", style: AppFonts.medium(16, AppColors.textWhite))],
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
                                      SizedBox(height: 10),
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
        );
      }),
    );
  }
}
