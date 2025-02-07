import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:subqdocs/app/data/service/socket_service.dart';
import 'package:toastification/toastification.dart';

import 'app/core/common/app_preferences.dart';
import 'app/routes/app_pages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<void> main() async {
  SocketService socketService = SocketService();

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference.instance.init();

  // IO.Socket socket = IO.io('https://dev-api.subqdocs.com', IO.OptionBuilder().setTransports(['websocket']).build());

  socketService.socket.onConnect((_) {
    print('connect');
    // socket.emit('msg', 'test');
  });
  socketService.socket.on('event', (data) => print(data));
  socketService.socket.onDisconnect((_) => print('disconnect'));
  socketService.socket.on('fromServer', (_) => print(_));
  socketService.socket.onConnectError(
    (data) {
      print("socket connect error is :- ${data}");
    },
  );
  socketService.socket.onError(
    (data) {
      print("socket onError is :- ${data}");
    },
  );

  runApp(
    ToastificationWrapper(
      child: GetMaterialApp(
        title: "Application",
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
