class TextScaleFactor {
  final String displayName;
  final double scaleFactor;

  const TextScaleFactor({
    this.displayName,
    this.scaleFactor,
  });

  static final TextScaleFactor _systemDefault = TextScaleFactor(
    displayName: 'System Default',
    scaleFactor: null,
  );

  static final TextScaleFactor _small = TextScaleFactor(
    displayName: 'Small',
    scaleFactor: 0.8,
  );

  static final TextScaleFactor _normal = TextScaleFactor(
    displayName: 'Normal',
    scaleFactor: 1.0,
  );

  static final TextScaleFactor _large = TextScaleFactor(
    displayName: 'Large',
    scaleFactor: 1.3,
  );

  static final TextScaleFactor _huge = TextScaleFactor(
    displayName: 'Huge',
    scaleFactor: 2.0,
  );

  static List<TextScaleFactor> _allTextScaleFactors = <TextScaleFactor>[
    _systemDefault,
    _small,
    _normal,
    _large,
    _huge,
  ];

  static List<TextScaleFactor> getAllTextScaleFactors() {
    return _allTextScaleFactors;
  }

  static TextScaleFactor getDefault() {
    return _systemDefault;
  }
}
