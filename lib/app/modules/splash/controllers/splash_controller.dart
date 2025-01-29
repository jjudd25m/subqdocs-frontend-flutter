import 'dart:async';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    splashTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void splashTimer() async {
    Timer(const Duration(seconds: 3), () async {
      Get.offAllNamed(Routes.LOGIN);
    });
  }

  void increment() => count.value++;
}
