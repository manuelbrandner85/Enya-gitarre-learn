import 'package:flutter/material.dart';

import '../audio/reference_audio_service.dart';
import '../music_theory/string_colors.dart';
import 'finger_icons.dart';

// ─────────────────────────────── Data model ───────────────────────────────────

class FretPosition {
  final int string; // 1-6, 1=hohe e, 6=tiefe E
  final int fret; // 0=leer, 1+=Bund
  final int? finger; // 1=Zeigefinger, 2=Mittel, 3=Ring, 4=kleiner
  final Color? color;
  final bool isTarget;
  const FretPosition({
    required this.string,
    required this.fret,
    this.finger,
    this.color,
    this.isTarget = false,
  });
}

// ──────────────────────────────── Enums ───────────────────────────────────────

enum FretFeedback { none, correct, tooHigh, tooLow }

// ────────────────────────────── Main widget ───────────────────────────────────

class FretboardWidget extends StatefulWidget {
  final List<FretPosition> highlightedPositions;
  final FretPosition? activePosition;
  final int fretCount;
  final int startFret;
  final bool showFingerNumbers;
  final bool showNoteNames;
  final void Function(int string, int fret)? onTap;

  // B9 – links- / rechtshändig
  final bool isLeftHanded;

  // B10 – visuelles Feedback
  final FretFeedback feedbackState;

  // B6 – Schlag-Hand-Indikator (Platzhalter, visuell im Canvas)
  final bool showStrumHand;

  // B12 – Audio-Vorschau beim Antippen
  final bool enableAudioPreview;
  final ReferenceAudioService? audioService;

  // B11 – Mini-Map über dem Canvas
  final bool showMiniMap;

  // B4 – Saiten-Labels unterhalb
  final bool showStringLabels;

  // B2 – Finger-Legende unterhalb
  final bool showFingerLegend;

  const FretboardWidget({
    super.key,
    required this.highlightedPositions,
    this.activePosition,
    this.fretCount = 5,
    this.startFret = 0,
    this.showFingerNumbers = true,
    this.showNoteNames = false,
    this.onTap,
    this.isLeftHanded = false,
    this.feedbackState = FretFeedback.none,
    this.showStrumHand = false,
    this.enableAudioPreview = false,
    this.audioService,
    this.showMiniMap = false,
    this.showStringLabels = true,
    this.showFingerLegend = false,
  });

  // ────────────────────── Statische Hilfs­methoden ──────────────────────────

  /// Berechnet alle Griffbrettpositionne für einen Notennamen dynamisch
  /// aus der Standard-Stimmung (E-A-D-G-H-e).
  static List<FretPosition> positionsForNote(String noteName) {
    // Standard-Stimmung: MIDI-Noten der offenen Saiten (Index 0=Saite 6=tief, Index 5=Saite 1=hoch)
    const openStringMidi = [40, 45, 50, 55, 59, 64]; // E2, A2, D3, G3, B3, E4

    // Notenname → Chroma-Index (0=C, 1=C#/Db, ..., 11=B)
    const noteToChroma = {
      'C': 0, 'C#': 1, 'Db': 1, 'D': 2, 'D#': 3, 'Eb': 3,
      'E': 4, 'F': 5, 'F#': 6, 'Gb': 6, 'G': 7, 'G#': 8,
      'Ab': 8, 'A': 9, 'A#': 10, 'Bb': 10, 'B': 11,
    };

    // Notenname mit Oktave parsen (z.B. "F#3", "Bb4", "E2")
    final match = RegExp(r'^([A-Ga-g][#b]?)(\d+)$').firstMatch(noteName);
    if (match == null) return [];

    final name = match.group(1)!;
    final octave = int.parse(match.group(2)!);
    final chroma = noteToChroma[name];
    if (chroma == null) return [];

    // MIDI-Nummer der Ziel-Note berechnen (C-1=0, C0=12, C1=24, ...)
    final targetMidi = (octave + 1) * 12 + chroma;

    final positions = <FretPosition>[];
    for (int s = 0; s < 6; s++) {
      final fret = targetMidi - openStringMidi[s];
      if (fret >= 0 && fret <= 22) {
        positions.add(FretPosition(
          string: 6 - s, // Saite 6=tiefste (Index 0), Saite 1=höchste (Index 5)
          fret: fret,
        ));
      }
    }
    return positions;
  }

