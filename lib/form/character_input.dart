import 'package:anagrammatic/common/anagrammatic_app_bar.dart';
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
  final textController = new TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AnagrammaticAppBar.appBar,
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
                child: TextField(
                  autofocus: true,
                  controller: textController,
                  textAlign: TextAlign.center,
                  maxLength: 20,
                  maxLengthEnforced: true,
                  decoration: new InputDecoration(counterText: ''),
                  style: TextStyle(fontSize: 20.0),
                  onChanged: (String text) {
                    changeText();
                  },
                  onSubmitted: (String characters) {
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
        ));
  }

  void transferToLengthInput(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) =>
              new LengthInput(characters: textController.text)),
    );
  }

  // DEBT: This is the approach taken as the TextInputFormatter
  // is broken on ios
  void changeText() {
    String oldText = textController.text;
    TextSelection oldSelection = textController.selection;

    String newText = editText(oldText);
    int lengthDifference = newText.length - oldText.length;
    TextSelection newSelection = new TextSelection(
      baseOffset: oldSelection.baseOffset + lengthDifference,
      extentOffset: oldSelection.baseOffset + lengthDifference,
    );

    textController.text = newText;
    textController.selection = newSelection;
  }

  String editText(String text) {
    return text.toUpperCase().replaceAll(new RegExp(r'[^A-Z]'), '');
  }
}
