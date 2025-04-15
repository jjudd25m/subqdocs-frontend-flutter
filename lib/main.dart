import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/data/service/socket_service.dart';
import 'package:toastification/toastification.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'app/core/common/app_preferences.dart';
import 'app/core/common/global_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<void> main() async {
  SocketService socketService = SocketService();

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference.instance.init();

  WakelockPlus.enable();

  socketService.socket.onConnect((_) {
    print('connect');
    // socket.emit('msg', 'test');
  });
  socketService.socket.on('event', (data) => print(data));
  socketService.socket.onDisconnect((_) => print('disconnect'));
  socketService.socket.on('fromServer', (_) => print(""));
  socketService.socket.onConnectError((data) {
    print("socket connect error is :- ${data}");
  });
  socketService.socket.onError((data) {
    print("socket onError is :- ${data}");
  });

  Get.put(GlobalController());

  runApp(ToastificationWrapper(child: GetMaterialApp(title: "Application", debugShowCheckedModeBanner: false, initialRoute: AppPages.INITIAL, getPages: AppPages.routes)));
}
