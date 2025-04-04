import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpSetPasswordController extends GetxController {
  //TODO: Implement SignUpSetPasswordController

  RxBool passwordVisible = RxBool(true);
  RxBool confirmPasswordVisible = RxBool(true);

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var passwordValidation = {
    'length': false,
    'number': false,
    'letter': false,
    'special': false,
  }.obs;

  @override
  void onInit() {
    super.onInit();
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
}
