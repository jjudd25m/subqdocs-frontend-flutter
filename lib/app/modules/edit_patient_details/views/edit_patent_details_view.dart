import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/widget/appbar.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_image_view.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../custom_drawer/views/custom_drawer_view.dart';
import '../controllers/edit_patent_details_controller.dart';

class EditPatentDetailsView extends GetView<EditPatentDetailsController> {
  EditPatentDetailsView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        drawer: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: CustomDrawerView(),
        ),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomAppBar(drawerkey: _key),
                Expanded(
                    child: Container(
                  color: AppColors.ScreenBackGround,
                  child: Padding(
                    padding: EdgeInsets.only(top: Dimen.margin20, right: Dimen.margin16, left: Dimen.margin16),
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
                                    "Patient Details",
                                    style: AppFonts.regular(18, AppColors.textBlack),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimen.margin24,
                              ),
                              Row(
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
                                    width: 12.5,
                                  ),
                                  SvgPicture.asset(
                                    ImagePath.edit,
                                    width: 26,
                                    height: 26,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Edit Profile Image",
                                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Dimen.margin16,
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
                                        isValid: true,
                                        controller: controller.firstNameController,
                                        hint: "Don",
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
                                  ),
                                  SizedBox(
                                    width: Dimen.margin10,
                                  ),
                                  Expanded(
                                    child: TextFormFiledWidget(
                                        label: "Middle Name",
                                        controller: controller.middleNameController,
                                        hint: "Joseph",
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
                                  ),
                                  SizedBox(
                                    width: Dimen.margin10,
                                  ),
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      label: "Last Name",
                                      isValid: true,
                                      // isImportant: true,
                                      controller: controller.lastNameController,
                                      hint: "Jones",
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
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
                                      readOnly: true,
                                      onTap: () {
                                        controller.showDOBCupertinoDatePicker(context, controller.dobController);
                                      },
                                      controller: controller.dobController,
                                      hint: "12/1/1972",
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
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
                                      checkValidation: (value) {
                                        return Validation.emailValidate(value);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Dimen.margin16,
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      label: "Visit Date",
                                      readOnly: true,
                                      onTap: () {
                                        controller.showVisitDateCupertinoDatePicker(
                                            context, controller.visitDateController);
                                      },
                                      controller: controller.visitDateController,
                                      hint: "10/12/2024",
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
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
                                              controller.selectedVisitTimeValue.value = value ?? "";
                                            },
                                            selectText: "12:00 AM",
                                          );
                                        }),
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
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  ContainerButton(
                                    onPressed: () {
                                      // Your onPressed function

                                      Get.back();
                                    },
                                    text: 'Cancel',

                                    borderColor: AppColors.backgroundPurple, // Custom border color
                                    backgroundColor: AppColors.white, // Custom background color
                                    needBorder: true, // Show border
                                    textColor: AppColors.backgroundPurple, // Custom text color
                                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12), // Custom padding
                                    radius: 6, // Custom border radius
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ContainerButton(
                                    onPressed: () {
                                      // Your onPressed function

                                      if (_formKey.currentState!.validate()) {
                                        controller.addPatient();
                                      }
                                    },
                                    text: 'Save',

                                    borderColor: AppColors.backgroundPurple, // Custom border color
                                    backgroundColor: AppColors.backgroundPurple, // Custom background color
                                    needBorder: false, // Show border
                                    textColor: AppColors.white, // Custom text color
                                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 12), // Custom padding
                                    radius: 6, // Custom border radius
                                  ),
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
                ))
              ],
            ),
          ),
        ));
  }
}
