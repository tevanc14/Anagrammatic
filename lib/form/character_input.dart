import 'package:anagramatic/form/length_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterInput extends StatefulWidget {
  @override
  State createState() {
    return CharacterInputState();
  }
}

class CharacterInputState extends State<CharacterInput> {
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
                          new LengthInput(characters: characters)),
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
