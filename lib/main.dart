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
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey[600],
          accentColor: Colors.grey[600]),
      home: CharacterForm(),
    );
  }
}

class CharacterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Text('What characters are available?'),
          Padding(padding: const EdgeInsets.only(top: 48.0)),
          CharacterEntryField(
            fields: 7,
            keyboardType: TextInputType.text,
            onSubmit: (String value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LengthForm(characters: value)),
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
        body: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Text('How many characters long should the anagrams be?'),
          Padding(padding: const EdgeInsets.only(top: 48.0)),
          CharacterEntryField(
            fields: 1,
            keyboardType: TextInputType.number,
            onSubmit: (String value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnagramList(
                        characters: this.characters, length: int.parse(value))),
              );
            },
          ),
        ])));
  }
}

// List: https://proandroiddev.com/flutter-thursday-02-beautiful-list-ui-and-detail-page-a9245f5ceaf0
// currently takes two back presses to navigate back a page
// separate out widgets and API service
// consider state storage alternatives to passing variables into widgets
// something for when no anagrams exist
// check length against the number of characters given
// able to delete characters
// change number of characters and length possible
