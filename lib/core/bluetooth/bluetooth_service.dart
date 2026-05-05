import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

import '../utils/constants.dart';

enum XmariConnectionState {
  unknown,
  unavailable,
  unauthorized,
  turningOn,
  turningOff,
  on,
  off,
  connecting,
  connected,
  disconnecting,
  disconnected,
}

extension XmariConnectionStateExtension on XmariConnectionState {
  String get displayName {
    switch (this) {
      case XmariConnectionState.unknown:
        return 'Unbekannt';
      case XmariConnectionState.unavailable:
        return 'Nicht verfügbar';
      case XmariConnectionState.unauthorized:
        return 'Keine Berechtigung';
      case XmariConnectionState.turningOn:
        return 'Wird aktiviert...';
      case XmariConnectionState.turningOff:
        return 'Wird deaktiviert...';
      case XmariConnectionState.on:
        return 'Bereit';
      case XmariConnectionState.off:
        return 'Deaktiviert';
      case XmariConnectionState.connecting:
        return 'Verbinde...';
      case XmariConnectionState.connected:
        return 'Verbunden';
      case XmariConnectionState.disconnecting:
        return 'Trenne Verbindung...';
      case XmariConnectionState.disconnected:
        return 'Getrennt';
    }
  }

  bool get isConnected => this == XmariConnectionState.connected;
  bool get isConnecting => this == XmariConnectionState.connecting;
  bool get isReady =>
      this == XmariConnectionState.on || isConnected;
}

class DiscoveredXmariDevice {
  final String id;
  final String name;
  final int rssi;
  final fbp.BluetoothDevice nativeDevice;

  const DiscoveredXmariDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.nativeDevice,
  });

  bool get isXmari =>
      name.startsWith(AppConstants.xmariDeviceNamePrefix) ||
      name.toLowerCase().contains('xmari');
}

class AppBluetoothService {
  final StreamController<XmariConnectionState> _stateController =
      StreamController<XmariConnectionState>.broadcast();
  final StreamController<List<DiscoveredXmariDevice>> _devicesController =
      StreamController<List<DiscoveredXmariDevice>>.broadcast();

  fbp.BluetoothDevice? _connectedDevice;
  XmariConnectionState _currentState = XmariConnectionState.unknown;

  StreamSubscription<fbp.BluetoothAdapterState>? _adapterSubscription;
  StreamSubscription<List<fbp.ScanResult>>? _scanSubscription;

  Stream<XmariConnectionState> get stateStream => _stateController.stream;
  Stream<List<DiscoveredXmariDevice>> get devicesStream =>
      _devicesController.stream;

  bool get isConnected => _currentState == XmariConnectionState.connected;
  String? get connectedDeviceName => _connectedDevice?.platformName;
  XmariConnectionState get currentState => _currentState;

  /// Initializes the Bluetooth service and subscribes to adapter state
  Future<void> initialize() async {
    _adapterSubscription =
        fbp.FlutterBluePlus.adapterState.listen((adapterState) {
      switch (adapterState) {
        case fbp.BluetoothAdapterState.on:
          _setState(XmariConnectionState.on);
          break;
        case fbp.BluetoothAdapterState.off:
          _setState(XmariConnectionState.off);
          break;
        case fbp.BluetoothAdapterState.turningOn:
          _setState(XmariConnectionState.turningOn);
          break;
        case fbp.BluetoothAdapterState.turningOff:
          _setState(XmariConnectionState.turningOff);
          break;
        case fbp.BluetoothAdapterState.unavailable:
          _setState(XmariConnectionState.unavailable);
          break;
        case fbp.BluetoothAdapterState.unauthorized:
          _setState(XmariConnectionState.unauthorized);
          break;
        default:
          _setState(XmariConnectionState.unknown);
      }
    });
  }

  /// Scans for nearby Enya XMARI devices
  Future<void> scanForXmari() async {
    if (!_currentState.isReady) return;

    final foundDevices = <DiscoveredXmariDevice>[];

    try {
      await fbp.FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        withServices: [],
      );

      _scanSubscription = fbp.FlutterBluePlus.scanResults.listen((results) {
        foundDevices.clear();

        for (final result in results) {
          final device = DiscoveredXmariDevice(
            id: result.device.remoteId.str,
            name: result.device.platformName.isNotEmpty
                ? result.device.platformName
                : 'Unbekanntes Gerät',
            rssi: result.rssi,
            nativeDevice: result.device,
          );
          foundDevices.add(device);
        }

        _devicesController.add(List.from(foundDevices));
      });
    } catch (e) {
      // Bluetooth may not be available in simulator
    }
  }

  /// Stops scanning for devices
  Future<void> stopScan() async {
    await fbp.FlutterBluePlus.stopScan();
    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  /// Connects to a device by its ID
  Future<bool> connect(String deviceId) async {
    try {
      _setState(XmariConnectionState.connecting);

      final device = fbp.BluetoothDevice.fromId(deviceId);
      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      _connectedDevice = device;
      _setState(XmariConnectionState.connected);

      // Listen for disconnection
      device.connectionState.listen((state) {
        if (state == fbp.BluetoothConnectionState.disconnected) {
          _connectedDevice = null;
          _setState(XmariConnectionState.disconnected);
        }
      });

      return true;
    } catch (e) {
      _connectedDevice = null;
      _setState(XmariConnectionState.disconnected);
      return false;
    }
  }

  /// Disconnects from the currently connected device
  Future<void> disconnect() async {
    try {
      _setState(XmariConnectionState.disconnecting);
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      _setState(XmariConnectionState.disconnected);
    } catch (e) {
      _connectedDevice = null;
      _setState(XmariConnectionState.disconnected);
    }
  }

  void _setState(XmariConnectionState state) {
    _currentState = state;
    _stateController.add(state);
  }

  void dispose() {
    _adapterSubscription?.cancel();
    _scanSubscription?.cancel();
    _stateController.close();
    _devicesController.close();
    disconnect();
  }
}
