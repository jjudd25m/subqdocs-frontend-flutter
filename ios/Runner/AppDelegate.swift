import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

//    let sharedDefault = UserDefaults(suiteName: "group.subqdocs.liveactivities")!

    NotificationCenter.default.addObserver(self, selector: #selector(userNameUpdated), name: Notification.Name("userNameUpdated"), object: nil)

    let controller = window?.rootViewController as! FlutterViewController
       let methodChannel = FlutterMethodChannel(name: "com.subqdocs/shared", binaryMessenger: controller.binaryMessenger)

       // Save the method channel as a property to send messages to Flutter
       self.methodChannel = methodChannel

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  var methodChannel: FlutterMethodChannel?


  @objc func userNameUpdated() {
    // Data has changed; handle the update accordingly
    print("User name has been updated!")
    methodChannel?.invokeMethod("onUserNameUpdated", arguments: nil)
  }

  deinit {
    // Don't forget to remove the observer when it's no longer needed
    NotificationCenter.default.removeObserver(self)
  }
}
