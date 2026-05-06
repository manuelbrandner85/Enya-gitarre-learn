import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final isOnlineProvider = StateNotifierProvider<OnlineStatusNotifier, bool>((ref) {
  return OnlineStatusNotifier();
});

class OnlineStatusNotifier extends StateNotifier<bool> {
  Timer? _timer;

  OnlineStatusNotifier() : super(true) {
    _checkConnection();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      await Supabase.instance.client
          .from('app_config')
          .select('id')
          .limit(1)
          .timeout(const Duration(seconds: 5));
      if (mounted) state = true;
    } catch (_) {
      if (mounted) state = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
