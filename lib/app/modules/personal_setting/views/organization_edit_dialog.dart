import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_webapi/places.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/logger.dart';
import '../controllers/personal_setting_controller.dart';
import 'google_place_picker/autocomplete_view.dart';

class OrganizationEditDialog extends GetView<PersonalSettingController> {
  final void Function(Map<String, dynamic>) receiveParam;

  const OrganizationEditDialog({super.key, required this.receiveParam});

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
                decoration: const BoxDecoration(color: AppColors.backgroundPurple, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text("Organization Management", style: AppFonts.medium(14, Colors.white))),
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
              Expanded(
                child: ListView(
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
                            Row(children: [Text(textAlign: TextAlign.center, "Organization Management", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]),
                            const SizedBox(height: 10),
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
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.requiredFiled(value);
                                    },
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
                                    controller: controller.organizationEmailController,
                                    isValid: controller.isValid.value,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationEmailController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
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
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    checkValidation: (value) {
                                      return Validation.phoneValidate(value, isRequired: true);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(children: [Text(textAlign: TextAlign.center, "Address", style: AppFonts.medium(16, AppColors.backgroundPurple)), const Spacer()]),
                            const SizedBox(height: 5),

                            Row(children: [Text("Search Address", style: AppFonts.regular(14, AppColors.textBlack)), const Spacer()]),
                            Row(
                              children: [
                                Expanded(
                                  child: PlacesAutocomplete(
                                    top: true,
                                    region: "us",
                                    hideOnUnfocus: false,
                                    components: [Component('country', 'us')],
                                    emptyBuilder: (p0) {
                                      return Material(color: Colors.white, child: Container(width: double.maxFinite, height: 40, alignment: Alignment.center, child: Text("No data found", style: AppFonts.regular(16, AppColors.textDarkGrey))));
                                    },
                                    controller: controller.organizationGooglePickerController,
                                    topCardColor: AppColors.white,
                                    topCardShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                    apiKey: WebUri(dotenv.get("GOOGLE_MAP_API_PROD", fallback: "")).toString(),
                                    mounted: true,
                                    hideBackButton: true,
                                    debounceDuration: const Duration(milliseconds: 500),
                                    onGetDetailsByPlaceId: (PlacesDetailsResponse? result) {
                                      if (result != null) {
                                        customPrint("result is :- ${result.result.formattedAddress ?? ""}");

                                        String postalCode = '';
                                        String city = '';
                                        String state = '';
                                        String route = '';

                                        for (AddressComponent adr in result.result.addressComponents.toList()) {
                                          customPrint(" sort :- ${adr.shortName}");
                                          customPrint(" long :- ${adr.longName}");
                                          customPrint("Types:- ${adr.types}");

                                          if (adr.types.contains("administrative_area_level_1")) {
                                            state = adr.longName;
                                          }

                                          if (adr.types.contains("locality")) {
                                            city = adr.longName;
                                          }

                                          if (adr.types.contains("postal_code")) {
                                            postalCode = adr.longName;
                                          }

                                          if (adr.types.contains("route")) {
                                            route = adr.longName;
                                          }
                                        }

                                        // Set the values after the loop
                                        controller.organizationPostalCodeController.text = postalCode;
                                        controller.organizationCityController.text = city;
                                        controller.organizationStateController.text = state;
                                        controller.organizationStreetNameController.text = route;
                                        controller.organizationAddress1Controller.text = result.result.formattedAddress ?? "";
                                      }
                                    },
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
                                      label: "Address",
                                      controller: controller.organizationAddress1Controller,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationAddress1Controller.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
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
                                      label: "Street Name",
                                      controller: controller.organizationStreetNameController,
                                      isSuffixIconVisible: false,
                                      isFirst: true,
                                      hint: "",
                                      onTap: () {
                                        controller.organizationStreetNameController.clear();
                                      },
                                      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "City",
                                    controller: controller.organizationCityController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationCityController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormFiledWidget(
                                    label: "State",
                                    controller: controller.organizationStateController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationStateController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormFiledWidget(
                                    format: [PostalCodeFormatter()],
                                    label: "Postal code",
                                    controller: controller.organizationPostalCodeController,
                                    isSuffixIconVisible: false,
                                    isFirst: true,
                                    hint: "",
                                    onTap: () {
                                      controller.organizationPostalCodeController.clear();
                                    },
                                    suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [Text("Country", style: AppFonts.regular(14, AppColors.textBlack))]),
                                      const SizedBox(height: 8),
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
                            const SizedBox(height: 20),
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
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 100,
                      child: CustomButton(
                        navigate: () {
                          if (controller.formKey.currentState!.validate()) {
                            Map<String, dynamic> param = <String, dynamic>{};

                            param["name"] = controller.organizationNameController.text;

                            if (controller.organizationEmailController.text.isNotEmpty) {
                              param["email"] = controller.organizationEmailController.text;
                            }

                            if (controller.organizationSelectedStateValue.value?.isNotEmpty ?? false) {
                              param["state"] = controller.organizationSelectedStateValue.value;
                            }

                            if (controller.organizationCityController.text.isNotEmpty) {
                              param["city"] = controller.organizationCityController.text;
                            }

                            if (controller.organizationPhoneNumberController.text.isNotEmpty) {
                              param["contact_no"] = controller.extractDigits(controller.organizationPhoneNumberController.text);
                            }

                            if (controller.selectedCountryValue.value?.isNotEmpty ?? false) {
                              param["country"] = controller.selectedCountryValue.value;
                            }

                            if (controller.organizationStreetNameController.text.isNotEmpty) {
                              param["street_name"] = controller.organizationStreetNameController.text;
                            }

                            if (controller.organizationPostalCodeController.text.isNotEmpty) {
                              param["postal_code"] = controller.organizationPostalCodeController.text;
                            }

                            if (controller.organizationAddress1Controller.text.isNotEmpty) {
                              param["address1"] = controller.organizationAddress1Controller.text;
                            }

                            receiveParam(param);
                            Navigator.pop(context);
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
