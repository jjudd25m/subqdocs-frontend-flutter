import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CustomToastification {
  //App related

  void showToast(String message, {ToastificationType type = ToastificationType.success, int toastDuration = 3}) {
    toastification.show(context: Get.context, type: type, title: Text(message, maxLines: 2), alignment: Alignment.bottomCenter, style: ToastificationStyle.flat, autoCloseDuration: Duration(seconds: toastDuration), showProgressBar: false);
  }

  void showChatGPTDownBanner() {
    Get.snackbar(
      "",
      "",
      titleText: Text("Chat GPT Down", maxLines: 2, style: AppFonts.regular(16, AppColors.white)),
      messageText: const SizedBox.shrink(),
      // Removes the default message widget
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      colorText: AppColors.white,
      borderRadius: 0,
      backgroundColor: AppColors.redText,
      isDismissible: false,
      dismissDirection: DismissDirection.none,
      mainButton: TextButton(onPressed: () => Get.back(), child: const Icon(Icons.close, color: Colors.white)),
      duration: const Duration(days: 1),
      // Improved animation parameters
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.fastOutSlowIn,
      reverseAnimationCurve: Curves.fastOutSlowIn,
      // Custom transition animation
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0,
      overlayBlur: 0,
      // Slide-in from top animation
      onTap: (_) {},
      shouldIconPulse: false,
    );
  }
}
