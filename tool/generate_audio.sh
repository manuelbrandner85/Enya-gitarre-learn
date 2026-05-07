#!/usr/bin/env bash
# Komfort-Wrapper: erzeugt alle Audio-Assets über Dart.
set -euo pipefail
cd "$(dirname "$0")/.."
dart run tool/generate_audio_assets.dart
