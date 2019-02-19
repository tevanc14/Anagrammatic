import 'package:anagrammatic/anagram/anagram_generator.dart';
import 'package:anagrammatic/anagram/anagram_length_bounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anagrammatic/anagram/anagram_list.dart';

class Input extends StatefulWidget {
  final transition;

  const Input({
    this.transition,
  });

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
    charactersTextController.addListener(_checkCurrentInputs);
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
        _dismissKeyboard();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
            left: 40.0,
            right: 40.0,
          ),
          child: Form(
            key: key,
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _textField(theme),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: showSubmitButton
            ? FloatingActionButton(
                onPressed: () {
                  _transferToAnagramList(context);
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

  Widget _textField(ThemeData theme) {
    return TextFormField(
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
        return _validateTextField(value);
      },
      onFieldSubmitted: (value) {
        _transferToAnagramList(context);
      },
    );
  }

  String _validateTextField(value) {
    return value.isEmpty ? 'Field cannot be empty' : null;
  }

  void _checkCurrentInputs() {
    _changeSubmitButtonVisibility(_inputsAreNotEmpty());
  }

  void _changeSubmitButtonVisibility(bool visibility) {
    setState(() {
      showSubmitButton = visibility;
    });
  }

  bool _inputsAreNotEmpty() {
    return charactersTextController.text.isNotEmpty;
  }

  void _transferToAnagramList(BuildContext context) {
    if (key.currentState.validate()) {
      widget.transition(
        AnagramList(
          characters: charactersTextController.text,
        ),
      );
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

class CharacterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains(RegExp('[^a-zA-Z\*]'))) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: newValue.text?.toUpperCase(),
        selection: newValue.selection,
      );
    }
  }
}
