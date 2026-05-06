import Flutter
import AVFoundation

class AudioInputPlugin: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.enya_gitarre_leicht/audio_input",
            binaryMessenger: registrar.messenger()
        )
        let instance = AudioInputPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Listen for audio route changes
        NotificationCenter.default.addObserver(
            instance,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isUsbAudioAvailable":
            let session = AVAudioSession.sharedInstance()
            let hasUsb = session.availableInputs?.contains {
                $0.portType == .usbAudio
            } ?? false
            result(hasUsb)
        case "getAvailableAudioDevices":
            let inputs = AVAudioSession.sharedInstance().availableInputs ?? []
            let devices = inputs.map { input -> [String: Any] in
                let type: String
                switch input.portType {
                case .usbAudio: type = "usb"
                case .bluetoothHFP, .bluetoothLE: type = "bluetooth"
                case .builtInMic: type = "builtin"
                default: type = "microphone"
                }
                return [
                    "id": input.uid,
                    "name": input.portName,
                    "type": type,
                    "isConnected": true,
                    "sampleRate": 44100,
                    "channelCount": 1
                ]
            }
            result(devices)
        case "setAudioSource":
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @objc func handleRouteChange(notification: Notification) {
        // Route change handling - notify Flutter via EventChannel if needed
    }
}
