import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/audio/metronome_service.dart';
import '../../core/utils/constants.dart';

final metronomeServiceProvider = Provider<MetronomeService>((ref) {
  final service = MetronomeService();
  ref.onDispose(() => service.dispose());
  return service;
});

final metronomeBeatProvider = StreamProvider<BeatEvent>((ref) {
  return ref.watch(metronomeServiceProvider).beatStream;
});

final metronomeStateProvider =
    StateNotifierProvider<MetronomeStateNotifier, MetronomeState>((ref) {
  return MetronomeStateNotifier();
});

class MetronomeState {
  final bool isPlaying;
  final int bpm;
  final TimeSignature timeSignature;
  final MetronomeSound sound;
  final int currentBeat;

  const MetronomeState({
    this.isPlaying = false,
    this.bpm = AppConstants.defaultBpm,
    this.timeSignature = TimeSignature.fourFour,
    this.sound = MetronomeSound.click,
    this.currentBeat = 0,
  });

  MetronomeState copyWith({
    bool? isPlaying,
    int? bpm,
    TimeSignature? timeSignature,
    MetronomeSound? sound,
    int? currentBeat,
  }) {
    return MetronomeState(
      isPlaying: isPlaying ?? this.isPlaying,
      bpm: bpm ?? this.bpm,
      timeSignature: timeSignature ?? this.timeSignature,
      sound: sound ?? this.sound,
      currentBeat: currentBeat ?? this.currentBeat,
    );
  }
}

class MetronomeStateNotifier extends StateNotifier<MetronomeState> {
  MetronomeStateNotifier() : super(const MetronomeState());

  void setBpm(int bpm) => state = state.copyWith(bpm: bpm);
  void setTimeSignature(TimeSignature sig) =>
      state = state.copyWith(timeSignature: sig);
  void setSound(MetronomeSound s) => state = state.copyWith(sound: s);
  void setPlaying(bool playing) => state = state.copyWith(isPlaying: playing);
  void setBeat(int beat) => state = state.copyWith(currentBeat: beat);
}

class MetronomeScreen extends ConsumerStatefulWidget {
  const MetronomeScreen({super.key});

  @override
  ConsumerState<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends ConsumerState<MetronomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pendulumController;
  late Animation<double> _pendulumAnimation;

