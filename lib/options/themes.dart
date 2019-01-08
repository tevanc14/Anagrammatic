import 'package:flutter/material.dart';

class AnagrammaticTheme {
  const AnagrammaticTheme._(
    this.name,
    this.data,
  );

  final String name;
  final ThemeData data;
}

final AnagrammaticTheme darkTheme = AnagrammaticTheme._(
  'Dark',
  _buildDarkTheme(),
);
final AnagrammaticTheme lightTheme = AnagrammaticTheme._(
  'Light',
  _buildLightTheme(),
);

final Color _errorColor = const Color(0xFFB00020);

TextTheme _buildTextTheme(TextTheme base) {
  final String fontFamily = 'Roboto';

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
  Color primaryColor = Colors.blueGrey[700];
  Color secondaryColor = Colors.grey[600];
  Color backgroundColor = const Color(0xFF202124);
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
  const Color primaryColor = Color(0xFF0175c2);
  const Color secondaryColor = Color(0xFF13B9FD);
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
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
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
