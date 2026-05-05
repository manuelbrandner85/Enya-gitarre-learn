import 'dart:async';
import 'package:flutter/services.dart';
import '../models/audio_device.dart';

class AudioInputChannel {
  static const _channel = MethodChannel('com.enya_gitarre_leicht/audio_input');
  static const _eventChannel = EventChannel('com.enya_gitarre_leicht/audio_input_events');

  Future<List<AudioDevice>> getAvailableAudioDevices() async {
    try {
      final raw = await _channel.invokeMethod<List>('getAvailableAudioDevices');
      return (raw ?? [])
          .cast<Map>()
          .map((m) => AudioDevice.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> setAudioSource(AudioSourceType type) async {
    try {
      return await _channel.invokeMethod<bool>('setAudioSource', {'type': type.name}) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isUsbAudioAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isUsbAudioAvailable') ?? false;
    } catch (_) {
      return false;
    }
  }

  Stream<AudioDeviceEvent> get onDeviceChanged {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) {
          final m = Map<String, dynamic>.from(event as Map);
          return AudioDeviceEvent(
            device: AudioDevice.fromMap(Map<String, dynamic>.from(m['device'] as Map)),
            eventType: m['eventType'] == 'connected'
                ? AudioDeviceEventType.connected
                : AudioDeviceEventType.disconnected,
          );
        });
  }
}
