import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widget/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
          key: controller.formKey,
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
              Obx(
                () {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: isPortrait ? null : 30,
                      ),
                      Text(
                        AppString.login,
                        style: AppFonts.medium(24, AppColors.backgroundPurple),
                      ),
                      controller.getCurrentScreen()
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
