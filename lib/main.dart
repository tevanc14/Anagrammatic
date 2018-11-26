import 'package:anagrammatic/form/character_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(AnagrammaticApp());

class AnagrammaticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey[600],
          accentColor: Colors.grey[600]),
      home: new CharacterInput(),
    );
  }
}

// card size when anagram size is small
// make colors not ugly
// Check if length is empty
// splashscreen (https://flutter.io/docs/development/ui/assets-and-images)
