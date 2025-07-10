import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<String> getDeviceType(BuildContext context) async {
  if (kIsWeb) {
    return 'Web Browser';
  }

  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    if (iosInfo.model.toLowerCase().contains('ipad')) {
      return 'iPad';
    }
    return 'iPhone';
  } else if (Platform.isAndroid) {
    // Use screen size to determine phone vs tablet
    final mediaQuery = MediaQuery.of(context);
    final shortestSide = mediaQuery.size.shortestSide;

    // 600 is a common threshold for tablets
    if (shortestSide >= 600) {
      return 'Android Tablet';
    } else {
      return 'Android Phone';
    }
  }

  // Handle other platforms
  if (Platform.isMacOS) return 'MacOS';
  if (Platform.isWindows) return 'Windows';
  if (Platform.isLinux) return 'Linux';

  return 'Unknown Device';
}
