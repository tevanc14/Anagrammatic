import 'dart:async';
import 'dart:convert';

import 'package:anagramatic/input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(AnagramaticApp());

class AnagramaticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Anagramatic';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey[600],
          accentColor: Colors.grey[600]),
      home: CharacterForm(),
    );
  }
}

class CharacterForm extends StatefulWidget {
  @override
  CharacterFormState createState() {
    return CharacterFormState();
  }
}

class CharacterFormState extends State<CharacterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('What characters are available?'),
                  Padding(padding: const EdgeInsets.only(top: 48.0)),
                  CharacterEntryField(
                    fields: 7,
                    keyboardType: TextInputType.text,
                    onSubmit: (String value) {
                      // DEBT: removeWhere would stall everything, so take out nulls here
                      String editedValue =
                          value.replaceAll(new RegExp('(null)+'), '');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LengthForm(editedValue)),
                      );
                    },
                  ),
                ])));
  }
}

class LengthForm extends StatefulWidget {
  String _characters;

  LengthForm(String characters) {
    this._characters = characters;
  }

  @override
  LengthFormState createState() {
    return LengthFormState(this._characters);
  }
}

class LengthFormState extends State<LengthForm> {
  final _formKey = GlobalKey<FormState>();
  String _characters;

  LengthFormState(String characters) {
    this._characters = characters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('How many characters long should the anagrams be?'),
                  Padding(padding: const EdgeInsets.only(top: 48.0)),
                  CharacterEntryField(
                    fields: 1,
                    keyboardType: TextInputType.number,
                    onSubmit: (String value) {
                      getAnagrams(this._characters, value);
                    },
                  ),
                ])));
  }
}

Future<Map> getAnagrams(String characters, String length) async {
  String apiUrl =
      'https://us-central1-stringpermutations.cloudfunctions.net/PermutationsInDictionary';
  http.Response response = await http.post(apiUrl,
      headers: {'Content-type': 'application/json'},
      body: json.encode({'input_word': characters, 'input_length': length}));
  return json.decode(response.body);
}

// List: https://proandroiddev.com/flutter-thursday-02-beautiful-list-ui-and-detail-page-a9245f5ceaf0
// currently takes two back presses to navigate back a page
// separate out widgets and API service
// consider state storage alternatives to passing variables into widgets
