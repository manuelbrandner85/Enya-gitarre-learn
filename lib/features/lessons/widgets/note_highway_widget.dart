import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../core/audio/pitch_detector.dart';

/// A single note in the falling Note Highway.
class HighwayNote {
  final int stringIndex; // 0..5 (low E to high E)
  final int fret;
  final double timestampSec;
  final double durationSec;

  const HighwayNote({
    required this.stringIndex,
    required this.fret,
    required this.timestampSec,
    this.durationSec = 0.25,
  });

  /// MIDI note resulting from a string + fret using standard tuning.
  int get midiNote {
    // Standard tuning low to high: E2=40, A2=45, D3=50, G3=55, B3=59, E4=64
    const open = [40, 45, 50, 55, 59, 64];
    final s = stringIndex.clamp(0, 5);
    return open[s] + fret;
  }
}

/// Result returned when the highway run completes.
class HighwayResult {
  final int hitCount;
  final int missCount;
  final int perfectCount;
  final int greatCount;
  final int goodCount;
  final int maxCombo;
  final double accuracy;
  final int score;

  const HighwayResult({
    required this.hitCount,
    required this.missCount,
    required this.perfectCount,
    required this.greatCount,
    required this.goodCount,
    required this.maxCombo,
    required this.accuracy,
    required this.score,
  });
}

/// Hit timing classifications.
enum HitGrade { perfect, great, good, miss }

extension HitGradeExtension on HitGrade {
  String get label {
    switch (this) {
      case HitGrade.perfect:
        return 'PERFECT';
      case HitGrade.great:
        return 'GREAT';
      case HitGrade.good:
        return 'GOOD';
      case HitGrade.miss:
        return 'MISS';
    }
  }

  Color get color {
    switch (this) {
      case HitGrade.perfect:
        return AppColors.xpColor;
      case HitGrade.great:
        return AppColors.primary;
      case HitGrade.good:
        return AppColors.accent;
      case HitGrade.miss:
        return AppColors.error;
    }
  }

  int get points {
    switch (this) {
      case HitGrade.perfect:
        return 100;
      case HitGrade.great:
        return 75;
      case HitGrade.good:
        return 40;
      case HitGrade.miss:
        return 0;
    }
  }
}

/// Public widget hosting the Flame game.
class NoteHighwayWidget extends StatefulWidget {
  final List<HighwayNote> notes;
  final int bpm;
  final Stream<PitchResult> pitchStream;
  final ValueChanged<HighwayResult>? onComplete;

  const NoteHighwayWidget({
    super.key,
    required this.notes,
    required this.bpm,
    required this.pitchStream,
    this.onComplete,
  });

  @override
  State<NoteHighwayWidget> createState() => _NoteHighwayWidgetState();
}

class _NoteHighwayWidgetState extends State<NoteHighwayWidget> {
  late final NoteHighwayGame _game;

  @override
  void initState() {
    super.initState();
    _game = NoteHighwayGame(
      notes: widget.notes,
      bpm: widget.bpm,
      pitchStream: widget.pitchStream,
      onComplete: widget.onComplete,
    );
  }

  @override
  void dispose() {
    _game.disposeGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDark,
      child: GameWidget(game: _game),
    );
  }
}

/// String tint colors derived from AppColors finger palette.
const List<Color> _stringColors = [
  AppColors.fingerThumb, // string 0 (low E) — purple
  AppColors.fingerIndex, // string 1 (A) — blue
  AppColors.fingerMiddle, // string 2 (D) — green
  AppColors.fingerPinky, // string 3 (G) — yellow
  AppColors.secondary, // string 4 (B) — orange
  AppColors.fingerRing, // string 5 (high E) — red
];

/// The Flame game.
class NoteHighwayGame extends FlameGame {
  final List<HighwayNote> notes;
  final int bpm;
  final Stream<PitchResult> pitchStream;
  final ValueChanged<HighwayResult>? onComplete;

