import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/widget/appbar.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_table.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../controllers/patient_profile_controller.dart';
import '../widgets/common_patient_data.dart';

class PatientProfileView extends GetView<PatientProfileController> {
  PatientProfileView({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 25,
                //   ),
                //   child: Container(
                //     height: 68,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(15),
                //       child: Row(
                //         children: [
                //           SvgPicture.asset("assets/images/logo_drawer.svg"),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           Image.asset("assets/images/log_subQdocs.png"),
                //           Spacer(),
                //           RoundedImageWidget(
                //             size: 50,
                //             imagePath: "assets/images/user.png",
                //           ),
                //           SizedBox(
                //             width: 8,
                //           ),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 "Adrian Tinajero",
                //                 style: AppFonts.medium(14, AppColors.backgroundBlack),
                //               ),
                //               Text(
                //                 "DO, FAAD",
                //                 style: AppFonts.medium(12, AppColors.textDarkGrey),
                //               ),
                //             ],
                //           ),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           SvgPicture.asset("assets/images/logo_signout.svg")
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    color: AppColors.ScreenBackGround,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: EdgeInsets.all(Dimen.margin16),
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
                                        child: SvgPicture.asset(
                                          ImagePath.arrowLeft,
                                          fit: BoxFit.cover,
                                          width: Dimen.margin24,
                                          height: Dimen.margin24,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimen.margin8,
                                      ),
                                      Text(
                                        "Patient Details",
                                        style: AppFonts.regular(16, AppColors.textBlack),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "https://s3-alpha-sig.figma.com/img/a4fb/0475/22a6a267e52fb2110d906506ebecb290?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Y7ACwUmQuZYw2hburAkZdY7tlHHQwCz~i3Wht~HvYmQcGFD8GDwKHMCbwYgpOBUXGvVtgcZnowY9LR9ViFQbXp5wri4bxQEFttHdu~vevrmZv-WVCoXSV3LXw7Nt4a-xuqABAHtw~WLxLk5e8YDeHwFVbvNg~2LVDF3WmHMr-lvd2SN-mJy0JHA2wTXcWZnQSb~Al-1TzETWp3w0v4fvMTlt63jkC6fvt-jRWIM1-1TGrT3zbhOS8o0qO97EkN3zddNpk1kS5k2u02qhSBlIffrfa6YzCohR8wgyujUJQJwtEihsK~La5qYdDFYb8Heja9-vMcnn4l9ePcueAuCCKw__",
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SvgPicture.asset(
                                              ImagePath.edit,
                                              width: 26,
                                              height: 26,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Edit Profile Image",
                                              style: AppFonts.regular(14, AppColors.textDarkGrey),
                                            )
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            SvgPicture.asset(
                                              ImagePath.edit,
                                              width: 26,
                                              height: 26,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                width: 125,
                                                child: Expanded(
                                                  child: CustomButton(navigate: () {}, label: "Schedule Visit"),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimen.margin16,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CommonPatientData(
                                            label: "Patient ID",
                                            data: "12345678",
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          CommonPatientData(
                                            label: "Date of Birth",
                                            data: "12/1/1972",
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CommonPatientData(
                                            label: "First Name",
                                            data: "Don",
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          CommonPatientData(
                                            label: "Sex",
                                            data: "Male",
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CommonPatientData(
                                                label: "Middle Name",
                                                data: "Joseph",
                                              ),
                                              SizedBox(
                                                width: 120,
                                              ),
                                              CommonPatientData(
                                                label: "Last Name",
                                                data: "Jones",
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          CommonPatientData(
                                            label: "Email Address",
                                            data: "donjones@example.com",
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CommonPatientData(
                                                label: "",
                                                data: "",
                                              ),
                                              CommonPatientData(
                                                label: "",
                                                data: "",
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          CommonPatientData(
                                            label: "",
                                            data: "",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimen.margin16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 0.5, color: AppColors.lightpurpule),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: ExpansionTile(
                                  shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  title: Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Scheduled Visit",
                                          style: AppFonts.medium(16, AppColors.backgroundPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 0),
                                        child: CustomTable(
                                          rows: [
                                            ['Visit Date', 'Time', "Action"],
                                            ["10/12/2024", '11:00 PM', 'View'],
                                            ["10/12/2024", '11:00 PM', 'View'],
                                            ["10/12/2024", '11:00 PM', 'View'],
                                            ["10/12/2024", '11:00 PM', 'View'],
                                          ],
                                          cellBuilder: (context, rowIndex, colIndex, cellData) {
                                            return colIndex == 2 && rowIndex != 0
                                                ? Text(
                                                    cellData,
                                                    textAlign: TextAlign.center,
                                                    style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                    softWrap: true, // Allows text to wrap
                                                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                  )
                                                : rowIndex == 0
                                                    ? Text(
                                                        cellData,
                                                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                        style: AppFonts.regular(12, AppColors.black),
                                                        softWrap: true, // Allows text to wrap
                                                        overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                      )
                                                    : Text(
                                                        cellData,
                                                        textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                        style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                        softWrap: true, // Allows text to wrap
                                                        overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                      );
                                          },
                                          columnCount: 3,
                                          context: context,
                                          columnWidths: [0.33, 0.33, 0.33],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 0.5, color: AppColors.lightpurpule),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: ExpansionTile(
                                  shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  title: Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Scheduled Visit",
                                          style: AppFonts.medium(16, AppColors.backgroundPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 53,
                                          ),
                                          SvgPicture.asset(ImagePath.noVisitFound),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "No Visit Found",
                                            style: AppFonts.medium(16, AppColors.black),
                                          ),
                                          SizedBox(
                                            height: 17,
                                          ),
                                          Container(
                                            width: 125,
                                            child: CustomButton(navigate: () {}, label: "Schedule Visit"),
                                          ),
                                          SizedBox(
                                            height: 46,
                                          ),
                                        ],
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 0.5, color: AppColors.lightpurpule),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: ExpansionTile(
                                  shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  collapsedBackgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                  title: Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Past Visits",
                                          style: AppFonts.medium(16, AppColors.backgroundPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
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
                                                              style: AppFonts.regular(15, AppColors.textGrey),
                                                            ),
                                                            SizedBox(width: 20),
                                                            Expanded(
                                                                child: Text(
                                                              maxLines: 1,
                                                              textAlign: TextAlign.center,
                                                              "No recurrence. Started erbium laser and Kenalog for nasal scar. Advised routine skin checks...",
                                                              style: AppFonts.regular(15, AppColors.textGrey),
                                                            )),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              textAlign: TextAlign.center,
                                                              "View",
                                                              style: AppFonts.regular(15, AppColors.textPurple),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
