import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widget/custom_animated_button.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../utils/validation_service.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Image.asset("assets/images/image_header1.png"),
            Padding(
              padding: const EdgeInsets.only(left: 200, right: 200),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Text(
                    "Login",
                    style: AppFonts.medium(24, AppColors.backgroundPurple),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Welcome back",
                    style: AppFonts.medium(24, AppColors.textBlack),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormFiledWidget(
                      label: "Email Address",
                      controller: email,
                      hint: "johndoe@medical.com",
                      checkValidation: (value) {
                        return Validation.emailValidate(value);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return TextFormFiledWidget(
                        label: "Password",
                        hint: "******",
                        visibility: controller.visiblity.value,
                        controller: password,
                        suffixIcon: controller.visiblity.value
                            ? GestureDetector(
                                onTap: () {
                                  controller.changeVisiblity();
                                },
                                child: SvgPicture.asset(
                                  "assets/images/eye_icon_logo.svg",
                                  height: 5,
                                  width: 5,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller.changeVisiblity();
                                },
                                child: Icon(CupertinoIcons.eye_slash_fill),
                              ),
                        checkValidation: (value) {
                          return Validation.passwordValidate(value);
                        });
                  }),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
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
                        "Remember me",
                        style: AppFonts.medium(14, AppColors.textDarkGrey),
                      ),
                      Spacer(),
                      Text(
                        "Forgot Password?",
                        style: AppFonts.medium(14, AppColors.backgroundPurple),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomAnimatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.offAllNamed(
                          Routes.HOME,
                        );
                      } else {
                        Get.offAllNamed(
                          Routes.HOME,
                        );
                      }
                    },
                    height: 45,
                    text: "Log in",
                    enabledTextColor: AppColors.white,
                    enabledColor: AppColors.backgroundPurple,
                  ),
                  // CustomButton(
                  //     navigate: () => {
                  //           if (_formKey.currentState!.validate())
                  //             {
                  //               Get.offAllNamed(
                  //                 Routes.HOME,
                  //               )
                  //             }
                  //           else
                  //             {
                  //               Get.offAllNamed(
                  //                 Routes.HOME,
                  //               )
                  //             }
                  //         },
                  //     label: "Log in"),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
