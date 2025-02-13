import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/widget/appbar.dart';

import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../routes/app_pages.dart';
import '../controllers/visit_main_controller.dart';

class VisitMainView extends GetView<VisitMainController> {
  VisitMainView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: AppColors.white,
      // appBar: CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                  child: Container(
                    color: AppColors.ScreenBackGround1,
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                                      SvgPicture.asset(
                                        ImagePath.logo_back,
                                        height: 15,
                                        width: 18,
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
                                        height: 15,
                                        width: 15,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      ContainerButton(
                                        onPressed: () {
                                          // Your onPressed function
                                        },
                                        text: 'Patient History',

                                        borderColor: AppColors.appbarBorder,
                                        // Custom border color
                                        backgroundColor: AppColors.white,
                                        // Custom background color
                                        needBorder: true,
                                        // Show border
                                        textColor: AppColors.textDarkGrey,
                                        // Custom text color
                                        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                                        // Custom padding
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
                                  )
                                  // ExpansionTile(
                                  //   title: Text(
                                  //     'Sub title',
                                  //   ),
                                  //   children: <Widget>[
                                  //     // ListTile(
                                  //     //   title: Text('data'),
                                  //     // )
                                  //   ],
                                  // ),
                                  // ListTile(
                                  //   title: Text('data'),
                                  // )
                                ],
                              ),
                              SizedBox(height: 10.0),
                              ExpansionTile(
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
                                        height: 48,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                          color: AppColors.backgroundWhite,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              "He enjoys fishing and gardening. His wife's name is Julie.",
                                              style: AppFonts.regular(14, AppColors.textDarkGrey),
                                            ),
                                            Spacer(),
                                            Text(
                                              textAlign: TextAlign.center,
                                              "Mon - 20/01/2025",
                                              style: AppFonts.regular(10, AppColors.textDarkGrey),
                                            ),
                                            SizedBox(width: 7),
                                            SvgPicture.asset(
                                              ImagePath.edit_outline,
                                              height: 28,
                                              width: 28,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                  // ExpansionTile(
                                  //   title: Text(
                                  //     'Sub title',
                                  //   ),
                                  //   children: <Widget>[
                                  //     // ListTile(
                                  //     //   title: Text('data'),
                                  //     // )
                                  //   ],
                                  // ),
                                  // ListTile(
                                  //   title: Text('data'),
                                  // )
                                ],
                              ),
                              SizedBox(height: 10),
                              ExpansionTile(
                                childrenPadding: EdgeInsets.all(0),
                                collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.backgroundWhite,
                                collapsedBackgroundColor: AppColors.backgroundWhite,
                                title: Row(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      "Visit Snapshot",
                                      style: AppFonts.regular(16, AppColors.textBlack),
                                    ),
                                    Spacer(),
                                    SvgPicture.asset(
                                      ImagePath.edit_outline,
                                      height: 28,
                                      width: 28,
                                    ),
                                  ],
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                    child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5)),
                                          color: AppColors.backgroundWhite,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SvgPicture.asset(
                                              ImagePath.ai,
                                              height: 16,
                                              width: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              textAlign: TextAlign.start,
                                              "He enjoys fishing and gardening. His wife's name is Julie.",
                                              style: AppFonts.regular(14, AppColors.textGrey),
                                            ),
                                            Spacer(),
                                            SizedBox(
                                              height: 36,
                                              child: ContainerButton(
                                                onPressed: () {
                                                  // Your onPressed function
                                                },
                                                text: 'Generate',

                                                borderColor: AppColors.backgroundPurple,
                                                // Custom border color
                                                backgroundColor: AppColors.white,
                                                // Custom background color
                                                needBorder: true,
                                                // Show border
                                                textColor: AppColors.backgroundPurple,
                                                // Custom text color
                                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                                // Custom padding
                                                radius: 6, // Custom border radius
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      "Don Jones has a history of melanoma in situ on the nasal tip, surgically excised with flap repair. Post-op care included imiquimod treatment, later discontinued due to irritation. Recently started erbium Pearl Fractional laser and Kenalog injections for scar improvement. No signs of melanoma recurrence; benign lesions (seborrheic keratoses, solar lentigines, cherry angiomas) noted—no treatment needed. Scheduled for another laser session today.",
                                      style: AppFonts.regular(14, AppColors.textGrey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              ExpansionTile(
                                childrenPadding: EdgeInsets.all(0),
                                collapsedShape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.backgroundWhite,
                                collapsedBackgroundColor: AppColors.backgroundWhite,
                                title: Row(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.start,
                                      "Visit Recaps (8 Visits)",
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

                                          // Text(
                                          //   "Attachments",
                                          //   style: AppFonts.medium(16, AppColors.textBlack),
                                          // ),
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
                                                          "1/13/2025",
                                                          style: AppFonts.medium(14, AppColors.textGrey),
                                                        ),
                                                        SizedBox(width: 15),
                                                        Expanded(
                                                            child: Text(
                                                          maxLines: 1,
                                                          textAlign: TextAlign.center,
                                                          "No recurrence. Started erbium laser and Kenalog for nasal scar. Advised routine skin checks..",
                                                          style: AppFonts.regular(14, AppColors.textGrey),
                                                        )),
                                                        Spacer(),
                                                        Text(
                                                          textAlign: TextAlign.center,
                                                          "View",
                                                          style: AppFonts.medium(12, AppColors.textPurple),
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
                                        itemCount: 8),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              ExpansionTile(
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
                                      onTap: () {
                                        Get.toNamed(Routes.ALL_ATTACHMENT);
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
                                                  onTap: () {
                                                    controller.isSelectedAttchmentOption.value = 0;
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
                                                        colorFilter:
                                                            ColorFilter.mode(controller.isSelectedAttchmentOption.value == 0 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text("Document", style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 0 ? AppColors.backgroundPurple : AppColors.textBlack)),
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
                                                  },
                                                  height: 30,
                                                  padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(width: 5),
                                                      SvgPicture.asset(ImagePath.image_attchment,
                                                          width: 30,
                                                          height: 30,
                                                          colorFilter:
                                                              ColorFilter.mode(controller.isSelectedAttchmentOption.value == 1 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn)),
                                                      const SizedBox(width: 8),
                                                      Text("Image", style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 1 ? AppColors.backgroundPurple : AppColors.textBlack)),
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
                                                        colorFilter:
                                                            ColorFilter.mode(controller.isSelectedAttchmentOption.value == 2 ? AppColors.backgroundPurple : AppColors.textDarkGrey, BlendMode.srcIn),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text("Date", style: AppFonts.medium(17, controller.isSelectedAttchmentOption.value == 2 ? AppColors.backgroundPurple : AppColors.textBlack)),
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
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: SizedBox(
                                          height: 170,
                                          width: double.infinity,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.only(top: 20),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height: 150,
                                                width: 130,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          height: 120,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: AppColors.buttonBackgroundGrey.withValues(alpha: 0.8)),
                                                            // color: AppColors.backgroundWhite,
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          padding: const EdgeInsets.only(bottom: Dimen.margin2),
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8), // Add rounded corners here
                                                              child: Container(
                                                                  color: AppColors.backgroundPdfAttchment,
                                                                  width: 120,
                                                                  height: 120,
                                                                  child: Center(
                                                                    child: (index % 2 == 0)
                                                                        ? Image.asset(
                                                                            ImagePath.pdf,
                                                                            width: 60,
                                                                            height: 60,
                                                                            fit: BoxFit.contain,
                                                                          )
                                                                        : BaseImageView(
                                                                            imageUrl: "https://gratisography.com/wp-content/uploads/2024/11/gratisography-augmented-reality-800x525.jpg",
                                                                            width: 120,
                                                                            height: 120,
                                                                          ),
                                                                  ))),
                                                        ),
                                                        // Positioned(
                                                        //   top: -15,
                                                        //   right: -15,
                                                        //   child: Container(
                                                        //     width: 50, // Width of the circle
                                                        //     height: 50, // Height of the circle
                                                        //     decoration: BoxDecoration(
                                                        //       shape: BoxShape.circle, // Ensures the container is circular
                                                        //       color: Colors.white, // Circle color (can be changed as needed)
                                                        //       boxShadow: [
                                                        //         BoxShadow(
                                                        //           color: Colors.black.withOpacity(0.25), // Shadow color
                                                        //           blurRadius: 8, // Shadow blur radius
                                                        //           offset: Offset(2, 2), // Shadow offset
                                                        //         ),
                                                        //       ],
                                                        //     ),
                                                        //     child: GestureDetector(
                                                        //       onTap: () {
                                                        //         showDialog(
                                                        //           context: context,
                                                        //           barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                        //           builder: (BuildContext context) {
                                                        //             return DeleteImageDialog(); // Our custom dialog
                                                        //           },
                                                        //         );
                                                        //       },
                                                        //       child: SvgPicture.asset(
                                                        //         ImagePath.delete_round,
                                                        //         height: 50, // Set the height and width as needed
                                                        //         width: 50,
                                                        //         fit: BoxFit.cover, // To make sure the image fits the circular shape
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // )

                                                        // Container(
                                                        //   decoration: BoxDecoration(
                                                        //     shape: BoxShape.circle, // Makes the container circular
                                                        //     boxShadow: [
                                                        //       BoxShadow(
                                                        //         color: Colors.black.withValues(alpha: 0.10), // Shadow color
                                                        //         blurRadius: 0.2,
                                                        //         blurStyle: BlurStyle.normal,
                                                        //         spreadRadius: 2, // Shadow blur radius
                                                        //         offset: Offset(0, 0), // Shadow offset
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        //   child: SvgPicture.asset(
                                                        //     ImagePath.delete_round,
                                                        //     height: 60, // Set the height and width as needed
                                                        //     width: 60,
                                                        //     fit: BoxFit.cover, // To make sure the image fits the circular shape
                                                        //   ),
                                                        // ),
                                                        // )

                                                        // Positioned(
                                                        //   top: -15,
                                                        //   right: -5,
                                                        //   child: ClipRRect(
                                                        //     borderRadius: BorderRadius.circular(30),
                                                        //     child: Container(
                                                        //       decoration: BoxDecoration(
                                                        //         border: Border.all(color: AppColors.buttonBackgroundGrey.withValues(alpha: 0.8)),
                                                        //         borderRadius: BorderRadius.circular(1),
                                                        //       ),
                                                        //       child: SvgPicture.asset(
                                                        //         ImagePath.delete_round,
                                                        //         height: 60,
                                                        //         width: 60,
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) => const SizedBox(width: Dimen.margin15),
                                            itemCount: 8,
                                          ))),
                                ],
                              ),
                            ],
                          ),
                        ],
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
                            child: GestureDetector(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: ['mp3', 'aac', 'm4a'],
                                );

                                print("audio is:- ${result?.files.first.xFile.path}");

                                controller.submitAudio(File(result?.files.first.path ?? ""));

                                // showDialog(
                                //   context: context,
                                //   barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                //   builder: (BuildContext context) {
                                //     return ViewAttchmentImage(); // Our custom dialog
                                //   },
                                // );
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
                                          ImagePath.add_photo,
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Add a Photo",
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
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.isStartRecording.value = true;
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
                          ],
                          if (controller.isStartRecording.value) ...[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.PATIENT_INFO);
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
            // Positioned(
            //     bottom: 30,
            //     right: 30,
            //     child: Obx(() {
            //       return Stack(
            //         children: [
            //           if (controller.isExpandRecording.value) ...[
            //             Container(
            //               width: MediaQuery.of(context).size.width * 0.45,
            //               decoration: BoxDecoration(boxShadow: [
            //                 BoxShadow(
            //                   color: AppColors.backgroundLightGrey.withValues(alpha: 0.9),
            //                   spreadRadius: 6,
            //                   blurRadius: 4.0,
            //                 )
            //               ], borderRadius: BorderRadius.circular(12), color: AppColors.backgroundWhite),
            //               child: Column(
            //                 children: [
            //                   Container(
            //                     height: 50,
            //                     padding: EdgeInsets.symmetric(horizontal: 20),
            //                     // color: AppColors.backgroundPurple,
            //                     decoration: BoxDecoration(boxShadow: [
            //                       BoxShadow(
            //                         color: AppColors.backgroundLightGrey.withValues(alpha: 0.9),
            //                         spreadRadius: 6,
            //                         blurRadius: 4.0,
            //                       )
            //                     ], borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)), color: AppColors.backgroundPurple),
            //                     child: Row(
            //                       children: [
            //                         Text(
            //                           textAlign: TextAlign.center,
            //                           "Recording in Progress",
            //                           style: AppFonts.medium(14, AppColors.textWhite),
            //                         ),
            //                         Spacer(),
            //                         GestureDetector(
            //                           onTap: () {
            //                             controller.isExpandRecording.value = !controller.isExpandRecording.value;
            //                           },
            //                           child: SvgPicture.asset(
            //                             ImagePath.collpase,
            //                             height: 30,
            //                             width: 30,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(height: 20),
            //                   Text(
            //                     textAlign: TextAlign.center,
            //                     "Recording in Progress",
            //                     style: AppFonts.regular(17, AppColors.textBlack),
            //                   ),
            //                   SizedBox(height: 20),
            //                   Image.asset(
            //                     ImagePath.wave,
            //                     height: 90,
            //                     width: 90,
            //                     fit: BoxFit.fill,
            //                   ),
            //                   SizedBox(height: 20),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       GestureDetector(
            //                         onTap: () async {
            //                           await controller.recorderService.startRecording();
            //                         },
            //                         child: Column(
            //                           children: [
            //                             SvgPicture.asset(
            //                               ImagePath.pause_recording,
            //                               height: 50,
            //                               width: 50,
            //                             ),
            //                             SizedBox(height: 10),
            //                             Text(
            //                               textAlign: TextAlign.center,
            //                               "Pause",
            //                               style: AppFonts.medium(17, AppColors.textGrey),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       SizedBox(width: 20),
            //                       GestureDetector(
            //                           onTap: () async {
            //                             File? audioFile = await controller.recorderService.stopRecording();
            //                             print("audio file url is :- ${audioFile?.absolute}");
            //                             controller.submitAudio(audioFile!);
            //                           },
            //                           child: Column(
            //                             children: [
            //                               SvgPicture.asset(
            //                                 ImagePath.stop_recording,
            //                                 height: 50,
            //                                 width: 50,
            //                               ),
            //                               SizedBox(height: 10),
            //                               Text(
            //                                 textAlign: TextAlign.center,
            //                                 "Stop",
            //                                 style: AppFonts.medium(17, AppColors.textGrey),
            //                               ),
            //                             ],
            //                           ))
            //                     ],
            //                   ),
            //                   SizedBox(height: 20),
            //                   Text(
            //                     textAlign: TextAlign.center,
            //                     "(01:07:12)",
            //                     style: AppFonts.regular(14, AppColors.textBlack),
            //                   ),
            //                   SizedBox(height: 10),
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(horizontal: 10),
            //                     child: Text(
            //                       textAlign: TextAlign.center,
            //                       "Press the stop button to start generating your summary.",
            //                       style: AppFonts.regular(14, AppColors.textGrey),
            //                     ),
            //                   ),
            //                   SizedBox(height: 15),
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(horizontal: 20),
            //                     child: Row(
            //                       spacing: 15,
            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //                         Expanded(
            //                           child: GestureDetector(
            //                             onTap: () {},
            //                             child: Container(
            //                               height: 50,
            //                               decoration: BoxDecoration(
            //                                 border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 2),
            //                                 color: AppColors.white,
            //                                 borderRadius: BorderRadius.circular(8),
            //                               ),
            //                               child: Row(
            //                                 mainAxisAlignment: MainAxisAlignment.center,
            //                                 children: [
            //                                   SvgPicture.asset(
            //                                     ImagePath.logo_back,
            //                                     height: 20,
            //                                     width: 20,
            //                                   ),
            //                                   SizedBox(
            //                                     width: 10,
            //                                   ),
            //                                   Text(
            //                                     textAlign: TextAlign.center,
            //                                     "Back To Visit",
            //                                     style: AppFonts.medium(14, AppColors.textGrey),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         Expanded(
            //                           child: GestureDetector(
            //                             onTap: () async {
            //                               FilePickerResult? result = await FilePicker.platform.pickFiles(
            //                                 allowMultiple: false,
            //                                 type: FileType.custom,
            //                                 allowedExtensions: ['mp3', 'aac', 'm4a'],
            //                               );
            //
            //                               print("audio is:- ${result?.files.first.xFile.path}");
            //
            //                               controller.submitAudio(File(result?.files.first.path ?? ""));
            //                             },
            //                             child: Container(
            //                               height: 50,
            //                               decoration: BoxDecoration(
            //                                 border: Border.all(color: AppColors.textPurple, width: 2),
            //                                 color: AppColors.white,
            //                                 borderRadius: BorderRadius.circular(8),
            //                               ),
            //                               child: Row(
            //                                 mainAxisAlignment: MainAxisAlignment.center,
            //                                 children: [
            //                                   SvgPicture.asset(
            //                                     ImagePath.uploadImage,
            //                                     height: 20,
            //                                     width: 20,
            //                                   ),
            //                                   SizedBox(
            //                                     width: 10,
            //                                   ),
            //                                   Text(
            //                                     textAlign: TextAlign.center,
            //                                     "Upload Photos",
            //                                     style: AppFonts.medium(14, AppColors.textPurple),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     height: 20,
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ],
            //           if (controller.isExpandRecording.value == false) ...[
            //             Container(
            //               width: 340,
            //               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.backgroundBlack),
            //               child: Row(
            //                 children: [
            //                   SvgPicture.asset(
            //                     ImagePath.recording,
            //                     height: 45,
            //                     width: 45,
            //                   ),
            //                   SizedBox(width: 10),
            //                   Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         textAlign: TextAlign.left,
            //                         "Don Jones",
            //                         style: AppFonts.regular(14, AppColors.textWhite),
            //                       ),
            //                       SizedBox(height: 0),
            //                       Text(
            //                         textAlign: TextAlign.left,
            //                         "00:03:09",
            //                         style: AppFonts.regular(14, AppColors.textGrey),
            //                       ),
            //                     ],
            //                   ),
            //                   Spacer(),
            //                   SizedBox(
            //                     height: 20,
            //                   ),
            //                   GestureDetector(
            //                     onTap: () async {
            //                       await controller.recorderService.startRecording();
            //                     },
            //                     child: SvgPicture.asset(
            //                       ImagePath.pause_white,
            //                       height: 45,
            //                       width: 45,
            //                     ),
            //                   ),
            //                   SizedBox(width: 10),
            //                   GestureDetector(
            //                     onTap: () async {
            //                       File? audioFile = await controller.recorderService.stopRecording();
            //                       print("audio file url is :- ${audioFile?.absolute}");
            //                       controller.submitAudio(audioFile!);
            //                     },
            //                     child: SvgPicture.asset(
            //                       ImagePath.stop_recording,
            //                       height: 45,
            //                       width: 45,
            //                     ),
            //                   ),
            //                   SizedBox(width: 10),
            //                   GestureDetector(
            //                     onTap: () {
            //                       controller.isExpandRecording.value = !controller.isExpandRecording.value;
            //                     },
            //                     child: SvgPicture.asset(
            //                       ImagePath.expand_recording,
            //                       height: 45,
            //                       width: 45,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ]
            //         ],
            //       );
            //     }))
            Positioned(
              bottom: 30,
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
                                controller.isExpandRecording.value ? "Recording in Progress" : "Don Jones",
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
                                  // If not recording, start the recording
                                  await controller.recorderService.startRecording();
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

                            // GestureDetector(
                            //   onTap: () async {
                            //     await controller.recorderService.startRecording();
                            //   },
                            //   child: Column(
                            //     children: [
                            //       SvgPicture.asset(
                            //         ImagePath.start_recording,
                            //         height: 50,
                            //         width: 50,
                            //       ),
                            //       SizedBox(height: 10),
                            //       Text(
                            //         textAlign: TextAlign.center,
                            //         "Start",
                            //         style: AppFonts.medium(17, AppColors.textGrey),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () async {
                                File? audioFile = await controller.recorderService.stopRecording();
                                print("audio file url is :- ${audioFile?.absolute}");
                                controller.submitAudio(audioFile!);
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
                                  onTap: () {},
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
                                        SvgPicture.asset(
                                          ImagePath.logo_back,
                                          height: 20,
                                          width: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Back To Visit",
                                          style: AppFonts.medium(14, AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      allowMultiple: false,
                                      type: FileType.custom,
                                      allowedExtensions: ['mp3', 'aac', 'm4a'],
                                    );

                                    print("audio is:- ${result?.files.first.xFile.path}");
                                    controller.submitAudio(File(result?.files.first.path ?? ""));
                                  },
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
                                          style: AppFonts.medium(14, AppColors.textPurple),
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
                                  "Don Jones",
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
                            GestureDetector(
                              onTap: () async {
                                await controller.recorderService.startRecording();
                              },
                              child: SvgPicture.asset(
                                ImagePath.pause_white,
                                height: 45,
                                width: 45,
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                File? audioFile = await controller.recorderService.stopRecording();
                                print("audio file url is :- ${audioFile?.absolute}");
                                controller.submitAudio(audioFile!);
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
            // if (controller.isLoading.value) ...[
            //   Center(
            //       child: Column(
            //     children: [
            //       Lottie.asset(
            //         'assets/lottie/progress_loader.json',
            //         width: 200,
            //         height: 200,
            //         fit: BoxFit.fill,
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       Text(controller.loadingMessage.value)
            //     ],
            //   )),
            // ]
          ],
        ),
      ),
    );
  }
}
