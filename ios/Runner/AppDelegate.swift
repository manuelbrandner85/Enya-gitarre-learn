import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let methodChannelName = "com.enya.gitarre_leicht/audio_input"
  private let audioStreamChannelName = "com.enya.gitarre_leicht/audio_input/stream"
  private let usbEventChannelName = "com.enya.gitarre_leicht/usb/events"

  private var audioEventSink: FlutterEventSink?
  private var usbEventSink: FlutterEventSink?

  private let audioEngine = AVAudioEngine()
  private var isCapturing = false

  private let captureQueue = DispatchQueue(label: "com.enya.gitarre_leicht.capture",
                                           qos: .userInitiated)

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    let messenger = controller.binaryMessenger

    let methodChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: messenger)
    methodChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {
      case "isUsbAudioConnected":
        result(self.isUsbAudioConnected())
      case "getUsbAudioDeviceInfo":
        result(self.getUsbAudioDeviceInfo())
      case "startAudioCapture":
        let args = call.arguments as? [String: Any] ?? [:]
        let sampleRate = args["sampleRate"] as? Int ?? 44100
        let bufferSize = args["bufferSize"] as? Int ?? 1024
        let sourceType = args["sourceType"] as? String ?? "mic"
        do {
          try self.startAudioCapture(sampleRate: Double(sampleRate),
                                     bufferSize: AVAudioFrameCount(bufferSize),
                                     sourceType: sourceType)
          result(true)
        } catch {
          result(FlutterError(code: "AUDIO_START",
                              message: error.localizedDescription, details: nil))
        }
      case "stopAudioCapture":
        self.stopAudioCapture()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    let audioEvents = FlutterEventChannel(name: audioStreamChannelName, binaryMessenger: messenger)
    audioEvents.setStreamHandler(AudioStreamHandler(owner: self))

    let usbEvents = FlutterEventChannel(name: usbEventChannelName, binaryMessenger: messenger)
    usbEvents.setStreamHandler(UsbEventsHandler(owner: self))

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Inputs

  fileprivate func usbInputs() -> [AVAudioSessionPortDescription] {
    let session = AVAudioSession.sharedInstance()
    let inputs = session.availableInputs ?? []
    return inputs.filter { $0.portType == .usbAudio }
  }

  fileprivate func isUsbAudioConnected() -> Bool {
    return !usbInputs().isEmpty
  }

  fileprivate func getUsbAudioDeviceInfo() -> [String: Any]? {
    guard let port = usbInputs().first else { return nil }
    var map: [String: Any] = [:]
    map["productName"] = port.portName
    map["deviceName"] = port.portName
    map["manufacturerName"] = NSNull()
    map["uid"] = port.uid
    map["vendorId"] = NSNull()
    map["productId"] = NSNull()
    if let sources = port.dataSources {
      map["dataSources"] = sources.map { ["id": $0.dataSourceID, "name": $0.dataSourceName] }
    } else {
      map["dataSources"] = []
    }
    return map
  }

  // MARK: - Audio capture

  fileprivate func startAudioCapture(sampleRate: Double,
                                     bufferSize: AVAudioFrameCount,
                                     sourceType: String) throws {
    if isCapturing { return }

    let session = AVAudioSession.sharedInstance()
    try session.setCategory(.playAndRecord,
                            mode: .measurement,
                            options: [.allowBluetooth, .defaultToSpeaker, .mixWithOthers])
    try session.setPreferredSampleRate(sampleRate)

    if sourceType == "usb", let usb = usbInputs().first {
      try? session.setPreferredInput(usb)
    }

    try session.setActive(true, options: [])

    let input = audioEngine.inputNode
    let hwFormat = input.inputFormat(forBus: 0)

    input.removeTap(onBus: 0)
    input.installTap(onBus: 0, bufferSize: bufferSize, format: hwFormat) { [weak self] buffer, _ in
      guard let self = self else { return }
      self.captureQueue.async {
        self.dispatchBuffer(buffer)
      }
    }

    audioEngine.prepare()
    try audioEngine.start()
    isCapturing = true
  }

  private func dispatchBuffer(_ buffer: AVAudioPCMBuffer) {
    let frameLength = Int(buffer.frameLength)
    if frameLength == 0 { return }

    var floats = [Float](repeating: 0, count: frameLength)

    if let floatChannelData = buffer.floatChannelData {
      let ptr = floatChannelData[0]
      for i in 0..<frameLength { floats[i] = ptr[i] }
    } else if let int16ChannelData = buffer.int16ChannelData {
      let ptr = int16ChannelData[0]
      for i in 0..<frameLength { floats[i] = Float(ptr[i]) / 32768.0 }
    } else if let int32ChannelData = buffer.int32ChannelData {
      let ptr = int32ChannelData[0]
      for i in 0..<frameLength { floats[i] = Float(ptr[i]) / Float(Int32.max) }
    } else {
      return
    }

    let data = floats.withUnsafeBufferPointer { Data(buffer: $0) }
    DispatchQueue.main.async { [weak self] in
      self?.audioEventSink?(FlutterStandardTypedData(bytes: data))
    }
  }

  fileprivate func stopAudioCapture() {
    if isCapturing {
      audioEngine.inputNode.removeTap(onBus: 0)
      audioEngine.stop()
      isCapturing = false
    }
    try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
  }

  // MARK: - Route observation

  fileprivate func startObservingRoute() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleRouteChange(_:)),
      name: AVAudioSession.routeChangeNotification,
      object: nil)
  }

  fileprivate func stopObservingRoute() {
    NotificationCenter.default.removeObserver(self,
      name: AVAudioSession.routeChangeNotification, object: nil)
  }

  @objc private func handleRouteChange(_ notification: Notification) {
    let session = AVAudioSession.sharedInstance()
    let inputs = session.currentRoute.inputs
    let usbConnected = inputs.contains { $0.portType == .usbAudio }

    var devicePayload: Any = NSNull()
    if usbConnected, let info = getUsbAudioDeviceInfo() {
      devicePayload = info
    }
    let payload: [String: Any] = [
      "connected": usbConnected,
      "device": devicePayload
    ]
    DispatchQueue.main.async { [weak self] in
      self?.usbEventSink?(payload)
    }
  }

  // MARK: - Stream handlers

  private class AudioStreamHandler: NSObject, FlutterStreamHandler {
    weak var owner: AppDelegate?
    init(owner: AppDelegate) { self.owner = owner }
    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      owner?.audioEventSink = events
      return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
      owner?.audioEventSink = nil
      return nil
    }
  }

  private class UsbEventsHandler: NSObject, FlutterStreamHandler {
    weak var owner: AppDelegate?
    init(owner: AppDelegate) { self.owner = owner }
    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      owner?.usbEventSink = events
      owner?.startObservingRoute()
      return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
      owner?.stopObservingRoute()
      owner?.usbEventSink = nil
      return nil
    }
  }
}
