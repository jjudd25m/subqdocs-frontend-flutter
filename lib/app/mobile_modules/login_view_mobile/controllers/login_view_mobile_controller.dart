import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_mobile_controller.dart';
import '../../../core/common/logger.dart';
import '../../../modules/login/model/login_model.dart';
import '../../../modules/login/repository/login_repository.dart';
import '../../../routes/app_pages.dart';

class LoginViewMobileController extends GetxController {
  // Dependencies
  final LoginRepository _loginRepository;
  final AppPreference _preference;

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observables
  final RxBool isPasswordVisible = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRememberMe = false.obs;
  final RxInt failedAttempts = 0.obs;

  LoginViewMobileController({LoginRepository? loginRepository, AppPreference? preference}) : _loginRepository = loginRepository ?? LoginRepository(), _preference = preference ?? AppPreference.instance;

  @override
  void onInit() {
    super.onInit();
    _loadRememberedCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Loads saved credentials if "Remember Me" was enabled
  void _loadRememberedCredentials() {
    final isRemember = _preference.getBool(AppString.prefKeyRememberMe);
    if (!isRemember) return;

    final email = _preference.getString(AppString.prefKeyRememberEmail);
    final password = _preference.getString(AppString.prefKeyRememberPassword);

    if (email.isNotEmpty) {
      emailController.text = email;
      isRememberMe.value = true;
    }

    if (password.isNotEmpty) {
      passwordController.text = password;
    }
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Handles the login process
  Future<void> authLoginUser() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      await _handleRememberMePreference();

      final email = emailController.text.toLowerCase().trim();
      final password = passwordController.text.trim();

      final loginModel = await _loginRepository.login(email: email, password: password);

      await _handleSuccessfulLogin(loginModel);
    } catch (error, stackTrace) {
      _handleLoginError(error, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  /// Saves or clears credentials based on "Remember Me" preference
  Future<void> _handleRememberMePreference() async {
    if (isRememberMe.value) {
      await _preference.setBool(AppString.prefKeyRememberMe, true);
      await _preference.setString(AppString.prefKeyRememberEmail, emailController.text);
      await _preference.setString(AppString.prefKeyRememberPassword, passwordController.text);
    } else {
      await _clearRememberedCredentials();
    }
  }

  /// Clears saved credentials
  Future<void> _clearRememberedCredentials() async {
    await _preference.setBool(AppString.prefKeyRememberMe, false);
    await _preference.setString(AppString.prefKeyRememberEmail, "");
    await _preference.setString(AppString.prefKeyRememberPassword, "");
  }

  /// Handles successful login
  Future<void> _handleSuccessfulLogin(LoginModel loginModel) async {
    customPrint("Login response: ${loginModel.toJson()}");

    if (loginModel.responseData == null) {
      CustomToastification().showToast(loginModel.message ?? "", type: ToastificationType.error);
    } else {
      await Future.wait([_preference.setString(AppString.prefKeyUserLoginData, json.encode(loginModel.toJson())), _preference.setString(loginModel.responseData?.token ?? "", AppString.prefKeyToken)]);

      CustomToastification().showToast("User logged in successfully", type: ToastificationType.success);

      // Navigate to home screen
      Get.offNamed(Routes.HOME_VIEW_MOBILE);
      Get.put(GlobalMobileController());
    }
  }

  /// Handles login errors
  void _handleLoginError(dynamic error, StackTrace stackTrace) {
    failedAttempts.value++;
    customPrint("Login error: $error\n$stackTrace");

    final errorMessage = error is ApiException ? error.message : "An unexpected error occurred. Please try again.";

    CustomToastification().showToast(errorMessage, type: ToastificationType.error);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}
