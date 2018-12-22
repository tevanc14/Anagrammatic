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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                      ),
                      child: TextFormField(
                        controller: charactersTextController,
                        inputFormatters: [
                          CharacterInputFormatter(),
                        ],
                        autofocus: true,
                        textAlign: TextAlign.center,
                        maxLength: 20,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: theme.textTheme.title.color,
                        ),
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
