enum AudioSourceType { usb, microphone, bluetooth, builtin }
enum AudioDeviceEventType { connected, disconnected }

class AudioDevice {
  final String id;
  final String name;
  final AudioSourceType type;
  final bool isConnected;
  final int sampleRate;
  final int channelCount;

  const AudioDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isConnected,
    this.sampleRate = 44100,
    this.channelCount = 1,
  });

  factory AudioDevice.fromMap(Map<String, dynamic> m) => AudioDevice(
    id: m['id'] as String? ?? '',
    name: m['name'] as String? ?? 'Unbekannt',
    type: AudioSourceType.values.firstWhere(
      (t) => t.name == (m['type'] as String? ?? 'builtin'),
      orElse: () => AudioSourceType.builtin,
    ),
    isConnected: m['isConnected'] as bool? ?? false,
    sampleRate: m['sampleRate'] as int? ?? 44100,
    channelCount: m['channelCount'] as int? ?? 1,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'type': type.name,
    'isConnected': isConnected, 'sampleRate': sampleRate,
    'channelCount': channelCount,
  };

  bool get isXmari => name.toLowerCase().contains('xmari') ||
      name.toLowerCase().contains('enya');
}

class AudioDeviceEvent {
  final AudioDevice device;
  final AudioDeviceEventType eventType;
  const AudioDeviceEvent({required this.device, required this.eventType});
}
