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
                                    format: [
                                      MaskTextInputFormatter(mask: "+1 (###) ###-####"),
                                    ],
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
                                    // checkValidation: (value) {
                                    //   return Validation.phoneValidate(value, isRequired: true);
                                    // }
                                  ),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Country",
                                            style: AppFonts.regular(14, AppColors.textBlack),
                                          ),
                                          Text(
                                            "*",
                                            style: AppFonts.regular(14, AppColors.redText),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
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
                                      })
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Expanded(
                                //     child: TextFormFiledWidget(
                                //         format: [
                                //           CustomTextInputFormatter(),
                                //         ],
                                //         label: "Country",
                                //         isValid: controller.isValid.value,
                                //         // isImportant: true,
                                //         controller: controller.userCountryController,
                                //         isSuffixIconVisible: false,
                                //         isFirst: true,
                                //         hint: "",
                                //         onTap: () {
                                //           controller.userCountryController.clear();
                                //         },
                                //         suffixIcon: Icon(
                                //           Icons.highlight_remove,
                                //           color: AppColors.textDarkGrey,
                                //           size: 25,
                                //         ),
                                //         checkValidation: (value) {
                                //           return Validation.requiredFiled(value);
                                //         }),
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Expanded(
                                //     child: TextFormFiledWidget(
                                //         format: [
                                //           CustomTextInputFormatter(),
                                //         ],
                                //         label: "State",
                                //         isValid: controller.isValid.value,
                                //         // isImportant: true,
                                //         controller: controller.userStateController,
                                //         isSuffixIconVisible: false,
                                //         isFirst: true,
                                //         hint: "",
                                //         onTap: () {
                                //           controller.userStateController.clear();
                                //         },
                                //         suffixIcon: Icon(
                                //           Icons.highlight_remove,
                                //           color: AppColors.textDarkGrey,
                                //           size: 25,
                                //         ),
                                //         checkValidation: (value) {
                                //           return Validation.requiredFiled(value);
                                //         }),
                                //   ),
                                // ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "State",
                                            style: AppFonts.regular(14, AppColors.textBlack),
                                          ),
                                          Text(
                                            "*",
                                            style: AppFonts.regular(14, AppColors.redText),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.userStateOption,
                                          selectedValue: controller.userSelectedStateValue.value,
                                          onChanged: (value) {
                                            controller.userSelectedStateValue.value = value;

                                            print("state is:- ${value}");

                                            List<String> cityList = controller.statesCities.firstWhere((element) => element.state == value).cities;

                                            print("city is :- ${cityList}");

                                            if (cityList.isNotEmpty) {
                                              print("city list if");
                                              controller.userCityOption.value = cityList;
                                              controller.userSelectedCityValue.value = controller.userCityOption.first;
                                            } else {
                                              print("city list else");
                                              controller.userSelectedCityValue.value = "";
                                              controller.userCityOption.value = [];
                                            }
                                          },
                                          // selectText: "United States",
                                        );
                                      })
                                    ],
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
                                      Row(
                                        children: [
                                          Text(
                                            "City",
                                            style: AppFonts.regular(14, AppColors.textBlack),
                                          ),
                                          Text(
                                            "*",
                                            style: AppFonts.regular(14, AppColors.redText),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return BaseDropdown<String>(
                                          valueAsString: (value) => value ?? "",
                                          items: controller.userCityOption,
                                          selectedValue: controller.userSelectedCityValue.value,
                                          onChanged: (value) {
                                            controller.userSelectedCityValue.value = value;
                                          },
                                          // selectText: "United States",
                                        );
                                      })
                                    ],
                                  ),
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
                                    // checkValidation: (value) {
                                    //   return Validation.requiredFiled(value);
                                    // }
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
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
                                    // checkValidation: (value) {
                                    //   return Validation.requiredFiled(value);
                                    // }
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
                                    // checkValidation: (value) {
                                    //   return Validation.requiredFiled(value);
                                    // }
                                  ),
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [
                                      MedicalLicenseNumberFormatter(),
                                    ],
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
                                    // checkValidation: (value) {
                                    //   return Validation.medicalRequiredFiled(value);
                                    //   // return Validation.requiredFiled(value);
                                    // }
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
                                    format: [
                                      NpiFormatter(),
                                    ],
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
                                    // checkValidation: (value) {
                                    //   return Validation.requiredFiled(value);
                                    // }
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
                                      TaxonomyCodeFormatter(),
                                    ],
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
                                    /* checkValidation: (value) {
                                        return Validation.medicalRequiredFiled(value);
                                        // return Validation.requiredFiled(value);
                                      }*/
                                  ),
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
                                    // checkValidation: (value) {
                                    //   return Validation.requiredFiled(value);
                                    // }
                                  ),
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
                            // if (controller.userSelectedCityValue.value?.isNotEmpty ?? true) {
                            Map<String, dynamic> param = {};

                            param['first_name'] = controller.userFirstNameController.text;
                            param['last_name'] = controller.userLastNameController.text;
                            param['organization_name'] = controller.userOrganizationNameNameController.text;
                            param['email'] = controller.userEmailController.text;

                            if (controller.extractDigits(controller.userPhoneNumberController.text).isNotEmpty) {
                              param['contact_no'] = controller.extractDigits(controller.userPhoneNumberController.text);
                            }

                            if (controller.selectedCountryValue.value?.isNotEmpty ?? false) {
                              param['country'] = controller.selectedCountryValue.value;
                            }

                            if (controller.userSelectedStateValue.value?.isNotEmpty ?? false) {
                              param['state'] = controller.userSelectedStateValue.value;
                            }

                            if (controller.userSelectedCityValue.value?.isNotEmpty ?? false) {
                              param['city'] = controller.userSelectedCityValue.value;
                            }

                            if (controller.userStreetNameController.text.isNotEmpty) {
                              param['street_name'] = controller.userStreetNameController.text;
                            }

                            if (controller.userPostalCodeController.text.isNotEmpty) {
                              param['postal_code'] = controller.userPostalCodeController.text;
                            }

                            if (controller.userPractitionerController.text.isNotEmpty) {
                              param['title'] = controller.userPractitionerController.text;
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

                            // Map<String, dynamic> sparam = {
                            //   'first_name': controller.userFirstNameController.text,
                            //   'last_name': controller.userLastNameController.text,
                            //   'organization_name': controller.userOrganizationNameNameController.text,
                            //   'email': controller.userEmailController.text,
                            //   'contact_no': controller.extractDigits(controller.userPhoneNumberController.text),
                            //   'country': controller.selectedCountryValue.value,
                            //   'state': controller.userSelectedStateValue.value,
                            //   'city': controller.userSelectedCityValue.value,
                            //   'street_name': controller.userStreetNameController.text,
                            //   'postal_code': controller.userPostalCodeController.text,
                            //   'title': controller.userPractitionerController.text,
                            //   'medical_license_number': controller.userMedicalLicenseNumberController.text,
                            //   'license_expiry_date': controller.userLicenseExpiryDateController.text,
                            //   'national_provider_identifier': controller.userNationalProviderIdentifierController.text,
                            //   'taxonomy_code': controller.userTaxonomyCodeController.text,
                            //   'specialization': controller.userSpecializationController.text
                            // };

                            print("user edit param is :- ${param}");

                            receiveParam(param);
                            // controller.addImage();
                            Navigator.pop(context);
                            // } else {
                            //   CustomToastification().showToast("Please select city", type: ToastificationType.error);
                            // }
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
