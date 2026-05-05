import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audio/models/audio_device.dart';
import '../providers/app_providers.dart';
import '../../app/theme/colors.dart';

final audioSourceProvider = StateProvider<AudioSourceType>((ref) => AudioSourceType.microphone);

class AudioSourceIndicator extends ConsumerWidget {
  const AudioSourceIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(audioSourceProvider);
    final (label, color, icon) = switch (source) {
      AudioSourceType.usb => ('USB (XMARI)', AppColors.success, Icons.usb),
      AudioSourceType.bluetooth => ('Bluetooth', AppColors.warning, Icons.bluetooth),
      AudioSourceType.microphone => ('Mikrofon', AppColors.textSecondary, Icons.mic),
      AudioSourceType.builtin => ('Eingebaut', AppColors.textSecondary, Icons.mic_none),
    };

    return GestureDetector(
      onTap: () => _showSourceSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  void _showSourceSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Audio-Eingang wählen',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          for (final src in AudioSourceType.values)
            ListTile(
              leading: Icon(_iconFor(src)),
              title: Text(_labelFor(src)),
              onTap: () {
                ref.read(audioSourceProvider.notifier).state = src;
                Navigator.pop(context);
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _iconFor(AudioSourceType s) => switch (s) {
    AudioSourceType.usb => Icons.usb,
    AudioSourceType.bluetooth => Icons.bluetooth,
    AudioSourceType.microphone => Icons.mic,
    AudioSourceType.builtin => Icons.mic_none,
  };

  String _labelFor(AudioSourceType s) => switch (s) {
    AudioSourceType.usb => 'USB (Enya XMARI)',
    AudioSourceType.bluetooth => 'Bluetooth',
    AudioSourceType.microphone => 'Eingebautes Mikrofon',
    AudioSourceType.builtin => 'Gerät-Mikrofon',
  };
}
