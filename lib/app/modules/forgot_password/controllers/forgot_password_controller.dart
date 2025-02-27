import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/forgot_password/models/send_otp_model.dart';
import 'package:subqdocs/app/modules/forgot_password/models/valid_otp_model.dart';
import 'package:subqdocs/app/modules/forgot_password/repository/forgot_password_repository.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import '../views/enter_mail_view.dart';
import '../views/enter_otp_view.dart';
import '../views/enter_password_view.dart';
import '../views/forgot_password_view.dart';
import '../views/password_changed_screen.dart';

class ForgotPasswordController extends GetxController {
  RxBool passwordVisible = RxBool(true);
  RxBool confirmPasswordVisible = RxBool(true);
  RxBool isLoading = RxBool(false);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String otpCode = "";

  final ForgotPasswordRepository _forgotPasswordRepository = ForgotPasswordRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String optScreen = "otp_Screen";
  String enterPassword = "enter_password";
  String passwordChangedScreen = "password_changed_screen";
  String deaFault = "deafault";
  RxString currentScreen = RxString("deafault");

  // Map that associates the value to a corresponding screen (widget)
  Map<String, Widget> screenMap = {
    "otp_Screen": EnterOtpView(),
    "enter_password": EnterPasswordView(),
    "password_changed_screen": PasswordChangedScreen(),
  };
  //TODO: Implement ForgotPasswordController
  Widget getCurrentScreen() {
    return screenMap[currentScreen.value] ?? EnterMailView(); // Default screen if no match
  }

  void changePasswordVisible() {
    passwordVisible.value = passwordVisible.value == true ? false : true;
    passwordVisible.refresh();
  }

  void changeConfirmPasswordVisible() {
    confirmPasswordVisible.value = confirmPasswordVisible.value == true ? false : true;
    confirmPasswordVisible.refresh();
  }

  void changeCurrentScreen(String screenName) {
    currentScreen.value = screenName;
    currentScreen.refresh();
  }

  final count = 0.obs;

  void increment() => count.value++;

  Future<void> sendOtp() async {
    isLoading.value = true;

    try {
      SendOtpModel sendOtpModel = await _forgotPasswordRepository.sendOtp(email: emailController.text.toLowerCase().trim());

      if (sendOtpModel.responseData != false) {
        isLoading.value = false;
        print("response is ${sendOtpModel.toJson()} ");
        currentScreen.value = optScreen;
        currentScreen.refresh();
        CustomToastification().showToast(sendOtpModel.message ?? "", type: ToastificationType.success);
      } else {
        isLoading.value = false;
        CustomToastification().showToast(sendOtpModel.message ?? "", type: ToastificationType.error);
      }
    } catch (error) {
      CustomToastification().showToast("$error", type: ToastificationType.error);
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    isLoading.value = true;

    Map<String, dynamic> param = {};

    param['email'] = emailController.text;
    param['otp'] = otpCode;

    try {
      VerifyOtpModel verifyOtpModel = await _forgotPasswordRepository.verifyOpt(param: param);
      if (verifyOtpModel.responseData != false) {
        isLoading.value = false;
        print(verifyOtpModel.toJson());
        currentScreen.value = enterPassword;
        currentScreen.refresh();
        CustomToastification().showToast(verifyOtpModel.message ?? "", type: ToastificationType.success);
      } else {
        isLoading.value = false;
        CustomToastification().showToast(verifyOtpModel.message ?? "", type: ToastificationType.error);
      }
    } catch (error) {
      CustomToastification().showToast("$error", type: ToastificationType.error);
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    isLoading.value = true;

    Map<String, dynamic> param = {};

    param['email'] = emailController.text.trim();
    param['password'] = confirmPasswordController.text.trim();

    try {
      VerifyOtpModel verifyOtpModel = await _forgotPasswordRepository.resetPassword(param: param);
      if (verifyOtpModel.responseData != false) {
        isLoading.value = false;
        print(verifyOtpModel.toJson());
        CustomToastification().showToast(verifyOtpModel.message ?? "Password Update Sucessfully", type: ToastificationType.success);
        currentScreen.value = passwordChangedScreen;

        currentScreen.refresh();
      } else {
        isLoading.value = false;
        CustomToastification().showToast(verifyOtpModel.message ?? "", type: ToastificationType.error);
      }
    } catch (error) {
      CustomToastification().showToast("$error", type: ToastificationType.error);
      isLoading.value = false;
    }
  }
}
