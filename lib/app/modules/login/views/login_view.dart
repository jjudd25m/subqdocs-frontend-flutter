import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/widgets/custom_button.dart';

import '../../../../widgets/custom_textfiled.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Column(
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
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormFiledWidget(
                  label: "Password",
                  hint: "******",
                  controller: password,
                  suffixIcon: SvgPicture.asset(
                    "assets/images/eye_icon_logo.svg",
                    height: 5,
                    width: 5,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: AppColors.backgroundPurple,
                      value: true,
                      onChanged: (value) => {},
                    ),
                    Text(
                      "Remember me",
                      style: AppFonts.regular(14, AppColors.textDarkGrey),
                    ),
                    Spacer(),
                    Text(
                      "Forgot Password?",
                      style: AppFonts.regular(14, AppColors.backgroundPurple),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                CustomButton(navigate: () => {Get.offAllNamed(Routes.HOME)}, label: "Log in"),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet?",
                      style: AppFonts.regular(14, AppColors.textDarkGrey),
                    ),
                    Text(
                      "Sign up now",
                      style: AppFonts.regular(14, AppColors.backgroundPurple),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