  StreamSubscription<PitchResult>? _pitchSub;

  // Game state
  double _playheadSec = 0;
  int _hitCount = 0;
  int _missCount = 0;
  int _perfectCount = 0;
  int _greatCount = 0;
  int _goodCount = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _score = 0;
  bool _completed = false;

  // Timing (seconds)
  static const double _perfectWindow = 0.05;
  static const double _greatWindow = 0.10;
  static const double _goodWindow = 0.20;

  // Visual layout
  late double _laneWidth;
  late double _hitZoneY;
  static const double _topPadding = 80;

  // Speed: 1 beat (= 60/bpm sec) -> 200px travel.
  // pixelsPerSecond = 200 * bpm / 60.
  late double _pixelsPerSecond;

  // Components and indexing
  final List<_NoteComponent> _activeNotes = [];
  int _spawnIndex = 0;

  // HUD
  late _HudComponent _hud;

  NoteHighwayGame({
    required this.notes,
    required this.bpm,
    required this.pitchStream,
    this.onComplete,
  });

  @override
  Color backgroundColor() => AppColors.backgroundDark;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _laneWidth = size.x / 6.0;
    _hitZoneY = size.y * 0.85;
    _pixelsPerSecond = 200.0 * bpm / 60.0;

    // Lane backgrounds
    for (int i = 0; i < 6; i++) {
      final lane = RectangleComponent(
        position: Vector2(i * _laneWidth, 0),
        size: Vector2(_laneWidth, size.y),
        paint: Paint()
          ..color = _stringColors[i].withOpacity(0.06)
          ..style = PaintingStyle.fill,
      );
      add(lane);
    }

    // Lane dividers
    for (int i = 1; i < 6; i++) {
      add(RectangleComponent(
        position: Vector2(i * _laneWidth - 0.5, 0),
        size: Vector2(1, size.y),
        paint: Paint()..color = AppColors.outline,
      ));
    }

    // Hit zone bar
    add(RectangleComponent(
      position: Vector2(0, _hitZoneY),
      size: Vector2(size.x, 4),
      paint: Paint()..color = AppColors.primary,
    ));

    // Hit zone glow background
    add(RectangleComponent(
      position: Vector2(0, _hitZoneY),
      size: Vector2(size.x, size.y * 0.15),
      paint: Paint()..color = AppColors.primaryMuted,
    ));

    // Hit-zone targets (circles per lane)
    for (int i = 0; i < 6; i++) {
      add(CircleComponent(
        radius: _laneWidth * 0.28,
        position: Vector2(i * _laneWidth + _laneWidth / 2, _hitZoneY + 4),
        anchor: Anchor.center,
        paint: Paint()
          ..color = _stringColors[i].withOpacity(0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      ));
    }

    // HUD overlay
    _hud = _HudComponent();
    add(_hud);

    // Subscribe to pitch detector
    _pitchSub = pitchStream.listen(_onPitch);
  }

  /// Travel time = (hitZoneY - topPadding) / pixelsPerSecond
  double get _travelTimeSec => (_hitZoneY - _topPadding) / _pixelsPerSecond;

  @override
  void update(double dt) {
    super.update(dt);
    if (_completed) return;

    _playheadSec += dt;

    // Spawn new notes when their timestamp - travelTime <= playhead
    while (_spawnIndex < notes.length &&
        notes[_spawnIndex].timestampSec - _travelTimeSec <= _playheadSec) {
      final n = notes[_spawnIndex];
      final comp = _NoteComponent(
        note: n,
        laneWidth: _laneWidth,
        hitZoneY: _hitZoneY,
        pixelsPerSecond: _pixelsPerSecond,
        topY: _topPadding,
      );
      _activeNotes.add(comp);
      add(comp);
      _spawnIndex++;
    }

    // Update positions and detect misses (note has passed beyond good window)
    for (final c in List<_NoteComponent>.from(_activeNotes)) {
      c.updatePosition(_playheadSec);

      if (!c.consumed && _playheadSec - c.note.timestampSec > _goodWindow) {
        _registerMiss(c);
      }
    }

    // Refresh HUD
    _hud.updateHud(
      score: _score,
      combo: _combo,
    );

    // Completion check
    if (_spawnIndex >= notes.length && _activeNotes.isEmpty && !_completed) {
      _completed = true;
      _emitResult();
    }
  }

