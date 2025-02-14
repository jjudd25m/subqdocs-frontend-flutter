import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/widget/appbar.dart';
import 'package:subqdocs/widget/base_image_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/ContainerButton.dart';
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
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                  child: Container(
                    color: AppColors.ScreenBackGround,
                    child: SingleChildScrollView(
                      child: Obx(() {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                padding: EdgeInsets.all(Dimen.margin16),
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.white),
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
                                                  child: BaseImageView(
                                                    height: 50,
                                                    width: 50,
                                                    fontSize: 16,
                                                    imageUrl:
                                                        controller.patientDetailModel.responseData?.profileImage ?? "",
                                                    nameLetters:
                                                        "${controller.patientDetailModel.responseData?.firstName}  ${controller.patientDetailModel.responseData?.lastName} ",
                                                  )),
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
                                              // Container(
                                              //     width: 125,
                                              //     child: Expanded(
                                              //       child: CustomButton(navigate: () {}, label: "Schedule Visit"),
                                              //     )),
                                              // ContainerButton(
                                              //   onPressed: () {},
                                              //   text: 'Schedule Visit',
                                              // ),

                                              ContainerButton(
                                                onPressed: () {},
                                                text: 'Schedule Visit',

                                                borderColor: AppColors.backgroundPurple, // Custom border color
                                                backgroundColor: AppColors.backgroundPurple, // Custom background color
                                                needBorder: true, // Show border
                                                textColor: AppColors.white, // Custom text color
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 11, horizontal: 12), // Custom padding
                                                radius: 6, // Custom border radius
                                              )
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
                                              data: controller.patientDetailModel.responseData?.patientId.toString(),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            CommonPatientData(
                                              label: "Date of Birth",
                                              data: controller.dob.value,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonPatientData(
                                              label: "First Name",
                                              data: controller.patientDetailModel.responseData?.firstName ?? "",
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            CommonPatientData(
                                                label: "Sex",
                                                data: controller.patientDetailModel.responseData?.gender ?? ""),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CommonPatientData(
                                                  label: "Middle Name",
                                                  data: controller.patientDetailModel.responseData?.middleName,
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                ),
                                                CommonPatientData(
                                                  label: "Last Name",
                                                  data: controller.patientDetailModel.responseData?.lastName,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            CommonPatientData(
                                              label: "Email Address",
                                              data: controller.patientDetailModel.responseData?.email,
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
                                    shape: OutlineInputBorder(
                                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    collapsedShape: OutlineInputBorder(
                                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
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
                                              ["10/12/2024", '11:00 PM', 'View ', "Reschedule", "Cancel visit"],
                                              ["10/12/2024", '11:00 PM', 'View ', "Reschedule", "Cancel visit"],
                                              ["10/12/2024", '11:00 PM', 'View ', "Reschedule", "Cancel visit"],
                                              ["10/12/2024", '11:00 PM', 'View ', "Reschedule", "Cancel visit"],
                                              ["10/12/2024", '11:00 PM', 'View ', "Reschedule", "Cancel visit"],
                                            ],
                                            cellBuilder: (context, rowIndex, colIndex, cellData, profileImage) {
                                              return colIndex == 2 && rowIndex != 0
                                                  ? Text(
                                                      cellData,
                                                      textAlign: TextAlign.center,
                                                      style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                      softWrap: true, // Allows text to wrap
                                                      overflow:
                                                          TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                    )
                                                  : (colIndex == 3 || colIndex == 4) && rowIndex != 0
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "|  ",
                                                              style: AppFonts.regular(12, AppColors.appbarBorder),
                                                            ),
                                                            Text(
                                                              cellData ?? "",
                                                              textAlign: TextAlign.center,
                                                              style: AppFonts.regular(14, AppColors.backgroundPurple),
                                                              softWrap: true, // Allows text to wrap
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Adds ellipsis if text overflows
                                                            ),
                                                          ],
                                                        )
                                                      : rowIndex == 0
                                                          ? Text(
                                                              cellData ?? "",
                                                              textAlign:
                                                                  colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                              style: AppFonts.regular(12, AppColors.black),
                                                              softWrap: true, // Allows text to wrap
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Adds ellipsis if text overflows
                                                            )
                                                          : Text(
                                                              cellData ?? "",
                                                              textAlign:
                                                                  colIndex == 0 ? TextAlign.start : TextAlign.center,
                                                              style: AppFonts.regular(14, AppColors.textDarkGrey),
                                                              softWrap: true, // Allows text to wrap
                                                              overflow: TextOverflow
                                                                  .ellipsis, // Adds ellipsis if text overflows
                                                            );
                                            },
                                            columnCount: 5,
                                            context: context,
                                            columnWidths: isPortrait
                                                ? [0.25, 0.29, 0.11, 0.17, 0.18]
                                                : [0.33, 0.32, 0.10, 0.13, 0.12],
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
                                    shape: OutlineInputBorder(
                                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    backgroundColor: AppColors.backgroundPurple.withValues(alpha: 0.2),
                                    collapsedShape: OutlineInputBorder(
                                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
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
                                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(ImagePath.noVisitFound),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "No Visit Found",
                                                    style: AppFonts.regular(16, AppColors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "Your scheduled visits will show here",
                                                    style: AppFonts.regular(12, AppColors.black),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              ContainerButton(
                                                onPressed: () {
                                                  // Your onPressed function
                                                },
                                                text: 'Schedule Visit',

                                                borderColor: AppColors.backgroundPurple, // Custom border color
                                                backgroundColor: AppColors.backgroundPurple, // Custom background color
                                                needBorder: false, // Show border
                                                textColor: AppColors.white, // Custom text color
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 11, horizontal: 12), // Custom padding
                                                radius: 6, // Custom border radius
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 0.5, color: AppColors.lightpurpule),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: ExpansionTile(
                                    shape: OutlineInputBorder(
                                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                    collapsedShape: OutlineInputBorder(
                                        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
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
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
