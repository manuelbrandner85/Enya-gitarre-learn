import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Hands-Free Steuer-Befehle.
enum HandsFreeCommand { next, back, start, stop, repeat, skip, help }

/// Hands-Free Modi.
enum HandsFreeMode { off, voice, doubleTap, volumeButton }

/// Vollwertige Hands-Free-Service-Implementierung mit drei Modi:
///
///   * voice: speech_to_text de_DE, Fuzzy-Keyword-Matching, Auto-Restart
///   * doubleTap: 2× = next, 3× = back, Long-Press = start
///   * volumeButton: HardwareKeyboard Volume-Up = next, Volume-Down = back
class HandsFreeService {
  final SpeechToText _speech = SpeechToText();
  final StreamController<HandsFreeCommand> _commandController =
      StreamController<HandsFreeCommand>.broadcast();
  final StreamController<String> _recognizedTextController =
      StreamController<String>.broadcast();

  HandsFreeMode _mode = HandsFreeMode.off;
  bool _isListening = false;
  String _lastRecognizedText = '';
  Timer? _restartTimer;

  Stream<HandsFreeCommand> get commandStream => _commandController.stream;
  Stream<String> get recognizedTextStream => _recognizedTextController.stream;
  HandsFreeMode get currentMode => _mode;
  bool get isListening => _isListening;
  String get lastRecognizedText => _lastRecognizedText;

  /// Keyword-Mapping (case-insensitive). Wenn das erkannte Sprach-Ergebnis
  /// einen dieser Strings enthält, wird der zugeordnete Befehl emittiert.
  static const Map<String, HandsFreeCommand> _keywords = {
    'weiter': HandsFreeCommand.next,
    'nächste': HandsFreeCommand.next,
    'next': HandsFreeCommand.next,
    'zurück': HandsFreeCommand.back,
    'back': HandsFreeCommand.back,
    'vorherige': HandsFreeCommand.back,
    'start': HandsFreeCommand.start,
    'starten': HandsFreeCommand.start,
    'go': HandsFreeCommand.start,
    'stopp': HandsFreeCommand.stop,
    'halt': HandsFreeCommand.stop,
    'stop': HandsFreeCommand.stop,
    'nochmal': HandsFreeCommand.repeat,
    'wiederholen': HandsFreeCommand.repeat,
    'repeat': HandsFreeCommand.repeat,
    'überspringen': HandsFreeCommand.skip,
    'skip': HandsFreeCommand.skip,
    'hilfe': HandsFreeCommand.help,
    'help': HandsFreeCommand.help,
  };

  /// Setzt den Modus und (re-)startet ggf. nötige Listener.
  Future<void> setMode(HandsFreeMode mode) async {
    await _stopCurrent();
    _mode = mode;
    switch (mode) {
      case HandsFreeMode.voice:
        await _startVoice();
        break;
      case HandsFreeMode.volumeButton:
        _startVolumeButtonListener();
        break;
      case HandsFreeMode.doubleTap:
        // Nichts zu starten – die UI ruft `handleTap`/`handleLongPress` auf.
        break;
      case HandsFreeMode.off:
        break;
    }
  }

  // ── Voice-Modus ────────────────────────────────────────────────────────────

  Future<void> _startVoice() async {
    final available = await _speech.initialize(
      onError: (e) {
        debugPrint('HandsFreeService STT-Fehler: $e');
        // Bei Fehler nach kurzer Pause neu versuchen
        _scheduleRestart();
      },
      onStatus: (status) {
        // Bei done/notListening neu starten, solange wir im Voice-Modus sind
        if (status == 'done' || status == 'notListening') {
          if (_mode == HandsFreeMode.voice) _scheduleRestart();
        }
      },
    );
    if (!available) {
      debugPrint('HandsFreeService: speech_to_text nicht verfügbar');
      return;
    }
    await _listen();
  }

  Future<void> _listen() async {
    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords.toLowerCase();
        _lastRecognizedText = words;
        _recognizedTextController.add(words);
        if (!result.finalResult) return;
        for (final entry in _keywords.entries) {
          if (words.contains(entry.key)) {
            _commandController.add(entry.value);
            break;
          }
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
      ),
      localeId: 'de_DE',
    );
  }

  void _scheduleRestart() {
    _restartTimer?.cancel();
    _restartTimer = Timer(const Duration(milliseconds: 800), () async {
      if (_mode == HandsFreeMode.voice) {
        await _listen();
      }
    });
  }

  // ── Double-Tap-Modus ───────────────────────────────────────────────────────

  void handleTap(int tapCount) {
    if (_mode != HandsFreeMode.doubleTap) return;
    if (tapCount == 2) _commandController.add(HandsFreeCommand.next);
    if (tapCount == 3) _commandController.add(HandsFreeCommand.back);
  }

  void handleLongPress() {
    if (_mode != HandsFreeMode.doubleTap) return;
    _commandController.add(HandsFreeCommand.start);
  }

  // ── Volume-Button-Modus (HardwareKeyboard) ─────────────────────────────────

  bool _onKey(KeyEvent event) {
    if (_mode != HandsFreeMode.volumeButton) return false;
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp) {
      _commandController.add(HandsFreeCommand.next);
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
      _commandController.add(HandsFreeCommand.back);
      return true;
    }
    return false;
  }

  void _startVolumeButtonListener() {
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  void _stopVolumeButtonListener() {
    HardwareKeyboard.instance.removeHandler(_onKey);
  }

  // ── Cleanup ────────────────────────────────────────────────────────────────

  Future<void> _stopCurrent() async {
    _restartTimer?.cancel();
    _restartTimer = null;
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
    _stopVolumeButtonListener();
  }

  Future<void> dispose() async {
    await _stopCurrent();
    await _commandController.close();
    await _recognizedTextController.close();
  }
}
