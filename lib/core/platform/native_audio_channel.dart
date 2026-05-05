import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

enum AudioSource { usb, microphone }

extension _AudioSourceX on AudioSource {
  String get nativeName {
    switch (this) {
      case AudioSource.usb:
        return 'usb';
      case AudioSource.microphone:
        return 'mic';
    }
  }
}

class UsbAudioDeviceInfo {
  final int? vendorId;
  final int? productId;
  final String? productName;
  final String? manufacturerName;
  final String? deviceName;

  const UsbAudioDeviceInfo({
    this.vendorId,
    this.productId,
    this.productName,
    this.manufacturerName,
    this.deviceName,
  });

  factory UsbAudioDeviceInfo.fromMap(Map<dynamic, dynamic> map) {
    return UsbAudioDeviceInfo(
      vendorId: map['vendorId'] is int ? map['vendorId'] as int : null,
      productId: map['productId'] is int ? map['productId'] as int : null,
      productName: map['productName'] as String?,
      manufacturerName: map['manufacturerName'] as String?,
      deviceName: map['deviceName'] as String?,
    );
  }

  @override
  String toString() =>
      'UsbAudioDeviceInfo(vendorId=$vendorId, productId=$productId, '
      'productName=$productName, manufacturerName=$manufacturerName, '
      'deviceName=$deviceName)';
}

class UsbConnectionEvent {
  final bool connected;
  final UsbAudioDeviceInfo? device;

  const UsbConnectionEvent({required this.connected, this.device});

  factory UsbConnectionEvent.fromMap(Map<dynamic, dynamic> map) {
    final rawDevice = map['device'];
    UsbAudioDeviceInfo? device;
    if (rawDevice is Map) {
      device = UsbAudioDeviceInfo.fromMap(rawDevice);
    }
    return UsbConnectionEvent(
      connected: map['connected'] == true,
      device: device,
    );
  }
}

class NativeAudioChannel {
  static const MethodChannel _methodChannel =
      MethodChannel('com.enya.gitarre_leicht/audio_input');
  static const EventChannel _audioStreamChannel =
      EventChannel('com.enya.gitarre_leicht/audio_input/stream');
  static const EventChannel _usbEventChannel =
      EventChannel('com.enya.gitarre_leicht/usb/events');

  Stream<Float32List>? _audioFrameStream;
  Stream<UsbConnectionEvent>? _usbEventsStream;

  Future<bool> isUsbAudioConnected() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>(
        'isUsbAudioConnected',
      );
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<UsbAudioDeviceInfo?> getUsbAudioDeviceInfo() async {
    try {
      final result = await _methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('getUsbAudioDeviceInfo');
      if (result == null) return null;
      return UsbAudioDeviceInfo.fromMap(result);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> startAudioCapture({
    required int sampleRate,
    required int bufferSize,
    required AudioSource source,
  }) async {
    try {
      await _methodChannel.invokeMethod<void>('startAudioCapture', {
        'sampleRate': sampleRate,
        'bufferSize': bufferSize,
        'sourceType': source.nativeName,
      });
    } on MissingPluginException {
      // Native channel unavailable; silently skip so app keeps running.
    }
  }

  Future<void> stopAudioCapture() async {
    try {
      await _methodChannel.invokeMethod<void>('stopAudioCapture');
    } on MissingPluginException {
      // ignore
    }
  }

  Stream<Float32List> get audioFrameStream {
    return _audioFrameStream ??= _audioStreamChannel
        .receiveBroadcastStream()
        .map<Float32List>((dynamic event) {
      if (event is Float32List) return event;
      if (event is Uint8List) {
        final byteData = ByteData.view(event.buffer, event.offsetInBytes,
            event.lengthInBytes);
        final count = event.lengthInBytes ~/ 4;
        final out = Float32List(count);
        for (var i = 0; i < count; i++) {
          out[i] = byteData.getFloat32(i * 4, Endian.little);
        }
        return out;
      }
      if (event is List) {
        return Float32List.fromList(event.cast<double>());
      }
      return Float32List(0);
    }).handleError((_) {
      // swallow errors so the stream keeps providing values when possible
    });
  }

  Stream<UsbConnectionEvent> get usbEvents {
    return _usbEventsStream ??= _usbEventChannel
        .receiveBroadcastStream()
        .map<UsbConnectionEvent>((dynamic event) {
      if (event is Map) {
        return UsbConnectionEvent.fromMap(event);
      }
      return const UsbConnectionEvent(connected: false);
    }).handleError((_) {
      // ignore stream errors so listeners aren't terminated
    });
  }
}
