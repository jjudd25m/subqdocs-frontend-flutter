import 'dart:io';

class DeviceDetection {
  static bool isPhone() {
    if (Platform.isAndroid) {
      return true; // Could be phone or tablet; refine with screen size if needed
    } else if (Platform.isIOS) {
      // crude heuristic; refine with UIDeviceInfo if needed
      return !isIpad();
    }
    return false;
  }

  static bool isIpad() {
    // crude check; you can refine this if needed
    return Platform.isIOS && (Platform.operatingSystemVersion.contains("iPad"));
  }
}
