import 'dart:async';
import 'package:flutter/foundation.dart';
import 'result.dart';
import 'app_exception.dart';

Future<Result<T>> safeCall<T>(
  Future<T> Function() action, {
  String? context,
}) async {
  try {
    final data = await action();
    return Success(data);
  } on AppException catch (e, st) {
    debugPrint('[safeCall${context != null ? "($context)" : ""}] ${e.runtimeType}: $e');
    return Failure(e.userFriendlyMessage, error: e, stackTrace: st);
  } catch (e, st) {
    debugPrint('[safeCall${context != null ? "($context)" : ""}] Unexpected: $e');
    return Failure('Ein unerwarteter Fehler ist aufgetreten.', error: e, stackTrace: st);
  }
}

Result<T> safeCallSync<T>(T Function() action, {String? context}) {
  try {
    return Success(action());
  } on AppException catch (e, st) {
    return Failure(e.userFriendlyMessage, error: e, stackTrace: st);
  } catch (e, st) {
    debugPrint('[safeCallSync] Unexpected: $e');
    return Failure('Ein unerwarteter Fehler ist aufgetreten.', error: e, stackTrace: st);
  }
}
