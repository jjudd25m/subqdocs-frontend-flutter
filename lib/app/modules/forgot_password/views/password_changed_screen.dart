import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/forgot_password/controllers/forgot_password_controller.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';

import '../../../../utils/imagepath.dart';
import '../../../../widget/custom_animated_button.dart';

class PasswordChangedScreen extends GetView<ForgotPasswordController> {
  const PasswordChangedScreen({super.key});

  bool isWidthLessThan428(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < 428;
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = isWidthLessThan428(context);
    return Column(
      children: [
        const SizedBox(height: 29),
        SvgPicture.asset(ImagePath.rightCheck),
        const SizedBox(height: 20),
        Text("Password Changed", style: AppFonts.medium(18, AppColors.textBlack)),
        const SizedBox(height: 16),
        SizedBox(width: isSmallScreen ? 300 : 400, child: Text("Please enter your registered email address below, and we’ll send you a link to reset your password", style: AppFonts.regular(14, AppColors.textDarkGrey), textAlign: TextAlign.center)),
        const SizedBox(height: 30),
        Obx(() {
          return SizedBox(
            width: isSmallScreen ? Get.width - 30 : 416,
            child: CustomAnimatedButton(
              onPressed: () {
                Get.back();
              },
              height: 45,
              text: "Back to Login",
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