  @override
  void initState() {
    super.initState();
    _pendulumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pendulumAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _pendulumController, curve: Curves.easeInOutSine),
    );

    ref.listenManual(metronomeBeatProvider, (_, next) {
      next.whenData((beat) {
        ref.read(metronomeStateProvider.notifier).setBeat(beat.beatNumber);
        _pendulumController.forward(from: 0).then((_) {
          _pendulumController.reverse();
        });
      });
    });
  }

  @override
  void dispose() {
    _pendulumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(metronomeStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Metronom')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // BPM Display
            _buildBpmDisplay(context, state),

            const SizedBox(height: 32),

            // Pendulum visual
            _buildPendulum(state),

            const SizedBox(height: 32),

            // Beat indicators
            _buildBeatIndicators(state),

            const SizedBox(height: 32),

            // BPM slider
            _buildBpmSlider(state),

            const SizedBox(height: 24),

            // Time signature selector
            _buildTimeSignatureSelector(state),

            const SizedBox(height: 24),

            // Sound selector
            _buildSoundSelector(state),

            const Spacer(),

            // Controls
            _buildControls(state),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBpmDisplay(BuildContext context, MetronomeState state) {
    return Column(
      children: [
        Text(
          '${state.bpm}',
          style: AppTypography.bpmDisplay.copyWith(
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(),
        Text(
          MetronomeService.tempoMarking(state.bpm),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  Widget _buildPendulum(MetronomeState state) {
    return SizedBox(
      height: 120,
      child: AnimatedBuilder(
        animation: _pendulumAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _pendulumAnimation.value * 0.4,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 4,
                    height: 80,
                    decoration: BoxDecoration(
                      color: state.isPlaying
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: state.isPlaying
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBeatIndicators(MetronomeState state) {
    final beats = state.timeSignature.beatsPerMeasure;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(beats, (i) {
        final isActive = state.isPlaying && state.currentBeat == (i + 1);
        final isAccent = (i + 1) == 1;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 20 : 16,
          height: isActive ? 20 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (isAccent ? AppColors.secondary : AppColors.primary)
                : AppColors.outline,
          ),
        );
      }),
    );
  }

  Widget _buildBpmSlider(MetronomeState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppConstants.minBpm}',
              style: TextStyle(
                  color: AppColors.textTertiary,
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12),
            ),
            Text(
              '${AppConstants.maxBpm}',
              style: TextStyle(
                  color: AppColors.textTertiary,
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12),
            ),
          ],
        ),
        Slider(
          value: state.bpm.toDouble(),
          min: AppConstants.minBpm.toDouble(),
          max: AppConstants.maxBpm.toDouble(),
          divisions: AppConstants.maxBpm - AppConstants.minBpm,
          label: '${state.bpm} BPM',
          onChanged: (value) async {
            final newBpm = value.round();
            ref.read(metronomeStateProvider.notifier).setBpm(newBpm);
            if (state.isPlaying) {
              await ref.read(metronomeServiceProvider).setBpm(newBpm);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimeSignatureSelector(MetronomeState state) {
    return Row(
      children: [
        Text(
          'Takt:',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TimeSignature.values.map((sig) {
                final isSelected = sig == state.timeSignature;
                return GestureDetector(
                  onTap: () async {
                    ref
                        .read(metronomeStateProvider.notifier)
                        .setTimeSignature(sig);
                    if (state.isPlaying) {
                      await ref
                          .read(metronomeServiceProvider)
                          .setTimeSignature(sig);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.surfaceVariantDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outline,
                      ),
                    ),
                    child: Text(
                      sig.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSoundSelector(MetronomeState state) {
    return Row(
      children: [
        Text(
          'Sound:',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MetronomeSound.values.map((s) {
                final isSelected = s == state.sound;
                return GestureDetector(
                  onTap: () {
                    ref.read(metronomeStateProvider.notifier).setSound(s);
                    ref.read(metronomeServiceProvider).setSound(s);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withOpacity(0.2)
                          : AppColors.surfaceVariantDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.outline,
                      ),
                    ),
                    child: Text(
                      s.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontFamily: 'Inter',
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls(MetronomeState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tap tempo button
        OutlinedButton.icon(
          onPressed: () {
            final service = ref.read(metronomeServiceProvider);
            final newBpm = service.tapTempo();
            ref.read(metronomeStateProvider.notifier).setBpm(newBpm);
          },
          icon: const Icon(Icons.touch_app),
          label: const Text('Tap'),
        ),

        const SizedBox(width: 16),

        // Play/pause button
        SizedBox(
          width: 72,
          height: 72,
          child: ElevatedButton(
            onPressed: () => _toggleMetronome(state),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor:
                  state.isPlaying ? AppColors.error : AppColors.primary,
            ),
            child: Icon(
              state.isPlaying ? Icons.stop : Icons.play_arrow,
              size: 32,
              color: state.isPlaying ? Colors.white : Colors.black,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Reset button
        OutlinedButton.icon(
          onPressed: () {
            ref
                .read(metronomeStateProvider.notifier)
                .setBpm(AppConstants.defaultBpm);
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
      ],
    );
  }

  Future<void> _toggleMetronome(MetronomeState state) async {
    final service = ref.read(metronomeServiceProvider);
    final notifier = ref.read(metronomeStateProvider.notifier);

    if (state.isPlaying) {
      await service.stop();
      notifier.setPlaying(false);
    } else {
      await service.initialize();
      await service.start(state.bpm, state.timeSignature);
      notifier.setPlaying(true);
    }
  }
}
