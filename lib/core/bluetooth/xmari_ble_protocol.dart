import 'dart:typed_data';

import 'models/xmari_preset.dart';

/// BLE Protocol for Enya XMARI Smart Guitar.
///
/// WICHTIG: Die UUIDs sind Platzhalter. Die echten UUIDs müssen über
/// BLE-Sniffing der originalen Enya Music App ermittelt werden
/// (z.B. mit nRF Connect App oder Wireshark auf einem gerooteten Gerät).
class XmariBleProtocol {
  XmariBleProtocol._();

  // ── Service & Characteristic UUIDs (Platzhalter) ──────────────────────
  static const String serviceUuid =
      '0000FFF0-0000-1000-8000-00805f9b34fb'; // Guitar control service
  static const String presetCharacteristicUuid =
      '0000FFF1-0000-1000-8000-00805f9b34fb'; // Preset read/write
  static const String batteryCharacteristicUuid =
      '0000180F-0000-1000-8000-00805f9b34fb'; // Standard BLE Battery Service
  static const String firmwareCharacteristicUuid =
      '0000180A-0000-1000-8000-00805f9b34fb'; // Device Information Service
  static const String notifyCharacteristicUuid =
      '0000FFF2-0000-1000-8000-00805f9b34fb'; // Notifications from guitar

  // ── Packet Format ──────────────────────────────────────────────────────
  // Byte 0: Command type
  // Byte 1: Payload length
  // Bytes 2+: Payload
  // Last byte: XOR checksum of all preceding bytes

  static const int cmdPresetChange = 0x01;
  static const int cmdPresetParam  = 0x02;
  static const int cmdGetBattery   = 0x10;
  static const int cmdGetFirmware  = 0x11;

  static Uint8List encodePresetChange(int presetIndex) {
    assert(presetIndex >= 0 && presetIndex <= 3);
    return _buildPacket(cmdPresetChange, Uint8List.fromList([presetIndex]));
  }

  static Uint8List encodePresetParameter(String param, double value) {
    final paramId = _paramId(param);
    final valByte = (value.clamp(0.0, 1.0) * 255).round();
    return _buildPacket(cmdPresetParam, Uint8List.fromList([paramId, valByte]));
  }

  static XmariPreset decodePresetData(List<int> data) {
    if (data.length < 5) return XmariPreset.defaults[0];
    return XmariPreset(
      index: data[0] & 0x03,
      name: _presetName(data[0] & 0x03),
      gain: data[1] / 255.0,
      tone: data[2] / 255.0,
      volume: data[3] / 255.0,
      effectType: XmariEffectType.values[data[4].clamp(0, 3)],
    );
  }

  static int decodeBatteryLevel(List<int> data) {
    if (data.isEmpty) return -1;
    return data[0].clamp(0, 100);
  }

  static String decodeFirmwareVersion(List<int> data) {
    if (data.length < 3) return '?.?.?';
    return '${data[0]}.${data[1]}.${data[2]}';
  }

  // ── Private helpers ────────────────────────────────────────────────────
  static Uint8List _buildPacket(int cmd, Uint8List payload) {
    final packet = Uint8List(3 + payload.length);
    packet[0] = cmd;
    packet[1] = payload.length;
    packet.setRange(2, 2 + payload.length, payload);
    int checksum = 0;
    for (int i = 0; i < packet.length - 1; i++) checksum ^= packet[i];
    packet[packet.length - 1] = checksum;
    return packet;
  }

  static int _paramId(String param) => switch (param) {
    'gain'   => 0x01,
    'tone'   => 0x02,
    'volume' => 0x03,
    'reverb' => 0x04,
    'delay'  => 0x05,
    _        => 0x00,
  };

  static String _presetName(int index) => switch (index) {
    0 => 'Clean',
    1 => 'Overdrive',
    2 => 'Distortion',
    3 => 'High Gain',
    _ => 'Custom',
  };
}
