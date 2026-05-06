import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/result.dart';
import 'models/xmari_preset.dart';
import 'xmari_ble_protocol.dart';

enum XmariDeviceState {
  disconnected,
  scanning,
  connecting,
  connected,
  reconnecting,
}

class XmariService {
  static const int _maxReconnectAttempts = 3;
  static const Duration _scanTimeout = Duration(seconds: 10);

  BluetoothDevice? _device;
  BluetoothCharacteristic? _presetChar;
  BluetoothCharacteristic? _batteryChar;

  final _stateController = StreamController<XmariDeviceState>.broadcast();
  final _batteryController = StreamController<int>.broadcast();
  final _presetController = StreamController<XmariPreset>.broadcast();

  XmariDeviceState _state = XmariDeviceState.disconnected;
  Timer? _batteryTimer;
  int _reconnectAttempts = 0;
  bool _disposed = false;

  Stream<XmariDeviceState> get connectionStateStream => _stateController.stream;
  Stream<int> get batteryStream => _batteryController.stream;
  Stream<XmariPreset> get presetStream => _presetController.stream;
  XmariDeviceState get state => _state;
  bool get isConnected => _state == XmariDeviceState.connected;

  void _setState(XmariDeviceState s) {
    _state = s;
    if (!_stateController.isClosed) _stateController.add(s);
  }

  Future<Result<BluetoothDevice>> scanForXmari() async {
    _setState(XmariDeviceState.scanning);
    try {
      await FlutterBluePlus.startScan(timeout: _scanTimeout);
      final results = await FlutterBluePlus.scanResults
          .firstWhere(
            (r) => r.any(_isXmari),
            orElse: () => [],
          )
          .timeout(_scanTimeout);
      await FlutterBluePlus.stopScan();

      final xmariResult = results.where(_isXmari).firstOrNull;
      if (xmariResult == null) {
        _setState(XmariDeviceState.disconnected);
        return const Failure(
          'Keine XMARI gefunden. Ist sie eingeschaltet und in Reichweite?',
        );
      }
      return Success(xmariResult.device);
    } catch (e) {
      _setState(XmariDeviceState.disconnected);
      return Failure('Scan fehlgeschlagen: $e', error: e);
    }
  }

  bool _isXmari(ScanResult r) {
    final name = r.device.platformName.toLowerCase();
    return name.contains('xmari') || name.contains('enya');
  }

  Future<Result<void>> connectToXmari(BluetoothDevice device) async {
    _setState(XmariDeviceState.connecting);
    try {
      await device.connect(timeout: const Duration(seconds: 15));
      _device = device;
      await _discoverServices(device);
      _setState(XmariDeviceState.connected);
      _reconnectAttempts = 0;
      _startBatteryPolling();
      _listenForDisconnect(device);
      return const Success(null);
    } catch (e) {
      _setState(XmariDeviceState.disconnected);
      return Failure('Verbindung fehlgeschlagen: $e', error: e);
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final char in service.characteristics) {
        final uuid = char.uuid.toString().toUpperCase();
        if (uuid.contains('FFF1')) _presetChar = char;
        if (uuid.contains('180F') || uuid.contains('2A19')) _batteryChar = char;
      }
    }
    debugPrint(
      'XmariService: presetChar=${_presetChar != null}, '
      'batteryChar=${_batteryChar != null}',
    );
  }

  void _listenForDisconnect(BluetoothDevice device) {
    device.connectionState.listen((connectionState) {
      if (connectionState == BluetoothConnectionState.disconnected &&
          !_disposed) {
        _setState(XmariDeviceState.disconnected);
        _batteryTimer?.cancel();
        _attemptReconnect(device);
      }
    });
  }

  Future<void> _attemptReconnect(BluetoothDevice device) async {
    if (_reconnectAttempts >= _maxReconnectAttempts || _disposed) return;
    _reconnectAttempts++;
    _setState(XmariDeviceState.reconnecting);
    final delay = Duration(seconds: 2 << (_reconnectAttempts - 1)); // 2s, 4s, 8s
    debugPrint(
      'XmariService: Reconnect attempt $_reconnectAttempts '
      'in ${delay.inSeconds}s',
    );
    await Future.delayed(delay);
    if (!_disposed) await connectToXmari(device);
  }

  Future<Result<void>> changePreset(int index) async {
    if (_presetChar == null) return const Failure('Nicht verbunden');
    try {
      final packet = XmariBleProtocol.encodePresetChange(index);
      await _presetChar!.write(packet, withoutResponse: false);
      _presetController.add(XmariPreset.defaults[index]);
      return const Success(null);
    } catch (e) {
      return Failure('Preset-Wechsel fehlgeschlagen: $e', error: e);
    }
  }

  Future<Result<void>> setPresetParameter(String param, double value) async {
    if (_presetChar == null) return const Failure('Nicht verbunden');
    try {
      final packet = XmariBleProtocol.encodePresetParameter(param, value);
      await _presetChar!.write(packet, withoutResponse: false);
      return const Success(null);
    } catch (e) {
      return Failure('Parameter-Update fehlgeschlagen: $e', error: e);
    }
  }

  Future<Result<int>> getBatteryLevel() async {
    if (_batteryChar == null) {
      return const Failure('Battery-Service nicht verfügbar');
    }
    try {
      final data = await _batteryChar!.read();
      final level = XmariBleProtocol.decodeBatteryLevel(data);
      _batteryController.add(level);
      return Success(level);
    } catch (e) {
      return Failure('Battery-Level nicht lesbar: $e', error: e);
    }
  }

  Future<Result<String>> getFirmwareVersion() async {
    try {
      return const Success('1.0.0'); // placeholder — read from firmware char
    } catch (e) {
      return Failure('Firmware-Version nicht lesbar: $e', error: e);
    }
  }

  void _startBatteryPolling() {
    _batteryTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      getBatteryLevel();
    });
  }

  Future<void> disconnect() async {
    _batteryTimer?.cancel();
    await _device?.disconnect();
    _device = null;
    _presetChar = null;
    _batteryChar = null;
    _setState(XmariDeviceState.disconnected);
  }

  void dispose() {
    _disposed = true;
    _batteryTimer?.cancel();
    _stateController.close();
    _batteryController.close();
    _presetController.close();
  }
}
