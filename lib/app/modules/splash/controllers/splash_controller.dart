import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/app_string.dart';
import '../../../../widget/device_detection.dart';
import '../../../core/common/app_preferences.dart';
import '../../../core/common/logger.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  String deviceType = "";

  @override
  void onInit() {
    super.onInit();
    _startSplashFlow();
  }

  // Main splash screen sequence
  Future<void> _startSplashFlow() async {
    await _setDeviceType();
    _lockOrientation();
    _redirectAfterDelay();
  }

  // Detect and store device type
  Future<void> _setDeviceType() async {
    deviceType = await getDeviceType(Get.context!);
    customPrint("Device: $deviceType");
  }

  // Restrict orientation for phones, allow rotation for iPads
  void _lockOrientation() {
    if (_isPhone) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else if (_isIpad) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  // Wait 3 seconds then route to appropriate screen
  Future<void> _redirectAfterDelay() async {
    final isLoggedIn = await _checkLoginStatus();
    Timer(const Duration(seconds: 3), () => _goToDestination(isLoggedIn));
  }

  // Check if user has existing login data
  Future<bool> _checkLoginStatus() async {
    final loginData = await AppPreference.instance.getString(AppString.prefKeyUserLoginData);
    customPrint("Login data exists: ${loginData.isNotEmpty}");
    return loginData.isNotEmpty;
  }

  // Navigate to home (logged in) or login (guest)
  void _goToDestination(bool isLoggedIn) {
    final route = isLoggedIn ? (_isPhone ? Routes.HOME_VIEW_MOBILE : Routes.HOME) : (_isPhone ? Routes.LOGIN_VIEW_MOBILE : Routes.LOGIN);
    Get.offAllNamed(route);
  }

  // Device type checkers
  bool get _isPhone => deviceType == 'iPhone' || deviceType == 'Android Phone';

  bool get _isIpad => deviceType == 'iPad';
}
