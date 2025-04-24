import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/app/modules/sign_up/models/sign_up_models.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/Formetors.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
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
      body: GestureDetector(
        onTap: removeFocus,
        child: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: isSmallScreen ? 130 : 300, child: Stack(children: [Positioned(left: 0, right: 0, top: isPortrait ? 0 : -80, child: Image.asset(ImagePath.loginHeader))])),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isPortrait ? null : 30),
                  Text("Lets Get Started", style: AppFonts.medium(24, AppColors.backgroundPurple)),
                  SizedBox(height: 24),
                  Text("Sign Up", style: AppFonts.medium(20, AppColors.textBlack)),
                  SizedBox(height: 24),

                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 460,
                    child: Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: TextFormFiledWidget(
                            isSuffixIconVisible: false,
                            isFirst: true,
                            format: [CustomTextInputFormatter()],
                            label: "First Name",
                            controller: controller.firstNameController,
                            hint: "Enter First Name",
                            onTap: () {
                              controller.firstNameController.clear();
                            },
                            suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                            checkValidation: (value) {
                              return Validation.requiredFiled(value);
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormFiledWidget(
                            isSuffixIconVisible: false,
                            isFirst: true,
                            label: "Last Name",
                            format: [CustomTextInputFormatter()],
                            controller: controller.lastNameController,
                            hint: "Enter Last Name",
                            onTap: () {
                              controller.lastNameController.clear();
                            },
                            suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                            checkValidation: (value) {
                              return Validation.requiredFiled(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 460,
                    child: TextFormFiledWidget(
                      isSuffixIconVisible: false,
                      isFirst: true,
                      label: AppString.emailAddress,
                      format: [NoSpaceLowercaseTextFormatter()],
                      controller: controller.emailController,
                      hint: "Enter Email",
                      onTap: () {
                        controller.emailController.clear();
                      },
                      suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                      checkValidation: (value) {
                        return Validation.emailValidateRequired(value);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 460,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Checkbox(
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: AppColors.backgroundPurple,
                            value: controller.isTermsCondition.value,
                            onChanged: (value) => {controller.isTermsCondition.value = value!},
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("I agree to the ", style: AppFonts.medium(14, AppColors.textDarkGrey)),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SIGN_UP);
                              },
                              child: Text("Terms & Conditions", style: AppFonts.medium(14, AppColors.backgroundPurple).copyWith(decoration: TextDecoration.underline)),
                            ),
                            Text(" and ", style: AppFonts.medium(14, AppColors.textDarkGrey)),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SIGN_UP);
                              },
                              child: Text("Privacy Policy", style: AppFonts.medium(14, AppColors.backgroundPurple).copyWith(decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  SizedBox(height: 42),
                  Obx(() {
                    return SizedBox(
                      width: isSmallScreen ? Get.width - 30 : 460,
                      child: CustomAnimatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!controller.isTermsCondition.value) {
                              CustomToastification().showToast("Please accept terms and conditions", type: ToastificationType.error);
                            } else {
                              CheckNewUserModel checkNewUserModel = await controller.checkIsNewUser(email: controller.emailController.text);

                              if (checkNewUserModel.responseData ?? false) {
                                Get.toNamed(
                                  Routes.SIGN_UP_SET_PASSWORD,
                                  arguments: {'first_name': controller.firstNameController.text, 'last_name': controller.lastNameController.text, 'email': controller.emailController.text},
                                );
                              } else {
                                CustomToastification().showToast(checkNewUserModel.message ?? "", type: ToastificationType.error);
                              }
                            }
                          }
                        },
                        height: 45,
                        text: "Continue",
                        isLoading: controller.isLoading.value,
                        enabledTextColor: AppColors.white,
                        enabledColor: AppColors.backgroundPurple,
                      ),
                    );
                  }),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: AppFonts.medium(14, AppColors.textDarkGrey)),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text("Sign in", style: AppFonts.medium(14, AppColors.backgroundPurple).copyWith(decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
