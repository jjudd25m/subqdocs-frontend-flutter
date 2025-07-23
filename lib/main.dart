import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:subqdocs/app/data/provider/api_provider.dart';
import 'package:subqdocs/utils/app_constants.dart';
import 'package:subqdocs/widgets/device_info_model.dart';
import 'package:toastification/toastification.dart';

import 'app/core/common/app_preferences.dart';
import 'app/core/common/global_controller.dart';
import 'app/core/common/global_mobile_controller.dart';
import 'app/data/service/socket_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await AppPreference.instance.init();

  SocketService socketService = SocketService();

  socketService.socket.onConnect((_) {
    socketService.openAISocket.connect();
  });

  Get.put(GlobalController());
  Get.put(GlobalMobileController());

  Map<String, String> deviceInfo = await DeviceInfoService.getDeviceInfoAsJson();
  ApiProvider.instance.cachedDeviceInfo = deviceInfo;

  runApp(ToastificationWrapper(child: GetMaterialApp(navigatorKey: AppConstants().navigatorKey, title: "Application", debugShowCheckedModeBanner: false, defaultTransition: Transition.noTransition, initialRoute: AppPages.INITIAL, getPages: AppPages.routes)));
}
