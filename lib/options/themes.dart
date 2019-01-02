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

final String _fontFamily = 'Roboto';

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    title: base.title.copyWith(
      fontFamily: _fontFamily,
    ),
    headline: base.headline.copyWith(
      fontFamily: _fontFamily,
    ),
    subhead: base.subhead.copyWith(
      fontFamily: _fontFamily,
    ),
  );
}

ThemeData _buildDarkTheme() {
  Color primaryColor = Colors.blueGrey[700];
  Color secondaryColor = Colors.grey[600];
  Color backgroundColor = const Color(0xFF202124);
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    backgroundColor: backgroundColor,
    errorColor: _errorColor,
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFF0175c2);
  const Color secondaryColor = Color(0xFF13B9FD);
  final ThemeData base = ThemeData.light();
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
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}
