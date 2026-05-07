import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audio/hands_free_service.dart';

final handsFreeServiceProvider = Provider<HandsFreeService>((ref) {
  final svc = HandsFreeService();
  ref.onDispose(() => svc.dispose());
  return svc;
});

final handsFreeModeProvider = StateProvider<HandsFreeMode>((ref) => HandsFreeMode.off);

class HandsFreeOverlay extends ConsumerWidget {
  const HandsFreeOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(handsFreeModeProvider);

    return Positioned(
      right: 12,
      bottom: 12,
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 88),
        child: GestureDetector(
          onTap: () => _showModeSheet(context, ref),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mode != HandsFreeMode.off
                  ? const Color(0xFF7C3AED).withOpacity(0.9)
                  : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForMode(mode),
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForMode(HandsFreeMode mode) {
    switch (mode) {
      case HandsFreeMode.off:
        return Icons.do_not_touch;
      case HandsFreeMode.voice:
        return Icons.mic;
      case HandsFreeMode.doubleTap:
        return Icons.touch_app;
      case HandsFreeMode.volumeButton:
        return Icons.volume_up;
    }
  }

  void _showModeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hands-Free-Steuerung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Steuere die App ohne die Hände von der XMARI zu nehmen',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ...HandsFreeMode.values.map((m) => _ModeTile(mode: m, ctx: ctx)),
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends ConsumerWidget {
  final HandsFreeMode mode;
  final BuildContext ctx;
  const _ModeTile({required this.mode, required this.ctx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(handsFreeModeProvider);
    final isSelected = current == mode;
    return ListTile(
      leading: Icon(_icon, color: isSelected ? const Color(0xFF7C3AED) : null),
      title: Text(_label),
      subtitle: Text(_description, style: const TextStyle(fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF7C3AED)) : null,
      onTap: () async {
        ref.read(handsFreeModeProvider.notifier).state = mode;
        await ref.read(handsFreeServiceProvider).setMode(mode);
        Navigator.pop(ctx);
      },
    );
  }

  IconData get _icon {
    switch (mode) {
      case HandsFreeMode.off:
        return Icons.do_not_touch;
      case HandsFreeMode.voice:
        return Icons.mic;
      case HandsFreeMode.doubleTap:
        return Icons.touch_app;
      case HandsFreeMode.volumeButton:
        return Icons.volume_up;
    }
  }

  String get _label {
    switch (mode) {
      case HandsFreeMode.off:
        return 'Aus';
      case HandsFreeMode.voice:
        return 'Sprachsteuerung';
      case HandsFreeMode.doubleTap:
        return 'Doppel-Tap';
      case HandsFreeMode.volumeButton:
        return 'Lautstärke-Tasten';
    }
  }

  String get _description {
    switch (mode) {
      case HandsFreeMode.off:
        return 'Manuelle Bedienung';
      case HandsFreeMode.voice:
        return '"Weiter", "Zurück", "Stopp" – Mikrofon ist frei wenn XMARI via USB-C!';
      case HandsFreeMode.doubleTap:
        return '2× Tippen = Weiter, 3× = Zurück, Halten = Start/Stopp';
      case HandsFreeMode.volumeButton:
        return 'Vol+ = Weiter, Vol- = Zurück (Android)';
    }
  }
}
