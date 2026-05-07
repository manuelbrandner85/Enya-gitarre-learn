import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Favorites
// ─────────────────────────────────────────────────────────────────────────────

/// Riverpod provider for the set of favourite song IDs.
final songFavoritesProvider =
    StateNotifierProvider<SongFavoritesNotifier, Set<String>>(
  (ref) => SongFavoritesNotifier(),
);

class SongFavoritesNotifier extends StateNotifier<Set<String>> {
  static const _key = 'song_favorites';

  SongFavoritesNotifier() : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = (jsonDecode(raw) as List).cast<String>();
      state = Set<String>.from(list);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toList()));
  }

  /// Toggles the favourite state of [songId].
  void toggle(String songId) {
    if (state.contains(songId)) {
      state = {...state}..remove(songId);
    } else {
      state = {...state, songId};
    }
    _save();
  }

  /// Returns whether [songId] is currently a favourite.
  bool isFavorite(String songId) => state.contains(songId);
}

// ─────────────────────────────────────────────────────────────────────────────
// Recently Viewed
// ─────────────────────────────────────────────────────────────────────────────

/// Riverpod provider for the list of recently viewed song IDs (max 15, newest first).
final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>(
  (ref) => RecentlyViewedNotifier(),
);

class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  static const _key = 'recently_viewed_songs';
  static const _maxItems = 15;

  RecentlyViewedNotifier() : super(const []) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = (jsonDecode(raw) as List).cast<String>();
      state = List<String>.from(list);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state));
  }

  /// Records that [songId] was viewed, moving it to the front.
  /// Keeps at most [_maxItems] entries.
  void add(String songId) {
    final updated = [songId, ...state.where((id) => id != songId)];
    state = updated.length > _maxItems
        ? updated.sublist(0, _maxItems)
        : updated;
    _save();
  }
}
