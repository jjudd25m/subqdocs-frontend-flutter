import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:subqdocs/app/data/provider/api_provider.dart';
import 'package:subqdocs/app/data/service/socket_service.dart';
import 'package:subqdocs/utils/app_constants.dart';
import 'package:subqdocs/widgets/device_info_model.dart';
import 'package:toastification/toastification.dart';

import 'app/core/common/app_preferences.dart';
import 'app/core/common/global_controller.dart';
import 'app/core/common/global_mobile_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: ".env");

      await SentryFlutter.init((options) {
        options.dsn = WebUri(dotenv.get("SENTRY_URL", fallback: "")).toString();
      });

      await AppPreference.instance.init();

      SocketService socketService = SocketService();

      socketService.socket.onConnect((_) {
        socketService.openAISocket.connect();
      });

      Get.put(GlobalController());
      Get.put(GlobalMobileController());

      //
      Map<String, String> deviceInfo = await DeviceInfoService.getDeviceInfoAsJson();
      print("device info is:- $deviceInfo");
      ApiProvider.instance.cachedDeviceInfo = deviceInfo;

      runApp(ToastificationWrapper(child: GetMaterialApp(navigatorKey: AppConstants().navigatorKey, title: "Application", debugShowCheckedModeBanner: false, defaultTransition: Transition.noTransition, initialRoute: AppPages.INITIAL, getPages: AppPages.routes)));
    },
    (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}
