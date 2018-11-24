import 'package:anagramatic/visualization/anagram_list.dart';
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