import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate , FlutterStreamHandler {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)


        NotificationCenter.default.addObserver(self, selector: #selector(userNameUpdated), name: Notification.Name("userNameUpdated"), object: nil)

        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.subqdocs/shared", binaryMessenger: controller.binaryMessenger)

        // Save the method channel as a property to send messages to Flutter
        self.methodChannel = methodChannel

        methodChannel.setMethodCallHandler { (call, result) in
            if call.method == "getAudioInputDevices" {
                result(self.getAudioInputs())
            } else if call.method == "setPreferredAudioInput" {
                if let args = call.arguments as? String {
                    let success = self.setPreferredAudioInput(portName: args)
                    result(success)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Port name required", details: nil))
                }
            }
            else if call.method == "startAudioRouteListening" {
                self.startListeningAudioRouteChanges()
                result(nil)
            }else if call.method == "stopAudioRouteListening" {
                self.stopListeningAudioRouteChanges()
                result(nil)
            }
            else if call.method == "getActiveMicrophoneName" {
                result( self.getActiveMicrophoneName())

            }


            else {
                result(FlutterMethodNotImplemented)
            }

        }


        // Event Channel
        let eventChannel = FlutterEventChannel(name: "com.subqdocs/audioEvents", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)


        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    var methodChannel: FlutterMethodChannel?
    var eventSink: FlutterEventSink?


    @objc func userNameUpdated() {
        // Data has changed; handle the update accordingly
        print("User name has been updated!")
        methodChannel?.invokeMethod("onUserNameUpdated", arguments: nil)
    }

    // MARK: - Stream Handler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func getActiveMicrophoneName() -> String? {
        let audioSession = AVAudioSession.sharedInstance()
        return audioSession.currentRoute.inputs.first?.portName
    }

    func getAudioInputs() -> [String] {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            print("Error setting audio session: \(error)")
            return ["Error: \(error.localizedDescription)"]
        }

        guard let inputs = session.availableInputs else {
            return ["No inputs available"]
        }

        return inputs.map { input in
            //            (\(input.portType.rawValue))
            return "\(input.portName)"
        }
    }

    func setPreferredAudioInput(portName: String) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            // 1. Configure audio session
            try audioSession.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.allowBluetooth, .allowBluetoothA2DP]
            )

            // 2. Get available inputs
            guard let inputs = audioSession.availableInputs else {
                print("No audio inputs available")
                return false
            }

            // 3. Find the requested input
            guard let selectedInput = inputs.first(where: { $0.portName == portName }) else {
                print("Input device not found: \(portName)")
                notifyFlutterAudioDevicesChanged()
                notifyFlutterBluetoothDevicesChanged()
                return false
            }

            // 4. Special handling for built-in mic
            if selectedInput.portType == .builtInMic {
                try audioSession.setPreferredInput(nil) // Clear preferred input
            }
            // 5. Special handling for Bluetooth
            else if [.bluetoothHFP, .bluetoothA2DP].contains(selectedInput.portType) {
                try audioSession.overrideOutputAudioPort(.none)
            }

            // 6. Set the preferred input
            try audioSession.setPreferredInput(selectedInput)

            // 7. Activate session
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            print("Successfully switched to: \(portName)")
            return true

        } catch {
            print("Failed to set audio input: \(error.localizedDescription)")
            return false
        }
    }

    func startListeningAudioRouteChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }

    func stopListeningAudioRouteChanges() {
        NotificationCenter.default.removeObserver(
            self,
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }

    @objc func handleAudioRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        let session = AVAudioSession.sharedInstance()
        switch reason {
        case .newDeviceAvailable:
            print("New audio device connected")
            for input in session.currentRoute.inputs {
                if input.portType == .bluetoothHFP || input.portType == .bluetoothA2DP {
                    print(" Bluetooth connected: \(input.portName)")
                    notifyFlutterBluetoothDevicesChanged()

                }
            }
            notifyFlutterAudioDevicesChanged()
        case .oldDeviceUnavailable:
            print("Audio device disconnected")
            if let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for input in previousRoute.inputs {
                    if input.portType == .bluetoothHFP || input.portType == .bluetoothA2DP {
                        print(" Bluetooth disconnected: \(input.portName)")
                        notifyFlutterBluetoothDevicesChanged()

                    }
                }
            }
            notifyFlutterAudioDevicesChanged()
            //          case .override:
            //            print("Audio device disconnected")
            //            notifyFlutterAudioDevicesChanged()
        default:
            break
        }
    }

    private func notifyFlutterAudioDevicesChanged() {
        DispatchQueue.main.async {
            self.eventSink?("audioDevicesChanged")
        }
    }
    private func notifyFlutterBluetoothDevicesChanged() {
        DispatchQueue.main.async {
            self.eventSink?("bluetoothAudioDevicesChanged")
        }
    }

    deinit {
        // Don't forget to remove the observer when it's no longer needed
        NotificationCenter.default.removeObserver(self)
    }
}