  /// Gibt die einfachste (niedrigste) Griffposition zurück.
  /// Bei gleichem Bund wird die tiefere Saite bevorzugt.
  static FretPosition? lowestPositionForNote(String noteName) {
    final positions = positionsForNote(noteName);
    if (positions.isEmpty) return null;
    positions.sort((a, b) {
      final fretDiff = a.fret.compareTo(b.fret);
      if (fretDiff != 0) return fretDiff;
      return b.string.compareTo(a.string); // Bevorzuge tiefere Saite bei gleichem Bund
    });
    return positions.first;
  }

  static List<FretPosition> positionsForChord(String chordName) {
    switch (chordName) {
      case 'Em':
        return [
          const FretPosition(string: 5, fret: 2, finger: 2),
          const FretPosition(string: 4, fret: 2, finger: 3),
        ];
      case 'Am':
        return [
          const FretPosition(string: 4, fret: 2, finger: 2),
          const FretPosition(string: 3, fret: 2, finger: 3),
          const FretPosition(string: 2, fret: 1, finger: 1),
        ];
      case 'D':
        return [
          const FretPosition(string: 3, fret: 2, finger: 1),
          const FretPosition(string: 2, fret: 3, finger: 3),
          const FretPosition(string: 1, fret: 2, finger: 2),
        ];
      case 'G':
        return [
          const FretPosition(string: 6, fret: 3, finger: 2),
          const FretPosition(string: 5, fret: 2, finger: 1),
          const FretPosition(string: 1, fret: 3, finger: 3),
        ];
      case 'C':
        return [
          const FretPosition(string: 5, fret: 3, finger: 3),
          const FretPosition(string: 4, fret: 2, finger: 2),
          const FretPosition(string: 2, fret: 1, finger: 1),
        ];
      case 'A':
        return [
          const FretPosition(string: 4, fret: 2, finger: 1),
          const FretPosition(string: 3, fret: 2, finger: 2),
          const FretPosition(string: 2, fret: 2, finger: 3),
        ];
      case 'E':
        return [
          const FretPosition(string: 5, fret: 2, finger: 2),
          const FretPosition(string: 4, fret: 2, finger: 3),
          const FretPosition(string: 3, fret: 1, finger: 1),
        ];
      case 'F':
        return [
          const FretPosition(string: 6, fret: 1, finger: 1),
          const FretPosition(string: 5, fret: 1, finger: 1),
          const FretPosition(string: 4, fret: 3, finger: 3),
          const FretPosition(string: 3, fret: 3, finger: 4),
          const FretPosition(string: 2, fret: 2, finger: 2),
          const FretPosition(string: 1, fret: 1, finger: 1),
        ];
      case 'Bm':
        return [
          const FretPosition(string: 5, fret: 2, finger: 1),
          const FretPosition(string: 4, fret: 4, finger: 3),
          const FretPosition(string: 3, fret: 4, finger: 4),
          const FretPosition(string: 2, fret: 3, finger: 2),
          const FretPosition(string: 1, fret: 2, finger: 1),
        ];
      default:
        return [];
    }
  }

  @override
  State<FretboardWidget> createState() => _FretboardWidgetState();
}

// ─────────────────────────────── State ────────────────────────────────────────

