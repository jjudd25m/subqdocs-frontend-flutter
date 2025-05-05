import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../../home/views/container_view_dropdown.dart';
import '../../home/views/drop_down_with_search_popup.dart';
import '../../home/views/reschedule_patient_dialog.dart';
import '../../patient_info/views/EditableViews/CommonContainer.dart';
import '../../patient_info/views/EditableViews/cancer_history_editable_view.dart';
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
                              children: <Widget>[VisitSnapShotEditbale(controller: controller), SizedBox(height: 10)],
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
                              children: <Widget>[PersnoalNoteEditable(controller: controller), SizedBox(height: 10)],
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
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Cancer History", child: CancerHistoryEditable(controller: controller))),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Medications History", child: MedicationHistoryEditable(controller: controller))),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Skin History", child: SkinHistoryEditable(controller: controller))),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Social History", child: SocialHistoryEditable(controller: controller))),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: CommonContainer(title: "Allergies", child: AllergiesEditable(controller: controller))),
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
                                                          arguments: {
                                                            "visitId": controller.visitRecapList.value?.responseData?[index].id.toString(),
                                                            "patientId": controller.patientId.value,
                                                            "unique_tag": DateTime.now().toString(),
                                                          },
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
                                    children: [
                                      SvgPicture.asset(ImagePath.add_photo, height: 30, width: 30),
                                      SizedBox(height: 10),
                                      Text(textAlign: TextAlign.center, "Add a Photo ", style: AppFonts.medium(16, AppColors.textBlack)),
                                    ],
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

                                    // controller.globalController.patientId.value = controller.patientId.value;
                                    // controller.globalController.visitId.value = controller.visitId.value;

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
          ),
        );
      }),
    );
  }
}
