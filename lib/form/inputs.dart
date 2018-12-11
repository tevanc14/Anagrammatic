import 'package:anagrammatic/common/form_input_elements.dart';
import 'package:anagrammatic/visualization/anagram_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Inputs extends StatefulWidget {
  @override
  State createState() {
    return InputsState();
  }
}

class InputsState extends State<Inputs> {
  final key = GlobalKey<FormState>();

  final charactersTextController = TextEditingController();

  bool showSubmitButton = false;

  @override
  void initState() {
    super.initState();

    charactersTextController.addListener(checkCurrentInputs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anagrammatic'),
      ),
      body: Form(
        key: key,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(
                    50.0,
                  ),
                  child: Text(
                    'Create anagrams with a set of characters',
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: FormInputElements.padding,
                  child: TextFormField(
                    controller: charactersTextController,
                    inputFormatters: [CharacterInputFormatter()],
                    autofocus: true,
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    style: FormInputElements.textStyle,
                    decoration: InputDecoration(
                      labelText: 'Characters',
                      border: FormInputElements.inputBorder,
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
          builder: (context) => AnagramList(
                characters: charactersTextController.text,
              ),
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
