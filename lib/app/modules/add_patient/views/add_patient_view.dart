import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_image_view.dart';
import '../../../../widgets/custom_button.dart';
import '../widgets/custom_dailog.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../controllers/add_patient_controller.dart';

class AddPatientView extends GetView<AddPatientController> {
  const AddPatientView({super.key});

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return CustomDialogAttachment(); // Our custom dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.ScreenBackGround,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
              ),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/logo_drawer.svg"),
                      SizedBox(
                        width: 15,
                      ),
                      Image.asset("assets/images/log_subQdocs.png"),
                      Spacer(),
                      RoundedImageWidget(
                        size: 50,
                        imagePath: "assets/images/user.png",
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Adrian Tinajero",
                            style: AppFonts.medium(14, AppColors.backgroundBlack),
                          ),
                          Text(
                            "DO, FAAD",
                            style: AppFonts.medium(12, AppColors.textDarkGrey),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SvgPicture.asset("assets/images/logo_signout.svg")
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Dimen.margin20, right: Dimen.margin16, left: Dimen.margin16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
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
                              "Add Patient Details",
                              style: AppFonts.regular(18, AppColors.textBlack),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimen.margin24,
                        ),
                        TextFormFiledWidget(
                          prefixIcon: SvgPicture.asset(
                            ImagePath.search,
                            fit: BoxFit.cover,
                            width: Dimen.margin12,
                            height: Dimen.margin12,
                          ),
                          controller: controller.searchController,
                          hint: "Search Patient Name, ID, Date of Birth or Email",
                          label: '',
                        ),
                        SizedBox(
                          height: Dimen.margin16,
                        ),
                        Row(
                          children: [
                            RoundedImageWidget(
                              size: 60,
                              imagePath: ImagePath.user,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            SizedBox(
                              width: 92,
                              child: Expanded(
                                child: CustomButton(
                                  hight: 30.0,
                                  navigate: () {},
                                  label: "Choose File",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 73,
                              child: Expanded(
                                child: CustomButton(
                                  navigate: () {},
                                  backGround: Colors.white,
                                  textColor: AppColors.redText,
                                  hight: 30.0,
                                  label: "Remove",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimen.margin16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Patient ID",
                                controller: controller.patientIdController,
                                hint: "12345678",
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(child: SizedBox()),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: SizedBox(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dimen.margin16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "First Name",
                                // isImportant: true,
                                controller: controller.firstNameController,
                                hint: "Don",
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Middle Name",
                                controller: controller.middleNameController,
                                hint: "Joseph",
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Last Name",
                                // isImportant: true,
                                controller: controller.lastNameController,
                                hint: "Jones",
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dimen.margin16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Date of birth",
                                controller: controller.dobController,
                                hint: "12/1/1972",
                                suffixIcon: SvgPicture.asset(ImagePath.calendar),
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sex",
                                    style: AppFonts.regular(14, AppColors.textBlack),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Obx(() {
                                    return BaseDropdown<String>(
                                      valueAsString: (value) => value ?? "",
                                      items: controller.sex,
                                      selectedValue: controller.selectedSexValue.value,
                                      onChanged: (value) {
                                        controller.selectedSexValue.value = value;
                                      },
                                      selectText: "Male",
                                    );
                                  })
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Email Address",
                                controller: controller.emailAddressController,
                                hint: "donjones@example.com",
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dimen.margin16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                label: "Visit Date",
                                controller: controller.visitDateController,
                                hint: "10/12/2024",
                                suffixIcon: SvgPicture.asset(ImagePath.calendar),
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Visit Time",
                                    style: AppFonts.regular(14, AppColors.textBlack),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Obx(() {
                                    return BaseDropdown<String>(
                                      valueAsString: (value) => value ?? "",
                                      items: controller.visitTime,
                                      selectedValue: controller.selectedVisitTimeValue.value,
                                      onChanged: (value) {
                                        controller.selectedVisitTimeValue.value = value;
                                      },
                                      selectText: "11 PM",
                                    );
                                  })
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Patient Type",
                                    style: AppFonts.regular(14, AppColors.textBlack),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Obx(() {
                                    return BaseDropdown<String>(
                                      valueAsString: (value) => value ?? "",
                                      items: controller.patientType,
                                      selectedValue: controller.selectedPatientValue.value,
                                      onChanged: (value) {
                                        controller.selectedPatientValue.value = value;
                                      },
                                      selectText: "New Patient",
                                    );
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimen.margin16,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 0.5, color: AppColors.textDarkGrey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: ExpansionTile(
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.lightpurpule,
                                collapsedBackgroundColor: AppColors.lightpurpule,
                                title: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Attachments",
                                        style: AppFonts.medium(16, AppColors.textBlack),
                                      ),
                                    ],
                                  ),
                                ),
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        child: SizedBox(
                                            height: 200,
                                            width: double.infinity,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.only(top: 20),
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  height: 200,
                                                  width: 140,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 120,
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors.buttonBackgroundGrey
                                                                      .withValues(alpha: 0.8)),
                                                              // color: AppColors.backgroundWhite,
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            padding: const EdgeInsets.only(bottom: Dimen.margin2),
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(
                                                                    8), // Add rounded corners here
                                                                child: Container(
                                                                    color: AppColors.lightpurpule,
                                                                    width: 120,
                                                                    height: 120,
                                                                    child: Center(
                                                                      child: (index % 2 == 0)
                                                                          ? BaseImageView(
                                                                              imageUrl:
                                                                                  "https://gratisography.com/wp-content/uploads/2024/11/gratisography-augmented-reality-800x525.jpg",
                                                                              width: 120,
                                                                              height: 120,
                                                                            )
                                                                          : BaseImageView(
                                                                              imageUrl:
                                                                                  "https://gratisography.com/wp-content/uploads/2024/11/gratisography-augmented-reality-800x525.jpg",
                                                                              width: 120,
                                                                              height: 120,
                                                                            ),
                                                                    ))),
                                                          ),
                                                          Positioned(
                                                            top: -18,
                                                            right: -18,
                                                            child: SvgPicture.asset(
                                                              ImagePath.delete_round_icon,
                                                              height: 50, // Set the height and width as needed
                                                              width: 50,
                                                              fit: BoxFit
                                                                  .cover, // To make sure the image fits the circular shape
                                                            ),
                                                          )

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
                                              separatorBuilder: (context, index) =>
                                                  const SizedBox(width: Dimen.margin15),
                                              itemCount: 8,
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dimen.margin20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 160,
                              child: Expanded(
                                child: CustomButton(
                                  navigate: () {
                                    _showCustomDialog(context);
                                  },
                                  label: "Add Attachments",
                                  backGround: AppColors.white,
                                  textColor: AppColors.textPurple,
                                  isTrue: false,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Clear Form",
                              style: AppFonts.regular(14, AppColors.textDarkGrey),
                            ),
                            SizedBox(
                              width: Dimen.margin6,
                            ),
                            SizedBox(
                              width: 75,
                              child: Expanded(
                                child: CustomButton(
                                  navigate: () {},
                                  label: "Cancel",
                                  backGround: AppColors.white,
                                  textColor: AppColors.textPurple,
                                  isTrue: false,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin6,
                            ),
                            SizedBox(
                              width: 183,
                              child: Expanded(
                                child: CustomButton(
                                  navigate: () {},
                                  label: "Save and Add Another",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dimen.margin6,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundPurple, borderRadius: BorderRadius.circular(10)),
                              width: 98,
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3, right: 11),
                                      child: Text(
                                        "demo",
                                        style: AppFonts.medium(14, Colors.white),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SvgPicture.asset(ImagePath.downArrow),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
