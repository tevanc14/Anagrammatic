import 'package:anagramatic/form/character_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(AnagramaticApp());

class AnagramaticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Anagramatic';

    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey[600],
          accentColor: Colors.grey[600]),
      home: new CharacterInput(),
    );
  }
}

// consider state storage alternatives to passing variables into widgets
// separate widgets into own files and consolidate any common styles and pieces
// top bar showing current word, num chars, num results?
