import 'package:flutter/material.dart';

class AnagrammaticTheme {
  const AnagrammaticTheme._(
    this.name,
    this.data,
    this.identifier,
  );

  final String name;
  final ThemeData data;
  final int identifier;

  bool operator ==(other) {
    return (identifier == other.identifier);
  }

  int get hashCode {
    return identifier;
  }

  static List<AnagrammaticTheme> _allThemes = <AnagrammaticTheme>[
    darkTheme,
    lightTheme,
  ];

  static List<AnagrammaticTheme> getAllTextScaleFactors() {
    return _allThemes;
  }

  static AnagrammaticTheme getByIdentifier(int id) {
    return getAllTextScaleFactors().firstWhere(
        (AnagrammaticTheme anagrammaticTheme) =>
            anagrammaticTheme.identifier == id);
  }
}

final AnagrammaticTheme darkTheme = AnagrammaticTheme._(
  'Dark',
  _buildDarkTheme(),
  0,
);
final AnagrammaticTheme lightTheme = AnagrammaticTheme._(
  'Light',
  _buildLightTheme(),
  1,
);

final Color _errorColor = const Color(0xFFB00020);

TextTheme _buildTextTheme(TextTheme base) {
  final String fontFamily = 'RobotoCondensed';

  return base.copyWith(
    display4: base.display4.copyWith(
      fontFamily: fontFamily,
    ),
    display3: base.display3.copyWith(
      fontFamily: fontFamily,
    ),
    display2: base.display2.copyWith(
      fontFamily: fontFamily,
    ),
    display1: base.display1.copyWith(
      fontFamily: fontFamily,
    ),
    headline: base.headline.copyWith(
      fontFamily: fontFamily,
    ),
    title: base.title.copyWith(
      fontFamily: fontFamily,
    ),
    subhead: base.subhead.copyWith(
      fontFamily: fontFamily,
    ),
    body2: base.body2.copyWith(
      fontFamily: fontFamily,
    ),
    body1: base.body1.copyWith(
      fontFamily: fontFamily,
    ),
    caption: base.caption.copyWith(
      fontFamily: fontFamily,
    ),
    button: base.button.copyWith(
      fontFamily: fontFamily,
    ),
  );
}

ThemeData _buildDarkTheme() {
  Color primaryColor = const Color(0xFFFF1744);
  Color secondaryColor = const Color(0xFFFFEE58);
  Color backgroundColor = const Color(0xFF222530);
  final ThemeData base = ThemeData.dark();
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    backgroundColor: backgroundColor,
    errorColor: _errorColor,
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

ThemeData _buildLightTheme() {
  Color primaryColor = const Color(0xFFFF1744);
  Color secondaryColor = const Color(0xFFFFEE58);
  Color backgroundColor = const Color(0xFFFAFAFA);
  final ThemeData base = ThemeData.light();
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    backgroundColor: backgroundColor,
    errorColor: _errorColor,
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}
