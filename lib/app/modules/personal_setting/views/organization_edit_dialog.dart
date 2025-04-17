import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import 'package:toastification/toastification.dart';
import '../../../../utils/Formetors.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../../widgets/custom_toastification.dart';
import '../controllers/personal_setting_controller.dart';

class OrganizationEditDialog extends GetView<PersonalSettingController> {
  final void Function(Map<String, dynamic>) receiveParam;

  OrganizationEditDialog({super.key, required this.receiveParam});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 16,
      child: Form(
        key: controller.formKey,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .80),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Organization Management", style: AppFonts.medium(14, Colors.white))),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(padding: EdgeInsets.all(15), color: AppColors.clear, child: SvgPicture.asset("assets/images/cross_white.svg", width: 15)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          spacing: 10,
                          children: [
                            Row(children: [Text(textAlign: TextAlign.center, "Organization Management", style: AppFonts.medium(16, AppColors.backgroundPurple)), Spacer()]),
                            SizedBox(height: 10),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [CustomTextInputFormatter()],
                                    label: "Name",
                                    isValid: controller.isValid.value,
                                    controller: controller.organizationNameController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationNameController.clear();
                                    },
                                    suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.requiredFiled(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(children: [Text(textAlign: TextAlign.center, "Contact", style: AppFonts.medium(16, AppColors.backgroundPurple)), Spacer()]),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [NoSpaceLowercaseTextFormatter()],
                                    label: "Email Address",
                                    controller: controller.organizationEmailController,
                                    isValid: controller.isValid.value,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationEmailController.clear();
                                    },
                                    suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.emailValidateRequired(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [MaskTextInputFormatter(mask: "+1 (###) ###-####")],
                                    label: "Phone Number",
                                    controller: controller.organizationPhoneNumberController,
                                    isValid: true,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    type: TextInputType.number,
                                    hint: "123456789",
                                    onTap: () {
                                      controller.organizationPhoneNumberController.clear();
                                    },
                                    suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.phoneValidate(value, isRequired: true);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(children: [Text(textAlign: TextAlign.center, "Address", style: AppFonts.medium(16, AppColors.backgroundPurple)), Spacer()]),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                      maxLines: 3,
                                      label: "address1",
                                      isValid: controller.isValid.value,
                                      controller: controller.organizationAddress1Controller,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationAddress1Controller.clear();
                                      },
                                      suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                      maxLines: 3,
                                      label: "address2",
                                      isValid: controller.isValid.value,
                                      controller: controller.organizationAddress2Controller,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationAddress2Controller.clear();
                                      },
                                      suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                      label: "Street name",
                                      maxLines: 3,
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.organizationStreetNameController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationStreetNameController.clear();
                                      },
                                      suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [Text("City", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                                      SizedBox(height: 8),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.organizationCityOption,
                                          selectedValue: controller.organizationSelectedCityValue.value,
                                          onChanged: (value) {
                                            controller.organizationSelectedCityValue.value = value;
                                          },
                                          // selectText: "United States",
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [Text("State", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                                      SizedBox(height: 8),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.organizationStateOption,
                                          selectedValue: controller.organizationSelectedStateValue.value,
                                          onChanged: (value) {
                                            controller.organizationSelectedStateValue.value = value;

                                            controller.organizationCityOption = controller.statesCities.firstWhere((element) => element.state == value).cities;
                                            controller.organizationSelectedCityValue.value = controller.organizationCityOption.first;
                                          },
                                          // selectText: "United States",
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [PostalCodeFormatter()],
                                    label: "Postal code",
                                    isValid: controller.isValid.value,
                                    // isImportant: true,
                                    controller: controller.organizationPostalCodeController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationPostalCodeController.clear();
                                    },
                                    suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.requiredFiled(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [Text("Country", style: AppFonts.regular(14, AppColors.textBlack)), Text("*", style: AppFonts.regular(14, AppColors.redText))]),
                                      SizedBox(height: 8),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.countryOption,
                                          selectedValue: controller.selectedCountryValue.value,
                                          onChanged: (value) {
                                            controller.selectedCountryValue.value = value;
                                          },
                                          selectText: "United States",
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                    SizedBox(width: 12),
                    SizedBox(
                      width: 100,
                      child: CustomButton(
                        navigate: () {
                          if (controller.formKey.currentState!.validate()) {
                            if (controller.organizationSelectedCityValue.value?.isNotEmpty ?? true) {
                              Map<String, dynamic> param = Map<String, dynamic>();

                              param["name"] = controller.organizationNameController.text;
                              param["email"] = controller.organizationEmailController.text;
                              param["state"] = controller.organizationSelectedStateValue.value;
                              param["city"] = controller.organizationSelectedCityValue.value;
                              param["contact_no"] = controller.extractDigits(controller.organizationPhoneNumberController.text);
                              param["country"] = controller.selectedCountryValue.value;
                              param["street_name"] = controller.organizationStreetNameController.text;
                              param["postal_code"] = controller.organizationPostalCodeController.text;
                              param["address1"] = controller.organizationAddress1Controller.text;
                              param["address2"] = controller.organizationAddress2Controller.text;

                              receiveParam(param);
                              Navigator.pop(context);
                            } else {
                              CustomToastification().showToast("Please select city", type: ToastificationType.error);
                            }
                          }
                        },
                        label: "Update",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
