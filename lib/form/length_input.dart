import 'package:anagrammatic/common/anagrammatic_app_bar.dart';
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
    return Scaffold(
        appBar: AnagrammaticAppBar.appBar,
        body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'How many characters long should the anagrams be?\n(20 or less)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 175.0,
                ),
                child: TextField(
                  autofocus: true,
                  controller: textController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(counterText: ''),
                  style: TextStyle(fontSize: 20.0),
                  onChanged: (String text) {
                    changeText();
                  },
                  onSubmitted: (String length) {
                    transferToAnagramList(context);
                  },
                ),
              ),
              RaisedButton(
                child: const Text('Submit'),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  transferToAnagramList(context);
                },
              )
            ],
          ),
        ));
  }

  void transferToAnagramList(BuildContext context) {
    if (textController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnagramList(
                  characters: widget.characters,
                  length: int.parse(textController.text),
                )),
      );
    }
  }

  // DEBT: This is the approach taken as the TextInputFormatter
  // is broken on ios
  void changeText() {
    String oldText = textController.text;
    TextSelection oldSelection = textController.selection;

    String newText = editText(oldText);
    int lengthDifference = newText.length - oldText.length;
    TextSelection newSelection = TextSelection(
      baseOffset: oldSelection.baseOffset + lengthDifference,
      extentOffset: oldSelection.baseOffset + lengthDifference,
    );

    textController.text = newText;
    textController.selection = newSelection;
  }

  String editText(String text) {
    int length = int.parse(text);
    if (length <= 20) {
      return text.replaceAll(RegExp(r'[^0-9]'), '');
    } else {
      return '';
    }
  }
}
