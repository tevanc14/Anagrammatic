import 'package:Anagrammatic/form/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnagrammaticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[600],
        accentColor: Colors.grey[600]),
      home: Inputs(),
    );
  }
}