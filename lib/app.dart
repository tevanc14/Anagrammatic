import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/home.dart';
import 'package:anagrammatic/options.dart';
import 'package:anagrammatic/themes.dart';

class AnagrammaticApp extends StatefulWidget {
  @override
  _AnagrammaticAppState createState() => _AnagrammaticAppState();
}

class _AnagrammaticAppState extends State<AnagrammaticApp> {
  Options _options;

  @override
  void initState() {
    super.initState();
    _options = Options(
      theme: darkTheme,
    );
  }

  void _handleOptionsChanged(Options newOptions) {
    setState(() {
      _options = newOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _options.theme.data,
      home: Home(
        optionsPage: OptionsPage(
          options: _options,
          onOptionsChanged: _handleOptionsChanged,
        ),
      ),
    );
  }
}
