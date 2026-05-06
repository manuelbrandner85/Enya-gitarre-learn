import 'package:flutter/material.dart';
import '../../../core/bluetooth/xmari_constants.dart';

class JourneyMapWidget extends StatelessWidget {
  final int completedModules;
  final int currentModule;
  final int totalModules;

  const JourneyMapWidget({
    super.key,
    required this.completedModules,
    required this.currentModule,
    this.totalModules = 12,
  });

  static const List<String> _presetUnlocks = [
    '', '', '', '', '',              // Module 1-5: nur Infotexte
    'Overdrive freigeschaltet! 🔥',  // Modul 6
    '', '',                          // Module 7-8
    'Distortion freigeschaltet! 🎸', // Modul 9
    '',                              // Modul 10
    'High-Gain freigeschaltet! 🤘',  // Modul 11
    '',                              // Modul 12
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          // Pfad
          CustomPaint(
            size: const Size(double.infinity, 600),
            painter: _JourneyPathPainter(completedModules: completedModules, total: totalModules),
          ),
          // Stationen
          ...List.generate(totalModules, (i) {
            final moduleNum = totalModules - i; // 12 oben, 1 unten
            final moduleIndex = moduleNum - 1;
            final isCompleted = moduleIndex < completedModules;
            final isCurrent = moduleIndex == currentModule - 1;
            final isLocked = moduleIndex > completedModules;

            final x = (moduleIndex % 2 == 0) ? 60.0 : 280.0;
            final y = 30.0 + (totalModules - 1 - moduleIndex) * 50.0;

            return Positioned(
              left: x - 20,
              top: y - 20,
              child: _StationDot(
                module: moduleNum,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLocked: isLocked,
                presetUnlock: moduleIndex < _presetUnlocks.length ? _presetUnlocks[moduleIndex] : '',
                presetIndex: moduleIndex >= 10 ? 3 : moduleIndex >= 8 ? 2 : moduleIndex >= 5 ? 1 : 0,
              ),
            );
          }),
          // Rockstar am Ende
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: completedModules >= totalModules ? [
                    BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 16, spreadRadius: 4),
                  ] : [],
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StationDot extends StatefulWidget {
  final int module;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final String presetUnlock;
  final int presetIndex;

  const _StationDot({
    required this.module,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.presetUnlock,
    required this.presetIndex,
  });

  @override
  State<_StationDot> createState() => _StationDotState();
}

class _StationDotState extends State<_StationDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    if (widget.isCompleted) {
      dotColor = const Color(0xFFFFD700);
    } else if (widget.isCurrent) {
      dotColor = const Color(0xFF7C3AED);
    } else if (widget.isLocked) {
      dotColor = Colors.grey;
    } else {
      dotColor = const Color(0xFF3B82F6);
    }

    Widget dot = Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: dotColor.withOpacity(widget.isLocked ? 0.3 : 1.0),
        shape: BoxShape.circle,
        border: Border.all(color: dotColor, width: 2),
      ),
      child: Center(
        child: widget.isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : widget.isLocked
                ? const Icon(Icons.lock, color: Colors.white54, size: 14)
                : Text('${widget.module}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    if (widget.isCurrent) {
      dot = ScaleTransition(scale: _scale, child: dot);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot,
        if (widget.presetUnlock.isNotEmpty) ...[
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: XmariConstants.presetColor(widget.presetIndex).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(widget.presetUnlock,
                style: TextStyle(fontSize: 8, color: XmariConstants.presetColor(widget.presetIndex))),
          ),
        ],
      ],
    );
  }
}

class _JourneyPathPainter extends CustomPainter {
  final int completedModules;
  final int total;
  const _JourneyPathPainter({required this.completedModules, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final completedPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool started = false;
    for (int i = 0; i < total; i++) {
      final x = (i % 2 == 0) ? 60.0 : 280.0;
      final y = 30.0 + (total - 1 - i) * 50.0;
      if (!started) { path.moveTo(x, y); started = true; }
      else { path.lineTo(x, y); }
    }
    canvas.drawPath(path, paint);

    if (completedModules > 1) {
      final cPath = Path();
      bool cStarted = false;
      for (int i = 0; i < completedModules.clamp(0, total); i++) {
        final x = (i % 2 == 0) ? 60.0 : 280.0;
        final y = 30.0 + (total - 1 - i) * 50.0;
        if (!cStarted) { cPath.moveTo(x, y); cStarted = true; }
        else { cPath.lineTo(x, y); }
      }
      canvas.drawPath(cPath, completedPaint);
    }
  }

  @override
  bool shouldRepaint(_JourneyPathPainter old) => old.completedModules != completedModules;
}
