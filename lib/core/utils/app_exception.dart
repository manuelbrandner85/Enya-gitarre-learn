sealed class AppException implements Exception {
  const AppException();
  String get userFriendlyMessage;
}

final class DatabaseException extends AppException {
  final String message;
  final Object? original;
  const DatabaseException(this.message, {this.original});
  @override
  String get userFriendlyMessage => 'Daten konnten nicht geladen werden. Bitte versuche es erneut.';
  @override
  String toString() => 'DatabaseException: $message';
}

final class NetworkException extends AppException {
  final String message;
  final int? statusCode;
  final Object? original;
  const NetworkException(this.message, {this.statusCode, this.original});
  @override
  String get userFriendlyMessage => 'Keine Verbindung zum Server. Prüfe deine Internetverbindung.';
  @override
  String toString() => 'NetworkException($statusCode): $message';
}

final class AudioException extends AppException {
  final String message;
  final Object? original;
  const AudioException(this.message, {this.original});
  @override
  String get userFriendlyMessage => 'Mikrofon konnte nicht gestartet werden. Prüfe die Berechtigungen.';
}

final class BluetoothException extends AppException {
  final String message;
  final Object? original;
  const BluetoothException(this.message, {this.original});
  @override
  String get userFriendlyMessage => 'Bluetooth-Verbindung fehlgeschlagen. Ist deine XMARI eingeschaltet?';
}

final class ValidationException extends AppException {
  final String message;
  final Map<String, String>? fieldErrors;
  const ValidationException(this.message, {this.fieldErrors});
  @override
  String get userFriendlyMessage => 'Ungültige Eingabe. Bitte überprüfe deine Daten.';
}

final class PermissionException extends AppException {
  final String permission;
  final String? message;
  const PermissionException(this.permission, {this.message});
  @override
  String get userFriendlyMessage => 'Berechtigung für $permission wird benötigt.';
}
