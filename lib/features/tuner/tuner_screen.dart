import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/pitch_detector.dart';
import '../../core/audio/tuner_service.dart';
import '../../core/utils/constants.dart';

final tunerServiceProvider = Provider<TunerService>((ref) {
  final service = TunerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final tunerReadingProvider = StreamProvider<TunerReading>((ref) {
  final service = ref.watch(tunerServiceProvider);
  return service.tunerStream;
});

class TunerScreen extends ConsumerStatefulWidget {
  const TunerScreen({super.key});

  @override
  ConsumerState<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends ConsumerState<TunerScreen> {
  bool _isActive = false;
  TuningType _selectedTuning = TuningType.standard;

  @override
  Widget build(BuildContext context) {
    final tunerReading = ref.watch(tunerReadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Gitarren-Stimmgerät'),
        actions: [
          PopupMenuButton<TuningType>(
            icon: const Icon(Icons.tune),
            onSelected: (tuning) {
              setState(() => _selectedTuning = tuning);
              ref.read(tunerServiceProvider).setTuningType(tuning);
            },
            itemBuilder: (ctx) => TuningType.values
                .map(
                  (t) => PopupMenuItem(
                    value: t,
                    child: Row(
                      children: [
                        if (t == _selectedTuning)
                          const Icon(Icons.check,
                              size: 16, color: AppColors.primary)
                        else
                          const SizedBox(width: 16),
                        const SizedBox(width: 8),
                        Text(t.displayName),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Tuning type label
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariantDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Text(
                      _selectedTuning.displayName,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                        fontSize: 13,
                      ),
                    ),
                  ).animate().fadeIn(),

                  const Spacer(),

                  // Main note display
                  tunerReading.when(
                    data: (reading) => _buildTunerDisplay(context, reading),
                    loading: () => _buildIdleDisplay(context),
                    error: (_, __) => _buildIdleDisplay(context),
                  ),

                  const Spacer(),

                  // String indicators
                  _buildStringIndicators(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom activation button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton.icon(
                    key: ValueKey(_isActive),
                    onPressed: _toggleTuner,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isActive ? AppColors.error : AppColors.primary,
                    ),
                    icon: Icon(_isActive ? Icons.mic_off : Icons.mic),
                    label: Text(_isActive ? 'Stoppen' : 'Stimmgerät starten'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTunerDisplay(BuildContext context, TunerReading reading) {
    final inTune = reading.isInTune;
    final almostInTune = reading.isAlmostInTune;

    final indicatorColor = inTune
        ? AppColors.primary
        : almostInTune
            ? AppColors.warning
            : AppColors.error;

    return Column(
      children: [
        // Note name - large display
        Text(
          _isActive && reading.amplitude > 0.01
              ? reading.detectedNote.fullName
              : '--',
          style: AppTypography.noteDisplay.copyWith(
            color: inTune && _isActive ? AppColors.primary : AppColors.textPrimary,
          ),
        ).animate(key: ValueKey(reading.detectedNote.fullName)).fadeIn(duration: 100.ms),

        const SizedBox(height: 8),

        // Frequency display
        if (_isActive && reading.frequency > 0)
          Text(
            '${reading.frequency.toStringAsFixed(1)} Hz',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontFamily: 'JetBrainsMono',
                ),
          ),

        const SizedBox(height: 32),

        // Tuning meter
        _TuningMeter(
          offset: _isActive ? reading.tuningOffset : 0.0,
          color: indicatorColor,
        ),

        const SizedBox(height: 16),

        // Cents display
        if (_isActive && reading.amplitude > 0.01)
          Text(
            reading.isInTune
                ? '✓ Gestimmt'
                : reading.direction == TuningDirection.sharp
                    ? '▲ ${reading.centsOff.toStringAsFixed(0)} ¢ zu hoch'
                    : '▼ ${reading.centsOff.abs().toStringAsFixed(0)} ¢ zu tief',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: indicatorColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
      ],
    );
  }

  Widget _buildIdleDisplay(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.graphic_eq,
          size: 80,
          color: AppColors.textTertiary,
        ),
        const SizedBox(height: 16),
        Text(
          'Stimmgerät inaktiv',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Starte das Stimmgerät und spiele eine Saite',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStringIndicators() {
    final strings = AppConstants.stringNames;
    final targetFreqs = AppConstants.standardTuningHz;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(strings.length, (i) {
        return Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariantDark,
                border: Border.all(color: AppColors.outline),
              ),
              child: Center(
                child: Text(
                  strings[i],
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${targetFreqs[i].toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _toggleTuner() async {
    final service = ref.read(tunerServiceProvider);
    if (_isActive) {
      await service.stop();
    } else {
      await service.start();
    }
    setState(() => _isActive = !_isActive);
  }
}

class _TuningMeter extends StatelessWidget {
  final double offset; // -1.0 to 1.0
  final Color color;

  const _TuningMeter({
    required this.offset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Track
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Center line
          Container(
            width: 2,
            height: 24,
            color: AppColors.textPrimary,
          ),

          // Indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment(offset.clamp(-1.0, 1.0), 0),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Scale marks
          Positioned(
            left: 0,
            child: Text(
              '-50¢',
              style: TextStyle(
                  fontSize: 9,
                  color: AppColors.textTertiary,
                  fontFamily: 'JetBrainsMono'),
            ),
          ),
          Positioned(
            right: 0,
            child: Text(
              '+50¢',
              style: TextStyle(
                  fontSize: 9,
                  color: AppColors.textTertiary,
                  fontFamily: 'JetBrainsMono'),
            ),
          ),
        ],
      ),
    );
  }
}
