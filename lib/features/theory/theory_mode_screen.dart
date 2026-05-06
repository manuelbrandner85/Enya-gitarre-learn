import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/colors.dart';
import '../../core/music_theory/note_colors.dart';

enum TheoryCategory {
  fretboardQuiz,
  chordRecognition,
  earTraining,
  rhythmClap,
}

class TheoryModeScreen extends ConsumerStatefulWidget {
  const TheoryModeScreen({super.key});

  @override
  ConsumerState<TheoryModeScreen> createState() => _TheoryModeScreenState();
}

class _TheoryModeScreenState extends ConsumerState<TheoryModeScreen> {
  TheoryCategory? _selectedCategory;
  int _score = 0;
  int _total = 0;
  String? _currentQuestion;
  String? _correctAnswer;
  List<String> _options = [];
  bool? _lastAnswerCorrect;

  static const _notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  static const _chords = [
    'Em', 'Am', 'D', 'G', 'C', 'A', 'E', 'F', 'Bm', 'Dm'
  ];

  void _startCategory(TheoryCategory cat) {
    setState(() {
      _selectedCategory = cat;
      _score = 0;
      _total = 0;
      _lastAnswerCorrect = null;
    });
    _nextQuestion();
  }

  void _nextQuestion() {
    final rng = math.Random();
    switch (_selectedCategory) {
      case TheoryCategory.fretboardQuiz:
        final note = _notes[rng.nextInt(_notes.length)];
        setState(() {
          _currentQuestion = 'Welche Note ist das?';
          _correctAnswer = note;
          _options = _generateOptions(note, _notes);
        });
        break;
      case TheoryCategory.chordRecognition:
        final chord = _chords[rng.nextInt(_chords.length)];
        setState(() {
          _currentQuestion = 'Erkenne den Akkord';
          _correctAnswer = chord;
          _options = _generateOptions(chord, _chords);
        });
        break;
      default:
        setState(() {
          _currentQuestion = 'Theorie-Modus';
          _correctAnswer = 'C';
          _options = ['C', 'D', 'E', 'F'];
        });
    }
  }

  List<String> _generateOptions(String correct, List<String> pool) {
    final rng = math.Random();
    final opts = <String>{correct};
    while (opts.length < 4) {
      opts.add(pool[rng.nextInt(pool.length)]);
    }
    return opts.toList()..shuffle();
  }

  void _answer(String answer) {
    final correct = answer == _correctAnswer;
    setState(() {
      _lastAnswerCorrect = correct;
      _total++;
      if (correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _lastAnswerCorrect = null);
        _nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == null) return _buildCategorySelect();
    return _buildQuiz();
  }

  Widget _buildCategorySelect() {
    return Scaffold(
      appBar: AppBar(title: const Text('Theorie-Modus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lerne Theorie – auch ohne Gitarre',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('🌙 Ideal für unterwegs oder abends',
                style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 24),
            ...[
              _CategoryCard(
                icon: Icons.grid_on,
                title: 'Griffbrett-Quiz',
                description: 'Lerne alle 22 Bünde deiner XMARI',
                color: AppColors.info,
                onTap: () =>
                    _startCategory(TheoryCategory.fretboardQuiz),
              ),
              _CategoryCard(
                icon: Icons.music_note,
                title: 'Akkord-Erkennung',
                description: 'Erkenne Akkorde nach ihrem Klang',
                color: AppColors.fingerThumb,
                onTap: () =>
                    _startCategory(TheoryCategory.chordRecognition),
              ),
              _CategoryCard(
                icon: Icons.hearing,
                title: 'Gehörtraining',
                description: 'Trainiere dein musikalisches Gehör',
                color: AppColors.success,
                onTap: () =>
                    _startCategory(TheoryCategory.earTraining),
              ),
              _CategoryCard(
                icon: Icons.access_time,
                title: 'Rhythmus klatschen',
                description: 'Halte den Takt ohne Gitarre',
                color: AppColors.warning,
                onTap: () =>
                    _startCategory(TheoryCategory.rhythmClap),
              ),
            ]
                .map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: w))
                .toList(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 Tipp: Morgen diese Theorie direkt auf deiner XMARI ausprobieren!',
                style:
                    TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory!.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              setState(() => _selectedCategory = null),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('$_score/$_total',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _total > 0 ? _score / _total : 0,
              color: AppColors.success,
            ),
            const Spacer(),
            if (_currentQuestion != null)
              Text(_currentQuestion!,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            if (_correctAnswer != null) ...[
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: NoteColors.forNoteWithOpacity(
                      _correctAnswer![0], 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color:
                          NoteColors.forNote(_correctAnswer![0]),
                      width: 2),
                ),
                child: Center(
                  child: Text(
                    _correctAnswer![0],
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: NoteColors.forNote(
                            _correctAnswer![0])),
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (_lastAnswerCorrect != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (_lastAnswerCorrect!
                          ? AppColors.success
                          : AppColors.error)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _lastAnswerCorrect! ? '✓ Richtig!' : '✗ Falsch',
                  style: TextStyle(
                    color: _lastAnswerCorrect!
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: _options
                  .map((opt) => ElevatedButton(
                        onPressed: _lastAnswerCorrect != null
                            ? null
                            : () => _answer(opt),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.surfaceDark),
                        child: Text(opt,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description,
            style: const TextStyle(
                fontSize: 12, color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
