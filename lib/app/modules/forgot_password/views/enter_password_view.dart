import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../../utils/Formetors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';

class EnterPasswordView extends GetView<ForgotPasswordController> {
  const EnterPasswordView({super.key});

  bool isWidthLessThan428(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < 428;
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = isWidthLessThan428(context);
    return Column(
      children: [
        const SizedBox(height: 24),
        Text("Forgot Password", style: AppFonts.medium(18, AppColors.textBlack)),
        const SizedBox(height: 16),
        SizedBox(width: isSmallScreen ? 300 : 400, child: Text("Enter a new password below to reset your account. Your password must be 8-20 characters with at least 1 number, 1 letter and 1 special symbol.", style: AppFonts.regular(14, AppColors.textDarkGrey), textAlign: TextAlign.center)),
        const SizedBox(height: 24),
        Obx(() {
          return SizedBox(
            width: isSmallScreen ? Get.width - 30 : 416,
            child: TextFormFiledWidget(
              label: "New Password",
              format: [NoSpaceTextFormatter()],
              controller: controller.passwordController,
              hint: AppString.passwordHint,
              visibility: controller.passwordVisible.value,
              suffixIcon:
                  controller.passwordVisible.value
                      ? GestureDetector(
                        onTap: () {
                          controller.changePasswordVisible();
                        },
                        child: Padding(padding: const EdgeInsets.all(4), child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 7, width: 7)),
                      )
                      : GestureDetector(
                        onTap: () {
                          controller.changePasswordVisible();
                        },
                        child: const Icon(CupertinoIcons.eye_slash_fill),
                      ),
              checkValidation: (value) {
                return Validation.conforimpasswordValidate(value, controller.confirmPasswordController.text);
              },
            ),
          );
        }),
        const SizedBox(height: 20),
        Obx(() {
          return SizedBox(
            width: isSmallScreen ? Get.width - 30 : 416,
            child: TextFormFiledWidget(
              label: "Confirm Password",
              format: [NoSpaceTextFormatter()],
              controller: controller.confirmPasswordController,
              hint: AppString.passwordHint,
              visibility: controller.confirmPasswordVisible.value,
              suffixIcon:
                  controller.confirmPasswordVisible.value
                      ? GestureDetector(
                        onTap: () {
                          controller.changeConfirmPasswordVisible();
                        },
                        child: Padding(padding: const EdgeInsets.all(4), child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 7, width: 7)),
                      )
                      : GestureDetector(
                        onTap: () {
                          controller.changeConfirmPasswordVisible();
                        },
                        child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey),
                      ),
              checkValidation: (value) {
                return Validation.conforimpasswordValidate(value, controller.passwordController.text);
              },
            ),
          );
        }),
        const SizedBox(height: 30),
        Obx(() {
          return SizedBox(
            width: isSmallScreen ? Get.width - 30 : 416,
            child: CustomAnimatedButton(
              onPressed: () {
                // controller.authLoginUser();

                if (controller.formKey.currentState!.validate()) {
                  controller.resetPassword();
                }
              },
              height: 45,
              text: "Save",
              isLoading: controller.isLoading.value,
              enabledTextColor: AppColors.white,
              enabledColor: AppColors.backgroundPurple,
            ),
          );
        }),
      ],
    );
  }
}
