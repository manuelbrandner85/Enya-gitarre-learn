import 'dart:async';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/audio/pitch_detector.dart';
import '../../../core/providers/app_providers.dart';
import '../../../app/theme/colors.dart';

class FirstNotePage extends ConsumerStatefulWidget {
  final VoidCallback onCompleted;
  final VoidCallback onSkipped;

  const FirstNotePage({
    super.key,
    required this.onCompleted,
    required this.onSkipped,
  });

  @override
  ConsumerState<FirstNotePage> createState() => _FirstNotePageState();
}

class _FirstNotePageState extends ConsumerState<FirstNotePage>
    with TickerProviderStateMixin {
  final _pitchDetector = PitchDetector();
  late final ConfettiController _confettiController;
  late final AnimationController _pulseController;
  late final AnimationController _checkController;

  StreamSubscription<PitchResult>? _pitchSub;
  _DetectionState _state = _DetectionState.waiting;
  PitchResult? _lastPitch;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _requestPermissionAndStart();
  }

  Future<void> _requestPermissionAndStart() async {
    final status = await Permission.microphone.request();
    if (!mounted) return;
    if (status.isGranted) {
      await _pitchDetector.start();
      _pitchSub = _pitchDetector.pitchStream.listen(_onPitch);
    }
  }

  void _onPitch(PitchResult pitch) {
    if (!mounted || _completed) return;
    setState(() => _lastPitch = pitch);

    if (!pitch.isValid) {
      setState(() => _state = _DetectionState.waiting);
      return;
    }

    // E2 = MIDI 40, frequency ~82.4 Hz, accept ±50 cents
    final isE2 = pitch.midiNote >= 38 &&
        pitch.midiNote <= 42 &&
        pitch.centsOff.abs() <= 50;
    final isLowNote = pitch.midiNote < 50; // below D3

    if (isE2) {
      _onSuccess();
    } else if (pitch.amplitude > 0.05 && isLowNote) {
      setState(() => _state = _DetectionState.almostRight);
    } else if (pitch.amplitude > 0.05) {
      setState(() => _state = _DetectionState.hearing);
    } else {
      setState(() => _state = _DetectionState.waiting);
    }
  }

  void _onSuccess() {
    if (_completed) return;
    _completed = true;
    setState(() => _state = _DetectionState.success);
    _confettiController.play();
    HapticFeedback.heavyImpact();
    _checkController.forward();

    // Award XP
    ref.read(currentUserProfileProvider.notifier).addXp(50);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onCompleted();
    });
  }

  @override
  void dispose() {
    _pitchSub?.cancel();
    _pitchDetector.stop();
    _pitchDetector.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: widget.onSkipped,
                    child: const Text('Überspringen',
                        style: TextStyle(color: Colors.white54)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Spiel deinen ersten Ton!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: -0.2),
                const SizedBox(height: 8),
                const Text(
                  'Zupfe die dickste Saite deiner Gitarre\n(die tiefe E-Saite)',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 40),
                _buildDetectorCircle(),
                const SizedBox(height: 32),
                _buildStatusText(),
                const Spacer(),
                if (_state == _DetectionState.success)
                  ElevatedButton.icon(
                    onPressed: widget.onCompleted,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Weiter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ).animate().fadeIn().scale(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 40,
          colors: const [
            Color(0xFF7C3AED),
            Color(0xFF3B82F6),
            Color(0xFFFFD700),
            Color(0xFF4CAF50),
            Color(0xFFFF6B35),
          ],
        ),
      ],
    );
  }

  Widget _buildDetectorCircle() {
    final isSuccess = _state == _DetectionState.success;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = isSuccess ? 1.0 : 1.0 + _pulseController.value * 0.08;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isSuccess
                    ? [
                        AppColors.success,
                        AppColors.success.withOpacity(0.3)
                      ]
                    : [
                        AppColors.primary.withOpacity(0.3),
                        Colors.transparent
                      ],
              ),
              border: Border.all(
                color: isSuccess ? AppColors.success : AppColors.primary,
                width: 3,
              ),
            ),
            child: isSuccess
                ? ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _checkController,
                      curve: Curves.elasticOut,
                    ),
                    child: const Icon(Icons.check,
                        size: 80, color: Colors.white),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _lastPitch?.isValid == true
                            ? Icons.graphic_eq
                            : Icons.mic,
                        size: 48,
                        color: Colors.white70,
                      ),
                      if (_lastPitch?.isValid == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          _lastPitch!.fullNoteName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_lastPitch!.frequency.toStringAsFixed(1)} Hz',
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildStatusText() {
    final (text, color) = switch (_state) {
      _DetectionState.waiting => ('Warte auf dein Signal...', Colors.white54),
      _DetectionState.hearing => ('Ich höre etwas...', Colors.white70),
      _DetectionState.almostRight => (
          'Fast! Versuche die dickste Saite',
          AppColors.warning
        ),
      _DetectionState.success => (
          'PERFEKT! Das ist ein E! +50 XP 🎸',
          AppColors.success
        ),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(_state),
        style: TextStyle(
            fontSize: 18, color: color, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}

enum _DetectionState { waiting, hearing, almostRight, success }
