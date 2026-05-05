import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../platform/native_audio_channel.dart';

enum ConnectionType {
  usbOtg,
  microphone,
  bluetooth,
  none,
}

extension ConnectionTypeExtension on ConnectionType {
  String get displayName {
    switch (this) {
      case ConnectionType.usbOtg:
        return 'USB OTG (Enya XMARI)';
      case ConnectionType.microphone:
        return 'Mikrofon';
      case ConnectionType.bluetooth:
        return 'Bluetooth';
      case ConnectionType.none:
        return 'Nicht verbunden';
    }
  }

  String get icon {
    switch (this) {
      case ConnectionType.usbOtg:
        return 'usb';
      case ConnectionType.microphone:
        return 'mic';
      case ConnectionType.bluetooth:
        return 'bluetooth';
      case ConnectionType.none:
        return 'mic_off';
    }
  }

  bool get isConnected => this != ConnectionType.none;
}

class AudioInputService {
  /// Known Enya vendor IDs. Update when official IDs are confirmed.
  static const Set<int> _enyaVendorIds = <int>{
    0x2E88, // tentative Enya vendor id
    0x1A86, // common XMARI USB-Audio bridge chipset
  };

  final AudioRecorder _recorder = AudioRecorder();
  final NativeAudioChannel _native = NativeAudioChannel();

  ConnectionType _currentConnectionType = ConnectionType.none;
  bool _isXmariConnected = false;
  UsbAudioDeviceInfo? _lastDeviceInfo;

  final StreamController<ConnectionType> _connectionController =
      StreamController<ConnectionType>.broadcast();

  StreamSubscription<UsbConnectionEvent>? _usbSub;
  Timer? _simulationTimer;

  Stream<ConnectionType> get connectionStream => _connectionController.stream;

  ConnectionType get currentConnectionType => _currentConnectionType;
  bool get isXmariConnected => _isXmariConnected;
  bool get isConnected => _currentConnectionType != ConnectionType.none;
  UsbAudioDeviceInfo? get lastUsbDeviceInfo => _lastDeviceInfo;

  /// Requests microphone permission and returns whether it was granted
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  /// Checks if microphone permission is granted
  Future<bool> hasMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  /// Initializes audio input and detects connection type
  Future<ConnectionType> initialize() async {
    final hasPermission = await requestMicrophonePermission();

    if (!hasPermission) {
      _setConnectionType(ConnectionType.none);
      return ConnectionType.none;
    }

    // Subscribe to native USB events (no-op on platforms without native channel).
    _usbSub ??= _native.usbEvents.listen(_handleUsbEvent);

    // Try to detect USB OTG (Enya XMARI) via native channel
    final isUsb = await _detectUsbOtg();
    if (isUsb) {
      _setConnectionType(ConnectionType.usbOtg);
      return ConnectionType.usbOtg;
    }

    // Fall back to microphone
    final hasMic = await _recorder.hasPermission();
    if (hasMic) {
      _setConnectionType(ConnectionType.microphone);
      return ConnectionType.microphone;
    }

    _setConnectionType(ConnectionType.none);
    return ConnectionType.none;
  }

  /// Starts monitoring for connection changes
  void startMonitoring() {
    _usbSub ??= _native.usbEvents.listen(_handleUsbEvent);
    _simulationTimer ??= Timer.periodic(const Duration(seconds: 5), (_) {
      _checkConnections();
    });
  }

  /// Stops monitoring
  void stopMonitoring() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _usbSub?.cancel();
    _usbSub = null;
  }

  /// Starts recording to a file
  Future<void> startRecording(String outputPath) async {
    final hasPermission = await hasMicrophonePermission();
    if (!hasPermission) return;

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: outputPath,
    );
  }

  /// Stops recording and returns the output path
  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  /// Returns whether recording is currently active
  Future<bool> get isRecording => _recorder.isRecording();

  /// Returns the amplitude level of the current audio input (0.0-1.0)
  Future<double> getAmplitude() async {
    try {
      final amp = await _recorder.getAmplitude();
      // Convert dBFS to 0-1 range (-160 dBFS = silent, 0 dBFS = max)
      final normalized = (amp.current + 160) / 160;
      return normalized.clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  /// Detects if USB OTG audio device (Enya XMARI) is connected via native code.
  Future<bool> _detectUsbOtg() async {
    final connected = await _native.isUsbAudioConnected();
    if (!connected) {
      _isXmariConnected = false;
      _lastDeviceInfo = null;
      return false;
    }

    final info = await _native.getUsbAudioDeviceInfo();
    _lastDeviceInfo = info;
    _isXmariConnected = _matchesXmari(info, hadUsbAudio: true);
    return true;
  }

  bool _matchesXmari(UsbAudioDeviceInfo? info, {required bool hadUsbAudio}) {
    if (info == null) {
      // We have a USB-Audio class device but no descriptor info; treat as
      // candidate XMARI since the manifest filter targets these.
      return hadUsbAudio;
    }
    final vendor = info.vendorId;
    if (vendor != null && _enyaVendorIds.contains(vendor)) return true;
    final name = (info.productName ?? info.manufacturerName ?? '')
        .toLowerCase();
    if (name.contains('xmari') || name.contains('enya')) return true;
    // Fall back: if the system reports a USB-Audio device at all, surface it
    // as USB-OTG so users can route audio through it.
    return hadUsbAudio;
  }

  void _handleUsbEvent(UsbConnectionEvent event) {
    if (event.connected) {
      _lastDeviceInfo = event.device;
      _isXmariConnected = _matchesXmari(event.device, hadUsbAudio: true);
      _setConnectionType(ConnectionType.usbOtg);
    } else {
      _isXmariConnected = false;
      _lastDeviceInfo = null;
      // Fall back to microphone if we currently consider USB the source.
      if (_currentConnectionType == ConnectionType.usbOtg) {
        _setConnectionType(ConnectionType.microphone);
      }
    }
  }

  void _checkConnections() async {
    final isUsb = await _detectUsbOtg();

    if (isUsb && _currentConnectionType != ConnectionType.usbOtg) {
      _setConnectionType(ConnectionType.usbOtg);
    } else if (!isUsb && _currentConnectionType == ConnectionType.usbOtg) {
      _setConnectionType(ConnectionType.microphone);
    }
  }

  void _setConnectionType(ConnectionType type) {
    _currentConnectionType = type;
    if (!_connectionController.isClosed) {
      _connectionController.add(type);
    }
  }

  /// Returns the input device name
  String get inputDeviceName {
    switch (_currentConnectionType) {
      case ConnectionType.usbOtg:
        return _lastDeviceInfo?.productName ?? 'Enya XMARI Smart Guitar';
      case ConnectionType.microphone:
        return 'Eingebautes Mikrofon';
      case ConnectionType.bluetooth:
        return 'Bluetooth-Mikrofon';
      case ConnectionType.none:
        return 'Kein Gerät';
    }
  }

  void dispose() {
    stopMonitoring();
    _recorder.dispose();
    _connectionController.close();
  }
}
