import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/theme/colors.dart';
import '../../core/curriculum/curriculum.dart';
import '../../core/music_theory/note.dart';
import '../../core/curriculum/hand_isolation.dart';
import 'dart:async';

import '../../core/audio/hands_free_service.dart';
import '../../core/curriculum/adaptive_engine.dart';
import '../../core/curriculum/pedagogy/learning_rules.dart';
import '../../core/models/lesson.dart';
import '../../core/practice/practice_session_tracker.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/fretboard_widget.dart';
import '../../core/widgets/hands_free_overlay.dart' as hf;
import 'controllers/lesson_controller.dart';
import 'widgets/hand_mode_selector.dart';
import 'widgets/real_time_feedback_widget.dart';
import 'widgets/reference_audio_button.dart';
import 'widgets/show_me_how_overlay.dart';
import 'widgets/xmari_setup_card.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String moduleId;
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.moduleId,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _currentStep = 0;
  bool _isExerciseComplete = false;
  bool _xmariSetupShown = true; // true = already dismissed (won't show)
  PracticeHand _practiceHand = PracticeHand.both;

  // Adaptive Difficulty State
  int _consecutiveLowAttempts = 0;
  AdaptiveAction? _lastAdaptiveAction;
  bool _adaptiveBannerDismissed = false;

  // Hands-Free Subscription
  StreamSubscription<HandsFreeCommand>? _handsFreeSub;

  late final LessonKey _lessonKey;
  late final Lesson? _lesson;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _lessonKey = LessonKey(
      moduleId: widget.moduleId,
      lessonId: widget.lessonId,
    );
    _lesson = Curriculum.findLesson(widget.moduleId, widget.lessonId) ??
        _fallbackLesson();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(practiceSessionTrackerProvider).start(
            moduleId: widget.moduleId,
            lessonId: widget.lessonId,
          );
    });

    // Pädagogik-Info immer verfügbar (nutzt _getPedagogy mit Fallback-Kette).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _xmariSetupShown = false);
    });

    // Hands-Free: Befehle in Lesson-Aktionen mappen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final svc = ref.read(hf.handsFreeServiceProvider);
      _handsFreeSub = svc.commandStream.listen(_onHandsFreeCommand);
    });
  }

  void _onHandsFreeCommand(HandsFreeCommand cmd) {
    if (!mounted) return;
    final controller =
        ref.read(lessonControllerProvider(_lessonKey).notifier);
    switch (cmd) {
      case HandsFreeCommand.next:
        // Nächster Schritt der Anleitung oder Übung beenden
        if (_currentStep < (_lesson?.instructions.length ?? 1) - 1) {
          setState(() => _currentStep++);
        } else if (!_isExerciseComplete) {
          controller.submitManualAttempt();
          controller.stopListening();
        }
        break;
      case HandsFreeCommand.back:
        if (_currentStep > 0) {
          setState(() => _currentStep--);
        }
        break;
      case HandsFreeCommand.repeat:
        controller.stopListening();
        setState(() => _isExerciseComplete = false);
        break;
      case HandsFreeCommand.stop:
        controller.stopListening();
        break;
      case HandsFreeCommand.start:
        controller.startListening();
        break;
      case HandsFreeCommand.skip:
      case HandsFreeCommand.help:
        // Nichts zu tun – wird vom übergeordneten Screen abgefangen.
        break;
    }
  }

  /// Bewertet die letzte Übungs-Genauigkeit und triggert ggf. Adaptive
  /// Difficulty Banner / Confirmation-Dialog.
  void _runAdaptiveEvaluation(double accuracy) {
    if (accuracy <= 0.50) {
      _consecutiveLowAttempts += 1;
    } else if (accuracy >= 0.70) {
      _consecutiveLowAttempts = 0;
    }
    final action =
        AdaptiveEngine.evaluate(accuracy, _consecutiveLowAttempts);
    setState(() {
      _lastAdaptiveAction = action;
      _adaptiveBannerDismissed = false;
    });

    // Bei reviewPrevious: separater Dialog mit Vorschlag.
    if (action == AdaptiveAction.reviewPrevious && mounted) {
      Future.microtask(() => _showReviewPreviousDialog());
    }
    // Bei skipAhead: Vorschlagen, direkt zur nächsten Lektion zu gehen.
    if (action == AdaptiveAction.skipAhead && mounted) {
      Future.microtask(() => _showSkipAheadDialog());
    }
  }

  void _showReviewPreviousDialog() {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kurz wiederholen'),
        content: Text(AdaptiveEngine.describe(AdaptiveAction.reviewPrevious)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Weiter probieren'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Rücksprung zur Modul-Übersicht – User wählt selbst.
              Navigator.of(context).pop();
            },
            child: const Text('Zur Übersicht'),
          ),
        ],
      ),
    );
  }

  void _showSkipAheadDialog() {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Schnelllerner! 🚀'),
        content: const Text(
          'Du hast die Lektion mit über 90% Genauigkeit gemeistert.\n\n'
          'Möchtest du direkt zur nächsten Lektion?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hier bleiben'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Klar!'),
          ),
        ],
      ),
    );
  }

  /// Pädagogik-Info zur aktuellen Lektion mit Fallback-Kette:
  /// 1. (zukünftig) `_lesson.pedagogy` direkt im Lesson-Modell
  /// 2. `LearningRules.lessonPedagogy[id]`
  /// 3. Default mit `XmariSetup.beginnerDefault`
  LessonPedagogyInfo _getPedagogy() {
    return LearningRules.lookupOrDefault(widget.lessonId);
  }

  @override
  void dispose() {
    _handsFreeSub?.cancel();
    WakelockPlus.disable();
    // Best-effort end practice session.
    ref.read(practiceSessionTrackerProvider).end();
    super.dispose();
  }

  Lesson _fallbackLesson() {
    return const Lesson(
      id: 'lesson-01',
      moduleId: 'module-01',
      title: 'Deine erste Note: E',
      description: 'Lerne, die hohe E-Saite (Saite 1) sauber anzuschlagen.',
      instructions: [
        'Halte die Gitarre aufrecht vor dir.',
        'Die dünne Saite oben ist die hohe E-Saite.',
        'Zupfe die Saite mit dem Daumen deiner rechten Hand.',
        'Lass den Ton frei schwingen.',
        'Übe, einen sauberen, klaren Ton zu erzeugen.',
      ],
      xpReward: 50,
      difficulty: 1,
      targetAccuracy: 0.70,
      presetRequired: GuitarPreset.clean,
      estimatedMinutes: 5,
    );
  }

  void _finishLesson(double accuracy, int xpReward, String title) async {
    // Trigger persistence + sync via the controller.
    final controller =
        ref.read(lessonControllerProvider(_lessonKey).notifier);
    await controller.completeLesson();

    // Update XP and streak (which will sync to Supabase).
    final profile = ref.read(currentUserProfileProvider.notifier);
    await profile.addXp(xpReward);
    await profile.incrementStreak();

    // Inform practice tracker of XP earned.
    ref.read(practiceSessionTrackerProvider).addXp(xpReward);

    if (!mounted) return;
    context.go(
      '/lesson-complete',
      extra: {
        'lessonTitle': title,
        'xpEarned': xpReward,
        'accuracy': accuracy,
        'newAchievements': <String>[],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = _lesson!;
    final state = ref.watch(lessonControllerProvider(_lessonKey));
    final controller = ref.read(lessonControllerProvider(_lessonKey).notifier);

    // Mikrofon-Fehler anzeigen
    final pitchError = state.pitchError;
    if (pitchError != null && pitchError.contains('Berechtigung')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Mikrofon-Zugriff erforderlich. Bitte in Einstellungen erlauben.'),
            action: SnackBarAction(
              label: 'Einstellungen',
              onPressed: () => openAppSettings(),
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      });
    }

    // Auto-complete the exercise UI when the controller has captured enough.
    if (state.attempts.isNotEmpty &&
        state.attempts.last.exerciseIndex == state.currentExerciseIndex &&
        !_isExerciseComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _isExerciseComplete = true);
        _runAdaptiveEvaluation(state.attempts.last.accuracy);
      });
    }

    final steps = lesson.instructions;
    final isLastStep = _currentStep >= steps.length - 1;
    final accuracy = state.currentAccuracy > 0
        ? state.currentAccuracy
        : state.bestAccuracy;

    // Mark activity for the practice session tracker on every rebuild that
    // occurs from a pitch update.
    if (state.livePitch != null) {
      ref.read(practiceSessionTrackerProvider).markActivity();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(lesson.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20),
            tooltip: 'So geht\'s',
            onPressed: () {
              final tip = _getPedagogy().xmariSetup.explanation;
              ShowMeHowOverlay.show(
                context,
                instruction: steps.isNotEmpty
                    ? steps[_currentStep]
                    : lesson.description,
                lessonId: widget.lessonId,
                xmariTip: tip,
                referenceNote: 'E4',
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentStep + 1} / ${steps.length}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
          LinearProgressIndicator(
            value: steps.isEmpty ? 0 : (_currentStep + 1) / steps.length,
            backgroundColor: AppColors.outline,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.presetClean.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.presetClean.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.graphic_eq,
                            size: 14, color: AppColors.presetClean),
                        const SizedBox(width: 6),
                        Text(
                          lesson.presetRequired.displayName,
                          style: TextStyle(
                            color: AppColors.presetClean,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (steps.isNotEmpty)
                    _InstructionCard(
                      step: _currentStep + 1,
                      total: steps.length,
                      instruction: steps[_currentStep],
                    ),
                  // Interaktives Griffbrett: zeigt die Ziel-Position der
                  // aktuellen Übung. Erscheint nur wenn die Note auf dem
                  // Griffbrett ableitbar ist.
                  if (state.currentExercise?.targetNoteOrChord != null) ...[
                    const SizedBox(height: 16),
                    Builder(builder: (_) {
                      final note = state.currentExercise!.targetNoteOrChord;
                      final positions = FretboardWidget.positionsForNote(note);
                      if (positions.isEmpty) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.outline),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 6),
                              child: Text(
                                'Position: $note',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            FretboardWidget(
                              highlightedPositions: positions,
                              activePosition: positions.first,
                              showFingerNumbers: true,
                              showNoteNames: true,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 24),
                  if ((isLastStep || steps.isEmpty) && !_isExerciseComplete) ...[
                    HandModeSelector(
                      selected: _practiceHand,
                      onChanged: (h) => setState(() => _practiceHand = h),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _practiceHand.xmariTip,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if ((isLastStep || steps.isEmpty) && !_isExerciseComplete)
                    _ExerciseArea(
                      isListening: state.isListening,
                      detectionsCaptured: state.detectionsCaptured,
                      detectionsRequired:
                          state.currentExercise?.repetitionsRequired ?? 4,
                      livePitch: state.livePitch,
                      targetNote:
                          state.currentExercise?.targetNoteOrChord ?? 'E4',
                      onStartListening: () => controller.startListening(),
                      onStopListening: () {
                        controller.submitManualAttempt();
                        controller.stopListening();
                      },
                    ),
                  if (_isExerciseComplete) _AccuracyResult(accuracy: accuracy),
                  if (_isExerciseComplete &&
                      _lastAdaptiveAction != null &&
                      !_adaptiveBannerDismissed)
                    _AdaptiveHintBanner(
                      action: _lastAdaptiveAction!,
                      onDismiss: () =>
                          setState(() => _adaptiveBannerDismissed = true),
                    ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0 && !_isExerciseComplete)
                    OutlinedButton(
                      onPressed: () {
                        controller.stopListening();
                        setState(() => _currentStep--);
                      },
                      child: const Text('Zurück'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isExerciseComplete
                        ? () => _finishLesson(
                              accuracy,
                              lesson.xpReward,
                              lesson.title,
                            )
                        : isLastStep
                            ? () {
                                if (state.isListening) {
                                  controller.submitManualAttempt();
                                  controller.stopListening();
                                } else {
                                  controller.startListening();
                                }
                              }
                            : () {
                                if (_currentStep < steps.length - 1) {
                                  setState(() => _currentStep++);
                                }
                              },
                    child: Text(
                      _isExerciseComplete
                          ? 'Abschließen'
                          : isLastStep
                              ? (state.isListening ? 'Stopp' : 'Üben')
                              : 'Weiter',
                    ),
                  ),
                ],
              ),
            ),
          ),
            ],
          ),  // closes Column
          if (!_xmariSetupShown)
            Builder(builder: (ctx) {
              // Jede Lektion hat dank Fallback-Kette ein Setup.
              final pedagogy = _getPedagogy();
              return Container(
                color: Colors.black54,
                child: Center(
                  child: XmariSetupCard(
                    setup: pedagogy.xmariSetup,
                    onDismiss: () => setState(() => _xmariSetupShown = true),
                  ),
                ),
              );
            }),
          const hf.HandsFreeOverlay(),
        ],  // closes Stack children
      ),  // closes Stack
    );
  }

  void _showExitDialog() {
    int elapsedMinutes = 0;
    try {
      elapsedMinutes =
          ref.read(practiceSessionTrackerProvider).currentSessionMinutes;
    } catch (_) {}

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lektion beenden?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (elapsedMinutes > 0) ...[
              const Text('Dein bisheriger Fortschritt wird gespeichert:'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 8),
                  Text('$elapsedMinutes Minuten geübt'),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Die Lektion wird als unvollständig markiert. Du kannst sie jederzeit fortsetzen.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ] else
              const Text(
                  'Du hast noch nicht geübt. Möchtest du trotzdem beenden?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Weiter üben'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              try {
                ref
                    .read(lessonControllerProvider(_lessonKey).notifier)
                    .stopListening();
              } catch (_) {}
              context.go('/home/lessons');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Beenden & Speichern'),
          ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final int step;
  final int total;
  final String instruction;

  const _InstructionCard({
    required this.step,
    required this.total,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schritt $step von $total',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            instruction,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    ).animate(key: ValueKey(step)).fadeIn().slideX(begin: 0.1);
  }
}

class _ExerciseArea extends StatelessWidget {
  final bool isListening;
  final int detectionsCaptured;
  final int detectionsRequired;
  final dynamic livePitch;
  final String targetNote;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;

  const _ExerciseArea({
    required this.isListening,
    required this.detectionsCaptured,
    required this.detectionsRequired,
    required this.livePitch,
    required this.targetNote,
    required this.onStartListening,
    required this.onStopListening,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isListening
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.outline,
          width: isListening ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (!isListening) ...[
            const Icon(Icons.mic_none, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Bereit zum Üben?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tippe auf den Button und spiele die Note',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onStartListening,
              icon: const Icon(Icons.mic),
              label: const Text('Aufnahme starten'),
            ),
            const SizedBox(height: 12),
            ReferenceAudioButton(note: targetNote),
          ] else ...[
            RealTimeFeedbackWidget(
              result: livePitch,
              targetNote: _parseNote(targetNote),
            ),
            const SizedBox(height: 16),
            Text(
              'Treffer: $detectionsCaptured / $detectionsRequired',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: detectionsRequired == 0
                  ? 0
                  : (detectionsCaptured / detectionsRequired).clamp(0.0, 1.0),
              backgroundColor: AppColors.outline,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onStopListening,
              icon: const Icon(Icons.stop),
              label: const Text('Stopp'),
            ),
          ],
        ],
      ),
    );
  }
}

