import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/imagepath.dart';
import '../../../../utils/no_space_lowercase.dart';
import '../../../../utils/validation_service.dart';
import '../../../../widget/custom_animated_button.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../../core/common/common_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_view_mobile_controller.dart';

class LoginViewMobileView extends GetView<LoginViewMobileController> {
  LoginViewMobileView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: removeFocus,
          child: Form(
            key: _formKey,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: ListView(physics: const BouncingScrollPhysics(), padding: EdgeInsets.zero, children: [_buildHeaderSection(context), _buildFormFieldsSection(), _buildRememberMeSection(), _buildLoginButtonSection()])),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [const SizedBox(height: 30), SvgPicture.asset(ImagePath.subqdocs_app_bar_logo, width: MediaQuery.of(context).size.width * 0.45), const SizedBox(height: 24), Text("Sign In", style: AppFonts.medium(20, AppColors.textBlack)), const SizedBox(height: 24)],
    );
  }

  Widget _buildFormFieldsSection() {
    return Column(children: [_buildEmailField(), const SizedBox(height: 20), _buildPasswordField(), const SizedBox(height: 12)]);
  }

  Widget _buildEmailField() {
    return TextFormFiledWidget(
      isSuffixIconVisible: false,
      isFirst: true,
      type: TextInputType.emailAddress,
      label: AppString.emailAddress,
      controller: controller.emailController,
      format: [NoSpaceLowercaseTextFormatter()],
      hint: AppString.emailPlaceHolder,
      onTap: () => controller.emailController.clear(),
      suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
      checkValidation: (value) => Validation.emailValidateRequired(value),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormFiledWidget(label: AppString.password, hint: AppString.passwordHint, visibility: controller.isPasswordVisible.value, controller: controller.passwordController, suffixIcon: _buildPasswordVisibilityToggle(), checkValidation: (value) => Validation.passwordValidate(value));
    });
  }

  Widget _buildPasswordVisibilityToggle() {
    return controller.isPasswordVisible.value
        ? GestureDetector(onTap: () => controller.togglePasswordVisibility(), child: const Icon(CupertinoIcons.eye_slash_fill, color: AppColors.textDarkGrey))
        : GestureDetector(onTap: () => controller.togglePasswordVisibility(), child: SvgPicture.asset(ImagePath.eyeLogoOpen, height: 5, width: 5));
  }

  Widget _buildRememberMeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Combined clickable area for both checkbox and text
        GestureDetector(onTap: () => controller.isRememberMe.toggle(), child: Row(mainAxisSize: MainAxisSize.min, children: [_buildRememberMeCheckbox(), const SizedBox(width: 5), Text(AppString.rememberMe, style: AppFonts.regular(14, AppColors.textDarkGrey))])),
        const Spacer(),
        _buildForgotPasswordButton(),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Obx(() {
      return SizedBox(width: 24, height: 24, child: Checkbox(visualDensity: VisualDensity.compact, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, activeColor: AppColors.backgroundPurple, value: controller.isRememberMe.value, onChanged: (value) => controller.isRememberMe.value = value!));
    });
  }

  Widget _buildForgotPasswordButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.FORGOT_PASSWORD, arguments: {"email": controller.emailController.text});
      },
      child: Text(AppString.forgotPassword, style: AppFonts.regular(14, AppColors.backgroundPurple)),
    );
  }

  Widget _buildLoginButtonSection() {
    return Column(children: [const SizedBox(height: 30), _buildLoginButton(), const SizedBox(height: 20)]);
  }

  Widget _buildLoginButton() {
    return Obx(() {
      return CustomAnimatedButton(onPressed: _handleLogin, height: 45, text: "Continue", isLoading: controller.isLoading.value, enabledTextColor: AppColors.white, enabledColor: AppColors.backgroundPurple);
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      controller.authLoginUser();
    }
  }
}