  void _onPitch(PitchResult pitch) {
    if (_completed) return;
    if (!pitch.isValid) return;

    // Find the closest unconsumed note in time whose midi is enharmonic.
    _NoteComponent? best;
    double bestDelta = double.infinity;

    for (final c in _activeNotes) {
      if (c.consumed) continue;
      final delta = (c.note.timestampSec - _playheadSec).abs();
      if (delta > _goodWindow) continue;
      // Match by chroma (mod 12) so octave drift in detection still counts.
      if ((c.note.midiNote - pitch.midiNote) % 12 != 0) continue;
      if (delta < bestDelta) {
        bestDelta = delta;
        best = c;
      }
    }

    if (best == null) return;

    HitGrade grade;
    if (bestDelta <= _perfectWindow) {
      grade = HitGrade.perfect;
      _perfectCount++;
    } else if (bestDelta <= _greatWindow) {
      grade = HitGrade.great;
      _greatCount++;
    } else {
      grade = HitGrade.good;
      _goodCount++;
    }

    _registerHit(best, grade);
  }

  void _registerHit(_NoteComponent c, HitGrade grade) {
    c.consume();
    _activeNotes.remove(c);
    _hitCount++;
    _combo++;
    if (_combo > _maxCombo) _maxCombo = _combo;
    _score += grade.points * (1 + _combo ~/ 10);

    // Visual feedback: glow + sparks
    _spawnFeedback(c, grade);
    c.removeFromParent();
  }

  void _registerMiss(_NoteComponent c) {
    c.consume();
    _activeNotes.remove(c);
    _missCount++;
    _combo = 0;

    // Red flash
    final flash = RectangleComponent(
      size: size.clone(),
      paint: Paint()..color = AppColors.error.withOpacity(0.25),
    );
    add(flash);
    flash.add(OpacityEffectFadeOut(0.4));

    _spawnFeedback(c, HitGrade.miss);
    c.removeFromParent();
  }

