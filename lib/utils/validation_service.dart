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

  static emailValidateRequired(value) {
    final bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);

    if (emailValid == false) {
      return "Enter Valid Mail Address";
    }

    return null;
  }

  static phoneValidate(value) {
    final bool phoneValid = RegExp(r'^\+1\d{10}$').hasMatch(value!);

    if (phoneValid == false) {
      return "Please enter a valid Contact number";
    }

    return null;
  }
  //
  // static passwordValidate(value) {
  //   if (value == null || value.isEmpty) {
  //     return "please filed above filed";
  //   }
  //   final bool passwordValidate =
  //   RegExp(
  //       r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?]{8,20}$'
  //   ).hasMatch(value!);
  //
  //   if (passwordValidate == false) {
  //     return "Please make Password Strong";
  //   }
  //
  //   return null;
  // }

  static String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty.";
    }

    // Check length
    if (value.length < 8 || value.length > 20) {
      return "Password must be between 8 and 20 characters.";
    }

    // Check for at least one letter
    if (!RegExp(r'(?=.*[a-zA-Z])').hasMatch(value)) {
      return "Password must contain at least one letter.";
    }

    // Check for at least one number
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return "Password must contain at least one number.";
    }

    // Check for at least one special character
    if (!RegExp(r'(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])').hasMatch(value)) {
      return "Password must contain at least one special character";
    }

    final bool passwordValidate =
    RegExp(
        r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?]{8,20}$'
    ).hasMatch(value!);

    if (passwordValidate == false) {
      return "Please make Password Strong";
    }


    return null;  // All conditions passed
  }

  // static conforimpasswordValidate(value, firstvalue) {
  //   if (value == null || value.isEmpty) {
  //     return "please filed above filed";
  //   }
  //
  //   print(value);
  //   print(firstvalue);
  //   if (value != firstvalue) {
  //     return "Password not Matched";
  //   }
  // }

  static String? conforimpasswordValidate(value , firstValue) {


    if (value == null || value.isEmpty) {
      return "Password cannot be empty.";
    }

    // Check length
    if (value.length < 8 || value.length > 20) {
      return "Password must be between 8 and 20 characters.";
    }

    // Check for at least one letter
    if (!RegExp(r'(?=.*[a-zA-Z])').hasMatch(value)) {
      return "Password must contain at least one letter.";
    }

    // Check for at least one number
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return "Password must contain at least one number.";
    }

    // Check for at least one special character
    if (!RegExp(r'(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])').hasMatch(value)) {
      return "Password must contain at least one special character";
    }

    final bool passwordValidate =
    RegExp(
        r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?]{8,20}$'
    ).hasMatch(value!);

    if (passwordValidate == false) {
      return "Please make Password Strong";
    }
    if (passwordValidate == false) {
      return "Please make Password Strong";
    }

      if (value != firstValue) {
        return "Password not Matched";
      }

    return null;
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
