import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/app/modules/patient_info/views/confirm_finalize_dialog.dart';
import 'package:subqdocs/app/modules/patient_info/views/doctor_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/full_note_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/patient_view.dart';
import 'package:subqdocs/app/modules/patient_info/views/visit_data_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/appbar.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../core/common/common_service.dart';
import '../../../routes/app_pages.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../controllers/patient_info_controller.dart';
import 'full_transcript_view.dart';

class PatientInfoView extends GetView<PatientInfoController> {
  PatientInfoView({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
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
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(drawerkey: _key),
              Expanded(
                child: Container(
                  color: AppColors.ScreenBackGround1,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent, // Remove splash color
                                highlightColor: Colors.transparent, // Remove highlight color
                              ),
                              child: ExpansionTile(
                                iconColor: AppColors.textDarkGrey,
                                collapsedIconColor: AppColors.textDarkGrey,
                                childrenPadding: EdgeInsets.zero,
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
                                          Get.offAllNamed(Routes.HOME);
                                          // Get.back();
                                        },
                                        child: SvgPicture.asset(
                                          ImagePath.logo_back,
                                          height: 15,
                                          width: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      BaseImageView(
                                        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s",
                                        width: 60,
                                        height: 60,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Don Jones",
                                            style: AppFonts.medium(16, AppColors.textBlack),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "12345678",
                                            style: AppFonts.regular(11, AppColors.textGrey),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      SvgPicture.asset(
                                        ImagePath.edit,
                                        height: 20,
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 18,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.textOrangle.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(100), // Set corner radius
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              "Pending",
                                              style: AppFonts.medium(14, AppColors.textOrangle),
                                            ),
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      ContainerButton(
                                        onPressed: () {
                                          // Your onPressed function
                                        },
                                        text: 'Patient History',

                                        borderColor: AppColors.appbarBorder, // Custom border color
                                        backgroundColor: AppColors.white, // Custom background color
                                        needBorder: true, // Show border
                                        textColor: AppColors.textDarkGrey, // Custom text color
                                        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12), // Custom padding
                                        radius: 6, // Custom border radius
                                      ),
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
                                              "52",
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
                                              "Male",
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
                                              "10/12/2024  10:30 am",
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
                                                          onTap: () {},
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
                                                )),
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
                                                  "Dr. Adrian Tinajero",
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
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                              child: Obx(
                                () {
                                  return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
                                      height: 45,
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            IntrinsicWidth(
                                              child: CustomAnimatedButton(
                                                onPressed: () {
                                                  controller.tabIndex.value = 0;
                                                },
                                                isDoctorView: true,
                                                text: " Q-view ",
                                                isOutline: true,
                                                paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                fontSize: 14,
                                                enabledTextColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.textGrey,
                                                enabledColor: controller.tabIndex.value == 0 ? AppColors.buttonPurpleLight : AppColors.clear,
                                                outLineEnabledColor: AppColors.textGrey,
                                                outlineColor: controller.tabIndex.value == 0 ? AppColors.backgroundPurple : AppColors.clear,
                                              ),
                                            ),
                                            IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 1;
                                              },
                                              text: " Full Transcript ",
                                              isOutline: true,
                                              paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 1 ? AppColors.buttonPurpleLight : AppColors.clear,
                                              outLineEnabledColor: AppColors.textGrey,
                                              outlineColor: controller.tabIndex.value == 1 ? AppColors.backgroundPurple : AppColors.clear,
                                            )),
                                            IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 2;
                                              },
                                              text: " Patient View ",
                                              isOutline: true,
                                              paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 2 ? AppColors.buttonPurpleLight : AppColors.clear,
                                              outLineEnabledColor: AppColors.textGrey,
                                              outlineColor: controller.tabIndex.value == 2 ? AppColors.backgroundPurple : AppColors.clear,
                                            )),
                                            IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 3;
                                              },
                                              text: " Full Note ",
                                              isOutline: true,
                                              paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 3 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 3 ? AppColors.buttonPurpleLight : AppColors.clear,
                                              outLineEnabledColor: AppColors.textGrey,
                                              outlineColor: controller.tabIndex.value == 3 ? AppColors.backgroundPurple : AppColors.clear,
                                            )),
                                            // IntrinsicWidth(
                                            //     child: CustomAnimatedButton(
                                            //   onPressed: () {
                                            //     controller.tabIndex.value = 4;
                                            //   },
                                            //   text: " Billing Form ",
                                            //   isOutline: true,
                                            //   paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                            //   fontSize: 14,
                                            //   enabledTextColor: controller.tabIndex.value == 4 ? AppColors.backgroundPurple : AppColors.textGrey,
                                            //   enabledColor: controller.tabIndex.value == 4 ? AppColors.buttonPurpleLight : AppColors.clear,
                                            //   outLineEnabledColor: AppColors.textGrey,
                                            //   outlineColor: controller.tabIndex.value == 4 ? AppColors.backgroundPurple : AppColors.clear,
                                            // )),
                                            // IntrinsicWidth(
                                            //     child: CustomAnimatedButton(
                                            //   onPressed: () {
                                            //     controller.tabIndex.value = 5;
                                            //   },
                                            //   text: " Requisition ",
                                            //   isOutline: true,
                                            //   paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                            //   fontSize: 14,
                                            //   enabledTextColor: controller.tabIndex.value == 5 ? AppColors.backgroundPurple : AppColors.textGrey,
                                            //   enabledColor: controller.tabIndex.value == 5 ? AppColors.buttonPurpleLight : AppColors.clear,
                                            //   outLineEnabledColor: AppColors.textGrey,
                                            //   outlineColor: controller.tabIndex.value == 5 ? AppColors.backgroundPurple : AppColors.clear,
                                            // )),
                                            IntrinsicWidth(
                                                child: CustomAnimatedButton(
                                              onPressed: () {
                                                controller.tabIndex.value = 6;
                                              },
                                              text: " Visit Data ",
                                              isOutline: true,
                                              paddingText: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                              fontSize: 14,
                                              enabledTextColor: controller.tabIndex.value == 6 ? AppColors.backgroundPurple : AppColors.textGrey,
                                              enabledColor: controller.tabIndex.value == 6 ? AppColors.buttonPurpleLight : AppColors.clear,
                                              outLineEnabledColor: AppColors.textGrey,
                                              outlineColor: controller.tabIndex.value == 6 ? AppColors.backgroundPurple : AppColors.clear,
                                            ))
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                              child: Obx(() {
                                return Column(
                                  children: [
                                    controller.tabIndex.value != 1
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height: 19,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16),
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
                                                                  padding: EdgeInsets.zero,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(10),
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
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 1,
                                                                        color: AppColors.appbarBorder,
                                                                        width: double.infinity,
                                                                      )
                                                                    ],
                                                                  )),
                                                              PopupMenuItem(
                                                                  onTap: () {},
                                                                  padding: EdgeInsets.zero,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(10),
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
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 1,
                                                                        color: AppColors.appbarBorder,
                                                                        width: double.infinity,
                                                                      )
                                                                    ],
                                                                  )),
                                                              PopupMenuItem(
                                                                  onTap: () {},
                                                                  padding: EdgeInsets.zero,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(10),
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
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 1,
                                                                        color: AppColors.appbarBorder,
                                                                        width: double.infinity,
                                                                      )
                                                                    ],
                                                                  )),
                                                              PopupMenuItem(
                                                                  onTap: () {},
                                                                  padding: EdgeInsets.zero,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(10),
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
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 1,
                                                                        color: AppColors.appbarBorder,
                                                                        width: double.infinity,
                                                                      )
                                                                    ],
                                                                  )),
                                                              PopupMenuItem(
                                                                  onTap: () {},
                                                                  padding: EdgeInsets.zero,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(10),
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
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ],
                                                        child: SvgPicture.asset(
                                                          ImagePath.share,
                                                          width: 36,
                                                          height: 36,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 19,
                                              ),
                                              Container(
                                                color: AppColors.appbarBorder,
                                                height: 1,
                                                width: double.infinity,
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          )
                                        : SizedBox(
                                            height: 10,
                                          ),
                                    if (controller.tabIndex.value == 0) ...[DoctorView()],
                                    if (controller.tabIndex.value == 1) ...[FullTranscriptView()],
                                    if (controller.tabIndex.value == 2) ...[PatientView()],
                                    if (controller.tabIndex.value == 3) ...[FullNoteView()],
                                    if (controller.tabIndex.value == 6) ...[VisitDataView()],
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
                color: AppColors.ScreenBackGround1,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  // color: AppColors.backgroundWhite,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.backgroundWhite),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        ],
      )),
    );
  }
}
