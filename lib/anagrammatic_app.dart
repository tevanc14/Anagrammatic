import 'package:anagrammatic/input/input.dart';
import 'package:anagrammatic/two_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnagrammaticApp extends StatefulWidget {
  @override
  AnagrammaticAppState createState() => AnagrammaticAppState();
}

class AnagrammaticAppState extends State<AnagrammaticApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[600],
        accentColor: Colors.grey[600],
      ),
      home: TwoPanels(
        frontLayerWidget: Input(),
        showBackButton: false,
      ),
    );
  }
}
