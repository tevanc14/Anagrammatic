import 'package:anagrammatic/backdrop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnagrammaticApp extends StatefulWidget {
  static final String title = 'Anagrammatic';

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
      home: BackdropPage(),
    );
  }
}
