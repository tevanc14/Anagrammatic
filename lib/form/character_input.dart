import 'package:anagrammatic/form/length_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterInput extends StatefulWidget {
  @override
  State createState() {
    return CharacterInputState();
  }
}

class CharacterInputState extends State<CharacterInput> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
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
              controller: textController,
              textAlign: TextAlign.center,
              maxLength: 20,
              maxLengthEnforced: true,
              decoration: new InputDecoration(counterText: ''),
              style: TextStyle(fontSize: 20.0),
              inputFormatters: [new CharacterInputFormatter()],
              onFieldSubmitted: (String characters) {
                transferToLengthInput(context);
              },
            ),
          ),
          new RaisedButton(
            child: const Text('Submit'),
            color: Theme.of(context).accentColor,
            onPressed: () {
              transferToLengthInput(context);
            },
          )
        ],
      ),
    );
  }

  void transferToLengthInput(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new Scaffold(
              body: new LengthInput(characters: textController.text))),
    );
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
