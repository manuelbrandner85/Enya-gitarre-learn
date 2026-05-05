# E-Gitarre Leicht

Eine gamifizierte E-Gitarren-Lern-App, speziell entwickelt für die **Enya XMARI Smart Guitar**. Die App führt Anfänger:innen Schritt für Schritt durch ein strukturiertes Curriculum mit Echtzeit-Feedback, eingebautem Stimmgerät, Metronom und Bluetooth-Anbindung an die Smart Guitar.

## Download

Aktuelles Release: **[GitHub Releases](https://github.com/manuelbrandner85/Enya-gitarre-learn/releases/latest)**

Auf dem Android-Gerät „Installation aus unbekannten Quellen" erlauben, dann die `.apk` öffnen. Update über die installierte Version ist möglich (gleicher Signing-Key vorausgesetzt).

### Release-Workflow

Releases werden vollautomatisch von GitHub Actions gebaut. Drei Trigger:

1. **Push auf `main` mit neuer Version in `pubspec.yaml`** → Workflow erkennt das, baut, taggt und veröffentlicht.
2. **Tag-Push `v[0-9]+.[0-9]+.[0-9]+`** → manueller Release-Trigger.
3. **`workflow_dispatch` aus der Actions-Tab** → manueller Build aus jedem Branch.

Pro Release wird automatisch:
- die nächste Build-Nummer geprüft (Android `versionCode` muss strikt steigen),
- ein Changelog aus den Git-Commits seit dem letzten Tag generiert,
- die APK gebaut, versioniert (`enya-gitarre-leicht-v<x.y.z>-universal.apk`) und an das GitHub-Release gehängt,
- die Supabase-Tabelle `app_config` mit Version + Download-URL für den In-App-Update-Dialog upserted (sofern `SUPABASE_SERVICE_ROLE_KEY` als Secret gesetzt ist).

## Funktionen

- **Strukturiertes Curriculum** - Vier Module von absoluten Grundlagen bis zu fortgeschrittenen Techniken.
- **Echtzeit-Feedback** - Pitch-Erkennung mit dem Mikrofon (oder direkt via Bluetooth) bewertet jeden Ton.
- **Stimmgerät** - Hochpräzises chromatisches Tuner mit visueller Nadelanzeige.
- **Metronom** - Anpassbares Metronom mit Tap-Tempo-Funktion.
- **Gamification** - XP-System, Level, Streaks und freischaltbare Achievements.
- **Spaced Repetition** - Lerninhalte werden gezielt wiederholt, um Erlerntes zu festigen.
- **Bluetooth-Integration** - Native Unterstützung für die Enya XMARI Smart Guitar.
- **Mehrsprachig** - Deutsch (Standard) und Englisch.
- **Hell/Dunkel-Modus** - Vollständig themable.

## Architektur

```
lib/
  app/              # MaterialApp, Theme, Router (go_router)
  core/
    audio/          # Pitch-Detection, Tuner, Metronom, Audio-Input
    bluetooth/      # Enya XMARI BLE-Service
    curriculum/     # Statische Lehrplandaten (4 Module)
    database/       # Drift (SQLite) - lokale Persistenz
    gamification/   # XP, Level, Streaks, Achievements
    models/         # Domain-Modelle (UserProfile, Lesson, ...)
    music_theory/   # Noten, Akkorde, Skalen, Griffbrett
    providers/      # Zentrale Riverpod-Provider
    spaced_repetition/
  features/
    home/ lessons/ tuner/ metronome/ progress/ settings/ splash/ onboarding/
  l10n/             # ARB-Dateien (de, en)
```

State-Management erfolgt durch **Riverpod** (manuelle Provider in `lib/core/providers/app_providers.dart`). Lokale Persistenz via **Drift** (SQLite) und **SharedPreferences**. Routing via **go_router**.

## Einrichtung

Voraussetzungen:
- Flutter SDK >= 3.22
- Dart SDK >= 3.4
- Android SDK (minSdk 23, targetSdk 34) und/oder Xcode 15+

```bash
# Abhängigkeiten installieren
flutter pub get

# Code-Generierung (Drift, Riverpod, go_router)
dart run build_runner build --delete-conflicting-outputs

# App starten
flutter run
```

## Berechtigungen

- **Mikrofon** - für Pitch-Erkennung und Echtzeit-Feedback
- **Bluetooth** - für die Verbindung zur Enya XMARI Smart Guitar
- **USB** (Android) - für externe Audio-Interfaces

## Lizenz

Proprietär - © 2025 E-Gitarre Leicht. Alle Rechte vorbehalten.