Note? _parseNote(String s) {
  if (s.isEmpty) return null;
  final match = RegExp(r'^([A-Ga-g][#b]?)(\d+)$').firstMatch(s.trim());
  if (match == null) return null;
  return Note(
    name: match.group(1)!.toUpperCase(),
    octave: int.tryParse(match.group(2)!) ?? 4,
  );
}

class _AccuracyResult extends StatelessWidget {
  final double accuracy;

  const _AccuracyResult({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    final stars = accuracy >= 0.98
        ? 3
        : accuracy >= 0.85
            ? 2
            : accuracy >= 0.70
                ? 1
                : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Icon(
                i < stars ? Icons.star : Icons.star_border,
                color: i < stars ? AppColors.xpColor : AppColors.textTertiary,
                size: 32,
              );
            }),
          ),
          const SizedBox(height: 16),
          _AccuracyGauge(accuracy: accuracy),
          const SizedBox(height: 4),
          Text(
            accuracy >= 0.85
                ? 'Ausgezeichnet!'
                : accuracy >= 0.70
                    ? 'Gut gemacht!'
                    : 'Weiter üben!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }
}

class _AccuracyGauge extends StatelessWidget {
  final double accuracy; // 0.0 to 1.0

  const _AccuracyGauge({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 80,
      child: CustomPaint(
        painter: _GaugePainter(accuracy: accuracy.clamp(0.0, 1.0)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              '${(accuracy * 100).round()}%',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double accuracy; // 0.0 to 1.0

  _GaugePainter({required this.accuracy});

  Color _gaugeColor(double value) {
    if (value <= 0.4) {
      // Red
      return const Color(0xFFCF6679);
    } else if (value <= 0.7) {
      // Interpolate red → yellow
      final t = (value - 0.4) / 0.3;
      return Color.lerp(
        const Color(0xFFCF6679),
        const Color(0xFFFFC107),
        t,
      )!;
    } else {
      // Interpolate yellow → green
      final t = (value - 0.7) / 0.3;
      return Color.lerp(
        const Color(0xFFFFC107),
        const Color(0xFF4CAF50),
        t,
      )!;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 4;
    final radius = size.width / 2 - 8;

    final trackPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = _gaugeColor(accuracy)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    const startAngle = 3.14159; // π (left)
    const sweepAngle = 3.14159; // π (half circle)

    final rect = Rect.fromCircle(
        center: Offset(cx, cy), radius: radius);

    // Track (full half-circle)
    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);

    // Progress arc
    canvas.drawArc(
        rect, startAngle, sweepAngle * accuracy, false, progressPaint);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.accuracy != accuracy;
}


class _AdaptiveHintBanner extends StatelessWidget {
  final AdaptiveAction action;
  final VoidCallback onDismiss;

  const _AdaptiveHintBanner({
    required this.action,
    required this.onDismiss,
  });

  Color _color(BuildContext ctx) {
    switch (action) {
      case AdaptiveAction.skipAhead:
      case AdaptiveAction.celebrate:
        return Colors.green;
      case AdaptiveAction.simplify:
      case AdaptiveAction.repeatSimplified:
        return Colors.amber;
      case AdaptiveAction.reviewPrevious:
      case AdaptiveAction.goBack:
        return Colors.orange;
      case AdaptiveAction.continue_:
      case AdaptiveAction.proceed:
        return Theme.of(ctx).primaryColor;
    }
  }

  IconData _icon() {
    switch (action) {
      case AdaptiveAction.skipAhead:
      case AdaptiveAction.celebrate:
        return Icons.rocket_launch;
      case AdaptiveAction.simplify:
      case AdaptiveAction.repeatSimplified:
        return Icons.lightbulb_outline;
      case AdaptiveAction.reviewPrevious:
      case AdaptiveAction.goBack:
        return Icons.replay;
      default:
        return Icons.thumb_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(_icon(), size: 20, color: c),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AdaptiveEngine.describe(action),
              style: TextStyle(color: c, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: c),
            tooltip: 'Hinweis ausblenden',
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
