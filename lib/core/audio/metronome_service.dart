import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../utils/constants.dart';

enum TimeSignature {
  twoFour,
  threeFour,
  fourFour,
  sixEight,
  sevenEight,
}

extension TimeSignatureExtension on TimeSignature {
  String get displayName {
    switch (this) {
      case TimeSignature.twoFour:
        return '2/4';
      case TimeSignature.threeFour:
        return '3/4';
      case TimeSignature.fourFour:
        return '4/4';
      case TimeSignature.sixEight:
        return '6/8';
      case TimeSignature.sevenEight:
        return '7/8';
    }
  }

  int get beatsPerMeasure {
    switch (this) {
      case TimeSignature.twoFour:
        return 2;
      case TimeSignature.threeFour:
        return 3;
      case TimeSignature.fourFour:
        return 4;
      case TimeSignature.sixEight:
        return 6;
      case TimeSignature.sevenEight:
        return 7;
    }
  }

  int get accentBeat => 1; // Beat 1 is always accented
}

enum MetronomeSound {
  click,
  woodblock,
  hihat,
  rimshot,
}

extension MetronomeSoundExtension on MetronomeSound {
  String get displayName {
    switch (this) {
      case MetronomeSound.click:
        return 'Klick';
      case MetronomeSound.woodblock:
        return 'Holzblock';
      case MetronomeSound.hihat:
        return 'Hi-Hat';
      case MetronomeSound.rimshot:
        return 'Rimshot';
    }
  }

  String get assetPath {
    switch (this) {
      case MetronomeSound.click:
        return 'assets/audio/metronome_click.wav';
      case MetronomeSound.woodblock:
        return 'assets/audio/metronome_woodblock.wav';
      case MetronomeSound.hihat:
        return 'assets/audio/metronome_hihat.wav';
      case MetronomeSound.rimshot:
        return 'assets/audio/metronome_rimshot.wav';
    }
  }

  String get accentAssetPath {
    switch (this) {
      case MetronomeSound.click:
        return 'assets/audio/metronome_click_accent.wav';
      case MetronomeSound.woodblock:
        return 'assets/audio/metronome_woodblock_accent.wav';
      case MetronomeSound.hihat:
        return 'assets/audio/metronome_hihat_accent.wav';
      case MetronomeSound.rimshot:
        return 'assets/audio/metronome_rimshot_accent.wav';
    }
  }
}

class BeatEvent {
  final int beatNumber; // 1-based
  final bool isAccented;
  final DateTime timestamp;
  final int bpm;
  final TimeSignature timeSignature;

  const BeatEvent({
    required this.beatNumber,
    required this.isAccented,
    required this.timestamp,
    required this.bpm,
    required this.timeSignature,
  });
}

class MetronomeService {
  int _bpm;
  TimeSignature _timeSignature;
  MetronomeSound _sound;

  int _currentBeat = 0;
  bool _isPlaying = false;
  Timer? _beatTimer;

  final StreamController<BeatEvent> _beatController =
      StreamController<BeatEvent>.broadcast();

  AudioPlayer? _clickPlayer;
  AudioPlayer? _accentPlayer;

  // For tap tempo
  final List<DateTime> _tapTimes = [];

  MetronomeService({
    int bpm = AppConstants.defaultBpm,
    TimeSignature timeSignature = TimeSignature.fourFour,
    MetronomeSound sound = MetronomeSound.click,
  })  : _bpm = bpm.clamp(AppConstants.minBpm, AppConstants.maxBpm),
        _timeSignature = timeSignature,
        _sound = sound;

  Stream<BeatEvent> get beatStream => _beatController.stream;

  bool get isPlaying => _isPlaying;
  int get bpm => _bpm;
  TimeSignature get timeSignature => _timeSignature;
  MetronomeSound get sound => _sound;
  int get currentBeat => _currentBeat;

  /// Initializes audio players
  Future<void> initialize() async {
    _clickPlayer = AudioPlayer();
    _accentPlayer = AudioPlayer();

    try {
      await _clickPlayer!.setAsset(_sound.assetPath);
      await _accentPlayer!.setAsset(_sound.accentAssetPath);
    } catch (e) {
      // Audio assets may not exist in dev; silently continue
    }
  }

  /// Starts the metronome
  Future<void> start(int bpm, TimeSignature signature) async {
    if (_isPlaying) await stop();

    _bpm = bpm.clamp(AppConstants.minBpm, AppConstants.maxBpm);
    _timeSignature = signature;
    _currentBeat = 0;
    _isPlaying = true;

    final beatInterval = Duration(
      microseconds: (60000000 / _bpm).round(),
    );

    // Fire first beat immediately
    _fireBeat();

    _beatTimer = Timer.periodic(beatInterval, (_) {
      if (_isPlaying) {
        _fireBeat();
      }
    });
  }

