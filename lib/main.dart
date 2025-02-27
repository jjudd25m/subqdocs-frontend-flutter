import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:subqdocs/app/data/service/socket_service.dart';
import 'package:toastification/toastification.dart';

import 'app/core/common/app_preferences.dart';
import 'app/routes/app_pages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<void> main() async {
  SocketService socketService = SocketService();

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference.instance.init();

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

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://51d562a8649b2d66ba8553d8b09ae40d@o4508879490646016.ingest.us.sentry.io/4508879495954432';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: ToastificationWrapper(
          child: GetMaterialApp(
            title: "Application",
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        ),
      ),
    ),
  );
}