class _FretboardWidgetState extends State<FretboardWidget>
    with TickerProviderStateMixin {
  // Glow für aktive Position
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  // B10 – Feedback-Flash
  late final AnimationController _feedbackController;
  late final Animation<double> _feedbackAnimation;

  // B12 – Pulse nach Antippen
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // B8 – gezoomter Bund/Saite
  int _zoomedString = -1;
  int _zoomedFret = -1;

  // für Tap-Koordinatenberechnung (B8 / onTap)
  final GlobalKey _canvasKey = GlobalKey();

  // aktueller startFret (scrollbar per Mini-Map)
  late int _currentStartFret;

  static const double _leftPadding = 36.0;
  static const double _topPadding = 20.0;
  static const double _bottomPadding = 14.0;
  static const double _rightPadding = 10.0;
  static const double _canvasHeight = 170.0;

  @override
  void initState() {
    super.initState();
    _currentStartFret = widget.startFret;

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(FretboardWidget old) {
    super.didUpdateWidget(old);
    if (old.feedbackState != widget.feedbackState &&
        widget.feedbackState != FretFeedback.none) {
      _feedbackController
        ..reset()
        ..forward();
    }
    if (old.startFret != widget.startFret) {
      setState(() => _currentStartFret = widget.startFret);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _feedbackController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ──────────────────────────── Tap-Handling ────────────────────────────────

  void _handleTap(TapDownDetails details) {
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);

    // Bei Left-Handed ist der Canvas gespiegelt → x umrechnen
    double tapX = local.dx;
    if (widget.isLeftHanded) tapX = box.size.width - tapX;

    final canvasWidth = box.size.width;
    final fretboardWidth = canvasWidth - _leftPadding - _rightPadding;
    final fretboardHeight = _canvasHeight - _topPadding - _bottomPadding;
    final stringSpacing = fretboardHeight / 5;
    final fretSpacing = fretboardWidth / widget.fretCount;

    // Saite bestimmen (y-Achse)
    final relY = local.dy - _topPadding;
    int tappedString = -1;
    for (int s = 0; s < 6; s++) {
      final sy = s * stringSpacing;
      if ((relY - sy).abs() < stringSpacing * 0.6) {
        tappedString = s + 1; // 1-basiert
        break;
      }
    }

    // Bund bestimmen (x-Achse)
    int tappedFret = -1;
    if (tapX < _leftPadding - 6) {
      tappedFret = 0; // offen
    } else {
      final relX = tapX - _leftPadding;
      final fretIdx = (relX / fretSpacing).floor() + 1;
      if (fretIdx >= 1 && fretIdx <= widget.fretCount) {
        tappedFret = _currentStartFret + fretIdx;
      }
    }

    if (tappedString < 1 || tappedFret < 0) return;

    // B8 – Zoom aktivieren
    setState(() {
      _zoomedString = tappedString;
      _zoomedFret = tappedFret;
    });

    // B12 – Audio-Vorschau
    if (widget.enableAudioPreview && widget.audioService != null) {
      final noteName = _noteNameForPosition(tappedString, tappedFret);
      if (noteName != null) {
        widget.audioService!.playNote(noteName);
        _pulseController
          ..reset()
          ..forward();
      }
    }

    widget.onTap?.call(tappedString, tappedFret);
  }

  // Einfaches Mapping Saite+Bund → Notenname über MIDI-Berechnung.
  // Standard-Stimmung: Saite 1=E4(64), 2=B3(59), 3=G3(55), 4=D3(50), 5=A2(45), 6=E2(40)
  String? _noteNameForPosition(int string, int fret) {
    const openMidi = [64, 59, 55, 50, 45, 40]; // index 0=Saite1
    final idx = string - 1;
    if (idx < 0 || idx > 5) return null;
    final midi = openMidi[idx] + fret;
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final octave = (midi ~/ 12) - 1;
    final name = noteNames[midi % 12];
    return '$name$octave';
  }

  // ──────────────────────────── Build ───────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allPositions = [
      ...widget.highlightedPositions,
      if (widget.activePosition != null) widget.activePosition!,
    ];
    final hasBarrePosition = _detectBarre(allPositions);

    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _feedbackAnimation, _pulseAnimation]),
      builder: (context, _) {
        final mainCanvas = GestureDetector(
          onTapDown: _handleTap,
          child: RepaintBoundary(
            child: CustomPaint(
              key: _canvasKey,
              size: const Size(double.infinity, _canvasHeight),
              painter: _FretboardPainter(
                highlightedPositions: widget.highlightedPositions,
                activePosition: widget.activePosition,
                fretCount: widget.fretCount,
                startFret: _currentStartFret,
                showFingerNumbers: widget.showFingerNumbers,
                glowOpacity: _glowAnimation.value,
                isLeftHanded: widget.isLeftHanded,
                feedbackState: widget.feedbackState,
                feedbackProgress: _feedbackAnimation.value,
                isDark: isDark,
                pulseProgress: _pulseAnimation.value,
                zoomedString: _zoomedString,
                zoomedFret: _zoomedFret,
                showStrumHand: widget.showStrumHand,
              ),
            ),
          ),
        );

        Widget body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // B11 – Mini-Map
            if (widget.showMiniMap)
              _MiniMap(
                totalFrets: 22,
                visibleCount: widget.fretCount,
                startFret: _currentStartFret,
                isDark: isDark,
                onFretSelected: (f) => setState(() => _currentStartFret = f),
              ),

            // Haupt-Canvas (ggf. mit Strum-Hand-Indikator)
            widget.showStrumHand
                ? Stack(
                    children: [
                      mainCanvas,
                      const Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(child: _StrumHandIndicator()),
                      ),
                    ],
                  )
                : mainCanvas,

            // B4 – Saiten-Labels
            if (widget.showStringLabels) ...[
              const SizedBox(height: 6),
              _StringLabelsRow(startFret: _currentStartFret, isDark: isDark),
              const SizedBox(height: 4),
              _MnemonicRow(isDark: isDark),
            ],

            // B4 – Barre-Tooltip
            if (hasBarrePosition) ...[
              const SizedBox(height: 4),
              _BarreTooltip(isDark: isDark),
            ],

            // B2 – Finger-Legende
            if (widget.showFingerLegend) ...[
              const SizedBox(height: 8),
              const _FingerLegend(),
            ],
          ],
        );

        // B8 – Zoom-Overlay
        if (_zoomedFret >= 0 && _zoomedString >= 1) {
          body = Stack(
            clipBehavior: Clip.none,
            children: [
              body,
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() {
                    _zoomedString = -1;
                    _zoomedFret = -1;
                  }),
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                top: _topPadding,
                left: 60,
                right: 60,
                child: _ZoomOverlay(
                  string: _zoomedString,
                  fret: _zoomedFret,
                  noteName: _noteNameForPosition(_zoomedString, _zoomedFret),
                  isDark: isDark,
                  onClose: () => setState(() {
                    _zoomedString = -1;
                    _zoomedFret = -1;
                  }),
                ),
              ),
            ],
          );
        }

        return body;
      },
    );
  }

  // Erkennt ob zwei Positionen denselben Finger auf verschiedene Saiten legen
  bool _detectBarre(List<FretPosition> positions) {
    final fingerFretsMap = <int, Set<int>>{}; // finger → set of strings
    for (final p in positions) {
      if (p.finger == null || p.fret == 0) continue;
      fingerFretsMap.putIfAbsent(p.finger!, () => {}).add(p.string);
    }
    return fingerFretsMap.values.any((strings) => strings.length > 1);
  }
}

