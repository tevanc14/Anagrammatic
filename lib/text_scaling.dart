class TextScaleFactor {
  const TextScaleFactor({
    this.displayName,
    this.scaleFactor,
  });

  final String displayName;
  final double scaleFactor;

  static List<TextScaleFactor> _allTextScaleFactors = <TextScaleFactor>[
    TextScaleFactor(
      displayName: 'System Default',
      scaleFactor: null,
    ),
    TextScaleFactor(
      displayName: 'Small',
      scaleFactor: 0.8,
    ),
    TextScaleFactor(
      displayName: 'Normal',
      scaleFactor: 1.0,
    ),
    TextScaleFactor(
      displayName: 'Large',
      scaleFactor: 1.3,
    ),
    TextScaleFactor(
      displayName: 'Huge',
      scaleFactor: 2.0,
    ),
  ];

  static List<TextScaleFactor> getAllTextScaleFactors() {
    return _allTextScaleFactors;
  }

  static TextScaleFactor getDefault() {
    return _allTextScaleFactors[0];
  }
}
