class Validation {
  static emailValidate(value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);

    if (emailValid == false) {
      return "Enter Valid Mail Address";
    }

    return null;
  }

  static phoneValidate(value) {
    if (value == null || value.isEmpty) {
      return "please filed above filed";
    }

    final bool mobileValidate = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!);

    if (mobileValidate == false) {
      return "Please Enter Valid Mobile Number";
    }
    return null;
  }

  static passwordValidate(value) {
    if (value == null || value.isEmpty) {
      return "please filed above filed";
    }
    final bool passwordValidate =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value!);

    if (passwordValidate == false) {
      return "Plese make Password Strong";
    }

    return null;
  }

  static conforimpasswordValidate(value, firstvalue) {
    if (value == null || value.isEmpty) {
      return "please filed above filed";
    }

    print(value);
    print(firstvalue);
    if (value != firstvalue) {
      return "Password not Matched";
    }
  }

  static visitDateAndTimeValidation(value, anotherValue) {
    if (value != "") {
      return null;
    }
    if (anotherValue != null) {
      print("value is the ${value}");
      return "please filed above filed";
    }

    return null;
  }

  static requiredFiled(value) {
    if (value == null || value.isEmpty) {
      return "please filed above filed";
    }

    return null;
  }
}
