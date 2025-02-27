import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/widget/appbar.dart';

import '../../../../utils/Formetors.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/fileImage.dart';
import '../../../../widgets/ContainerButton.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/base_image_view.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/date_field.dart';
import '../../../../widgets/rounded_image_widget.dart';
import '../../../routes/app_pages.dart';
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
                              Obx(
                                () {
                                  return Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: controller.profileImageUrl.value != null
                                            ? CachedNetworkImage(
                                                imageUrl: controller.profileImageUrl.value ?? "",
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              )
                                            : controller.profileImage.value?.path != null
                                                ? RoundedImageFileWidget(
                                                    size: 60,
                                                    imagePath: controller.profileImage.value,
                                                  )
                                                : BaseImageView(
                                                    imageUrl: "",
                                                    width: 60,
                                                    height: 60,
                                                    fontSize: 14,
                                                    nameLetters: "mihir",
                                                  ),
                                      ),
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
                                              visualDensity: VisualDensity(horizontal: 0, vertical: 0)),
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    padding: EdgeInsets.zero,
                                                    onTap: () {
                                                      controller.pickProfileImage();
                                                    },
                                                    // value: "",
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.file_copy_sharp,
                                                            color: AppColors.textDarkGrey,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Pick From Files",
                                                            style: AppFonts.regular(16, AppColors.textBlack),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                PopupMenuItem(
                                                    // value: "",
                                                    padding: EdgeInsets.zero,
                                                    onTap: () async {
                                                      controller.captureProfileImage();
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
                                                              Icon(CupertinoIcons.camera),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Take A Photo",
                                                                style: AppFonts.regular(16, AppColors.textBlack),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                          child: Row(
                                            children: [
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
                                              ),
                                            ],
                                          ))
                                    ],
                                  );
                                },
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
                                        label: "Patient Id ",

                                        // isImportant: true,
                                        type: TextInputType.number,
                                        isValid: true,
                                        format: [
                                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                                        ],
                                        controller: controller.patientIdController,
                                        hint: "123",
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
                                  ),
                                  SizedBox(
                                    width: Dimen.margin10,
                                  ),
                                  Expanded(
                                    child: TextFormFiledWidget(
                                        label: "First Name",
                                        format: [
                                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                        ],
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
                                      format: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                      ],
                                      controller: controller.middleNameController,
                                      hint: "Joseph",
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
                                      label: "Last Name",
                                      format: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                                      ],
                                      isValid: true,
                                      // isImportant: true,
                                      controller: controller.lastNameController,
                                      hint: "Jones",
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimen.margin10,
                                  ),
                                  Expanded(
                                    child: TextFormFiledWidget(
                                        suffixIcon: Icon(Icons.calendar_month),
                                        label: "Date of birth",
                                        format: [NoSpaceTextFormatter()],
                                        isValid: true,
                                        readOnly: true,
                                        // isImportant: true,
                                        controller: controller.dobController,
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now().subtract(Duration(days: 400)),
                                            firstDate: DateTime.now().subtract(Duration(days: 36700)),
                                            lastDate: DateTime.now().subtract(Duration(days: 400)),
                                          );
                                          if (picked != null) {
                                            String inputText;
                                            String padDayMonth(int value) => value.toString().padLeft(2, '0');
                                            inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
                                            controller.dobController.text = inputText;
                                          }
                                        },
                                        hint: "mm/dd/yyyy",
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
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
                                ],
                              ),
                              SizedBox(
                                height: Dimen.margin16,
                              ),
                              Obx(
                                () {
                                  return controller.isFromSchedule.value
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: TextFormFiledWidget(
                                                format: [NoSpaceLowercaseTextFormatter()],
                                                label: "Email Address",
                                                controller: controller.emailAddressController,
                                                hint: "donjones@example.com",
                                                checkValidation: (value) {
                                                  return Validation.emailValidate(value);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimen.margin10,
                                            ),
                                            Expanded(
                                              child: TextFormFiledWidget(
                                                suffixIcon: Icon(Icons.calendar_month),
                                                label: "Visit Date",
                                                format: [NoSpaceTextFormatter()],
                                                readOnly: true,
                                                // isImportant: true,
                                                controller: controller.visitDateController,
                                                onTap: () async {
                                                  final picked = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.now().add(Duration(days: 1000)),
                                                  );
                                                  if (picked != null) {
                                                    String inputText;
                                                    String padDayMonth(int value) => value.toString().padLeft(2, '0');
                                                    inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
                                                    controller.visitDateController.text = inputText;
                                                  }
                                                },
                                                hint: "mm/dd/yyyy",
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
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: TextFormFiledWidget(
                                                label: "Email Address",
                                                format: [NoSpaceLowercaseTextFormatter()],
                                                controller: controller.emailAddressController,
                                                hint: "donjones@example.com",
                                                checkValidation: (value) {
                                                  return Validation.emailValidate(value);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimen.margin10,
                                            ),
                                            Expanded(child: SizedBox()),
                                            Expanded(child: SizedBox()),
                                          ],
                                        );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  ContainerButton(
                                    onPressed: () {
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
