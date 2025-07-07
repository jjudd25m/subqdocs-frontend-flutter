import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:subqdocs/app/core/common/logger.dart';
import 'package:subqdocs/app/data/service/socket_service.dart';
import 'package:subqdocs/utils/app_constants.dart';
import 'package:subqdocs/widgets/custom_toastification.dart';
import 'package:toastification/toastification.dart';

import 'app/core/common/app_preferences.dart';
import 'app/core/common/global_controller.dart';
import 'app/core/common/global_mobile_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  SocketService socketService = SocketService();

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference.instance.init();

  socketService.socket.onConnect((_) {
    customPrint('connect');

    socketService.openAISocket.connect();
    socketService.openAISocket.onConnect((data) {
      socketService.socket.on("openaiStatusUpdate", (data) {
        var res = data as Map<String, dynamic>;
        customPrint('Open Ai server status $res');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomToastification().showChatGPTDownBanner();
        });
      });
    });

    // socket.emit('msg', 'test');
  });
  socketService.socket.on('event', (data) => customPrint(data));
  socketService.socket.onDisconnect((_) => customPrint('disconnect'));
  socketService.socket.on('fromServer', (_) => customPrint(""));
  socketService.socket.onConnectError((data) {
    customPrint("socket connect error is :- $data");
  });
  socketService.socket.onError((data) {
    customPrint("socket onError is :- $data");
  });

  Get.put(GlobalController());
  Get.put(GlobalMobileController());

  runApp(ToastificationWrapper(child: GetMaterialApp(navigatorKey: AppConstants().navigatorKey, title: "Application", debugShowCheckedModeBanner: false, defaultTransition: Transition.noTransition, initialRoute: AppPages.INITIAL, getPages: AppPages.routes)));
}
