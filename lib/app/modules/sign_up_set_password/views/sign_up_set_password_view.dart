import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utils/Formetors.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sign_up_set_password_controller.dart';

class SignUpSetPasswordView extends GetView<SignUpSetPasswordController> {
  SignUpSetPasswordView({super.key});

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
      body: GestureDetector(
        onTap: removeFocus,
        child: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: isSmallScreen ? 130 : 300,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: isPortrait ? 0 : -80,
                      child: Image.asset(
                        ImagePath.loginHeader,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isPortrait ? null : 30,
                  ),
                  Text(
                    "Lets Get Started",
                    style: AppFonts.medium(24, AppColors.backgroundPurple),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Sign Up",
                    style: AppFonts.medium(20, AppColors.textBlack),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Obx(() {
                    return SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: TextFormFiledWidget(
                          label: AppString.password,
                          maxLines: 1,
                          format: [NoSpaceTextFormatter()],
                          hint: "Enter Password",
                          visibility: controller.passwordVisible.value,
                          controller: controller.passwordController,
                          suffixIcon: controller.passwordVisible.value
                              ? GestureDetector(
                                  onTap: () {
                                    controller.changePasswordVisible();
                                  },
                                  child: SvgPicture.asset(
                                    ImagePath.eyeLogoOpen,
                                    height: 5,
                                    width: 5,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    controller.changePasswordVisible();
                                  },
                                  child: Icon(
                                    CupertinoIcons.eye_slash_fill,
                                    color: AppColors.textDarkGrey,
                                  ),
                                ),
                          onChanged: (p0) {
                            controller.validatePassword(p0 ?? "");
                          },
                          checkValidation: (value) {
                            return Validation.conforimpasswordValidate(value, controller.confirmPasswordController.text);
                          }),
                    );
                  }),
                  SizedBox(height: 15),
                  Obx(() {
                    return SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: Column(children: [
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    controller.passwordValidation['length']!
                                        ? ImagePath.passwordValidationTrue // Green check for valid
                                        : ImagePath.passwordValidationFalse,
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "8-20 Characters",
                                    style: AppFonts.regular(14, controller.passwordValidation['length']! ? AppColors.backgroundPurple : AppColors.textDarkGrey),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    controller.passwordValidation['number']!
                                        ? ImagePath.passwordValidationTrue // Green check for valid
                                        : ImagePath.passwordValidationFalse,
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "1 Number",
                                    style: AppFonts.regular(14, controller.passwordValidation['number']! ? AppColors.backgroundPurple : AppColors.textDarkGrey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                    );
                  }),
                  SizedBox(height: 15),
                  Obx(() {
                    return SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: Column(children: [
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    controller.passwordValidation['letter']!
                                        ? ImagePath.passwordValidationTrue // Green check for valid
                                        : ImagePath.passwordValidationFalse,
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "1 Letter",
                                    style: AppFonts.regular(14, controller.passwordValidation['letter']! ? AppColors.backgroundPurple : AppColors.textDarkGrey),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: 30,
                            // ),
                            Expanded(
                                child: Row(
                              children: [
                                SvgPicture.asset(
                                  controller.passwordValidation['special']!
                                      ? ImagePath.passwordValidationTrue // Green check for valid
                                      : ImagePath.passwordValidationFalse,
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "1 Special Character",
                                  style: AppFonts.regular(14, controller.passwordValidation['special']! ? AppColors.backgroundPurple : AppColors.textDarkGrey),
                                ),
                              ],
                            ))
                          ],
                        )
                      ]),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: TextFormFiledWidget(
                          label: "Confirm Password",
                          format: [NoSpaceTextFormatter()],
                          hint: "Enter confirm Password",
                          maxLines: 1,
                          visibility: controller.confirmPasswordVisible.value,
                          controller: controller.confirmPasswordController,
                          suffixIcon: controller.confirmPasswordVisible.value
                              ? GestureDetector(
                                  onTap: () {
                                    controller.changeConfirmPasswordVisible();
                                  },
                                  child: SvgPicture.asset(
                                    ImagePath.eyeLogoOpen,
                                    height: 5,
                                    width: 5,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    controller.changeConfirmPasswordVisible();
                                  },
                                  child: Icon(
                                    CupertinoIcons.eye_slash_fill,
                                    color: AppColors.textDarkGrey,
                                  ),
                                ),
                          checkValidation: (value) {
                            return Validation.conforimpasswordValidate(value, controller.passwordController.text);
                          }),
                    );
                  }),
                  SizedBox(
                    height: 42,
                  ),
                  Obx(() {
                    return SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 416,
                      child: CustomAnimatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.registerUser();
                          }
                        },
                        height: 45,
                        text: "Continue",
                        enabledTextColor: AppColors.white,
                        enabledColor: AppColors.backgroundPurple,
                        isLoading: controller.isLoading.value,
                      ),
                    );
                  }),
                  SizedBox(
                    height: 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
