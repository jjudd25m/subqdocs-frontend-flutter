class Validation {
  static emailValidate(value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);

    if (emailValid == false) {
      return "Enter Valid Mail Address";
    }

    return null;
  }

  static emailValidateRequired(value) {
    final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);

    if (emailValid == false) {
      return "Enter Valid Mail Address";
    }

    return null;
  }

  // static phoneValidate(value) {
  //   print(value);
  //   // print("${v}");
  //   final bool phoneValid = RegExp(r'^\+1\d{10}$').hasMatch(value!);
  //
  //   if (phoneValid == false) {
  //     return "Please enter a valid Contact number";
  //   }
  //
  //   return null;
  // }

  static String? phoneValidate(String? value) {
    // Define the list of valid US area codes
    List<String> usAreaCodes = [
      // Alabama
      '205', '251', '256', '334', '938',

      // Alaska
      '907',

      // Arizona
      '480', '520', '602', '623', '928',

      // Arkansas
      '501', '870',

      // California
      '209', '213', '310', '323', '408', '415', '424', '442', '510', '530', '562', '619', '626', '650', '661', '669', '714', '747', '818', '831', '858', '909', '916', '925', '949', '951',

      // Colorado
      '303', '719', '720', '970',

      // Connecticut
      '203', '475', '860', '959',

      // Delaware
      '302',

      // Florida
      '239', '305', '321', '352', '386', '407', '561', '727', '754', '786', '813', '850', '863', '904', '941', '954',

      // Georgia
      '229', '404', '470', '478', '678', '706', '762', '770', '912',

      // Hawaii
      '808',

      // Idaho
      '208',

      // Illinois
      '217', '224', '309', '312', '331', '618', '630', '708', '773', '779', '815', '847', '872',

      // Indiana
      '219', '260', '317', '574', '765', '812', '930',

      // Iowa
      '319', '515', '563', '641', '712',

      // Kansas
      '316', '620', '785', '913',

      // Kentucky
      '270', '502', '606', '859',

      // Louisiana
      '225', '318', '337', '504', '985',

      // Maine
      '207',

      // Maryland
      '240', '301', '410', '443', '667',

      // Massachusetts
      '339', '413', '508', '617', '774', '781', '857', '978',

      // Michigan
      '231', '248', '269', '313', '517', '586', '616', '734', '810', '906', '989',

      // Minnesota
      '218', '320', '507', '612', '651', '763', '952',

      // Mississippi
      '228', '601', '662', '769',

      // Missouri
      '314', '417', '573', '636', '660', '816', '975',

      // Montana
      '406',

      // Nebraska
      '308', '402', '531',

      // Nevada
      '702', '775',

      // New Hampshire
      '603',

      // New Jersey
      '201', '202' '551', '609', '732', '848', '856', '862', '973',

      // New Mexico
      '505', '575',

      // New York
      '212', '315', '332', '347', '516', '518', '585', '607', '631', '646', '716', '718', '845', '914', '917', '929',

      // North Carolina
      '252', '336', '704', '828', '910', '919', '980', '984',

      // North Dakota
      '701',

      // Ohio
      '216', '234', '330', '380', '419', '440', '513', '614', '740', '747', '937',

      // Oklahoma
      '405', '580', '918',

      // Oregon
      '503', '541', '971',

      // Pennsylvania
      '215', '267', '272', '412', '484', '570', '610', '717', '724', '814', '827', '878',

      // Rhode Island
      '401',

      // South Carolina
      '803', '843', '854', '864',

      // South Dakota
      '605',

      // Tennessee
      '423', '615', '629', '731', '865', '901', '931',

      // Texas
      '210', '214', '254', '281', '325', '409', '469', '512', '682', '713', '737', '806', '817', '830', '832', '903', '915', '936', '972', '979',

      // Utah
      '385', '435', '801',

      // Vermont
      '802',

      // Virginia
      '276', '434', '540', '571', '703', '757', '804',

      // Washington
      '206', '253', '360', '425', '509',

      // West Virginia
      '304', '681',

      // Wisconsin
      '262', '414', '534', '608', '715', '920',

      // Wyoming
      '307',
    ];
    // Regular expression to match the phone number format +1 (XXX) XXX-XXXX
    final RegExp phoneRegExp = RegExp(r'^\+1\(\d{3}\)\d{3}-\d{4}$');

    // First, check if the phone number matches the required format
    if (value == null) {
      return "Please enter a valid contact number";
    }

    // Extract the area code from the phone number
    final String areaCode = value.substring(4, 7);
    print(areaCode);

    // Extracting the area code between ( and )

    // Check if the area code is valid
    if (!usAreaCodes.contains(areaCode)) {
      return "Invalid area code";
    }

    // Check if the phone number length is correct (the length check is done by regex)
    if (value.length != 17) {
      return "Please enter a valid contact number";
    }

    return null; // Return null if all checks pass
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

    final bool passwordValidate = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?]{8,20}$').hasMatch(value!);

    if (passwordValidate == false) {
      return "Please make Password Strong";
    }

    return null; // All conditions passed
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

  static String? conforimpasswordValidate(value, firstValue) {
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

    final bool passwordValidate = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?])[A-Za-z\d!@#$%^&*()_+\-=\[\]{};":\\|,.<>\/?]{8,20}$').hasMatch(value!);

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
