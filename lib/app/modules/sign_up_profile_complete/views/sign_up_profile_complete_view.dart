import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../core/common/common_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sign_up_profile_complete_controller.dart';

class SignUpProfileCompleteView extends GetView<SignUpProfileCompleteController> {
  SignUpProfileCompleteView({super.key});

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
                    "Sign In",
                    style: AppFonts.medium(24, AppColors.backgroundPurple),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SvgPicture.asset(ImagePath.rightCheck, width: 70, height: 70),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "You’re All Set!",
                    style: AppFonts.medium(20, AppColors.textBlack),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Provide details about your organization and we’ll customize your subQdocs just for you!",
                    style: AppFonts.regular(14, AppColors.textDarkGrey),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: CustomAnimatedButton(
                      onPressed: () {
                        Get.until((route) => Get.currentRoute == Routes.LOGIN);
                      },
                      height: 45,
                      text: "Continue",
                      enabledTextColor: AppColors.white,
                      enabledColor: AppColors.backgroundPurple,
                    ),
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
