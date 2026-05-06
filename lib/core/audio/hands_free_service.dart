import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum HandsFreeCommand { next, back, start, stop, repeat, skip, help }
enum HandsFreeMode { off, voice, doubleTap, volumeButton }

class HandsFreeService {
  final SpeechToText _speech = SpeechToText();
  final StreamController<HandsFreeCommand> _commandController =
      StreamController<HandsFreeCommand>.broadcast();
  HandsFreeMode _mode = HandsFreeMode.off;
  bool _isListening = false;

  Stream<HandsFreeCommand> get commandStream => _commandController.stream;
  HandsFreeMode get currentMode => _mode;
  bool get isListening => _isListening;

  static const Map<String, HandsFreeCommand> _keywords = {
    'weiter': HandsFreeCommand.next,
    'next': HandsFreeCommand.next,
    'zurück': HandsFreeCommand.back,
    'back': HandsFreeCommand.back,
    'start': HandsFreeCommand.start,
    'stopp': HandsFreeCommand.stop,
    'stop': HandsFreeCommand.stop,
    'nochmal': HandsFreeCommand.repeat,
    'wiederholen': HandsFreeCommand.repeat,
    'überspringen': HandsFreeCommand.skip,
    'hilfe': HandsFreeCommand.help,
    'help': HandsFreeCommand.help,
  };

  Future<void> setMode(HandsFreeMode mode) async {
    await _stopCurrent();
    _mode = mode;
    if (mode == HandsFreeMode.voice) {
      await _startVoice();
    }
  }

  Future<void> _startVoice() async {
    final available = await _speech.initialize(
      onError: (e) => debugPrint('HandsFreeService STT error: $e'),
    );
    if (!available) return;
    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        if (!result.finalResult) return;
        final words = result.recognizedWords.toLowerCase();
        for (final entry in _keywords.entries) {
          if (words.contains(entry.key)) {
            _commandController.add(entry.value);
            break;
          }
        }
      },
      listenFor: const Duration(hours: 1),
      pauseFor: const Duration(seconds: 3),
      listenMode: ListenMode.dictation,
      localeId: 'de_DE',
    );
  }

  Future<void> _stopCurrent() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  void handleTap(int tapCount) {
    if (_mode != HandsFreeMode.doubleTap) return;
    if (tapCount == 2) _commandController.add(HandsFreeCommand.next);
    if (tapCount == 3) _commandController.add(HandsFreeCommand.back);
  }

  void handleLongPress() {
    if (_mode != HandsFreeMode.doubleTap) return;
    _commandController.add(HandsFreeCommand.start);
  }

  Future<void> dispose() async {
    await _stopCurrent();
    await _commandController.close();
  }
}
