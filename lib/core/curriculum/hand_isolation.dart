enum PracticeHand { both, frettingOnly, strummingOnly }

extension PracticeHandExtension on PracticeHand {
  String get label {
    switch (this) {
      case PracticeHand.both: return 'Beide Hände';
      case PracticeHand.frettingOnly: return 'Nur Greifhand';
      case PracticeHand.strummingOnly: return 'Nur Anschlaghand';
    }
  }

  String get description {
    switch (this) {
      case PracticeHand.both:
        return 'Normal spielen – beide Hände koordinieren.';
      case PracticeHand.frettingOnly:
        return 'NUR GREIFHAND auf deiner XMARI. Du kannst die Saiten ganz leise '
            'anschlagen – die USB-C-Verbindung erkennt auch leise Töne!';
      case PracticeHand.strummingOnly:
        return 'NUR ANSCHLAGHAND. Spiele auf den offenen Saiten deiner XMARI. '
            'Mit Clean-Preset hörst du jeden Anschlag klar im Kopfhörer.';
    }
  }

  String get xmariTip {
    switch (this) {
      case PracticeHand.both:
        return 'Alle XMARI-Presets nutzbar';
      case PracticeHand.frettingOnly:
        return 'Dank USB-C-Digital-Audio werden auch SEHR leise Töne erkannt – '
            'besser als jedes Mikrofon!';
      case PracticeHand.strummingOnly:
        return 'Empfohlen: Clean-Preset, Position 4 – für klaren Anschlag-Sound';
    }
  }
}