// ─────────────────────────────── Painter ──────────────────────────────────────

class _FretboardPainter extends CustomPainter {
  final List<FretPosition> highlightedPositions;
  final FretPosition? activePosition;
  final int fretCount;
  final int startFret;
  final bool showFingerNumbers;
  final double glowOpacity;
  final bool isLeftHanded;
  final FretFeedback feedbackState;
  final double feedbackProgress;
  final bool isDark;
  final double pulseProgress;
  final int zoomedString;
  final int zoomedFret;
  final bool showStrumHand;

  static const List<double> _stringThicknesses = [
    1.0, 1.4, 1.8, 2.2, 2.6, 3.0
  ];
  static const List<String> _stringNames = ['e', 'B', 'G', 'D', 'A', 'E'];
  static const List<Color> _fingerColors = [
    Color(0xFF2196F3), // 1: blau
    Color(0xFF4CAF50), // 2: grün
    Color(0xFFFF9800), // 3: orange
    Color(0xFFF44336), // 4: rot
  ];

  // Perspektiv-Faktor: Saiten konvergieren um 3 % nach rechts
  static const double _perspectiveFactor = 0.03;

  const _FretboardPainter({
    required this.highlightedPositions,
    required this.activePosition,
    required this.fretCount,
    required this.startFret,
    required this.showFingerNumbers,
    required this.glowOpacity,
    required this.isLeftHanded,
    required this.feedbackState,
    required this.feedbackProgress,
    required this.isDark,
    required this.pulseProgress,
    required this.zoomedString,
    required this.zoomedFret,
    required this.showStrumHand,
  });

  // Layoutkonstanten
  static const double leftPadding = 36.0;
  static const double topPadding = 20.0;
  static const double bottomPadding = 14.0;
  static const double rightPadding = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (isLeftHanded) {
      canvas.save();
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }

    _paintAll(canvas, size);

