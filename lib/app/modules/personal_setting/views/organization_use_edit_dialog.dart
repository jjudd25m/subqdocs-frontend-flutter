import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';
import '../../../../utils/Formetors.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../controllers/personal_setting_controller.dart';

class OrganizationUseEditDialog extends GetView<PersonalSettingController> {
  final void Function(Map<String, dynamic>) receiveParam;

  OrganizationUseEditDialog({super.key, required this.receiveParam});

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
                          "Personal Setting",
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
                                  "Personal Information",
                                  style: AppFonts.medium(16, AppColors.backgroundPurple),
                                ),
                                Spacer()
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [
                                        CustomTextInputFormatter(),
                                      ],
                                      label: "First Name",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.userFirstNameController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "John",
                                      onTap: () {
                                        controller.userFirstNameController.clear();
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
                                      label: "Last Name",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.userLastNameController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "John",
                                      onTap: () {
                                        controller.userLastNameController.clear();
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
                                        CustomTextInputFormatter(),
                                      ],
                                      label: "Organization",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.userOrganizationNameNameController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "SubQDocs",
                                      onTap: () {
                                        controller.userOrganizationNameNameController.clear();
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
                            //
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: TextFormFiledWidget(
                            //           format: [
                            //             CustomTextInputFormatter(),
                            //           ],
                            //           label: "Organization name",
                            //           isValid: controller.isValid.value,
                            //           // isImportant: true,
                            //           controller: controller.userOrganizationNameNameController,
                            //           isSuffixIconVisible: false,
                            //           isFirst: true,
                            //           hint: "John",
                            //           onTap: () {
                            //             controller.userOrganizationNameNameController.clear();
                            //           },
                            //           suffixIcon: Icon(
                            //             Icons.highlight_remove,
                            //             color: AppColors.textDarkGrey,
                            //             size: 25,
                            //           ),
                            //           checkValidation: (value) {
                            //             return Validation.requiredFiled(value);
                            //           }),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: TextFormFiledWidget(
                            //           format: [NoSpaceLowercaseTextFormatter()],
                            //           label: "Email Address",
                            //           controller: controller.userEmailController,
                            //           isValid: controller.isValid.value,
                            //           isSuffixIconVisible: false,
                            //           isFirst: true,
                            //           readOnly: true,
                            //           hint: "",
                            //           onTap: () {
                            //             controller.userEmailController.clear();
                            //           },
                            //           suffixIcon: Icon(
                            //             Icons.highlight_remove,
                            //             color: AppColors.textDarkGrey,
                            //             size: 25,
                            //           ),
                            //           checkValidation: (value) {
                            //             return Validation.emailValidateRequired(value);
                            //           }),
                            //     ),
                            //   ],
                            // ),
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
                                      controller: controller.userEmailController,
                                      isValid: controller.isValid.value,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userEmailController.clear();
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
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                      format: [PlusTextFormatter()],
                                      label: "Phone Number",
                                      controller: controller.userPhoneNumberController,
                                      isValid: true,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      type: TextInputType.number,
                                      hint: "123456789",
                                      onTap: () {
                                        controller.userPhoneNumberController.clear();
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
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                        format: [
                                          CustomTextInputFormatter(),
                                        ],
                                        label: "Country",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.userCountryController,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.userCountryController.clear();
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
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                        format: [
                                          CustomTextInputFormatter(),
                                        ],
                                        label: "State",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.userStateController,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.userStateController.clear();
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
                                      controller: controller.userCityController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userCityController.clear();
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
                                        PostalCodeFormatter(),
                                      ],
                                      label: "Postal code",
                                      // maxLength: 5,
                                      isValid: controller.isValid.value,
                                      controller: controller.userPostalCodeController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userPostalCodeController.clear();
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
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                        // format: [
                                        //   CustomTextInputFormatter(),
                                        // ],
                                        label: "Street name",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.userStreetNameController,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.userStreetNameController.clear();
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
                            SizedBox(height: 20),
                            // Practitioner Details
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "Practitioner Details",
                                  style: AppFonts.medium(16, AppColors.backgroundPurple),
                                ),
                                Spacer()
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                        format: [
                                          CustomTextInputFormatter(),
                                        ],
                                        label: "Title",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.userPractitionerController,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.userPractitionerController.clear();
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
                                Expanded(
                                  child: Expanded(
                                    child: TextFormFiledWidget(
                                        // format: [
                                        //   CustomTextInputFormatter(),
                                        // ],
                                        label: "Medical License Number",
                                        isValid: controller.isValid.value,
                                        // isImportant: true,
                                        controller: controller.userMedicalLicenseNumberController,
                                        isSuffixIconVisible: false,
                                        isFirst: true,
                                        hint: "",
                                        onTap: () {
                                          controller.userMedicalLicenseNumberController.clear();
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
                                    //format: [NoSpaceTextFormatter()],
                                    suffixIcon: Icon(Icons.calendar_month),
                                    label: "License Expiry Date",
                                    readOnly: true,
                                    // isImportant: true,
                                    controller: controller.userLicenseExpiryDateController,
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,

                                        // initialDate:  DateFormat('MM/dd/yy').parse(controller.visitDateController.text),
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(Duration(days: 1000)),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              cardColor: AppColors.white,
                                              primaryColor: AppColors.backgroundPurple,
                                              hintColor: AppColors.backgroundPurple,
                                              colorScheme: ColorScheme.light(primary: AppColors.backgroundPurple),
                                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                            ),
                                            child: child!,
                                          );
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
                                // Expanded(
                                //   child: TextFormFiledWidget(
                                //       format: [
                                //         CustomTextInputFormatter(),
                                //       ],
                                //       label: "License Expiry Date",
                                //       isValid: controller.isValid.value,
                                //       // isImportant: true,
                                //       controller: controller.userLicenseExpiryDateController,
                                //       isSuffixIconVisible: false,
                                //       isFirst: true,
                                //       hint: "",
                                //       onTap: () {
                                //         controller.userLicenseExpiryDateController.clear();
                                //       },
                                //       suffixIcon: Icon(
                                //         Icons.highlight_remove,
                                //         color: AppColors.textDarkGrey,
                                //         size: 25,
                                //       ),
                                //       checkValidation: (value) {
                                //         return Validation.requiredFiled(value);
                                //       }),
                                // ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                      // format: [
                                      //   PostalCodeFormatter(),
                                      // ],
                                      label: "National Provider Identifier",
                                      // maxLength: 5,
                                      isValid: controller.isValid.value,
                                      controller: controller.userNationalProviderIdentifierController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userNationalProviderIdentifierController.clear();
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
                                      // format: [
                                      //   CustomTextInputFormatter(),
                                      // ],
                                      label: "Taxonomy Code",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.userTaxonomyCodeController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userTaxonomyCodeController.clear();
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
                                      label: "Specialization",
                                      isValid: controller.isValid.value,
                                      // isImportant: true,
                                      controller: controller.userSpecializationController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.userSpecializationController.clear();
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
                            Map<String, dynamic> param = {
                              'first_name': controller.userFirstNameController.text,
                              'last_name': controller.userLastNameController.text,
                              'email': controller.userEmailController.text,
                              'contact_no': controller.userPhoneNumberController.text,
                              'country': controller.userCountryController.text,
                              'state': controller.userStateController.text,
                              'city': controller.userCityController.text,
                              'street_name': controller.userStreetNameController.text,
                              'postal_code': controller.userPostalCodeController.text,
                              'title': controller.userPractitionerController.text,
                              'medical_license_number': controller.userMedicalLicenseNumberController.text,
                              'license_expiry_date': controller.userLicenseExpiryDateController.text,
                              'national_provider_identifier': controller.userNationalProviderIdentifierController.text,
                              'taxonomy_code': controller.userTaxonomyCodeController.text,
                              'specialization': controller.userSpecializationController.text
                            };

                            receiveParam(param);
                            // controller.addImage();
                            Navigator.pop(context);
                          }
                        },
                        label: "Submit",
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
