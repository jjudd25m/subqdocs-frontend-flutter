import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/app/modules/patient_info/views/confirm_finalize_dialog.dart';
import 'package:subqdocs/app/modules/patient_info/views/doctor_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/full_note_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/patient_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/custom_textfiled.dart';
import '../controllers/patient_info_controller.dart';
import 'custom_table.dart';
import 'full_transcript_view.dart';

class PatientInfoView extends GetView<PatientInfoController> {
  PatientInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            Expanded(
              child: Container(
                color: AppColors.backgroundLightBlue,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          ExpansionTile(
                            collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColors.backgroundWhite,
                            collapsedBackgroundColor: AppColors.backgroundWhite,
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(
                                      ImagePath.logo_back,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 20),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: BaseImageView(
                                            imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  "Don Jones",
                                                  style: AppFonts.medium(15, AppColors.textBlack),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  "12345678",
                                                  style: AppFonts.regular(13, AppColors.textGrey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                        SizedBox(
                                          width: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                  // Text(
                                  //   textAlign: TextAlign.center,
                                  //   "Patient Details",
                                  //   style: AppFonts.medium(16, AppColors.textBlack),
                                  // ),
                                  Spacer(),
                                  SvgPicture.asset(
                                    ImagePath.edit,
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.textOrangle.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(25), // Set corner radius
                                      ),
                                      height: 50,
                                      width: 130,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Pending",
                                            style: AppFonts.medium(16, AppColors.textOrangle),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                      width: 150,
                                      height: 40,
                                      child: CustomAnimatedButton(
                                        text: " Patient History ",
                                        isOutline: true,
                                        enabledTextColor: AppColors.textGrey,
                                        enabledColor: AppColors.white,
                                        outLineEnabledColor: AppColors.textGrey,
                                        outlineColor: AppColors.textGrey,
                                      ))
                                ],
                              ),
                            ),
                            children: <Widget>[
                              SizedBox(
                                height: 20,
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
                                          style: AppFonts.medium(15, AppColors.textBlack),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "52",
                                          style: AppFonts.regular(13, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Gender",
                                          style: AppFonts.medium(15, AppColors.textBlack),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Male",
                                          style: AppFonts.regular(13, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Visit Date & Time",
                                          style: AppFonts.medium(15, AppColors.textBlack),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "10/12/2024  10:30 am",
                                          style: AppFonts.regular(13, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Medical Assistant",
                                          style: AppFonts.medium(15, AppColors.textBlack),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        PopupMenuButton<String>(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                            offset: const Offset(0, 5),
                                            color: AppColors.white,
                                            position: PopupMenuPosition.over,
                                            style: const ButtonStyle(
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                maximumSize: WidgetStatePropertyAll(Size.zero),
                                                visualDensity: VisualDensity(horizontal: -4, vertical: -4)),
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      onTap: () {
                                                        // controller.isSelectedAttchmentOption.value = 0;
                                                      },
                                                      // height: 30,
                                                      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                      child: Container(
                                                        width: 200,
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(width: 5),
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
                                                                      maxLines: 1, //or null
                                                                      decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10),
                                                            ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                itemBuilder: (context, index) => InkWell(
                                                                      onTap: () {},
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(height: 10),
                                                                            Row(
                                                                              children: [
                                                                                SvgPicture.asset(
                                                                                  ImagePath.checkbox_true,
                                                                                  width: 20,
                                                                                  height: 20,
                                                                                ),
                                                                                Spacer(),
                                                                                Text(
                                                                                  textAlign: TextAlign.center,
                                                                                  "Missie Cooper",
                                                                                  style: AppFonts.regular(15, AppColors.textPurple),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            if (index != 4) ...[
                                                                              Divider(
                                                                                height: 1,
                                                                              )
                                                                            ]
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                itemCount: 5),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                            child: Row(
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  "Missie Cooper",
                                                  style: AppFonts.regular(13, AppColors.textGrey),
                                                ),
                                                SizedBox(width: 5),
                                                SvgPicture.asset(
                                                  ImagePath.down_arrow,
                                                  width: 20,
                                                  height: 20,
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Doctor",
                                          style: AppFonts.medium(15, AppColors.textBlack),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              textAlign: TextAlign.center,
                                              "Dr. Adrian Tinajero",
                                              style: AppFonts.regular(13, AppColors.textGrey),
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
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                            child: Obx(() {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Obx(() {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundPurple.withValues(alpha: 0.2)),
                                          height: 70,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: CustomAnimatedButton(
                                                    onPressed: () {
                                                      controller.tabIndex.value = 0;
                                                    },
                                                    text: " Doctor View ",
                                                    isOutline: true,
                                                    fontSize: 17,
                                                    enabledTextColor: controller.tabIndex.value == 0 ? AppColors.textWhite : AppColors.textGrey,
                                                    enabledColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                                    outLineEnabledColor: AppColors.textGrey,
                                                    outlineColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                                  )),
                                              SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: CustomAnimatedButton(
                                                    onPressed: () {
                                                      controller.tabIndex.value = 1;
                                                    },
                                                    text: " Full Transcript ",
                                                    isOutline: true,
                                                    fontSize: 17,
                                                    enabledTextColor: controller.tabIndex.value == 1 ? AppColors.textWhite : AppColors.textGrey,
                                                    enabledColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                                    outLineEnabledColor: AppColors.textGrey,
                                                    outlineColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                                  )),
                                              SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: CustomAnimatedButton(
                                                    onPressed: () {
                                                      controller.tabIndex.value = 2;
                                                    },
                                                    text: " Patient View ",
                                                    isOutline: true,
                                                    fontSize: 17,
                                                    enabledTextColor: controller.tabIndex.value == 2 ? AppColors.textWhite : AppColors.textGrey,
                                                    enabledColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                                    outLineEnabledColor: AppColors.textGrey,
                                                    outlineColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                                  )),
                                              SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: CustomAnimatedButton(
                                                    onPressed: () {
                                                      controller.tabIndex.value = 3;
                                                    },
                                                    text: " Full Note ",
                                                    isOutline: true,
                                                    fontSize: 17,
                                                    enabledTextColor: controller.tabIndex.value == 3 ? AppColors.textWhite : AppColors.textGrey,
                                                    enabledColor: controller.tabIndex.value == 3 ? AppColors.backgroundPurple : AppColors.clear,
                                                    outLineEnabledColor: AppColors.textGrey,
                                                    outlineColor: controller.tabIndex.value == 3 ? AppColors.backgroundPurple : AppColors.clear,
                                                  )),
                                              SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: CustomAnimatedButton(
                                                    onPressed: () {
                                                      controller.tabIndex.value = 4;
                                                    },
                                                    text: " Billing Form ",
                                                    isOutline: true,
                                                    fontSize: 17,
                                                    enabledTextColor: controller.tabIndex.value == 4 ? AppColors.textWhite : AppColors.textGrey,
                                                    enabledColor: controller.tabIndex.value == 4 ? AppColors.backgroundPurple : AppColors.clear,
                                                    outLineEnabledColor: AppColors.textGrey,
                                                    outlineColor: controller.tabIndex.value == 4 ? AppColors.backgroundPurple : AppColors.clear,
                                                  )),
                                              SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: CustomAnimatedButton(
                                                    onPressed: () {
                                                      controller.tabIndex.value = 5;
                                                    },
                                                    text: " Requisition ",
                                                    isOutline: true,
                                                    fontSize: 17,
                                                    enabledTextColor: controller.tabIndex.value == 5 ? AppColors.textWhite : AppColors.textGrey,
                                                    enabledColor: controller.tabIndex.value == 5 ? AppColors.backgroundPurple : AppColors.clear,
                                                    outLineEnabledColor: AppColors.textGrey,
                                                    outlineColor: controller.tabIndex.value == 5 ? AppColors.backgroundPurple : AppColors.clear,
                                                  ))
                                            ],
                                          )),
                                    );
                                  }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Patient Medical Record",
                                          style: AppFonts.medium(20, AppColors.textBlack),
                                        ),
                                        Spacer(),
                                        PopupMenuButton<String>(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                                            offset: const Offset(0, 5),
                                            color: AppColors.white,
                                            position: PopupMenuPosition.under,
                                            style: const ButtonStyle(
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                maximumSize: WidgetStatePropertyAll(Size.zero),
                                                visualDensity: VisualDensity(horizontal: -4, vertical: -4)),
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      onTap: () {},
                                                      height: 30,
                                                      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(width: 5),
                                                          SvgPicture.asset(
                                                            ImagePath.share_copy_link,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text("Copy Link", style: AppFonts.medium(17, AppColors.textBlack)),
                                                          const SizedBox(width: 5),
                                                        ],
                                                      )),
                                                  PopupMenuItem(
                                                      onTap: () {},
                                                      height: 30,
                                                      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(width: 5),
                                                          SvgPicture.asset(
                                                            ImagePath.share_email,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text("Email", style: AppFonts.medium(17, AppColors.textBlack)),
                                                          const SizedBox(width: 5),
                                                        ],
                                                      )),
                                                  PopupMenuItem(
                                                      onTap: () {},
                                                      height: 30,
                                                      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(width: 5),
                                                          SvgPicture.asset(
                                                            ImagePath.share_pdf,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text("Download (PDF)", style: AppFonts.medium(17, AppColors.textBlack)),
                                                          const SizedBox(width: 5),
                                                        ],
                                                      )),
                                                  PopupMenuItem(
                                                      onTap: () {},
                                                      height: 30,
                                                      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(width: 5),
                                                          SvgPicture.asset(
                                                            ImagePath.share_text,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text("Download (Text)", style: AppFonts.medium(17, AppColors.textBlack)),
                                                          const SizedBox(width: 5),
                                                        ],
                                                      )),
                                                  PopupMenuItem(
                                                      onTap: () {},
                                                      height: 30,
                                                      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(width: 5),
                                                          SvgPicture.asset(
                                                            ImagePath.share_print,
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text("Print", style: AppFonts.medium(17, AppColors.textBlack)),
                                                          const SizedBox(width: 5),
                                                        ],
                                                      )),
                                                ],
                                            child: SvgPicture.asset(
                                              ImagePath.share,
                                              width: 40,
                                              height: 40,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    color: AppColors.backgroundLightGrey,
                                    height: 2,
                                    width: double.infinity,
                                    child: SizedBox(),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (controller.tabIndex.value == 0) ...[DoctorView()],
                                  if (controller.tabIndex.value == 1) ...[FullTranscriptView()],
                                  if (controller.tabIndex.value == 2) ...[PatientView()],
                                  if (controller.tabIndex.value == 3) ...[FullNoteView()],

                                  // SizedBox(height: 20),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                                  //   child: SingleChildScrollView(
                                  //     padding: EdgeInsets.zero,
                                  //     child: Column(
                                  //       children: [
                                  //         Table(
                                  //           border: TableBorder.all(
                                  //             color: AppColors.buttonBackgroundGrey, // Table border color
                                  //             width: 1, // Border width
                                  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), // Optional rounded corners
                                  //           ),
                                  //           columnWidths: {
                                  //             0: FractionColumnWidth(0.35), // Fixed width for "Procedure" column
                                  //             1: FractionColumnWidth(0.35), // Fixed width for "Diagnosis" column
                                  //             2: FractionColumnWidth(0.15), // Flexible width for "Unit" column (20% of screen)
                                  //             3: FractionColumnWidth(0.15), // Flexible width for "Unit charges" column (40% of screen)
                                  //           },
                                  //           children: [
                                  //             TableRow(
                                  //               decoration: BoxDecoration(
                                  //                 color: AppColors.white, // Header row background color
                                  //               ),
                                  //               children: [
                                  //                 _headerBuildTableCell('Procedure'),
                                  //                 _headerBuildTableCell('Diagnosis'),
                                  //                 _headerBuildTableCell('Unit'),
                                  //                 _headerBuildTableCell('Unit charges'),
                                  //               ],
                                  //             ),
                                  //             TableRow(
                                  //               decoration: BoxDecoration(
                                  //                 color: AppColors.white,
                                  //               ),
                                  //               children: [
                                  //                 _buildTableCell('99213 25 OFFICE O/P EST LOW 20 MIN', false),
                                  //                 _buildTableCell('Z08 (Encounter for follow-up examination after completed treatment for malignant neoplasm)', false),
                                  //                 _buildTableCell('1', false),
                                  //                 _buildTableCell('\$1344.5', false),
                                  //               ],
                                  //             ),
                                  //             // Add more rows if needed
                                  //           ],
                                  //         ),
                                  //         Table(
                                  //           border: TableBorder.all(
                                  //             color: AppColors.buttonBackgroundGrey, // Table border color
                                  //             width: 1, // Border width
                                  //             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)), // Optional rounded corners
                                  //           ),
                                  //           columnWidths: {
                                  //             0: FractionColumnWidth(0.85), // Fixed width for "Procedure" column
                                  //             1: FractionColumnWidth(0.15), // Fixed width for "Diagnosis" column
                                  //           },
                                  //           children: [
                                  //             TableRow(
                                  //               decoration: BoxDecoration(
                                  //                 color: AppColors.white, // Header row background color
                                  //               ),
                                  //               children: [
                                  //                 _headerBuildTableCell('Total'),
                                  //                 _headerBuildTableCell("\$279.46"),
                                  //               ],
                                  //             ),
                                  //             // Add more rows if needed
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 20),
                                ],
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.backgroundLightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // color: AppColors.backgroundWhite,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Obx(() {
                  return Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (controller.isSignatureDone.value) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.isSignatureDone.value = false;
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 120,
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
                                            ImagePath.signature,
                                            height: 30,
                                            width: 30,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Digitally Signed by Dr. Adrian Tinajero ",
                                            style: AppFonts.medium(16, AppColors.textWhite),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "12/10/2024 5:02 PM",
                                            style: AppFonts.medium(16, AppColors.textWhite),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Amend Note",
                                  style: AppFonts.medium(15, AppColors.textGrey).copyWith(decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (controller.isSignatureDone.value == false) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 100,
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
                                        "Add Photo or Document",
                                        style: AppFonts.medium(16, AppColors.textBlack),
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
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ConfirmFinalizeDialog();
                                },
                              );
                            },
                            child: Container(
                              height: 100,
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
                                        ImagePath.finalize_time,
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Finalize Later",
                                        style: AppFonts.medium(16, AppColors.textBlack),
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
                              controller.isSignatureDone.value = true;
                            },
                            child: Container(
                              height: 100,
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
                                        ImagePath.signature,
                                        height: 30,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Sign and Finalize",
                                        style: AppFonts.medium(16, AppColors.textWhite),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
