import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/theme/colors.dart';
import '../../core/curriculum/curriculum.dart';
import '../../core/curriculum/hand_isolation.dart';
import '../../core/curriculum/pedagogy/learning_rules.dart';
import '../../core/models/lesson.dart';
import '../../core/practice/practice_session_tracker.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/hands_free_overlay.dart';
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
  bool _xmariSetupShown = false;
  PracticeHand _practiceHand = PracticeHand.both;

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

    final pedagogy = LearningRules.lessonPedagogy[widget.lessonId];
    if (pedagogy?.xmariSetup != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _xmariSetupShown = false);
      });
    }
  }

  @override
  void dispose() {
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

    // Auto-complete the exercise UI when the controller has captured enough.
    if (state.attempts.isNotEmpty &&
        state.attempts.last.exerciseIndex == state.currentExerciseIndex &&
        !_isExerciseComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _isExerciseComplete = true);
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
              final tip = LearningRules.lessonPedagogy[widget.lessonId]
                  ?.xmariSetup?.explanation;
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
              padding: const EdgeInsets.all(24),
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
                      onStartListening: () => controller.startListening(),
                      onStopListening: () => controller.stopListening(),
                    ),
                  if (_isExerciseComplete) _AccuracyResult(accuracy: accuracy),
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
              final pedagogy =
                  LearningRules.lessonPedagogy[widget.lessonId];
              if (pedagogy?.xmariSetup == null) return const SizedBox.shrink();
              return Container(
                color: Colors.black54,
                child: Center(
                  child: XmariSetupCard(
                    setup: pedagogy!.xmariSetup,
                    onDismiss: () => setState(() => _xmariSetupShown = true),
                  ),
                ),
              );
            }),
          const HandsFreeOverlay(),
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
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;

  const _ExerciseArea({
    required this.isListening,
    required this.detectionsCaptured,
    required this.detectionsRequired,
    required this.livePitch,
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
            const ReferenceAudioButton(note: 'E4'),
          ] else ...[
            RealTimeFeedbackWidget(result: livePitch),
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
