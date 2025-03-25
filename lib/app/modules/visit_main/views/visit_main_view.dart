import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:subqdocs/app/modules/visit_main/views/table_custom.dart';
import 'package:subqdocs/app/modules/visit_main/views/view_attchment_image.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widget/appbar.dart';
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

  String getFileExtension(String filePath) {
    // Define image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];

    // Get the file extension
    String extension = p.extension(filePath);

    // Check if the extension is an image type
    if (imageExtensions.contains(extension.toLowerCase())) {
      return 'image'; // Return "image" if it's an image extension
    } else {
      return extension.replaceFirst('.', ''); // Return extension without dot
    }
  }

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

  String visitRecapformatDate({required String firstDate}) {
    if (firstDate != "") {
      // Parse the first and second arguments to DateTime objects
      DateTime firstDateTime = DateTime.parse(firstDate);

      // Format the first date (for month/day/year format)
      String formattedDate = DateFormat('MM/dd/yyyy').format(firstDateTime);

      // Return the formatted string in the desired format
      return formattedDate;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return Scaffold(
      key: _key,
      backgroundColor: AppColors.white,
      drawer: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: CustomDrawerView(
          onItemSelected: (index) async {
            if (index == 0) {
              final result = await Get.toNamed(Routes.ADD_PATIENT);

              _key.currentState!.closeDrawer();
            } else if (index == 1) {
              Get.toNamed(Routes.HOME, arguments: {
                "tabIndex": 1,
              });

              _key.currentState!.closeDrawer();
            } else if (index == 2) {
              Get.toNamed(Routes.HOME, arguments: {
                "tabIndex": 2,
              });
              _key.currentState!.closeDrawer();
            } else if (index == 3) {
              Get.toNamed(Routes.HOME, arguments: {
                "tabIndex": 0,
              });
              _key.currentState!.closeDrawer();
            }
          },
        ),
      ),
      // appBar: CustomAppBar(),
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: Obx(() {
            return Stack(
              children: [
                Column(
                  children: [
                    CustomAppBar(drawerkey: _key),
                    Expanded(
                      child: Expanded(
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
                                    breadcrumbHistory: controller
                                        .globalController.breadcrumbHistory,
                                    onBack: (breadcrumb) {
                                      controller.globalController
                                          .popUntilRoute(breadcrumb);
                                      // Get.offAllNamed(globalController.getKeyByValue(breadcrumb));

                                      while (Get.currentRoute !=
                                          controller.globalController
                                              .getKeyByValue(breadcrumb)) {
                                        Get.back(); // Pop the current screen
                                      }
                                    },
                                  ),
                                  // Container(
                                  //   width: double.infinity,
                                  //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(14),
                                  //     child: Text(
                                  //       "Patient Medical Record",
                                  //       style: AppFonts.regular(17, AppColors.textBlack),
                                  //     ),
                                  //   ),
                                  // ),
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
                                              child: Container(
                                                color: AppColors.white,
                                                padding: EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0, right: 20.0),
                                                child: SvgPicture.asset(
                                                  ImagePath.logo_back,
                                                  height: 20,
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: 11,
                                            // ),
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(30),
                                                child: BaseImageView(
                                                  imageUrl: controller.patientData.value?.responseData?.profileImage ?? "",
                                                  height: 60,
                                                  width: 60,
                                                  nameLetters:
                                                      "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}",
                                                  fontSize: 14,
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""} ",
                                                  style: AppFonts.medium(16, AppColors.textBlack),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  controller.patientData.value?.responseData?.patientId ?? "",
                                                  style: AppFonts.regular(11, AppColors.textGrey),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: AppColors.appbarBorder,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    "Age",
                                                    style: AppFonts.regular(12, AppColors.textBlack),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    controller.patientData.value?.responseData?.age.toString() ?? "",
                                                    style: AppFonts.regular(14, AppColors.textGrey),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    "Gender",
                                                    style: AppFonts.regular(12, AppColors.textBlack),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    controller.patientData.value?.responseData?.gender ?? "",
                                                    style: AppFonts.regular(14, AppColors.textGrey),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    "Visit Date & Time",
                                                    style: AppFonts.regular(12, AppColors.textBlack),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    formatDateTime(
                                                        firstDate: controller.patientData.value?.responseData?.visitDate ?? "",
                                                        secondDate: controller.patientData.value?.responseData?.visitTime ?? ""),
                                                    style: AppFonts.regular(14, AppColors.textGrey),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.start,
                                                    "Medical Assistant",
                                                    style: AppFonts.regular(12, AppColors.textBlack),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        textAlign: TextAlign.center,
                                                        "Missie Cooper",
                                                        style: AppFonts.regular(14, AppColors.textPurple),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: AppColors.textPurple,
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(width: 0.8, color: AppColors.textDarkGrey),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2),
                                                        child: Text(
                                                          textAlign: TextAlign.center,
                                                          "+2",
                                                          style: AppFonts.bold(10, AppColors.textWhite),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      SvgPicture.asset(
                                                        ImagePath.down_arrow,
                                                        width: 20,
                                                        height: 20,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    "Doctor",
                                                    style: AppFonts.regular(12, AppColors.textBlack),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        textAlign: TextAlign.center,
                                                        "${controller.patientData.value?.responseData?.doctorFirstName} ${controller.patientData.value?.responseData?.doctorLastName}",
                                                        style: AppFonts.regular(14, AppColors.textGrey),
                                                      ),
                                                      SizedBox(width: 5),
                                                      SvgPicture.asset(
                                                        ImagePath.down_arrow,
                                                        width: 20,
                                                        height: 20,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
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
                                      title: Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Personal Note",
                                            style: AppFonts.regular(16, AppColors.textBlack),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                // border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                                color: AppColors.backgroundWhite,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                children: [
                                                  for (String note in controller.patientData.value?.responseData?.personalNote?.personalNote ?? [])
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        if (controller.patientData.value?.responseData?.personalNote?.personalNote?.length != 1)
                                                          Text(
                                                            "•",
                                                            style: AppFonts.regular(24, AppColors.textDarkGrey),
                                                          ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            textAlign: TextAlign.start,
                                                            maxLines: 2,
                                                            note,
                                                            // "He enjoys fishing and gardening. His wife's name is Julie.",
                                                            style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        SizedBox(width: 7),
                                                      ],
                                                    ),
                                                ],
                                              )),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
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
                                      title: Row(
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Patient Medical History",
                                            style: AppFonts.regular(16, AppColors.textBlack),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                            child: Column(
                                              children: [
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
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
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    textAlign: TextAlign.center,
                                                                    "Cancer History",
                                                                    style: AppFonts.medium(16, AppColors.textPurple),
                                                                  ),
                                                                  Spacer(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: controller.medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistory != null ?? false
                                                              ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (context, index) => InkWell(
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
                                                                                    Text(
                                                                                      "•",
                                                                                      style: AppFonts.regular(24, AppColors.textGrey),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        controller.medicalRecords.value?.responseData?.fullNoteDetails?.cancerHistory ?? "",
                                                                                        style: AppFonts.regular(14, AppColors.textGrey),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 0),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                  itemCount: 1)
                                                              : Row(
                                                                  children: [
                                                                    Text(
                                                                      textAlign: TextAlign.left,
                                                                      "No data available",
                                                                      style: AppFonts.medium(16, AppColors.textBlack),
                                                                    ),
                                                                    Spacer()
                                                                  ],
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(height: 10),
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
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
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    textAlign: TextAlign.center,
                                                                    "Medication History",
                                                                    style: AppFonts.medium(16, AppColors.textPurple),
                                                                  ),
                                                                  Spacer(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
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
                                                                        SizedBox(
                                                                          width: Get.width * .25,
                                                                          child: Text(
                                                                            "Medication Name",
                                                                            style: AppFonts.regular(14, AppColors.black),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 7),
                                                                        SizedBox(
                                                                          width: Get.width * .45,
                                                                          child: Text(
                                                                            "Purpose",
                                                                            style: AppFonts.regular(14, AppColors.black),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 7),
                                                                        SizedBox(
                                                                          width: Get.width * .15,
                                                                          child: Text(
                                                                            "Dosage",
                                                                            style: AppFonts.regular(14, AppColors.black),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 7),
                                                                      ],
                                                                    )
                                                                  : SizedBox(),
                                                              controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications != null ? SizedBox(height: 10) : SizedBox(),
                                                              controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications != null
                                                                  ? Container(
                                                                      height: 0.5,
                                                                      width: double.infinity,
                                                                      color: AppColors.textGrey,
                                                                    )
                                                                  : SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?.isNotEmpty ?? false
                                                              ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (context, index) => InkWell(
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
                                                                                      child: (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].title ?? "") != ""
                                                                                          ? Text(
                                                                                              controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].title ?? "-",
                                                                                              style: AppFonts.regular(14, AppColors.textGrey),
                                                                                            )
                                                                                          : Text(
                                                                                              "-",
                                                                                              style: AppFonts.regular(14, AppColors.textGrey),
                                                                                            ),
                                                                                    ),
                                                                                    SizedBox(width: 7),
                                                                                    SizedBox(
                                                                                      width: Get.width * .45,
                                                                                      child: (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].purpose ?? "") != ""
                                                                                          ? Text(
                                                                                              (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].purpose ?? "-"),
                                                                                              style: AppFonts.regular(14, AppColors.textGrey),
                                                                                            )
                                                                                          : Text(
                                                                                              "-",
                                                                                              style: AppFonts.regular(14, AppColors.textGrey),
                                                                                            ),
                                                                                    ),
                                                                                    SizedBox(width: 7),
                                                                                    SizedBox(
                                                                                      width: Get.width * .15,
                                                                                      child: (controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].dosage ?? "") != ""
                                                                                          ? Text(
                                                                                              controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?[index].dosage ?? "-",
                                                                                              style: AppFonts.regular(14, AppColors.textGrey),
                                                                                            )
                                                                                          : Text(
                                                                                              "-",
                                                                                              style: AppFonts.regular(14, AppColors.textGrey),
                                                                                            ),
                                                                                    ),
                                                                                    SizedBox(width: 7),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 0),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                  itemCount: controller.medicalRecords.value?.responseData?.fullNoteDetails?.medications?.length ?? 0)
                                                              : Row(
                                                                  children: [
                                                                    Text(
                                                                      textAlign: TextAlign.left,
                                                                      "No data available",
                                                                      style: AppFonts.medium(16, AppColors.textBlack),
                                                                    ),
                                                                    Spacer()
                                                                  ],
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(height: 10),
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                                      color: AppColors.white,
                                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(6),
                                                              topRight: Radius.circular(6),
                                                            ),
                                                            color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                            border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                                          ),
                                                          // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    textAlign: TextAlign.center,
                                                                    "Skin History",
                                                                    style: AppFonts.medium(16, AppColors.textPurple),
                                                                  ),
                                                                  Spacer(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: controller.medicalRecords.value?.responseData?.fullNoteDetails?.skinHistory != null
                                                              ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (context, index) => InkWell(
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
                                                                                    Text(
                                                                                      "•",
                                                                                      style: AppFonts.regular(24, AppColors.black),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        controller.medicalRecords.value?.responseData?.fullNoteDetails?.skinHistory ?? "",
                                                                                        style: AppFonts.regular(14, AppColors.textGrey),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 0),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                  itemCount: 1)
                                                              : Row(
                                                                  children: [
                                                                    Text(
                                                                      textAlign: TextAlign.left,
                                                                      "No data available",
                                                                      style: AppFonts.medium(16, AppColors.textBlack),
                                                                    ),
                                                                    Spacer()
                                                                  ],
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(height: 10),
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                                      color: AppColors.white,
                                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(6),
                                                              topRight: Radius.circular(6),
                                                            ),
                                                            color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                            border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                                          ),
                                                          // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    textAlign: TextAlign.center,
                                                                    "Social History",
                                                                    style: AppFonts.medium(16, AppColors.textPurple),
                                                                  ),
                                                                  Spacer(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: controller.medicalRecords.value?.responseData?.fullNoteDetails?.socialHistory != null ?? false
                                                              ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (context, index) => InkWell(
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
                                                                                    Text(
                                                                                      "•",
                                                                                      style: AppFonts.regular(24, AppColors.black),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        controller.medicalRecords.value?.responseData?.fullNoteDetails?.socialHistory ?? "",
                                                                                        style: AppFonts.regular(14, AppColors.textGrey),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 0),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                  itemCount: 1)
                                                              : Row(
                                                                  children: [
                                                                    Text(
                                                                      textAlign: TextAlign.left,
                                                                      "No data available",
                                                                      style: AppFonts.medium(16, AppColors.textBlack),
                                                                    ),
                                                                    Spacer()
                                                                  ],
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(height: 10),
                                                Container(
                                                    width: double.infinity,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(6), topRight: Radius.circular(6), bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                                                      color: AppColors.white,
                                                      border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 1),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(6),
                                                              topRight: Radius.circular(6),
                                                            ),
                                                            color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                            border: Border.all(color: AppColors.backgroundPurple.withValues(alpha: 0.2), width: 0),
                                                          ),
                                                          // color: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    textAlign: TextAlign.center,
                                                                    "Allergies",
                                                                    style: AppFonts.medium(16, AppColors.textPurple),
                                                                  ),
                                                                  Spacer(),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: controller.medicalRecords.value?.responseData?.fullNoteDetails?.allergies != null ?? false
                                                              ? ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemBuilder: (context, index) => InkWell(
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
                                                                                    Text(
                                                                                      "•",
                                                                                      style: AppFonts.regular(24, AppColors.black),
                                                                                    ),
                                                                                    SizedBox(width: 10),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        controller.medicalRecords.value?.responseData?.fullNoteDetails?.allergies ?? "",
                                                                                        style: AppFonts.regular(14, AppColors.textGrey),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 0),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                  itemCount: 1)
                                                              : Row(
                                                                  children: [
                                                                    Text(
                                                                      textAlign: TextAlign.left,
                                                                      "No data available",
                                                                      style: AppFonts.medium(16, AppColors.textBlack),
                                                                    ),
                                                                    Spacer()
                                                                  ],
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10,
                                        )
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
                                          Text(
                                            textAlign: TextAlign.start,
                                            "Scheduled Visits",
                                            style: AppFonts.regular(16, AppColors.textBlack),
                                          ),
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
                                                SvgPicture.asset(
                                                  ImagePath.search,
                                                  height: 14,
                                                  width: 14,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 194,
                                                  height: 25,
                                                  child: TextField(
                                                    maxLines: 1,
                                                    textAlignVertical: TextAlignVertical.center, // Centers the text vertically
                                                    decoration: InputDecoration.collapsed(
                                                      hintText: "Search",
                                                      hintStyle: AppFonts.regular(14, AppColors.textGrey),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) => InkWell(
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
                                                              )),
                                                              SizedBox(width: 15),
                                                              Expanded(
                                                                  child: Text(
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                controller.visitTime(controller.patientDetailModel.value?.responseData!.scheduledVisits?[index].visitTime),
                                                                style: AppFonts.regular(14, AppColors.textGrey),
                                                              )),
                                                              // Spacer(),
                                                              SizedBox(width: 5),
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      print("print");
                                                                      Get.back();
                                                                      controller.globalController.addRoute(Routes.VISIT_MAIN);
                                                                      Get.toNamed(Routes.VISIT_MAIN, arguments: {
                                                                        "visitId": controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString(),
                                                                        "patientId": controller.patientId.value,
                                                                        "unique_tag": DateTime.now().toString(),
                                                                      });



                                                                    },
                                                                    child: Text(
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      textAlign: TextAlign.left,
                                                                      "Start visit now",
                                                                      style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                                    ),
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
                                                                                    customPrint(
                                                                                        "visit id :- ${controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString()}");
                                                                                    controller.patientReScheduleCreate(
                                                                                        param: {"visit_date": p1, "visit_time": p0},
                                                                                        visitId: controller.patientDetailModel.value?.responseData?.scheduledVisits![index].id.toString() ?? "-1");
                                                                                  },
                                                                                ); // Our custom dialog
                                                                              },
                                                                            )
                                                                          : CustomToastification().showToast("Internet is require for this feature", type: ToastificationType.info);
                                                                    },
                                                                    child: Text(
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      textAlign: TextAlign.left,
                                                                      "Reschedule",
                                                                      style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                                    ),
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
                                                                                    controller.changeStatus("Cancelled");

                                                                                    // controller.deletePatientVisit(
                                                                                    //     id: controller.patientDetailModel.value?.responseData?.scheduledVisits?[index].id.toString() ?? "");
                                                                                  },
                                                                                );
                                                                              },
                                                                            )
                                                                          : CustomToastification().showToast("Internet is require for this feature", type: ToastificationType.info);
                                                                    },
                                                                    child: Text(
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      textAlign: TextAlign.left,
                                                                      "Cancel visit",
                                                                      style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 60),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          if (index != 7) ...[
                                                            Divider(
                                                              height: 1,
                                                              color: AppColors.appbarBorder,
                                                            )
                                                          ]
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              itemCount: controller.patientDetailModel.value?.responseData?.scheduledVisits?.length ?? 0),
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
                                          Text(
                                            textAlign: TextAlign.start,
                                            "Visit Recaps ( ${controller.visitRecapList.value?.responseData?.length ?? 0} Visits)",
                                            style: AppFonts.regular(16, AppColors.textBlack),
                                          ),
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
                                                SvgPicture.asset(
                                                  ImagePath.search,
                                                  height: 14,
                                                  width: 14,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 194,
                                                  height: 25,
                                                  child: TextField(
                                                    maxLines: 1,
                                                    textAlignVertical: TextAlignVertical.center, // Centers the text vertically
                                                    decoration: InputDecoration.collapsed(
                                                      hintText: "Search",
                                                      hintStyle: AppFonts.regular(14, AppColors.textGrey),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) => InkWell(
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
                                                                visitRecapformatDate(firstDate: controller.visitRecapList.value?.responseData?[index].visitDate ?? ""),
                                                                style: AppFonts.medium(14, AppColors.textGrey),
                                                              ),
                                                              SizedBox(width: 15),
                                                              Expanded(
                                                                  child: Text(
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                                controller.visitRecapList.value?.responseData?[index].summary ?? "",
                                                                style: AppFonts.regular(14, AppColors.textGrey),
                                                              )),
                                                              // Spacer(),
                                                              SizedBox(width: 5),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print("vid:- ${controller.visitRecapList.value?.responseData?[index].id} pid:- ${controller.patientId.value}");
                                                                  controller.globalController.addRoute(Routes.PATIENT_INFO);
                                                                  Get.toNamed(Routes.PATIENT_INFO, arguments: {
                                                                    "visitId": controller.visitRecapList.value?.responseData?[index].id.toString(),
                                                                    "patientId": controller.patientId.value,
                                                                    "unique_tag": DateTime.now().toString(),
                                                                  });


                                                                },
                                                                child: Text(
                                                                  textAlign: TextAlign.center,
                                                                  "View",
                                                                  style: AppFonts.medium(12, AppColors.textPurple),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          if (index != 7) ...[
                                                            Divider(
                                                              height: 1,
                                                              color: AppColors.appbarBorder,
                                                            )
                                                          ]
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              itemCount: controller.visitRecapList.value?.responseData?.length ?? 0),
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
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Attachments",
                                            style: AppFonts.regular(16, AppColors.textBlack),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              if (controller.isConnected.value) {

                                                controller.globalController.addRoute(Routes.ALL_ATTACHMENT);
                                                var result = await Get.toNamed(Routes.ALL_ATTACHMENT, arguments: {
                                                  "visit_id": controller.patientId.value,
                                                });


                                                if (result != null) {
                                                  controller.getPatientAttachment();
                                                }
                                              } else {
                                                CustomToastification().showToast("Internet is require for this feature", type: ToastificationType.info);
                                              }
                                            },
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "View All Attachments",
                                              style: AppFonts.regular(15, AppColors.textPurple),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          PopupMenuButton<String>(
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                                              offset: const Offset(0, 5),
                                              color: AppColors.white,
                                              position: PopupMenuPosition.over,
                                              style: const ButtonStyle(
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  maximumSize: WidgetStatePropertyAll(Size.zero),
                                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4)),
                                              itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        enabled: false,
                                                        onTap: () {},
                                                        padding: EdgeInsets.zero,
                                                        value: "1",
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 16, right: 5, bottom: 5, top: 10),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Filters",
                                                                style: AppFonts.medium(16, AppColors.textBlack),
                                                              ),
                                                              SizedBox(
                                                                width: 80,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  customPrint("clicked");

                                                                  controller.clearFilter();
                                                                },
                                                                child: Text(
                                                                  "Clear",
                                                                  style: AppFonts.medium(14, AppColors.backgroundPurple),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    PopupMenuItem(
                                                        onTap: () {
                                                          controller.isSelectedAttchmentOption.value = 0;
                                                          controller.isDocument.value = true;
                                                          controller.isImage.value = false;
                                                          controller.getPatientAttachment();
                                                        },
                                                        height: 30,
                                                        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(width: 5),
                                                            SvgPicture.asset(
                                                              ImagePath.document_attchment,
                                                              width: 30,
                                                              height: 30,
                                                              colorFilter: ColorFilter.mode(
                                                                  controller.isSelectedAttchmentOption.value == 0 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text("Document",
                                                                style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 0 ? AppColors.backgroundPurple : AppColors.textBlack)),
                                                            const SizedBox(width: 5),
                                                            if (controller.isSelectedAttchmentOption.value == 0) ...[
                                                              SvgPicture.asset(
                                                                ImagePath.attchment_check,
                                                                width: 16,
                                                                height: 16,
                                                              )
                                                            ]
                                                          ],
                                                        )),
                                                    PopupMenuItem(
                                                        onTap: () {
                                                          controller.isSelectedAttchmentOption.value = 1;
                                                          controller.isDocument.value = false;
                                                          controller.isImage.value = true;
                                                          controller.getPatientAttachment();
                                                        },
                                                        height: 30,
                                                        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(width: 5),
                                                            SvgPicture.asset(ImagePath.image_attchment,
                                                                width: 30,
                                                                height: 30,
                                                                colorFilter: ColorFilter.mode(
                                                                    controller.isSelectedAttchmentOption.value == 1 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn)),
                                                            const SizedBox(width: 8),
                                                            Text("Image",
                                                                style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 1 ? AppColors.backgroundPurple : AppColors.textBlack)),
                                                            const SizedBox(width: 5),
                                                            if (controller.isSelectedAttchmentOption.value == 1) ...[
                                                              SvgPicture.asset(
                                                                ImagePath.attchment_check,
                                                                width: 16,
                                                                height: 16,
                                                              )
                                                            ]
                                                          ],
                                                        )),
                                                    PopupMenuItem(
                                                        onTap: () {
                                                          controller.isSelectedAttchmentOption.value = 2;
                                                        },
                                                        height: 30,
                                                        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(width: 5),
                                                            SvgPicture.asset(
                                                              ImagePath.date_attchment,
                                                              width: 30,
                                                              height: 30,
                                                              colorFilter: ColorFilter.mode(
                                                                  controller.isSelectedAttchmentOption.value == 2 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text("Date",
                                                                style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 2 ? AppColors.backgroundPurple : AppColors.textBlack)),
                                                            const SizedBox(width: 5),
                                                            if (controller.isSelectedAttchmentOption.value == 2) ...[
                                                              SvgPicture.asset(
                                                                ImagePath.attchment_check,
                                                                width: 16,
                                                                height: 16,
                                                              )
                                                            ]
                                                          ],
                                                        )),
                                                  ],
                                              child: SvgPicture.asset(
                                                ImagePath.logo_filter,
                                                width: 40,
                                                height: 40,
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                              // color: AppColors.backgroundWhite,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  ImagePath.search,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
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
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                            ImagePath.edit_outline,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                      children: <Widget>[
                                        Container(
                                          color: Colors.white,
                                          child: controller.patientAttachmentList.value?.responseData?.length != 0
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  child: SizedBox(
                                                      height: 200,
                                                      width: double.infinity,
                                                      child: Obx(
                                                        () {
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
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.appbarBorder,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              width: 120,
                                                                              height: 120,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  customPrint(controller.patientAttachmentList.value?.responseData?[index].fileType?.contains("image"));

                                                                                  if (controller.patientAttachmentList.value?.responseData?[index].fileType?.contains("image") ?? false) {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                                      builder: (BuildContext context) {
                                                                                        return ViewAttchmentImage(
                                                                                          imageUrl: controller.patientAttachmentList.value?.responseData?[index].filePath ?? "",
                                                                                          attchmentUrl: '',
                                                                                        );

                                                                                        // return controller.patientAttachmentList.value?.responseData?[index].fileType?.contains("image") ?? false
                                                                                        //     ? ViewAttchmentImage(
                                                                                        //         imageUrl: controller.patientAttachmentList.value?.responseData?[index].filePath ?? "",
                                                                                        //         attchmentUrl: '',
                                                                                        //       )
                                                                                        //     : ViewAttchmentImage(
                                                                                        //         imageUrl: "",
                                                                                        //         attchmentUrl:
                                                                                        //             controller.patientAttachmentList.value?.responseData?[index].filePath ?? ""); // Our custom dialog
                                                                                      },
                                                                                    );
                                                                                  } else {
                                                                                    Uri attchmentUri = Uri.parse(controller.patientAttachmentList.value?.responseData?[index].filePath ?? "");
                                                                                    customPrint("attchmentUri is :- ${attchmentUri}");
                                                                                    controller.launchInAppWithBrowserOptions(attchmentUri);
                                                                                  }
                                                                                },
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(10), // Set the radius here
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: controller.patientAttachmentList.value?.responseData?[index].filePath ?? "",
                                                                                    width: 120,
                                                                                    height: 120,
                                                                                    errorWidget: (context, url, error) {
                                                                                      return Image.asset(
                                                                                        ImagePath.file_placeHolder,
                                                                                      );
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
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.black.withOpacity(0.2),
                                                                                      blurRadius: 2.2,
                                                                                      offset: Offset(0.2, 0),
                                                                                    ),
                                                                                  ],
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
                                                                                            controller.deleteAttachments(controller.patientAttachmentList.value?.responseData![index].id ?? 0);
                                                                                          },
                                                                                          extension: controller.patientAttachmentList.value?.responseData?[index].fileType,
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  child: SvgPicture.asset(
                                                                                    ImagePath.delete_black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 6,
                                                                        ),
                                                                        Text(
                                                                          maxLines: 1,
                                                                          controller.patientAttachmentList.value?.responseData?[index].fileName ?? "",
                                                                          style: AppFonts.regular(12, AppColors.textDarkGrey),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 6,
                                                                        ),
                                                                        Text(
                                                                          DateFormat('MM/dd/yyyy')
                                                                              .format(DateTime.parse(controller.patientAttachmentList.value?.responseData?[index].createdAt ?? "").toLocal()),
                                                                          style: AppFonts.regular(12, AppColors.textDarkGrey),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            separatorBuilder: (context, index) => const SizedBox(width: Dimen.margin15),
                                                            itemCount: controller.patientAttachmentList.value?.responseData?.length ?? 0,
                                                          );
                                                        },
                                                      )))
                                              : Container(
                                                  width: double.infinity,
                                                  height: 200,
                                                  child: Center(child: Text("Attachments Not available")),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                      visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        padding: EdgeInsets.zero,
                                        onTap: () {
                                          // controller.pickProfileImage();
                                          controller.captureImage(context);

                                          // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                                        },
                                        // value: "",
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons.camera,
                                                color: AppColors.textDarkGrey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Take Photo or Video",
                                                style: AppFonts.regular(16, AppColors.textBlack),
                                              ),
                                            ],
                                          ),
                                        )),
                                    PopupMenuItem(
                                        // value: "",
                                        padding: EdgeInsets.zero,
                                        onTap: () async {
                                          // controller.captureProfileImage();

                                          controller.captureImage(context, fromCamera: false);
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: AppColors.textDarkGrey,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.photo_fill_on_rectangle_fill,
                                                    color: AppColors.textDarkGrey,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Choose Photo",
                                                    style: AppFonts.regular(16, AppColors.textBlack),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        // value: "",
                                        padding: EdgeInsets.zero,
                                        onTap: () async {
                                          // controller.captureProfileImage();
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
                                              padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.document_scanner_sharp,
                                                    color: AppColors.textDarkGrey,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Scan Documents",
                                                    style: AppFonts.regular(16, AppColors.textDarkGrey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    PopupMenuItem(
                                        // value: "",
                                        padding: EdgeInsets.zero,
                                        onTap: () async {
                                          // controller.captureProfileImage();

                                          controller.pickFiles(context);
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
                                              padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.file_copy_rounded,
                                                    color: AppColors.textDarkGrey,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Attach File",
                                                    style: AppFonts.regular(16, AppColors.textBlack),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                  child: Container(
                                    height: 81,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                      color: AppColors.backgroundLightGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              ImagePath.add_photo,
                                              height: 30,
                                              width: 30,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              "Add a Photo ",
                                              style: AppFonts.medium(16, AppColors.textBlack),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (controller.isStartRecording.value == false) ...[
                                if (controller.patientData.value?.responseData?.visitStatus == "Scheduled") ...[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.isStartTranscript.value = true;
                                        // controller.isStartRecording.value = true;
                                      },
                                      child: Container(
                                        height: 81,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.backgroundPurple),
                                          color: AppColors.backgroundPurple,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  ImagePath.ai_white,
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  "Start Transcribing",
                                                  style: AppFonts.medium(16, AppColors.textWhite),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                              if (controller.isStartRecording.value) ...[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Get.toNamed(Routes.PATIENT_INFO);
                                    },
                                    child: Container(
                                      height: 81,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.buttonBackgroundGreen),
                                        color: AppColors.buttonBackgroundGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                ImagePath.pause,
                                                height: 30,
                                                width: 30,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Pause",
                                                style: AppFonts.medium(16, AppColors.textWhite),
                                              ),
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
                                      controller.isStartRecording.value = false;
                                    },
                                    child: Container(
                                      height: 81,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.buttonBackgroundred),
                                        color: AppColors.buttonBackgroundred,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                ImagePath.stop_transcript,
                                                height: 30,
                                                width: 30,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Stop Transcribing",
                                                style: AppFonts.medium(16, AppColors.textWhite),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
                if (controller.isStartTranscript.value) ...[
                  Positioned(
                    bottom: 120,
                    right: 30,
                    child: Obx(() {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        // Set the duration for smooth animation
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.backgroundLightGrey.withValues(alpha: 0.9),
                              spreadRadius: 6,
                              blurRadius: 4.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                          color: controller.isExpandRecording.value ? AppColors.backgroundWhite : AppColors.black,
                        ),
                        padding: controller.isExpandRecording.value ? EdgeInsets.symmetric(horizontal: 0, vertical: 0) : EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        curve: Curves.easeInOut,
                        child: Column(
                          children: [
                            // Header Row (expand/collapse button)

                            if (controller.isExpandRecording.value) ...[
                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.backgroundLightGrey.withValues(alpha: 0.9),
                                      spreadRadius: 6,
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    topLeft: Radius.circular(12),
                                  ),
                                  color: AppColors.backgroundPurple,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      controller.isExpandRecording.value ? "Recording in Progress" :  "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}",
                                      style: AppFonts.medium(14, AppColors.textWhite),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        controller.isExpandRecording.value = !controller.isExpandRecording.value;
                                      },
                                      child: SvgPicture.asset(
                                        controller.isExpandRecording.value ? ImagePath.collpase : ImagePath.expand_recording,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                textAlign: TextAlign.center,
                                "Recording in Progress",
                                style: AppFonts.regular(17, AppColors.textBlack),
                              ),
                              SizedBox(height: 20),
                              Image.asset(
                                ImagePath.wave,
                                height: 90,
                                width: 90,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (controller.recorderService.recordingStatus.value == 0) {
                                        controller.changeStatus("In-Room");
                                        // If not recording, start the recording
                                        await controller.recorderService.startRecording(context);
                                      } else if (controller.recorderService.recordingStatus.value == 1) {
                                        // If recording, pause it
                                        await controller.recorderService.pauseRecording();
                                      } else if (controller.recorderService.recordingStatus.value == 2) {
                                        // If paused, resume the recording
                                        await controller.recorderService.resumeRecording();
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        // Display different icons and text based on the recording status
                                        Obx(() {
                                          if (controller.recorderService.recordingStatus.value == 0) {
                                            // If recording is stopped, show start button
                                            return SvgPicture.asset(
                                              ImagePath.start_recording,
                                              height: 50,
                                              width: 50,
                                            );
                                          } else if (controller.recorderService.recordingStatus.value == 1) {
                                            // If recording, show pause button
                                            return SvgPicture.asset(
                                              ImagePath.pause_recording, // Replace with the actual pause icon
                                              height: 50,
                                              width: 50,
                                            );
                                          } else {
                                            // If paused, show resume button
                                            return SvgPicture.asset(
                                              ImagePath.start_recording, // Replace with the actual resume icon
                                              height: 50,
                                              width: 50,
                                            );
                                          }
                                        }),
                                        SizedBox(height: 10),
                                        // Display corresponding text based on the status
                                        Obx(() {
                                          if (controller.recorderService.recordingStatus.value == 0) {
                                            return Text(
                                              textAlign: TextAlign.center,
                                              "Start",
                                              style: AppFonts.medium(17, AppColors.textGrey),
                                            );
                                          } else if (controller.recorderService.recordingStatus.value == 1) {
                                            return Text(
                                              textAlign: TextAlign.center,
                                              "Pause",
                                              style: AppFonts.medium(17, AppColors.textGrey),
                                            );
                                          } else {
                                            return Text(
                                              textAlign: TextAlign.center,
                                              "Resume",
                                              style: AppFonts.medium(17, AppColors.textGrey),
                                            );
                                          }
                                        }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () async {
                                      controller.changeStatus("In-Exam");
                                      File? audioFile = await controller.recorderService.stopRecording();
                                      customPrint("audio file url is :- ${audioFile?.absolute}");
                                      if (audioFile != null) {
                                        controller.submitAudio(audioFile!);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.stop_recording,
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Stop",
                                          style: AppFonts.medium(17, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Obx(() {
                                return Text(
                                  textAlign: TextAlign.center,
                                  controller.recorderService.formattedRecordingTime,
                                  style: AppFonts.regular(14, AppColors.textBlack),
                                );
                              }),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Press the stop button to start generating your summary.",
                                  style: AppFonts.regular(14, AppColors.textGrey),
                                ),
                              ),
                              SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  spacing: 15,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            allowMultiple: false,
                                            type: FileType.custom,
                                            allowedExtensions: ['mp3', 'aac', 'm4a'],
                                          );

                                          controller.changeStatus("In-Room");
                                          customPrint("audio is:- ${result?.files.first.xFile.path}");
                                          controller.submitAudio(File(result?.files.first.path ?? ""));
                                          controller.changeStatus("In-Exam");
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 2),
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 5),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  "Upload recording",
                                                  // "Back to Medical Record",
                                                  style: AppFonts.medium(13, AppColors.textGrey),
                                                ),
                                              ),
                                              SizedBox(width: 10)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
                                            visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              onTap: () {
                                                // controller.pickProfileImage();
                                                controller.captureImage(context);

                                                // customPrint(" patient id is ${controller.patientList[rowIndex - 1].patientId.toString()}");
                                              },
                                              // value: "",
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.camera,
                                                      color: AppColors.textDarkGrey,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Take Photo or Video",
                                                      style: AppFonts.regular(16, AppColors.textBlack),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          PopupMenuItem(
                                              // value: "",
                                              padding: EdgeInsets.zero,
                                              onTap: () async {
                                                // controller.captureProfileImage();

                                                controller.captureImage(context, fromCamera: false);
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 1,
                                                    color: AppColors.textDarkGrey,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons.photo_fill_on_rectangle_fill,
                                                          color: AppColors.textDarkGrey,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Choose Photo",
                                                          style: AppFonts.regular(16, AppColors.textBlack),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          PopupMenuItem(
                                              // value: "",
                                              padding: EdgeInsets.zero,
                                              onTap: () async {
                                                // controller.captureProfileImage();
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
                                                    padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.document_scanner_sharp,
                                                          color: AppColors.textDarkGrey,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Scan Documents",
                                                          style: AppFonts.regular(16, AppColors.textDarkGrey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          PopupMenuItem(
                                              // value: "",
                                              padding: EdgeInsets.zero,
                                              onTap: () async {
                                                // controller.captureProfileImage();

                                                controller.pickFiles(context);
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
                                                    padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.file_copy_rounded,
                                                          color: AppColors.textDarkGrey,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "Attach File",
                                                          style: AppFonts.regular(16, AppColors.textBlack),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: AppColors.textPurple, width: 2),
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                ImagePath.uploadImage,
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Upload Photos",
                                                style: AppFonts.medium(13, AppColors.textPurple),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                            if (!controller.isExpandRecording.value) ...[
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagePath.recording,
                                    height: 45,
                                    width: 45,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.left,
                                        "${controller.patientData.value?.responseData?.patientFirstName ?? ""} ${controller.patientData.value?.responseData?.patientLastName ?? ""}",
                                        style: AppFonts.regular(14, AppColors.textWhite),
                                      ),
                                      SizedBox(height: 0),
                                      Obx(() {
                                        return Text(
                                          textAlign: TextAlign.left,
                                          controller.recorderService.formattedRecordingTime,
                                          style: AppFonts.regular(14, AppColors.textGrey),
                                        );
                                      }),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(onTap: () async {
                                    if (controller.recorderService.recordingStatus.value == 0) {
                                      // If not recording, start the recording
                                      controller.changeStatus("In-Room");
                                      await controller.recorderService.startRecording(context);
                                    } else if (controller.recorderService.recordingStatus.value == 1) {
                                      // If recording, pause it
                                      await controller.recorderService.pauseRecording();
                                    } else if (controller.recorderService.recordingStatus.value == 2) {
                                      // If paused, resume the recording
                                      await controller.recorderService.resumeRecording();
                                    }
                                    // await controller.recorderService.startRecording(context);
                                  }, child: Obx(() {
                                    if (controller.recorderService.recordingStatus.value == 0) {
                                      // If recording is stopped, show start button
                                      return SvgPicture.asset(
                                        ImagePath.dark_play,
                                        height: 45,
                                        width: 45,
                                      );
                                    } else if (controller.recorderService.recordingStatus.value == 1) {
                                      // If recording, show pause button
                                      return SvgPicture.asset(
                                        ImagePath.pause_white, // Replace with the actual pause icon
                                        height: 45,
                                        width: 45,
                                      );
                                    } else {
                                      // If paused, show resume button
                                      return SvgPicture.asset(
                                        ImagePath.dark_play, // Replace with the actual resume icon
                                        height: 45,
                                        width: 45,
                                      );
                                    }
                                  })
                                      // SvgPicture.asset(
                                      //   ImagePath.pause_white,
                                      //   height: 45,
                                      //   width: 45,
                                      // ),
                                      ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      File? audioFile = await controller.recorderService.stopRecording();
                                      customPrint("audio file url is :- ${audioFile?.absolute}");

                                      controller.changeStatus("In-Exam");

                                      if (audioFile != null) {
                                        controller.submitAudio(audioFile!);
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      ImagePath.stop_recording,
                                      height: 45,
                                      width: 45,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      controller.isExpandRecording.value = !controller.isExpandRecording.value;
                                    },
                                    child: SvgPicture.asset(
                                      ImagePath.expand_recording,
                                      height: 45,
                                      width: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ),
                ],
                if (controller.isLoading.value) ...[
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Vertically centers the Column contents
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CircularProgressIndicator(color: AppColors.textPurple),
                      SizedBox(
                        height: 20,
                      ),
                      Text(controller.loadingMessage.value)
                    ],
                  )),
                ]
              ],
            );
          }),
        ),
      ),
    );
  }

  List<List<String>> _getTableRows(List<ScheduledVisits> patients) {
    List<List<String>> rows = [];

    // Add header row first
    rows.add(
      ['Visit Date', 'Time', "", "Action"],
    );

    // Iterate over each patient and extract data for each row
    for (var patient in patients) {
      String visitDate = "N/A";
      String visitTime = "N/A";

      if (patient.visitDate != null) {
        DateTime visitdateTime = DateTime.parse(patient.visitDate ?? "");

        // Create a DateFormat to format the date
        DateFormat visitdateFormat = DateFormat('MM/dd/yyyy');

        // Format the DateTime object to the desired format
        String visitformattedDate = visitdateFormat.format(visitdateTime);

        visitDate = visitformattedDate;
      }

      if (patient.visitTime != null) {
        DateTime visitdateTime = DateTime.parse(patient.visitTime ?? "").toLocal();

        // Create a DateFormat to format the date
        DateFormat visitdateFormat = DateFormat('hh:mm a');

        // Format the DateTime object to the desired format
        String visitformattedDate = visitdateFormat.format(visitdateTime);

        visitTime = visitformattedDate;
      }

      rows.add([
        visitDate,
        visitTime,
        'Start visit now ',
        "Reschedule",
        "Cancel visit"

        // Action (could be a button or some interaction)
      ]);
    }
    return rows;
  }
}
