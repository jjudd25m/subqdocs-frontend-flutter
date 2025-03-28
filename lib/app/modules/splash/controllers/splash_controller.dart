import 'dart:async';

import 'package:get/get.dart';

import '../../../../utils/app_string.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  @override
  void onInit() {
    super.onInit();
    splashTimer();
  }

  void splashTimer() async {
    var response = await AppPreference.instance.getString(AppString.prefKeyUserLoginData);

    customPrint("splash passcode is ${response}");

    Timer(const Duration(seconds: 3), () async {
      if (response.isNotEmpty) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }
}
