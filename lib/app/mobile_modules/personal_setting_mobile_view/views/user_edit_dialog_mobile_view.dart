import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/personal_setting_mobile_view_controller.dart';

class UserEditDialogMobileView extends GetView<PersonalSettingMobileViewController> {
  final void Function(Map<String, dynamic>) receiveParam;

  const UserEditDialogMobileView({super.key, required this.receiveParam});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  // color: AppColors.backgroundPurple,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    // padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Personal Setting", style: AppFonts.medium(14, Colors.white))),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(padding: const EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          spacing: 10,
                          children: [
                            Row(children: [Text(textAlign: TextAlign.center, "Personal Information", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]),
                            const SizedBox(height: 5),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [CustomTextInputFormatter()],
                                    label: "First Name",
                                    controller: controller.userFirstNameController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "John",
                                    onTap: () {
                                      controller.userFirstNameController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.requiredFiled(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [CustomTextInputFormatter()],
                                    label: "Last Name",
                                    controller: controller.userLastNameController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "John",
                                    onTap: () {
                                      controller.userLastNameController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.requiredFiled(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [CustomTextInputFormatter()],
                                    label: "Organization",
                                    controller: controller.userOrganizationNameNameController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    readOnly: true,
                                    hint: "",
                                    onTap: () {
                                      controller.userOrganizationNameNameController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(children: [Text(textAlign: TextAlign.center, "Contact", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [NoSpaceLowercaseTextFormatter()],
                                    label: "Email Address",
                                    controller: controller.userEmailController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.userEmailController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.emailValidateRequired(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [MaskTextInputFormatter(mask: "+1 (###) ###-####")],
                                    label: "Phone Number",
                                    controller: controller.userPhoneNumberController,
                                    // isValid: true,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    type: TextInputType.number,
                                    hint: "123456789",
                                    onTap: () {
                                      controller.userPhoneNumberController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 0),
                            // Practitioner Details
                            if (controller.userRole.value == "Doctor") ...[
                              Row(children: [Text(textAlign: TextAlign.center, "Practitioner Details", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]),
                              const SizedBox(height: 5),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      format: [CustomTextInputFormatter()],
                                      label: "Title",
                                      // isValid: controller.isValid.value,
                                      controller: controller.userPractitionerController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userPractitionerController.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      label: "Degree",
                                      controller: controller.organizationDegreeController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationDegreeController.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      format: [MedicalLicenseNumberFormatter()],
                                      label: "Medical License Number",
                                      controller: controller.userMedicalLicenseNumberController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userMedicalLicenseNumberController.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      suffixIcon: const Icon(Icons.calendar_month),
                                      format: [DateInputFormatter()],
                                      label: "License Expiry Date",
                                      controller: controller.userLicenseExpiryDateController,
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(const Duration(days: 1000)),
                                          builder: (context, child) {
                                            return Theme(data: ThemeData.light().copyWith(cardColor: AppColors.white, primaryColor: AppColors.backgroundPurple, hintColor: AppColors.backgroundPurple, colorScheme: const ColorScheme.light(primary: AppColors.backgroundPurple), buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)), child: child!);
                                          },
                                        );
                                        if (picked != null) {
                                          String inputText;
                                          String padDayMonth(int value) => value.toString().padLeft(2, '0');
                                          inputText = '${padDayMonth(picked.month)}/${padDayMonth(picked.day)}/${picked.year}';
                                          controller.userLicenseExpiryDateController.text = inputText;
                                        }
                                      },
                                      hint: "mm/dd/yyyy",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      format: [NpiFormatter()],
                                      label: "National Provider Identifier",
                                      controller: controller.userNationalProviderIdentifierController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userNationalProviderIdentifierController.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      format: [TaxonomyCodeFormatter()],
                                      label: "Taxonomy Code",
                                      controller: controller.userTaxonomyCodeController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userTaxonomyCodeController.clear();
                                      },
                                      checkValidation: (value) {
                                        return Validation.minimumLimitField(value, errorMsg: "Taxonomy Code must be 10 characters");
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: TextFormFiledWidget(
                                      label: "Specialization",
                                      controller: controller.userSpecializationController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userSpecializationController.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  Expanded(
                                    child: Obx(() {
                                      return TextFormFiledWidget(
                                        label: "Sign and Finalize PIN",
                                        format: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                        type: TextInputType.number,
                                        visibility: controller.userPinVisibility.value,
                                        controller: controller.userPINController,
                                        suffixIcon:
                                            !controller.userPinVisibility.value
                                                ? GestureDetector(
                                                  onTap: () {
                                                    controller.changeUserPinVisiblity();
                                                  },
                                                  child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5),
                                                )
                                                : GestureDetector(
                                                  onTap: () {
                                                    controller.changeUserPinVisiblity();
                                                  },
                                                  child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey),
                                                ),
                                        // checkValidation: (value) {
                                        //   return Validation.passwordValidate(value);
                                        // },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: CustomButton(
                          navigate: () {
                            Navigator.pop(context);
                          },
                          label: "Cancel",
                          backGround: Colors.white,
                          isTrue: false,
                          textColor: AppColors.backgroundPurple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: CustomButton(
                          navigate: () {
                            if (controller.formKey.currentState!.validate()) {
                              Map<String, dynamic> param = {};

                              param['first_name'] = controller.userFirstNameController.text;

                              param['last_name'] = controller.userLastNameController.text;
                              param['email'] = controller.userEmailController.text;

                              if (controller.extractDigits(controller.userPhoneNumberController.text).isNotEmpty) {
                                param['contact_no'] = controller.extractDigits(controller.userPhoneNumberController.text);
                              }

                              if (controller.userRole.value == "Doctor") {
                                if (controller.userPractitionerController.text.isNotEmpty) {
                                  param['title'] = controller.userPractitionerController.text;
                                }

                                if (controller.organizationDegreeController.text.isNotEmpty) {
                                  param['degree'] = controller.organizationDegreeController.text;
                                }

                                if (controller.userPINController.text.isNotEmpty) {
                                  param['pin'] = controller.userPINController.text;
                                }

                                if (controller.userMedicalLicenseNumberController.text.isNotEmpty) {
                                  param['medical_license_number'] = controller.userMedicalLicenseNumberController.text;
                                }

                                if (controller.userLicenseExpiryDateController.text.isNotEmpty) {
                                  param['license_expiry_date'] = controller.userLicenseExpiryDateController.text;
                                }

                                if (controller.userNationalProviderIdentifierController.text.isNotEmpty) {
                                  param['national_provider_identifier'] = controller.userNationalProviderIdentifierController.text;
                                }

                                if (controller.userTaxonomyCodeController.text.isNotEmpty) {
                                  param['taxonomy_code'] = controller.userTaxonomyCodeController.text;
                                }

                                if (controller.userSpecializationController.text.isNotEmpty) {
                                  param['specialization'] = controller.userSpecializationController.text;
                                }
                              }

                              receiveParam(param);
                              Navigator.pop(context);
                            }
                          },
                          label: "Submit",
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
    );
  }
}