    if (isLeftHanded) {
      canvas.restore();
    }
  }

  void _paintAll(Canvas canvas, Size size) {
    final fretboardWidth = size.width - leftPadding - rightPadding;
    final fretboardHeight = size.height - topPadding - bottomPadding;
    final fretSpacing = fretboardWidth / fretCount;

    // String-y mit leichter Perspektive (Saiten konvergieren leicht nach rechts)
    // String-Index 0 = hohe e (oben), 5 = tiefe E (unten)
    // Die Abstände bleiben gleichmäßig, aber jede Saite verschiebt sich minimal.
    double _stringY(int stringIndex, double xFraction) {
      final baseY = topPadding + stringIndex * (fretboardHeight / 5);
      // Perspektive: leichte Konvergenz
      final midY = topPadding + fretboardHeight / 2;
      final offset = (baseY - midY) * _perspectiveFactor * xFraction;
      return baseY - offset;
    }

    // ── Hintergrund: radialer Gradient ─────────────────────────────────────
    if (isDark) {
      final bgPaint = Paint()
        ..color = const Color(0xFF0D0D0D);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(leftPadding, topPadding, fretboardWidth, fretboardHeight),
          const Radius.circular(4),
        ),
        bgPaint,
      );
    } else {
      final bgShader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: const [Color(0xFF3E2000), Color(0xFF1A0D00)],
      ).createShader(
        Rect.fromLTWH(leftPadding, topPadding, fretboardWidth, fretboardHeight),
      );
      final bgPaint = Paint()..shader = bgShader;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(leftPadding, topPadding, fretboardWidth, fretboardHeight),
          const Radius.circular(4),
        ),
        bgPaint,
      );
    }

    // ── Feedback-Overlay ──────────────────────────────────────────────────
    if (feedbackState != FretFeedback.none && feedbackProgress > 0) {
      Color feedbackColor;
      switch (feedbackState) {
        case FretFeedback.correct:
          feedbackColor = const Color(0xFF4CAF50);
          break;
        case FretFeedback.tooHigh:
          feedbackColor = const Color(0xFFF44336);
          break;
        case FretFeedback.tooLow:
          feedbackColor = const Color(0xFF2196F3);
          break;
        case FretFeedback.none:
          feedbackColor = Colors.transparent;
      }
      final feedbackPaint = Paint()
        ..color = feedbackColor.withValues(alpha: 0.25 * (1.0 - feedbackProgress));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(leftPadding, topPadding, fretboardWidth, fretboardHeight),
          const Radius.circular(4),
        ),
        feedbackPaint,
      );
    }

    // ── Sattel ────────────────────────────────────────────────────────────
    // Schattierung unten (3D-Effekt)
    if (startFret == 0) {
      final saddleShadowPaint = Paint()
        ..color = const Color(0xFF998866)
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.butt;
      canvas.drawLine(
        Offset(leftPadding + 3, topPadding + 2),
        Offset(leftPadding + 3, topPadding + fretboardHeight - 2),
        saddleShadowPaint,
      );
      // Heller Kern (cream)
      final saddlePaint = Paint()
        ..color = const Color(0xFFFFF8E1)
        ..strokeWidth = 4.0;
      canvas.drawLine(
        Offset(leftPadding + 1, topPadding),
        Offset(leftPadding + 1, topPadding + fretboardHeight),
        saddlePaint,
      );
    } else {
      // Einfacher Sattel wenn nicht bei Bund 0
      final saddlePaint = Paint()
        ..color = const Color(0xFFCCBB88)
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(leftPadding, topPadding),
        Offset(leftPadding, topPadding + fretboardHeight),
        saddlePaint,
      );
    }

    // ── Bundstäbe ─────────────────────────────────────────────────────────
    for (int f = 1; f <= fretCount; f++) {
      final x = leftPadding + f * fretSpacing;
      final fretRect = Rect.fromLTWH(x - 2, topPadding, 4, fretboardHeight);
      final fretShader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
      ).createShader(fretRect);
      final fretPaint = Paint()..shader = fretShader;
      canvas.drawRect(fretRect, fretPaint);
    }

    // ── Inlay-Dots ────────────────────────────────────────────────────────
    const inlayFrets = [3, 5, 7, 9, 12];
    final dotPaint = Paint()
      ..color = isDark
          ? const Color(0xFF444444).withValues(alpha: 0.6)
          : const Color(0xFF8B6914).withValues(alpha: 0.45);
    for (final f in inlayFrets) {
      if (f >= startFret + 1 && f <= startFret + fretCount) {
        final fretIdx = f - startFret;
        final x = leftPadding + (fretIdx - 0.5) * fretSpacing;
        final midY = topPadding + fretboardHeight / 2;
        if (f == 12) {
          // Doppel-Dot
          canvas.drawCircle(Offset(x, midY - 8), 3.5, dotPaint);
          canvas.drawCircle(Offset(x, midY + 8), 3.5, dotPaint);
        } else {
          canvas.drawCircle(Offset(x, midY), 4, dotPaint);
        }
      }
    }

    // ── Saiten ────────────────────────────────────────────────────────────
    for (int s = 0; s < 6; s++) {
      final yLeft = _stringY(s, 0.0);
      final yRight = _stringY(s, 1.0);
      final thickness = _stringThicknesses[s];
      final stringColor = isDark
          ? Colors.white.withValues(alpha: 0.85)
          : StringColors.forString(s + 1); // s+1: Saite 1..6

      final stringPaint = Paint()
        ..color = stringColor
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(leftPadding, yLeft),
        Offset(leftPadding + fretboardWidth, yRight),
        stringPaint,
      );

      // Glanzlicht auf der Saite
      if (!isDark) {
        final highlightPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..strokeWidth = thickness * 0.4;
        canvas.drawLine(
          Offset(leftPadding, yLeft - thickness * 0.15),
          Offset(leftPadding + fretboardWidth, yRight - thickness * 0.15),
          highlightPaint,
        );
      }

      // Saitenname links
      final textPainter = TextPainter(
        text: TextSpan(
          text: _stringNames[s],
          style: TextStyle(
            color: isDark ? Colors.white54 : const Color(0xFF888888),
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
          canvas, Offset(3, yLeft - textPainter.height / 2));
    }

    // ── Bund-Nummern oben ────────────────────────────────────────────────
    for (int f = 0; f <= fretCount; f++) {
      final fretNum = startFret + f;
      if (fretNum == 0) continue;
      final x = leftPadding + (f - 0.5) * fretSpacing;
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$fretNum',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF666666),
            fontSize: isDark ? 11 : 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, 3));
    }

    // ── Gruppen für Barre erkennen ────────────────────────────────────────
    final allPositions = [
      ...highlightedPositions,
      if (activePosition != null) activePosition!,
    ];
    // Finger → Liste von Positionen
    final fingerGroups = <int, List<FretPosition>>{};
    for (final p in allPositions) {
      if (p.finger != null) {
        fingerGroups.putIfAbsent(p.finger!, () => []).add(p);
      }
    }

    // ── Barre-Balken zeichnen ─────────────────────────────────────────────
    fingerGroups.forEach((finger, positions) {
      if (positions.length < 2) return;
      // Alle auf demselben Bund?
      final frets = positions.map((p) => p.fret).toSet();
      if (frets.length != 1) return;
      final fretNum = frets.first;
      if (fretNum == 0) return;
      final adjustedFret = fretNum - startFret;
      if (adjustedFret < 1 || adjustedFret > fretCount) return;

      final x = leftPadding + (adjustedFret - 0.5) * fretSpacing;
      final strings = positions.map((p) => p.string).toList()..sort();
      final topString = strings.first; // kleinere Saiten-Nummer = oben
      final botString = strings.last;
      final yTop = _stringY(topString - 1, (adjustedFret - 0.5) / fretCount);
      final yBot = _stringY(botString - 1, (adjustedFret - 0.5) / fretCount);

      final fingerIndex = (finger - 1).clamp(0, 3);
      final barreColor = _fingerColors[fingerIndex];
      final barrePaint = Paint()
        ..color = barreColor.withValues(alpha: 0.85)
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(x, yTop), Offset(x, yBot), barrePaint);
      // Outline
      final outlinePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(x, yTop), Offset(x, yBot), outlinePaint);
    });

    // ── Finger-Dots ───────────────────────────────────────────────────────
    final isActive = <FretPosition, bool>{};
    for (final p in highlightedPositions) {
      isActive[p] = false;
    }
    if (activePosition != null) {
      isActive[activePosition!] = true;
    }

    isActive.forEach((pos, active) {
      _drawFingerDot(
        canvas, pos, fretSpacing, fretboardHeight, active, isDark,
        _stringY,
      );
    });
  }

  void _drawFingerDot(
    Canvas canvas,
    FretPosition pos,
    double fretSpacing,
    double fretboardHeight,
    bool isActive,
    bool isDark,
    double Function(int, double) stringYFn,
  ) {
    final stringIndex = pos.string - 1;
    if (stringIndex < 0 || stringIndex > 5) return;

    double x;
    double xFraction;
    if (pos.fret == 0) {
      x = leftPadding - 14;
      xFraction = 0.0;
    } else {
      final adjustedFret = pos.fret - startFret;
      if (adjustedFret < 1 || adjustedFret > fretCount) return;
      xFraction = (adjustedFret - 0.5) / fretCount;
      x = leftPadding + (adjustedFret - 0.5) * fretSpacing;
    }

    final y = stringYFn(stringIndex, xFraction);

    final fingerIndex = (pos.finger ?? 1) - 1;
    Color color = pos.color ??
        (fingerIndex >= 0 && fingerIndex < 4
            ? _fingerColors[fingerIndex]
            : StringColors.forString(pos.string));

    const radius = 10.0;

    // Glow für aktive Position
    if (isActive) {
      final glowRadius = isDark ? radius * 2.5 : radius * 2.0;
      final glowPaint = Paint()
        ..color = color.withValues(alpha: (isDark ? 0.6 : 0.3) * glowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDark ? 10 : 8);
      canvas.drawCircle(Offset(x, y), glowRadius, glowPaint);
    }

    if (pos.fret == 0) {
      // Offene Saite → hohler Kreis mit "O"
      final openPaint = Paint()
        ..color = color.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(x, y), radius - 1, openPaint);
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'O',
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    } else {
      // Normaler Kreis
      final circlePaint = Paint()..color = color;
      canvas.drawCircle(Offset(x, y), radius, circlePaint);

      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(x - 2, y - 2), radius * 0.5, highlightPaint);

      // Fingernummer
      if (showFingerNumbers && pos.finger != null) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${pos.finger}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
            canvas,
            Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }
    }

    // Zoom-Highlight
    if (zoomedString == pos.string && zoomedFret == pos.fret) {
      final zoomPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(Offset(x, y), radius + 4, zoomPaint);
    }
  }

  @override
  bool shouldRepaint(_FretboardPainter old) =>
      old.glowOpacity != glowOpacity ||
      old.feedbackProgress != feedbackProgress ||
      old.pulseProgress != pulseProgress ||
      old.highlightedPositions != highlightedPositions ||
      old.activePosition != activePosition ||
      old.startFret != startFret ||
      old.fretCount != fretCount ||
      old.isLeftHanded != isLeftHanded ||
      old.feedbackState != feedbackState ||
      old.isDark != isDark ||
      old.zoomedString != zoomedString ||
      old.zoomedFret != zoomedFret;
}