  void _spawnFeedback(_NoteComponent c, HitGrade grade) {
    final cx = c.note.stringIndex * _laneWidth + _laneWidth / 2;
    final cy = _hitZoneY + 4;

    // Glow circle
    final glow = CircleComponent(
      radius: _laneWidth * 0.45,
      position: Vector2(cx, cy),
      anchor: Anchor.center,
      paint: Paint()..color = grade.color.withOpacity(0.6),
    );
    add(glow);
    glow.add(OpacityEffectFadeOut(0.35));
    glow.add(_RemoveAfter(0.4));

    // Sparks (only on hits)
    if (grade != HitGrade.miss) {
      final rng = math.Random();
      for (int i = 0; i < 6; i++) {
        final angle = rng.nextDouble() * math.pi * 2;
        final speed = 60 + rng.nextDouble() * 80;
        final spark = CircleComponent(
          radius: 3,
          position: Vector2(cx, cy),
          anchor: Anchor.center,
          paint: Paint()..color = grade.color,
        );
        add(spark);
        spark.add(_LinearMove(
          velocity: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
          life: 0.45,
        ));
      }
    }

    // Grade label
    final tp = TextPaint(
      style: TextStyle(
        color: grade.color,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
    final label = TextComponent(
      text: grade.label,
      textRenderer: tp,
      position: Vector2(cx, cy - 40),
      anchor: Anchor.center,
    );
    add(label);
    label.add(_RemoveAfter(0.6));
  }

  void _emitResult() {
    final total = _hitCount + _missCount;
    final acc = total == 0 ? 0.0 : _hitCount / total;
    onComplete?.call(HighwayResult(
      hitCount: _hitCount,
      missCount: _missCount,
      perfectCount: _perfectCount,
      greatCount: _greatCount,
      goodCount: _goodCount,
      maxCombo: _maxCombo,
      accuracy: acc,
      score: _score,
    ));
  }

  /// Public dispose used by the wrapper widget.
  void disposeGame() {
    _pitchSub?.cancel();
    _pitchSub = null;
  }

  @override
  void onRemove() {
    disposeGame();
    super.onRemove();
  }
}

/// Falling note component.
class _NoteComponent extends PositionComponent {
  final HighwayNote note;
  final double laneWidth;
  final double hitZoneY;
  final double pixelsPerSecond;
  final double topY;
  bool consumed = false;

  late final Paint _fillPaint;
  late final Paint _borderPaint;

  _NoteComponent({
    required this.note,
    required this.laneWidth,
    required this.hitZoneY,
    required this.pixelsPerSecond,
    required this.topY,
  }) {
    final color = _stringColors[note.stringIndex.clamp(0, 5)];
    _fillPaint = Paint()..color = color;
    _borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    size = Vector2(laneWidth * 0.7, laneWidth * 0.45);
    anchor = Anchor.center;
    position = Vector2(
      note.stringIndex * laneWidth + laneWidth / 2,
      topY,
    );
  }

  void updatePosition(double playheadSec) {
    final secUntilHit = note.timestampSec - playheadSec;
    final y = hitZoneY + 4 - secUntilHit * pixelsPerSecond;
    position.y = y;
  }

  void consume() {
    consumed = true;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rrect, _fillPaint);
    canvas.drawRRect(rrect, _borderPaint);

    // Fret label
    final tp = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    tp.render(
      canvas,
      note.fret == 0 ? '0' : '${note.fret}',
      Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
  }
}

/// Tiny effect: linear motion with auto-fade.
class _LinearMove extends Component {
  final Vector2 velocity;
  final double life;
  double _t = 0;

  _LinearMove({required this.velocity, required this.life});

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    final p = parent;
    if (p is PositionComponent) {
      p.position += velocity * dt;
    }
    if (p is HasPaint) {
      final remaining = (1 - _t / life).clamp(0.0, 1.0);
      p.opacity = remaining;
    }
    if (_t >= life) {
      parent?.removeFromParent();
    }
  }
}

/// Simple opacity fade-out (in case the engine version doesn't ship with one).
class OpacityEffectFadeOut extends Component {
  final double duration;
  double _t = 0;

  OpacityEffectFadeOut(this.duration);

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    final p = parent;
    if (p is HasPaint) {
      final remaining = (1 - _t / duration).clamp(0.0, 1.0);
      p.opacity = remaining;
    }
    if (_t >= duration) {
      parent?.removeFromParent();
    }
  }
}

/// Removes the parent component after [seconds] seconds.
class _RemoveAfter extends Component {
  final double seconds;
  double _t = 0;

  _RemoveAfter(this.seconds);

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= seconds) parent?.removeFromParent();
  }
}

/// HUD overlay: score top-left, combo top-right.
class _HudComponent extends Component {
  int _score = 0;
  int _combo = 0;

  late final TextPaint _scorePaint;
  late final TextPaint _comboPaint;

  _HudComponent() {
    _scorePaint = TextPaint(
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
    _comboPaint = TextPaint(
      style: const TextStyle(
        color: AppColors.xpColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void updateHud({required int score, required int combo}) {
    _score = score;
    _combo = combo;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final game = findGame();
    if (game == null) return;
    final s = game.size;

    _scorePaint.render(
      canvas,
      'Score: $_score',
      Vector2(16, 16),
    );

    _comboPaint.render(
      canvas,
      _combo > 0 ? 'Combo x$_combo' : '',
      Vector2(s.x - 16, 16),
      anchor: Anchor.topRight,
    );
  }
}
