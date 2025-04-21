import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:subqdocs/widgets/custom_animated_button.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../controllers/beta_tester_code_controller.dart';

class BetaTesterCodeView extends GetView<BetaTesterCodeController> {
  BetaTesterCodeView({super.key});

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
                  Text("We are in active beta testing mode", style: AppFonts.medium(20, AppColors.textBlack)),
                  SizedBox(height: 24),
                  Text("Please enter the code to start testing", style: AppFonts.medium(16, AppColors.textDarkGrey)),
                  SizedBox(height: 24),
                  SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: TextFormFiledWidget(
                      isSuffixIconVisible: false,
                      isFirst: true,
                      label: "Enter the code",
                      controller: controller.betaCodeController,
                      format: [NoSpaceLowercaseTextFormatter()],
                      hint: "123456",
                      onTap: () {
                        // controller.emailController.clear();
                      },
                      suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                      checkValidation: (value) {
                        return Validation.emailValidateRequired(value);
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 120,
                    child: CustomAnimatedButton(
                      onPressed: () {
                        controller.validateBetaTesterCode();
                      },
                      text: "Continue",
                      enabledColor: AppColors.backgroundPurple,
                      height: 45,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: AppColors.backgroundLightGrey,
                    width: isSmallScreen ? Get.width - 30 : 460,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text("If you don't have  the code please reach out to join the waitlist", textAlign: TextAlign.center, style: AppFonts.regular(16, AppColors.backgroundBlack)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            Expanded(
                              child: TextFormFiledWidget(
                                isSuffixIconVisible: false,
                                isFirst: true,
                                label: "",
                                controller: controller.emailController,
                                format: [NoSpaceLowercaseTextFormatter()],
                                hint: AppString.emailPlaceHolder,
                                onTap: () {
                                  controller.emailController.clear();
                                },
                                suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                                checkValidation: (value) {
                                  return Validation.emailValidateRequired(value);
                                },
                              ),
                            ),
                            SizedBox(width: 160, child: CustomAnimatedButton(text: "Join the waitlist", enabledColor: AppColors.backgroundPurple, height: 45)),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
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
