import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:subqdocs/widget/custom_animated_button.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/app_string.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  // TextEditingController email = TextEditingController();
  // TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isWidthLessThan428(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("mobile widh is ${width}");
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
                  AppString.login,
                  style: AppFonts.medium(24, AppColors.backgroundPurple),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  AppString.welcomeBack,
                  style: AppFonts.medium(20, AppColors.textBlack),
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: isSmallScreen ? Get.width - 30 : 416,
                  child: TextFormFiledWidget(
                      label: AppString.emailAddress,
                      controller: controller.emailController,
                      hint: AppString.emailPlaceHolder,
                      checkValidation: (value) {
                        return Validation.emailValidate(value);
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
                        hint: AppString.passwordHint,
                        visibility: controller.visiblity.value,
                        controller: controller.passwordController,
                        suffixIcon: controller.visiblity.value
                            ? GestureDetector(
                                onTap: () {
                                  controller.changeVisiblity();
                                },
                                child: SvgPicture.asset(
                                  ImagePath.eyeLogoOpen,
                                  height: 5,
                                  width: 5,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller.changeVisiblity();
                                },
                                child: Icon(
                                  CupertinoIcons.eye_slash_fill,
                                  color: AppColors.textDarkGrey,
                                ),
                              ),
                        checkValidation: (value) {
                          return Validation.passwordValidate(value);
                        }),
                  );
                }),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: isSmallScreen ? Get.width - 30 : 416,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColors.backgroundPurple,
                        value: true,
                        onChanged: (value) => {},
                      ),
                      Text(
                        AppString.rememberMe,
                        style: AppFonts.medium(14, AppColors.textDarkGrey),
                      ),
                      Spacer(),
                      Text(
                        AppString.forgotPassword,
                        style: AppFonts.medium(14, AppColors.backgroundPurple),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return SizedBox(
                    width: isSmallScreen ? Get.width - 30 : 416,
                    child: CustomAnimatedButton(
                      onPressed: () {
                        controller.authLoginUser();
                      },
                      height: 45,
                      text: "Log in",
                      isLoading: controller.isLoading.value,
                      enabledTextColor: AppColors.white,
                      enabledColor: AppColors.backgroundPurple,
                    ),
                  );
                }),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet?",
                      style: AppFonts.medium(14, AppColors.textDarkGrey),
                    ),
                    Text(
                      "Sign up now",
                      style: AppFonts.medium(14, AppColors.backgroundPurple),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
