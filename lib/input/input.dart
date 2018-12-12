import 'package:anagrammatic/anagram/anagram_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatefulWidget {
  @override
  State createState() {
    return InputState();
  }
}

class InputState extends State<Input> {
  final key = GlobalKey<FormState>();
  final charactersTextController = TextEditingController();
  bool showSubmitButton = false;

  @override
  void initState() {
    super.initState();
    charactersTextController.addListener(checkCurrentInputs);
  }

  @override
  void dispose() {
    charactersTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  child: TextFormField(
                    controller: charactersTextController,
                    inputFormatters: [CharacterInputFormatter()],
                    autofocus: true,
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Characters',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      return validateTextField(value);
                    },
                    onFieldSubmitted: (value) {
                      transferToAnagramList(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: showSubmitButton
          ? FloatingActionButton(
              onPressed: () {
                transferToAnagramList(context);
              },
              tooltip: 'Generate Anagrams',
              child: Icon(Icons.done),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : Container(),
    );
  }

  validateTextField(value) {
    return value.isEmpty ? 'Field cannot be empty' : null;
  }

  checkCurrentInputs() {
    changeSubmitButtonVisibility(inputsAreNotEmpty());
  }

  changeSubmitButtonVisibility(bool visibility) {
    setState(() {
      showSubmitButton = visibility;
    });
  }

  bool inputsAreNotEmpty() {
    return charactersTextController.text.isNotEmpty;
  }

  transferToAnagramList(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (key.currentState.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AnagramList(characters: charactersTextController.text),
        ),
      );
    }
  }
}

class CharacterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains(RegExp('[^a-zA-Z]'))) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: newValue.text?.toUpperCase(),
        selection: newValue.selection,
      );
    }
  }
}
