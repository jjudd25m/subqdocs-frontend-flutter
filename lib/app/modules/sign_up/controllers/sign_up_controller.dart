import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/modules/sign_up/models/sign_up_models.dart';
import 'package:subqdocs/app/modules/sign_up/repository/signup_repository.dart';
import 'package:toastification/toastification.dart';

import '../../../../widgets/custom_toastification.dart';

class SignUpController extends GetxController {
  //TODO: Implement SignUpController

  RxBool passwordVisible = RxBool(true);
  RxBool confirmPasswordVisible = RxBool(true);
  RxBool isLoading = RxBool(false);
  final SignupRepository _signupRepository = SignupRepository();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void increment() => count.value++;

  void changePasswordVisible() {
    passwordVisible.value = passwordVisible.value == true ? false : true;
    passwordVisible.refresh();
  }

  void changeConfirmPasswordVisible() {
    confirmPasswordVisible.value = confirmPasswordVisible.value == true ? false : true;
    confirmPasswordVisible.refresh();
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    Map<String, dynamic> param = {};

    param["first_name"] = firstNameController.text.trim();
    param["last_name"] = lastNameController.text.trim();
    param["email"] = emailController.text.trim();
    param["password"] = confirmPasswordController.text.trim();

    try {
      SignUpModel signUpModel = await _signupRepository.registerUser(param: param);

      print("respionse is :- ${signUpModel.toJson()}");

      isLoading.value = false;

      if (signUpModel.responseType == "success") {
        Get.back();
        CustomToastification().showToast(signUpModel.message ?? "", type: ToastificationType.success);
      } else {
        CustomToastification().showToast(signUpModel.message ?? "", type: ToastificationType.error);
      }
    } catch (error) {
      isLoading.value = false;
      print("login catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }
}