  /// Stops the metronome
  Future<void> stop() async {
    _isPlaying = false;
    _beatTimer?.cancel();
    _beatTimer = null;
    _currentBeat = 0;
    await _clickPlayer?.stop();
    await _accentPlayer?.stop();
  }

  /// Changes the BPM while playing
  Future<void> setBpm(int newBpm) async {
    final clampedBpm = newBpm.clamp(AppConstants.minBpm, AppConstants.maxBpm);
    if (clampedBpm == _bpm) return;

    final wasPlaying = _isPlaying;
    if (wasPlaying) {
      await stop();
      _bpm = clampedBpm;
      await start(_bpm, _timeSignature);
    } else {
      _bpm = clampedBpm;
    }
  }

  /// Changes the time signature
  Future<void> setTimeSignature(TimeSignature sig) async {
    final wasPlaying = _isPlaying;
    if (wasPlaying) {
      await stop();
      _timeSignature = sig;
      await start(_bpm, _timeSignature);
    } else {
      _timeSignature = sig;
    }
  }

  /// Changes the metronome sound
  void setSound(MetronomeSound newSound) {
    _sound = newSound;
    try {
      _clickPlayer?.setAsset(newSound.assetPath);
      _accentPlayer?.setAsset(newSound.accentAssetPath);
    } catch (_) {}
  }

  /// Tap tempo: call on each tap, returns the calculated BPM
  int tapTempo() {
    final now = DateTime.now();
    _tapTimes.add(now);

    // Keep only the last 8 taps
    if (_tapTimes.length > 8) {
      _tapTimes.removeAt(0);
    }

    // Need at least 2 taps to calculate BPM
    if (_tapTimes.length < 2) return _bpm;

    // Remove old taps (older than 3 seconds)
    final cutoff = now.subtract(const Duration(seconds: 3));
    _tapTimes.removeWhere((t) => t.isBefore(cutoff));

    if (_tapTimes.length < 2) return _bpm;

    // Calculate average interval between taps
    double totalMs = 0;
    for (int i = 1; i < _tapTimes.length; i++) {
      totalMs += _tapTimes[i].difference(_tapTimes[i - 1]).inMilliseconds;
    }
    final avgMs = totalMs / (_tapTimes.length - 1);
    final calculatedBpm = (60000 / avgMs).round();

    _bpm = calculatedBpm.clamp(AppConstants.minBpm, AppConstants.maxBpm);
    return _bpm;
  }

  /// Resets tap tempo
  void resetTapTempo() {
    _tapTimes.clear();
  }

  void _fireBeat() {
    _currentBeat = (_currentBeat % _timeSignature.beatsPerMeasure) + 1;
    final isAccented = _currentBeat == 1;

    final event = BeatEvent(
      beatNumber: _currentBeat,
      isAccented: isAccented,
      timestamp: DateTime.now(),
      bpm: _bpm,
      timeSignature: _timeSignature,
    );

    _beatController.add(event);
    _playBeatSound(isAccented);
  }

  void _playBeatSound(bool isAccented) {
    try {
      if (isAccented) {
        _accentPlayer?.seek(Duration.zero);
        _accentPlayer?.play();
      } else {
        _clickPlayer?.seek(Duration.zero);
        _clickPlayer?.play();
      }
    } catch (_) {
      // Audio may not be available in development
    }
  }

  /// Returns BPM range info
  static const int minBpm = AppConstants.minBpm;
  static const int maxBpm = AppConstants.maxBpm;

  /// Returns tempo marking for a given BPM
  static String tempoMarking(int bpm) {
    if (bpm < 60) return 'Grave';
    if (bpm < 66) return 'Largo';
    if (bpm < 76) return 'Adagio';
    if (bpm < 108) return 'Andante';
    if (bpm < 120) return 'Moderato';
    if (bpm < 156) return 'Allegro';
    if (bpm < 176) return 'Vivace';
    if (bpm < 200) return 'Presto';
    return 'Prestissimo';
  }

  /// Returns the duration of one beat in milliseconds
  int get beatDurationMs => (60000 / _bpm).round();

  /// Returns the duration of one measure in milliseconds
  int get measureDurationMs => beatDurationMs * _timeSignature.beatsPerMeasure;

  void dispose() {
    stop();
    _beatController.close();
    _clickPlayer?.dispose();
    _accentPlayer?.dispose();
  }
}
