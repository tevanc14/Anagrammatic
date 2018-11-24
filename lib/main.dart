import 'package:anagramatic/anagram_list.dart';
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
      home: new CharacterForm(),
    );
  }
}

class CharacterForm extends StatefulWidget {
  @override
  State createState() {
    return CharacterFormState();
  }
}

class CharacterFormState extends State<CharacterForm> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'What characters are available?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              left: 70.0,
              right: 70.0,
            ),
            child: TextFormField(
              autofocus: true,
              textAlign: TextAlign.center,
              maxLength: 20,
              maxLengthEnforced: true,
              decoration: new InputDecoration(counterText: ''),
              style: TextStyle(fontSize: 20.0),
              inputFormatters: [new CharacterInputFormatter()],
              onFieldSubmitted: (String characters) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new LengthForm(characters: characters)),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class CharacterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Deleting a character
    if (newValue.text.length < oldValue.text.length) {
      return new TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
      );
    }

    if (newValue.text.contains(new RegExp('[^a-zA-Z]'))) {
      return new TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
      );
    }
    return new TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LengthForm extends StatefulWidget {
  final String characters;

  LengthForm({@required this.characters});

  @override
  State createState() {
    return LengthFormState();
  }
}

class LengthFormState extends State<LengthForm> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'How many characters long should the anagrams be?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 175.0,
            ),
            child: TextFormField(
              autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                counterText: '',
              ),
              style: TextStyle(fontSize: 20.0),
              inputFormatters: [new LengthInputFormatter()],
              onFieldSubmitted: (String length) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AnagramList(
                          characters: widget.characters,
                          length: int.parse(length))),
                );
              },
            ),
          ),
          new Text(
            '20 or less',
            style: TextStyle(fontSize: 15.0),
          )
        ],
      ),
    ));
  }
}

class LengthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Deleting a character
    if (newValue.text.length < oldValue.text.length) {
      return new TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
      );
    }

    if (newValue.text.contains(new RegExp('[^0-9]')) ||
        int.parse(newValue.text) > 20) {
      return new TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
      );
    } else {
      return new TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
      );
    }
  }
}

// consider state storage alternatives to passing variables into widgets
// separate widgets into own files and consolidate any common styles and pieces
// top bar showing current word, num chars, num results?
