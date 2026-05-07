import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/features/songs/screens/song_library_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

class Setlist {
  final String id;
  String name;
  List<String> songIds;
  final DateTime createdAt;

  Setlist({
    required this.id,
    required this.name,
    List<String>? songIds,
    DateTime? createdAt,
  })  : songIds = songIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'songIds': songIds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Setlist.fromJson(Map<String, dynamic> j) => Setlist(
        id: j['id'] as String,
        name: j['name'] as String,
        songIds: List<String>.from(j['songIds'] as List? ?? []),
        createdAt: DateTime.parse(
          j['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

class SetlistsNotifier extends StateNotifier<List<Setlist>> {
  static const _prefsKey = 'setlists';

  SetlistsNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => Setlist.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(state.map((s) => s.toJson()).toList()));
  }

  Future<void> createSetlist(String name) async {
    final setlist = Setlist(
      id: const Uuid().v4(),
      name: name.trim(),
    );
    state = [...state, setlist];
    await _save();
  }

  Future<void> deleteSetlist(String id) async {
    state = state.where((s) => s.id != id).toList();
    await _save();
  }

  Future<void> addSong(String setlistId, String songId) async {
    state = [
      for (final s in state)
        if (s.id == setlistId)
          Setlist(
            id: s.id,
            name: s.name,
            songIds: [...s.songIds, if (!s.songIds.contains(songId)) songId],
            createdAt: s.createdAt,
          )
        else
          s,
    ];
    await _save();
  }

  Future<void> removeSong(String setlistId, String songId) async {
    state = [
      for (final s in state)
        if (s.id == setlistId)
          Setlist(
            id: s.id,
            name: s.name,
            songIds: s.songIds.where((id) => id != songId).toList(),
            createdAt: s.createdAt,
          )
        else
          s,
    ];
    await _save();
  }

  Future<void> reorderSong(String setlistId, int oldIdx, int newIdx) async {
    state = [
      for (final s in state)
        if (s.id == setlistId)
          () {
            final ids = List<String>.from(s.songIds);
            final item = ids.removeAt(oldIdx);
            final insertAt = newIdx > oldIdx ? newIdx - 1 : newIdx;
            ids.insert(insertAt, item);
            return Setlist(
              id: s.id,
              name: s.name,
              songIds: ids,
              createdAt: s.createdAt,
            );
          }()
        else
          s,
    ];
    await _save();
  }

  Future<void> renameSetlist(String id, String newName) async {
    state = [
      for (final s in state)
        if (s.id == id)
          Setlist(
            id: s.id,
            name: newName.trim(),
            songIds: s.songIds,
            createdAt: s.createdAt,
          )
        else
          s,
    ];
    await _save();
  }
}

final setlistsProvider =
    StateNotifierProvider<SetlistsNotifier, List<Setlist>>(
  (_) => SetlistsNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// SETLISTS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SetlistsScreen extends ConsumerStatefulWidget {
  const SetlistsScreen({super.key});

  @override
  ConsumerState<SetlistsScreen> createState() => _SetlistsScreenState();
}

class _SetlistsScreenState extends ConsumerState<SetlistsScreen> {
  Future<void> _showCreateDialog() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Neue Setliste',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Name der Setliste',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          onSubmitted: (_) => Navigator.pop(ctx, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Erstellen',
                style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(setlistsProvider.notifier)
          .createSetlist(controller.text);
    }
    controller.dispose();
  }

  Future<void> _showRenameDialog(Setlist setlist) async {
    final controller = TextEditingController(text: setlist.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Umbenennen',
            style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Neuer Name',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          onSubmitted: (_) => Navigator.pop(ctx, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Speichern',
                style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(setlistsProvider.notifier)
          .renameSetlist(setlist.id, controller.text);
    }
    controller.dispose();
  }

  Future<void> _confirmDelete(Setlist setlist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Setliste löschen',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          '"${setlist.name}" wirklich löschen?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Löschen',
                style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(setlistsProvider.notifier).deleteSetlist(setlist.id);
    }
  }

