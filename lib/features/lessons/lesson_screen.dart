import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/theme/colors.dart';
import '../../core/models/lesson.dart';

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
  double _accuracy = 0.0;
  bool _isExerciseComplete = false;
  bool _isListening = false;

  // Simulate lesson data for the selected lesson
  late final Lesson _lesson;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _lesson = _buildMockLesson();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  Lesson _buildMockLesson() {
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

  void _completeExercise() {
    setState(() {
      _accuracy = 0.85;
      _isExerciseComplete = true;
    });
  }

  void _finishLesson() {
    context.go(
      '/lesson-complete',
      extra: {
        'lessonTitle': _lesson.title,
        'xpEarned': _lesson.xpReward,
        'accuracy': _accuracy,
        'newAchievements': <String>[],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _lesson.instructions;
    final isLastStep = _currentStep >= steps.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(_lesson.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
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
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentStep + 1) / steps.length,
            backgroundColor: AppColors.outline,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preset indicator
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
                          _lesson.presetRequired.displayName,
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

                  // Current instruction
                  _InstructionCard(
                    step: _currentStep + 1,
                    total: steps.length,
                    instruction: steps[_currentStep],
                  ),

                  const SizedBox(height: 24),

                  // Exercise area (simplified for lesson display)
                  if (_currentStep == steps.length - 1 && !_isExerciseComplete)
                    _ExerciseArea(
                      isListening: _isListening,
                      onStartListening: () {
                        setState(() => _isListening = true);
                        // Simulate completion after 3 seconds
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) _completeExercise();
                        });
                      },
                    ),

                  if (_isExerciseComplete)
                    _AccuracyResult(accuracy: _accuracy),
                ],
              ),
            ),
          ),

          // Bottom navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: () {
                        setState(() => _currentStep--);
                      },
                      child: const Text('Zurück'),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isExerciseComplete
                        ? _finishLesson
                        : isLastStep && !_isListening
                            ? () => setState(() => _isListening = false)
                            : () {
                                if (_currentStep < steps.length - 1) {
                                  setState(() {
                                    _currentStep++;
                                    _isListening = false;
                                  });
                                }
                              },
                    child: Text(
                      _isExerciseComplete
                          ? 'Abschließen 🎉'
                          : isLastStep
                              ? 'Üben'
                              : 'Weiter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lektion beenden?'),
        content: const Text(
            'Dein Fortschritt in dieser Lektion wird nicht gespeichert.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Weiter üben'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home/lessons');
            },
            child: Text('Beenden', style: TextStyle(color: AppColors.error)),
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
  final VoidCallback onStartListening;

  const _ExerciseArea({
    required this.isListening,
    required this.onStartListening,
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
              'Tippe auf den Button und spiele die E-Note',
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
          ] else ...[
            const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Spiele jetzt...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                  ),
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
    final stars = accuracy >= 0.98 ? 3 : accuracy >= 0.85 ? 2 : accuracy >= 0.70 ? 1 : 0;

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
          const SizedBox(height: 12),
          Text(
            '${(accuracy * 100).round()}% Genauigkeit',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            accuracy >= 0.85 ? 'Ausgezeichnet!' : accuracy >= 0.70 ? 'Gut gemacht!' : 'Weiter üben!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }
}
