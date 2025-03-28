import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import '../../../../utils/Formetors.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/personal_setting_controller.dart';

class OrganizationEditDialog extends GetView<PersonalSettingController> {
  final void Function(Map<String, dynamic>) receiveParam;

  OrganizationEditDialog({super.key, required this.receiveParam});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 16,
      child: Form(
        key: controller.formKey,
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * .80, maxWidth: Get.width * .80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundPurple,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                // color: AppColors.backgroundPurple,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  // padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          "Organization Management",
                          style: AppFonts.medium(14, Colors.white),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // controller.list.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          color: AppColors.clear,
                          child: SvgPicture.asset(
                            "assets/images/cross_white.svg",
                            width: 15,
                          ),
                        ),
                      )
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
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Organization Management",
                                  style: AppFonts.medium(16, AppColors.backgroundPurple),
                                ),
                                Spacer()
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [
                                        CustomTextInputFormatter(),
                                      ],
                                      label: "Name",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.organizationNameController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationNameController.clear();
                                      },
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      }),
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                      // format: [
                                      //   CustomTextInputFormatter(),
                                      // ],
                                      label: "No. of Providers",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.organizationNoOfProvidersController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationNoOfProvidersController.clear();
                                      },
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Contact",
                                  style: AppFonts.medium(16, AppColors.backgroundPurple),
                                ),
                                Spacer()
                              ],
                            ),
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
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.emailValidateRequired(value);
                                      }),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [PlusTextFormatter()],
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
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.phoneValidate(value);
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Address",
                                  style: AppFonts.medium(16, AppColors.backgroundPurple),
                                ),
                                Spacer()
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                        // format: [
                                        //   CustomTextInputFormatter(),
                                        // ],
                                        maxLines: 3,
                                        label: "address1",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.organizationAddress1Controller,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.organizationAddress1Controller.clear();
                                        },
                                        suffixIcon: Icon(
                                          Icons.highlight_remove,
                                          color: AppColors.textDarkGrey,
                                          size: 25,
                                        ),
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
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
                                        // format: [
                                        //   CustomTextInputFormatter(),
                                        // ],
                                        label: "address2",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.organizationAddress2Controller,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.organizationAddress2Controller.clear();
                                        },
                                        suffixIcon: Icon(
                                          Icons.highlight_remove,
                                          color: AppColors.textDarkGrey,
                                          size: 25,
                                        ),
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
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
                                        suffixIcon: Icon(
                                          Icons.highlight_remove,
                                          color: AppColors.textDarkGrey,
                                          size: 25,
                                        ),
                                        checkValidation: (value) {
                                          return Validation.requiredFiled(value);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [
                                        CustomTextInputFormatter(),
                                      ],
                                      label: "City",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.organizationCityController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationCityController.clear();
                                      },
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      }),
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [
                                        CustomTextInputFormatter(),
                                      ],
                                      label: "State",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.organizationStateController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationStateController.clear();
                                      },
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      }),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [
                                        PostalCodeFormatter(),
                                      ],
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
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      }),
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [
                                        CustomTextInputFormatter(),
                                      ],
                                      label: "Country",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.organizationCountryController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationCountryController.clear();
                                      },
                                      suffixIcon: Icon(
                                        Icons.highlight_remove,
                                        color: AppColors.textDarkGrey,
                                        size: 25,
                                      ),
                                      checkValidation: (value) {
                                        return Validation.requiredFiled(value);
                                      }),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child:
                            //
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    )
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
                          // controller.list.clear();
                        },
                        label: "Cancel",
                        backGround: Colors.white,
                        isTrue: false,
                        textColor: AppColors.backgroundPurple,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      width: 100,
                      child: CustomButton(
                        navigate: () {
                          if (controller.formKey.currentState!.validate()) {
                            Map<String, dynamic> param = Map<String, dynamic>();

                            param["name"] = controller.organizationNameController.text;
                            param["email"] = controller.organizationEmailController.text;
                            param["state"] = controller.organizationStateController.text;
                            param["city"] = controller.organizationCityController.text;
                            param["contact_no"] = controller.organizationPhoneNumberController.text;
                            param["country"] = controller.organizationCountryController.text;
                            param["street_name"] = controller.organizationStreetNameController.text;
                            param["postal_code"] = controller.organizationPostalCodeController.text;
                            param["address1"] = controller.organizationAddress1Controller.text;
                            param["address2"] = controller.organizationAddress2Controller.text;

                            receiveParam(param);
                            // controller.addImage();
                            Navigator.pop(context);
                          }
                        },
                        label: "Update",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