// ─────────────────────────────── Mini-Map ─────────────────────────────────────

class _MiniMap extends StatelessWidget {
  final int totalFrets;
  final int visibleCount;
  final int startFret;
  final bool isDark;
  final void Function(int) onFretSelected;

  const _MiniMap({
    required this.totalFrets,
    required this.visibleCount,
    required this.startFret,
    required this.isDark,
    required this.onFretSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(details.globalPosition);
        final fraction = (local.dx / box.size.width).clamp(0.0, 1.0);
        final targetFret = (fraction * (totalFrets - visibleCount)).round();
        onFretSelected(targetFret.clamp(0, totalFrets - visibleCount));
      },
      child: Container(
        height: 20,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFF2D1B00),
          borderRadius: BorderRadius.circular(3),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final fretWidth = w / totalFrets;
            final windowLeft = startFret * fretWidth;
            final windowWidth = visibleCount * fretWidth;
            return Stack(
              children: [
                // Alle Bund-Markers
                ...List.generate(totalFrets, (i) {
                  return Positioned(
                    left: i * fretWidth,
                    top: 4,
                    bottom: 4,
                    width: 1,
                    child: Container(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  );
                }),
                // Sichtbares Fenster
                Positioned(
                  left: windowLeft,
                  width: windowWidth,
                  top: 2,
                  bottom: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFFE0C080).withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : const Color(0xFFE0C080).withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────── String Labels Row ──────────────────────────────

class _StringLabelsRow extends StatelessWidget {
  final int startFret;
  final bool isDark;

  const _StringLabelsRow({required this.startFret, required this.isDark});

  // Labels: Index 0 = Saite 6 (tiefe E, links), Index 5 = Saite 1 (hohe e, rechts)
  static const List<String> _labels = ['6 E', '5 A', '4 D', '3 G', '2 B', '1 e'];
  static const List<Color> _colors = [
    StringColors.string6E,
    StringColors.string5A,
    StringColors.string4D,
    StringColors.string3G,
    StringColors.string2B,
    StringColors.string1E,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(6, (i) {
          return Text(
            _labels[i],
            style: TextStyle(
              color: _colors[i],
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────── Mnemonic Row ────────────────────────────────

class _MnemonicRow extends StatelessWidget {
  final bool isDark;

  const _MnemonicRow({required this.isDark});

  // "Eine Alte Dame Geht Heringe Essen"
  // Wort-Index 0 = Saite 6 (E), 5 = Saite 1 (e)
  static const List<String> _words = [
    'Eine', 'Alte', 'Dame', 'Geht', 'Heringe', 'Essen'
  ];
  static const List<Color> _colors = [
    StringColors.string6E,
    StringColors.string5A,
    StringColors.string4D,
    StringColors.string3G,
    StringColors.string2B,
    StringColors.string1E,
  ];

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? Colors.white54 : Colors.black45;
    final List<InlineSpan> spans = [];
    for (int i = 0; i < _words.length; i++) {
      if (i > 0) {
        spans.add(TextSpan(text: ' ', style: TextStyle(color: baseColor, fontSize: 10)));
      }
      final word = _words[i];
      // Erster Buchstabe in Saitenfarbe
      spans.add(TextSpan(
        text: word[0],
        style: TextStyle(
          color: _colors[i],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ));
      if (word.length > 1) {
        spans.add(TextSpan(
          text: word.substring(1),
          style: TextStyle(color: baseColor, fontSize: 10),
        ));
      }
    }
    return Center(
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}

// ──────────────────────────── Barre Tooltip ──────────────────────────────────

class _BarreTooltip extends StatelessWidget {
  final bool isDark;

  const _BarreTooltip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE0C080).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        'Drücke direkt hinter dem Bundstäbchen, nicht darauf.',
        style: TextStyle(
          fontSize: 10,
          color: isDark ? Colors.white70 : Colors.brown.shade700,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ──────────────────────────── Finger Legend ──────────────────────────────────

class _FingerLegend extends StatelessWidget {
  static const List<Color> _fingerColors = [
    Color(0xFF2196F3), // 1 Zeigefinger
    Color(0xFF4CAF50), // 2 Mittelfinger
    Color(0xFFFF9800), // 3 Ringfinger
    Color(0xFFF44336), // 4 kleiner Finger
  ];

  const _FingerLegend();

  @override
  Widget build(BuildContext context) {
    return FingerLegendRow(
      fingerColors: _fingerColors,
      iconSize: 28,
    );
  }
}

// ──────────────────────────── Zoom Overlay ───────────────────────────────────

class _ZoomOverlay extends StatelessWidget {
  final int string;
  final int fret;
  final String? noteName;
  final bool isDark;
  final VoidCallback onClose;

  const _ZoomOverlay({
    required this.string,
    required this.fret,
    required this.noteName,
    required this.isDark,
    required this.onClose,
  });

  static const List<String> _stringFullNames = [
    'hohe e', 'B', 'G', 'D', 'A', 'tiefe E'
  ];

  @override
  Widget build(BuildContext context) {
    final stringName = string >= 1 && string <= 6
        ? _stringFullNames[string - 1]
        : 'Saite $string';
    final stringColor = StringColors.forString(string);
    final fretLabel = fret == 0 ? 'leer' : 'Bund $fret';
    final noteLabel = noteName ?? '?';

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: Card(
          color: isDark ? const Color(0xFF252525) : Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: stringColor.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FingerIcons.widget(1, 24, stringColor),
                        const SizedBox(width: 8),
                        Text(
                          'Saite $string ($stringName), $fretLabel',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: stringColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    noteLabel,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: stringColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────── Strum Hand Indicator ───────────────────────────────

class _StrumHandIndicator extends StatelessWidget {
  const _StrumHandIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            'S',
            style: TextStyle(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
