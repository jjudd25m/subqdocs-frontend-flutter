import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../../utils/app_string.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';

class EnterMailView extends GetView<ForgotPasswordController> {
  const EnterMailView({super.key});

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
        Container(width: isSmallScreen ? 350 : 450, child: Text("Please enter your registered email address below, and you will receive an email with a OTP for verification of email.", style: AppFonts.regular(14, AppColors.textDarkGrey), textAlign: TextAlign.center)),
        const SizedBox(height: 24),
        Container(
          color: AppColors.white,
          width: isSmallScreen ? Get.width - 30 : 416,
          child: TextFormFiledWidget(
            isSuffixIconVisible: false,
            isFirst: true,
            label: AppString.emailAddress,
            format: [NoSpaceLowercaseTextFormatter()],
            controller: controller.emailController,
            hint: AppString.emailPlaceHolder,
            onTap: () {
              controller.emailController.clear();
            },
            suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
            checkValidation: (value) {
              return Validation.emailValidate(value);
            },
          ),
        ),
        const SizedBox(height: 30),
        Obx(() {
          return Container(
            width: isSmallScreen ? Get.width - 30 : 416,
            child: CustomAnimatedButton(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.sendOtp();
                }
              },
              height: 45,
              text: "Send Verification Code",
              isLoading: controller.isLoading.value,
              enabledTextColor: AppColors.white,
              enabledColor: AppColors.backgroundPurple,
            ),
          );
        }),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Text("Back to Login", style: AppFonts.medium(14, AppColors.backgroundPurple)),
        ),
      ],
    );
  }
}
