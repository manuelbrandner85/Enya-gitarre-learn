enum XmariEffectType { clean, overdrive, distortion, highGainLead }

class XmariPreset {
  final int index;
  final String name;
  final double gain;   // 0.0 – 1.0
  final double tone;   // 0.0 – 1.0
  final double volume; // 0.0 – 1.0
  final XmariEffectType effectType;

  const XmariPreset({
    required this.index,
    required this.name,
    required this.gain,
    required this.tone,
    required this.volume,
    required this.effectType,
  });

  XmariPreset copyWith({
    int? index, String? name, double? gain,
    double? tone, double? volume, XmariEffectType? effectType,
  }) => XmariPreset(
    index: index ?? this.index,
    name: name ?? this.name,
    gain: gain ?? this.gain,
    tone: tone ?? this.tone,
    volume: volume ?? this.volume,
    effectType: effectType ?? this.effectType,
  );

  static const List<XmariPreset> defaults = [
    XmariPreset(index: 0, name: 'Clean', gain: 0.3, tone: 0.5, volume: 0.8,
        effectType: XmariEffectType.clean),
    XmariPreset(index: 1, name: 'Overdrive', gain: 0.6, tone: 0.6, volume: 0.75,
        effectType: XmariEffectType.overdrive),
    XmariPreset(index: 2, name: 'Distortion', gain: 0.8, tone: 0.55, volume: 0.7,
        effectType: XmariEffectType.distortion),
    XmariPreset(index: 3, name: 'High Gain', gain: 0.95, tone: 0.45, volume: 0.65,
        effectType: XmariEffectType.highGainLead),
  ];
}
