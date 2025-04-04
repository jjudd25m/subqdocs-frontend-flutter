import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

import 'package:get/get.dart';

import 'package:subqdocs/app/data/service/socket_service.dart';
import 'package:toastification/toastification.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'app/core/common/app_preferences.dart';
import 'app/core/common/global_controller.dart';
import 'app/models/PiPHomePage.dart';

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

  Get.put(GlobalController(), permanent: true);

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

  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn = 'https://51d562a8649b2d66ba8553d8b09ae40d@o4508879490646016.ingest.us.sentry.io/4508879495954432';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //     // The sampling rate for profiling is relative to tracesSampleRate
  //     // Setting to 1.0 will profile 100% of sampled transactions:
  //     options.profilesSampleRate = 1.0;
  //   },
  //   appRunner: () => runApp(
  //     SentryWidget(
  //       child: ToastificationWrapper(
  //         child: GetMaterialApp(
  //           title: "Application",
  //           debugShowCheckedModeBanner: false,
  //           initialRoute: AppPages.INITIAL,
  //           getPages: AppPages.routes,
  //         ),
  //       ),
  //     ),
  //   ),
  // );
}

@pragma('vm:entry-point')
void pipMain() {
  runApp(ClipRRect(borderRadius: BorderRadius.circular(12), child: App(home: PiPHomePage())));
}
//

class App extends StatelessWidget {
  const App({super.key, required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.light(), darkTheme: ThemeData.dark(), home: home);
  }
}

class Timer extends StatelessWidget {
  const Timer({super.key});

  @override
  Widget build(BuildContext context) => Counter.down(
      value: const Duration(seconds: 500),
      builder: (Duration duration, bool isRunning, VoidCallback startTiming, VoidCallback stopTiming) {
        return Padding(padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12), child: Text('timer:${duration.inSeconds.toString()}'));
      });
}

class Filled extends StatelessWidget {
  const Filled({super.key, required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onPressed, child: Text(text, textAlign: TextAlign.center));
  }
}
