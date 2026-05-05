import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';

class SongData {
  final String id;
  final String title;
  final String artist;
  final int difficulty;
  final String genre;
  final List<String> chords;
  final String lessonRef;

  const SongData({
    required this.id,
    required this.title,
    required this.artist,
    required this.difficulty,
    required this.genre,
    required this.chords,
    required this.lessonRef,
  });
}

const List<SongData> kSongs = [
  SongData(
    id: 'smoke-on-the-water',
    title: 'Smoke on the Water',
    artist: 'Deep Purple',
    difficulty: 1,
    genre: 'Rock',
    chords: ['G5', 'A5', 'C5'],
    lessonRef: 'module_3/lesson_2',
  ),
  SongData(
    id: 'seven-nation-army',
    title: 'Seven Nation Army',
    artist: 'The White Stripes',
    difficulty: 1,
    genre: 'Rock',
    chords: ['E5', 'G5', 'D5', 'C5', 'B5'],
    lessonRef: 'module_3/lesson_3',
  ),
  SongData(
    id: 'wonderful-tonight',
    title: 'Wonderful Tonight',
    artist: 'Eric Clapton',
    difficulty: 2,
    genre: 'Pop',
    chords: ['G', 'D', 'C', 'Em'],
    lessonRef: 'module_4/lesson_1',
  ),
  SongData(
    id: 'knockin-on-heavens-door',
    title: "Knockin' on Heaven's Door",
    artist: 'Bob Dylan',
    difficulty: 2,
    genre: 'Folk',
    chords: ['G', 'D', 'Am', 'C'],
    lessonRef: 'module_4/lesson_2',
  ),
  SongData(
    id: 'horse-with-no-name',
    title: 'A Horse with No Name',
    artist: 'America',
    difficulty: 2,
    genre: 'Folk',
    chords: ['Em', 'D'],
    lessonRef: 'module_2/lesson_4',
  ),
  SongData(
    id: 'creep',
    title: 'Creep',
    artist: 'Radiohead',
    difficulty: 2,
    genre: 'Rock',
    chords: ['G', 'B', 'C', 'Cm'],
    lessonRef: 'module_5/lesson_1',
  ),
  SongData(
    id: 'smells-like-teen-spirit',
    title: 'Smells Like Teen Spirit',
    artist: 'Nirvana',
    difficulty: 3,
    genre: 'Rock',
    chords: ['F5', 'A#5', 'G#5', 'C#5'],
    lessonRef: 'module_6/lesson_2',
  ),
  SongData(
    id: 'enter-sandman',
    title: 'Enter Sandman',
    artist: 'Metallica',
    difficulty: 4,
    genre: 'Metal',
    chords: ['E5', 'G5', 'A5', 'F#5'],
    lessonRef: 'module_8/lesson_1',
  ),
  SongData(
    id: 'iron-man',
    title: 'Iron Man',
    artist: 'Black Sabbath',
    difficulty: 3,
    genre: 'Metal',
    chords: ['B5', 'D5', 'E5', 'G5'],
    lessonRef: 'module_7/lesson_3',
  ),
  SongData(
    id: 'back-in-black',
    title: 'Back in Black',
    artist: 'AC/DC',
    difficulty: 3,
    genre: 'Rock',
    chords: ['E5', 'D5', 'A5'],
    lessonRef: 'module_6/lesson_4',
  ),
  SongData(
    id: 'paranoid',
    title: 'Paranoid',
    artist: 'Black Sabbath',
    difficulty: 4,
    genre: 'Metal',
    chords: ['E5', 'D5', 'G5'],
    lessonRef: 'module_8/lesson_2',
  ),
  SongData(
    id: 'you-really-got-me',
    title: 'You Really Got Me',
    artist: 'The Kinks',
    difficulty: 2,
    genre: 'Rock',
    chords: ['F5', 'G5', 'A5'],
    lessonRef: 'module_5/lesson_3',
  ),
];

const List<String> _genres = ['Rock', 'Pop', 'Blues', 'Metal', 'Folk'];

class SongLibraryScreen extends ConsumerStatefulWidget {
  const SongLibraryScreen({super.key});

  @override
  ConsumerState<SongLibraryScreen> createState() => _SongLibraryScreenState();
}

class _SongLibraryScreenState extends ConsumerState<SongLibraryScreen> {
  final Set<String> _genreFilter = {};
  final Set<int> _diffFilter = {};

  List<SongData> get _filtered {
    return kSongs.where((s) {
      final gOk = _genreFilter.isEmpty || _genreFilter.contains(s.genre);
      final dOk = _diffFilter.isEmpty || _diffFilter.contains(s.difficulty);
      return gOk && dOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final songs = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Songs')),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final g in _genres)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(g),
                      selected: _genreFilter.contains(g),
                      onSelected: (sel) => setState(() {
                        if (sel) {
                          _genreFilter.add(g);
                        } else {
                          _genreFilter.remove(g);
                        }
                      }),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (int d = 1; d <= 5; d++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          d,
                          (_) => const Icon(Icons.star,
                              size: 14, color: AppColors.xpColor),
                        ),
                      ),
                      selected: _diffFilter.contains(d),
                      onSelected: (sel) => setState(() {
                        if (sel) {
                          _diffFilter.add(d);
                        } else {
                          _diffFilter.remove(d);
                        }
                      }),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: songs.isEmpty
                ? const Center(child: Text('Keine Songs gefunden'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: songs.length,
                    itemBuilder: (context, i) {
                      final s = songs[i];
                      return Card(
                        color: AppColors.cardDark,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              s.title.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            s.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.artist,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  ...List.generate(
                                    s.difficulty,
                                    (_) => const Icon(Icons.star,
                                        size: 12,
                                        color: AppColors.xpColor),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    s.genre,
                                    style: const TextStyle(
                                      color: AppColors.textTertiary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () => context.go('/home/songs/${s.id}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
