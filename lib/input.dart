import 'package:anagrammatic/anagram_length_bounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anagrammatic/anagram_list.dart';

class Input extends StatefulWidget {
  const Input({
    this.transition,
  });

  final transition;

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
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        dismissKeyboard();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Form(
          key: key,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 80.0,
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: TextFormField(
                      controller: charactersTextController,
                      inputFormatters: [
                        CharacterInputFormatter(),
                      ],
                      autofocus: true,
                      textAlign: TextAlign.center,
                      maxLength: AnagramLengthBounds.maximumAnagramLength,
                      style: theme.textTheme.title,
                      decoration: InputDecoration(
                        labelText: 'Characters',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            24.0,
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
                tooltip: 'Generate anagrams',
                child: Icon(
                  Icons.done,
                ),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              )
            : Container(),
      ),
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
    if (key.currentState.validate()) {
      widget.transition(
        AnagramList(
          characters: charactersTextController.text,
        ),
      );
    }
  }

  dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
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
