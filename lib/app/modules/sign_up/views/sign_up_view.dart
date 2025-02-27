import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utils/Formetors.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  SignUpView({super.key});
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
      body: Form(
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
                  "Sign Up",
                  style: AppFonts.medium(24, AppColors.backgroundPurple),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Welcome",
                  style: AppFonts.medium(20, AppColors.textBlack),
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: isSmallScreen ? Get.width - 30 : 416,
                  child: TextFormFiledWidget(
                      label: "First Name",
                      controller: controller.firstNameController,
                      hint: "Enter First Name",
                      checkValidation: (value) {
                        return Validation.requiredFiled(value);
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: isSmallScreen ? Get.width - 30 : 416,
                  child: TextFormFiledWidget(
                      label: "Last Name",
                      controller: controller.lastNameController,
                      hint: "Enter Last Name",
                      checkValidation: (value) {
                        return Validation.requiredFiled(value);
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: isSmallScreen ? Get.width - 30 : 416,
                  child: TextFormFiledWidget(
                      label: AppString.emailAddress,
                      format: [NoSpaceLowercaseTextFormatter()],
                      controller: controller.emailController,
                      hint: "Enter Email",
                      checkValidation: (value) {
                        return Validation.emailValidateRequired(value);
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: TextFormFiledWidget(
                        label: AppString.password,
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
                        checkValidation: (value) {
                          return Validation.conforimpasswordValidate(value, controller.confirmPasswordController.text);
                        }),
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
                      text: "Sign up",
                      isLoading: controller.isLoading.value,
                      enabledTextColor: AppColors.white,
                      enabledColor: AppColors.backgroundPurple,
                    ),
                  );
                }),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "Back to Login",
                    style: AppFonts.medium(14, AppColors.backgroundPurple),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