  String _buildSubtitle(Setlist setlist) {
    final count = setlist.songIds.length;
    if (count == 0) return 'Noch keine Songs';
    final songs = kSongs.where((s) => setlist.songIds.contains(s.id)).toList();
    final first3 = songs.take(3).map((s) => s.title).join(', ');
    return count == 1 ? '1 Song · $first3' : '$count Songs · $first3${count > 3 ? ' ...' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final setlists = ref.watch(setlistsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Meine Setlisten',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
      body: setlists.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: setlists.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final setlist = setlists[index];
                return _SetlistTile(
                  setlist: setlist,
                  subtitle: _buildSubtitle(setlist),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SetlistDetailScreen(setlist: setlist),
                      ),
                    );
                  },
                  onRename: () => _showRenameDialog(setlist),
                  onDelete: () => _confirmDelete(setlist),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Noch keine Setlisten',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Erstelle deine erste Setliste für dein nächstes Konzert.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, color: AppColors.textPrimary),
            label: const Text(
              'Neue Setliste',
              style: TextStyle(
                  color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETLIST TILE
// ─────────────────────────────────────────────────────────────────────────────

class _SetlistTile extends StatelessWidget {
  final Setlist setlist;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _SetlistTile({
    required this.setlist,
    required this.subtitle,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.queue_music,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      setlist.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.textSecondary, size: 20),
                onPressed: onRename,
                tooltip: 'Umbenennen',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                onPressed: onDelete,
                tooltip: 'Löschen',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETLIST DETAIL SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SetlistDetailScreen extends ConsumerStatefulWidget {
  final Setlist setlist;

  const SetlistDetailScreen({super.key, required this.setlist});

  @override
  ConsumerState<SetlistDetailScreen> createState() =>
      _SetlistDetailScreenState();
}

class _SetlistDetailScreenState extends ConsumerState<SetlistDetailScreen> {
  Setlist get _current {
    return ref
            .watch(setlistsProvider)
            .firstWhere((s) => s.id == widget.setlist.id,
                orElse: () => widget.setlist);
  }

  Future<void> _showAddSongDialog() async {
    final current = _current;
    final available =
        kSongs.where((s) => !current.songIds.contains(s.id)).toList();

    await showDialog<void>(
      context: context,
      builder: (ctx) => _SongPickerDialog(
        availableSongs: available,
        onSelect: (songId) async {
          await ref
              .read(setlistsProvider.notifier)
              .addSong(widget.setlist.id, songId);
        },
      ),
    );
  }

  Future<void> _navigateToFirstSong() async {
    final current = _current;
    if (current.songIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Songs in dieser Setliste.'),
          backgroundColor: AppColors.cardDark,
        ),
      );
      return;
    }
    final firstId = current.songIds.first;
    if (mounted) {
      context.push('/home/songs/$firstId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final setlist = _current;
    final songs =
        setlist.songIds.map((id) => kSongs.firstWhere((s) => s.id == id,
            orElse: () => SongData(
                  id: id,
                  title: id,
                  artist: '',
                  difficulty: 1,
                  genre: '',
                  sections: [],
                  lessonRef: '',
                  bpm: 120,
                ))).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          setlist.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.primary),
            onPressed: _showAddSongDialog,
            tooltip: 'Song hinzufügen',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToFirstSong,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.play_arrow, color: AppColors.textPrimary),
        label: const Text('Spielen',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: songs.isEmpty
          ? _buildEmptyState()
          : ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              onReorder: (oldIdx, newIdx) {
                ref
                    .read(setlistsProvider.notifier)
                    .reorderSong(setlist.id, oldIdx, newIdx);
              },
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return _SongListItem(
                  key: ValueKey(song.id),
                  song: song,
                  index: index,
                  onDelete: () {
                    ref
                        .read(setlistsProvider.notifier)
                        .removeSong(setlist.id, song.id);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_music_outlined,
              size: 72,
              color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text(
            'Noch keine Songs',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _showAddSongDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.add, color: AppColors.textPrimary),
            label: const Text('Song hinzufügen',
                style: TextStyle(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SONG LIST ITEM
// ─────────────────────────────────────────────────────────────────────────────

class _SongListItem extends StatelessWidget {
  final SongData song;
  final int index;
  final VoidCallback onDelete;

  const _SongListItem({
    super.key,
    required this.song,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          title: Text(
            song.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            song.artist,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_handle,
                  color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SONG PICKER DIALOG
// ─────────────────────────────────────────────────────────────────────────────

class _SongPickerDialog extends StatefulWidget {
  final List<SongData> availableSongs;
  final Future<void> Function(String songId) onSelect;

  const _SongPickerDialog({
    required this.availableSongs,
    required this.onSelect,
  });

  @override
  State<_SongPickerDialog> createState() => _SongPickerDialogState();
}

class _SongPickerDialogState extends State<_SongPickerDialog> {
  String _query = '';

  List<SongData> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.availableSongs;
    return widget.availableSongs
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.artist.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Song hinzufügen',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                autofocus: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Suchen...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text('Keine Songs gefunden',
                          style: TextStyle(color: AppColors.textSecondary)),
                    )
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final song = _filtered[i];
                        return ListTile(
                          leading: const Icon(Icons.music_note,
                              color: AppColors.primary),
                          title: Text(song.title,
                              style: const TextStyle(
                                  color: AppColors.textPrimary)),
                          subtitle: Text(song.artist,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                          onTap: () async {
                            await widget.onSelect(song.id);
                            if (context.mounted) Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
