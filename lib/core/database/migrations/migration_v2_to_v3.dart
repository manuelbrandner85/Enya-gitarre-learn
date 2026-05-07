import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

/// Migration von Schema-Version 2 → 3.
///
/// Aktuell ist diese Migration leer (Platzhalter für zukünftige
/// Schema-Änderungen). Sie kann sicher ausgeführt werden – der bestehende
/// Datenbestand wird nicht angefasst.
Future<void> migrateV2ToV3(Migrator m, GeneratedDatabase db) async {
  // Reserviert für zukünftige Tabellen-/Spalten-Erweiterungen.
  debugPrint('migrateV2ToV3: keine Schema-Änderungen, Pass-Through.');
}
