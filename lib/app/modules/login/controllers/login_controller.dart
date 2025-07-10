import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/app_string.dart';
import '../../../../widgets/custom_toastification.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/global_controller.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  final LoginRepository _loginRepository = LoginRepository();
  RxBool visibility = RxBool(true);
  RxBool isLoading = RxBool(false);

  RxBool isRememberMe = RxBool(false);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();

    bool isRemember = AppPreference.instance.getBool(AppString.prefKeyRememberMe);

    if (isRemember) {
      String preferenceEmail = AppPreference.instance.getString(AppString.prefKeyRememberEmail);
      String preferencePassword = AppPreference.instance.getString(AppString.prefKeyRememberPassword);
      emailController.text = preferenceEmail;
      passwordController.text = preferencePassword;
      isRememberMe.value = true;
    }
  }

  void changeVisiblity() {
    visibility.value = visibility == true ? false : true;
    visibility.refresh();
  }

  Future<void> authLoginUser() async {
    if (isRememberMe.value) {
      AppPreference.instance.setBool(AppString.prefKeyRememberMe, true);
      AppPreference.instance.setString(AppString.prefKeyRememberEmail, emailController.text);
      AppPreference.instance.setString(AppString.prefKeyRememberPassword, passwordController.text);
    } else {
      AppPreference.instance.setBool(AppString.prefKeyRememberMe, false);
      AppPreference.instance.setString(AppString.prefKeyRememberEmail, "");
      AppPreference.instance.setString(AppString.prefKeyRememberPassword, "");
    }

    isLoading.value = true;

    try {
      LoginModel loginModel = await _loginRepository.login(email: emailController.text.toLowerCase().trim(), password: passwordController.text.trim());
      isLoading.value = false;
      customPrint("response is ${loginModel.toJson()} ");

      if (loginModel.responseData == null) {
        CustomToastification().showToast(loginModel.message ?? "", type: ToastificationType.error);
      } else {
        await AppPreference.instance.setString(AppString.prefKeyUserLoginData, json.encode(loginModel.toJson()));
        await AppPreference.instance.removeKey(AppString.patientList);
        await AppPreference.instance.removeKey(AppString.pastPatientList);
        await AppPreference.instance.removeKey(AppString.schedulePatientList);
        AppPreference.instance.setString(loginModel.responseData?.token ?? "", AppString.prefKeyToken);
        CustomToastification().showToast("User logged in successfully", type: ToastificationType.success);
        // Get.replace(Routes.HOME);
        Get.offNamed(Routes.HOME);
        Get.put(GlobalController());
      }
    } catch (error) {
      isLoading.value = false;
      customPrint("login catch error is $error");
      CustomToastification().showToast(error.toString(), type: ToastificationType.error);
    }
  }
}
