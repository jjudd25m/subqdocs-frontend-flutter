import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../../widgets/custom_toastification.dart';
import '../../../routes/app_pages.dart';
import '../../sign_up/models/sign_up_models.dart';
import '../../sign_up/repository/signup_repository.dart';

class SignUpSetPasswordController extends GetxController {
  //TODO: Implement SignUpSetPasswordController

  RxBool passwordVisible = RxBool(true);
  RxBool confirmPasswordVisible = RxBool(true);

  RxBool isLoading = RxBool(false);

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final SignupRepository _signupRepository = SignupRepository();

  var passwordValidation = {'length': false, 'number': false, 'letter': false, 'special': false}.obs;

  String firstName = '';
  String lastName = '';
  String email = '';

  @override
  void onInit() {
    super.onInit();

    var arguments = Get.arguments;
    firstName = arguments['first_name'];
    lastName = arguments['last_name'];
    email = arguments['email'];
  }

  void changePasswordVisible() {
    passwordVisible.value = passwordVisible.value == true ? false : true;
    passwordVisible.refresh();
  }

  void changeConfirmPasswordVisible() {
    confirmPasswordVisible.value = confirmPasswordVisible.value == true ? false : true;
    confirmPasswordVisible.refresh();
  }

  // Validation functions
  bool validateLength(String password) {
    return password.length >= 8 && password.length <= 20;
  }

  bool validateNumber(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  bool validateLetter(String password) {
    return password.contains(RegExp(r'[a-zA-Z]'));
  }

  bool validateSpecial(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  // Check all validations
  void validatePassword(String password) {
    passwordValidation['length'] = validateLength(password);
    passwordValidation['number'] = validateNumber(password);
    passwordValidation['letter'] = validateLetter(password);
    passwordValidation['special'] = validateSpecial(password);
  }

  Future<void> registerUser() async {
    isLoading.value = true;

    Map<String, dynamic> param = {};

    param["first_name"] = firstName.trim();
    param["last_name"] = lastName.trim();
    param["email"] = email.trim();
    param["password"] = confirmPasswordController.text.trim();
    param["BETA_TESTER_CODE"] = "fdgdfg56egdfg";

    try {
      SignUpModel signUpModel = await _signupRepository.registerUser(param: param);

      print("response is :- ${signUpModel.toJson()}");
      isLoading.value = false;
      if (signUpModel.responseType == "success") {
        Get.toNamed(Routes.SIGN_UP_SET_ORGANIZATION_INFO, arguments: {'signupdata': signUpModel});
      } else {
        isLoading.value = false;
        Get.back();

        CustomToastification().showToast(signUpModel.message ?? "", type: ToastificationType.error);
      }
    } catch (error) {
      Get.back();
      isLoading.value = false;
      print("login catch error is $error");
      CustomToastification().showToast("$error", type: ToastificationType.error);
    }
  }
}
