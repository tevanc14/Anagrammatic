class TextScaleFactor {
  final String displayName;
  final double scaleFactor;
  final int identifier;

  const TextScaleFactor({
    this.displayName,
    this.scaleFactor,
    this.identifier,
  });

  bool operator ==(other) {
    return (identifier == other.identifier);
  }

  int get hashCode {
    return identifier;
  }

  static final TextScaleFactor _systemDefault = TextScaleFactor(
    displayName: 'System Default',
    scaleFactor: null,
    identifier: 0,
  );

  static final TextScaleFactor _small = TextScaleFactor(
    displayName: 'Small',
    scaleFactor: 0.8,
    identifier: 1,
  );

  static final TextScaleFactor _normal = TextScaleFactor(
    displayName: 'Normal',
    scaleFactor: 1.0,
    identifier: 2,
  );

  static final TextScaleFactor _large = TextScaleFactor(
    displayName: 'Large',
    scaleFactor: 1.3,
    identifier: 3,
  );

  static List<TextScaleFactor> _allTextScaleFactors = <TextScaleFactor>[
    _systemDefault,
    _small,
    _normal,
    _large,
  ];

  static List<TextScaleFactor> getAllTextScaleFactors() {
    return _allTextScaleFactors;
  }

  static TextScaleFactor getDefault() {
    return _systemDefault;
  }

  static TextScaleFactor getByIdentifier(int id) {
    return getAllTextScaleFactors().firstWhere(
        (TextScaleFactor textScaleFactor) => textScaleFactor.identifier == id);
  }
}
