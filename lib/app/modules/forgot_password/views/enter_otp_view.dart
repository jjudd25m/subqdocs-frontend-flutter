import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';

import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/logger.dart';

class EnterOtpView extends GetView<ForgotPasswordController> {
  const EnterOtpView({super.key});

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
        Text("Verify your Email", style: AppFonts.medium(18, AppColors.textBlack)),
        const SizedBox(height: 16),
        SizedBox(width: 330, child: Text(textAlign: TextAlign.center, "Please enter a verification code that has been sent to your email at ${controller.emailController.text}", style: AppFonts.regular(14, AppColors.textDarkGrey))),
        const SizedBox(height: 24),
        Center(
          child: OtpTextField(
            styles: const [],

            numberOfFields: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            fieldHeight: 40,
            fieldWidth: 40,
            fillColor: AppColors.blackLight,
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            margin: const EdgeInsets.only(right: 10),
            borderColor: AppColors.appbarBorder,
            borderWidth: 1,
            enabledBorderColor: AppColors.appbarBorder,
            focusedBorderColor: AppColors.appbarBorder,
            enabled: true,
            borderRadius: BorderRadius.circular(6),
            decoration: const InputDecoration(fillColor: AppColors.appbarBorder),
            textStyle: AppFonts.medium(16, AppColors.textBlack),
            filled: true,

            //set to true to show as box or false to show as dash
            showFieldAsBox: true,

            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
              customPrint(" code is $code");
              controller.otpCode = "";
            },

            //runs when every textfield is filled
            onSubmit: (String verificationCode) {
              customPrint(" verificationCode $verificationCode");
              controller.otpCode = verificationCode;
            },

            // end onSubmit
          ),
        ),
        const SizedBox(height: 40),
        Obx(() {
          return SizedBox(
            width: isSmallScreen ? Get.width - 30 : 416,
            child: CustomAnimatedButton(
              onPressed: () {
                if (controller.otpCode.length == 6) {
                  controller.verifyOtp();
                } else {
                  CustomToastification().showToast("Verification code must be 6 digits");
                }
              },
              height: 45,
              text: "Verify code",
              isLoading: controller.isLoading.value,
              enabledTextColor: AppColors.white,
              enabledColor: AppColors.backgroundPurple,
            ),
          );
        }),
        const SizedBox(height: 30),
        SizedBox(
          width: isSmallScreen ? Get.width - 30 : 416,
          child: Obx(() {
            int minutes = controller.timeRemaining.value ~/ 60;
            int seconds = controller.timeRemaining.value % 60;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.resendOtp();
                  },
                  child: Text('Time Remaining: $minutes:${seconds.toString().padLeft(2, '0')}', style: AppFonts.medium(12, AppColors.textDarkGrey)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (controller.isTimerActive.value == false) {
                      controller.resendOtp();
                    }
                  },
                  child: Text("Resend verification code", style: AppFonts.medium(12, controller.isTimerActive.value ? AppColors.textGrey : AppColors.backgroundPurple)),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Text("Back to Login", style: AppFonts.medium(12, AppColors.backgroundPurple)),
        ),
      ],
    );
  }
}
