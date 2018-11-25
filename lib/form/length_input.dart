import 'package:anagrammatic/visualization/anagram_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LengthInput extends StatefulWidget {
  final String characters;

  LengthInput({@required this.characters});

  @override
  State createState() {
    return LengthInputState();
  }
}

class LengthInputState extends State<LengthInput> {
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
            'How many characters long should the anagrams be? (20 or less)',
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
              controller: textController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                counterText: '',
              ),
              style: TextStyle(fontSize: 20.0),
              inputFormatters: [new LengthInputFormatter()],
              onFieldSubmitted: (String length) {
                transferTAnagramList(context);
              },
            ),
          ),
          new RaisedButton(
            child: const Text('Submit'),
            color: Theme.of(context).accentColor,
            onPressed: () {
              transferTAnagramList(context);
            },
          )
        ],
      ),
    );
  }

  void transferTAnagramList(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new Scaffold(
                  body: new AnagramList(
                characters: widget.characters,
                length: int.parse(textController.text),
              ))),
    );
  }
}

class LengthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var acceptNewValue = new TextEditingValue(
      text: newValue.text,
      selection: newValue.selection,
    );

    // Deleting a character
    if (newValue.text.length < oldValue.text.length) {
      return acceptNewValue;
    }

    if (newValue.text.contains(new RegExp('[^0-9]')) ||
        int.parse(newValue.text) > 20) {
      return new TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
      );
    } else {
      return acceptNewValue;
    }
  }
}
