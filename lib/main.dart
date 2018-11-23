import 'package:anagramatic/anagram_list.dart';
import 'package:anagramatic/input.dart';
import 'package:flutter/material.dart';

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
      home: new CharacterForm(),
    );
  }
}

class CharacterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Form(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          new Text('What characters are available?'),
          new Padding(padding: const EdgeInsets.only(top: 48.0)),
          new CharacterEntryField(
            fields: 7,
            keyboardType: TextInputType.text,
            onSubmit: (String value) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new LengthForm(characters: value)),
              );
            },
          ),
        ])));
  }
}

class LengthForm extends StatelessWidget {
  final String characters;

  LengthForm({@required this.characters});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Form(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          new Text('How many characters long should the anagrams be?'),
          new Padding(padding: const EdgeInsets.only(top: 48.0)),
          new CharacterEntryField(
            fields: 1,
            keyboardType: TextInputType.number,
            onSubmit: (String value) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new AnagramList(
                        characters: this.characters, length: int.parse(value))),
              );
            },
          ),
        ])));
  }
}

// currently takes two back presses to navigate back from length screen
// consider state storage alternatives to passing variables into widgets
// something for when no anagrams exist
// check length against the number of characters given
// able to delete characters
// change number of characters and length possible
