import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

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
  final AudioRecorder _recorder = AudioRecorder();
  ConnectionType _currentConnectionType = ConnectionType.none;
  bool _isXmariConnected = false;

  final StreamController<ConnectionType> _connectionController =
      StreamController<ConnectionType>.broadcast();

  // For development simulation
  Timer? _simulationTimer;

  Stream<ConnectionType> get connectionStream => _connectionController.stream;

  ConnectionType get currentConnectionType => _currentConnectionType;
  bool get isXmariConnected => _isXmariConnected;
  bool get isConnected => _currentConnectionType != ConnectionType.none;

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

    // Try to detect USB OTG (Enya XMARI)
    final isUsb = await _detectUsbOtg();
    if (isUsb) {
      _isXmariConnected = true;
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
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkConnections();
    });
  }

  /// Stops monitoring
  void stopMonitoring() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
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

  /// Detects if USB OTG audio device is connected (platform channel simulation)
  Future<bool> _detectUsbOtg() async {
    // In a real implementation, this would use platform channels to check
    // if a USB audio device matching Enya XMARI is connected.
    // For now, simulate as not connected.
    return false;
  }

  void _checkConnections() async {
    final isUsb = await _detectUsbOtg();

    if (isUsb && _currentConnectionType != ConnectionType.usbOtg) {
      _isXmariConnected = true;
      _setConnectionType(ConnectionType.usbOtg);
    } else if (!isUsb && _currentConnectionType == ConnectionType.usbOtg) {
      _isXmariConnected = false;
      _setConnectionType(ConnectionType.microphone);
    }
  }

  void _setConnectionType(ConnectionType type) {
    _currentConnectionType = type;
    _connectionController.add(type);
  }

  /// Returns the input device name
  String get inputDeviceName {
    switch (_currentConnectionType) {
      case ConnectionType.usbOtg:
        return 'Enya XMARI Smart Guitar';
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
