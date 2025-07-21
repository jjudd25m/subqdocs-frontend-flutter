import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../../../core/common/logger.dart';
import '../controllers/sign_up_set_organization_info_controller.dart';

class SignUpSetOrganizationInfoView extends GetView<SignUpSetOrganizationInfoController> {
  SignUpSetOrganizationInfoView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isWidthLessThan428(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < 428;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    bool isSmallScreen = isWidthLessThan428(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return GestureDetector(
          onTap: removeFocus,
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: isSmallScreen ? 130 : 300, child: Stack(children: [Positioned(left: 0, right: 0, top: isPortrait ? 0 : -80, child: Image.asset(ImagePath.loginHeader))])),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isPortrait ? null : 30),
                    Text("Lets Get Started", style: AppFonts.medium(24, AppColors.backgroundPurple)),
                    const SizedBox(height: 24),
                    Text("Set up your subQdocs profile", style: AppFonts.medium(20, AppColors.textBlack)),
                    const SizedBox(height: 20),
                    Text("Provide details about your organization and we’ll customize your subQdocs just for you!", style: AppFonts.regular(14, AppColors.textDarkGrey)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: TextFormFiledWidget(
                        isSuffixIconVisible: false,
                        isFirst: true,
                        label: "Organization name",
                        // format: [NoSpaceLowercaseTextFormatter()],
                        controller: controller.organizationNameController,
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: TextFormFiledWidget(
                        isSuffixIconVisible: false,
                        isFirst: true,
                        type: TextInputType.number,
                        format: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                        label: "How many providers are in your practice?",
                        // format: [NoSpaceLowercaseTextFormatter()],
                        controller: controller.noOfProviderController,
                        hint: "Type here",
                        onTap: () {
                          controller.noOfProviderController.clear();
                        },
                        suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                        checkValidation: (value) {
                          return Validation.requiredFiled(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [Text("What is your role within the organization?", style: AppFonts.regular(14, AppColors.textBlack))]),
                          const SizedBox(height: 8),
                          Obx(() {
                            return BaseDropdown<String>(
                              valueAsString: (value) => value ?? "",
                              items: controller.userRolesModel.value?.responseData ?? [],
                              selectedValue: controller.selectedRoleValue.value,
                              onChanged: (value) {
                                controller.selectedRoleValue.value = value;
                              },
                              selectText: controller.selectedRoleValue.value,
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (controller.selectedRoleValue.value?.toLowerCase() == "doctor") ...[
                      SizedBox(
                        width: isSmallScreen ? Get.width - 30 : 416,
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return TextFormFiledWidget(
                                  label: "Sign and Finalize PIN",
                                  isValid: true,
                                  fillColor: AppColors.clear,
                                  format: (controller.selectedRoleValue.value?.toLowerCase() == "doctor") ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)] : [],
                                  type: TextInputType.number,
                                  visibility: controller.userPinVisibility.value,
                                  controller: controller.userPINController,
                                  suffixIcon:
                                      !controller.userPinVisibility.value
                                          ? GestureDetector(
                                            onTap: () {
                                              controller.changeUserPinVisibility();
                                            },
                                            child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5),
                                          )
                                          : GestureDetector(
                                            onTap: () {
                                              controller.changeUserPinVisibility();
                                            },
                                            child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey),
                                          ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: CustomAnimatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (controller.selectedRoleValue.value?.toLowerCase() == "doctor") {
                              if (Validation.validateFourDigitNumber(controller.userPINController.text) != null) {
                                CustomToastification().showToast("Please enter sign and finalize PIN", type: ToastificationType.error);
                              } else {
                                print("success");
                                controller.organizationUpdate();
                              }
                            } else {
                              print("success");
                              controller.organizationUpdate();
                            }

                            customPrint("org name:- ${controller.organizationNameController.text}");
                            customPrint("provider:- ${controller.noOfProviderController.text}");
                            customPrint("org type:- ${controller.selectedRoleValue.value}");
                            customPrint("org pin:- ${controller.userPINController.text}");
                            // controller.organizationUpdate();
                          } else {
                            print("somethjiong wrne deong ");
                          }
                        },
                        height: 45,
                        text: "Continue",
                        enabledTextColor: AppColors.white,
                        enabledColor: AppColors.backgroundPurple,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
