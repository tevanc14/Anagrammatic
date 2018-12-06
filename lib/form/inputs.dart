import 'package:Anagrammatic/common/anagrammatic_app_bar.dart';
import 'package:Anagrammatic/common/form_input_elements.dart';
import 'package:Anagrammatic/visualization/anagram_list.dart';
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
  final lengthTextController = TextEditingController();

  final FocusNode lengthFocus = FocusNode();

  bool showSubmitButton = false;

  @override
  void initState() {
    super.initState();

    charactersTextController.addListener(checkCurrentInputs);
    lengthTextController.addListener(checkCurrentInputs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnagrammaticAppBar.appBar,
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
                    'Create anagrams with a set of characters and a certain length',
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(lengthFocus);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                ),
                Padding(
                  padding: FormInputElements.padding,
                  child: TextFormField(
                    controller: lengthTextController,
                    inputFormatters: [LengthInputFormatter()],
                    focusNode: lengthFocus,
                    textAlign: TextAlign.center,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    style: FormInputElements.textStyle,
                    decoration: InputDecoration(
                      labelText: 'Length',
                      border: FormInputElements.inputBorder,
                    ),
                    validator: (value) {
                      return validateTextField(value);
                    },
                    onFieldSubmitted: (value) {
                      transferToAnagramList(context);
                      changeSubmitButtonVisibility(true);
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
          : new Container(),
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
    return charactersTextController.text.isNotEmpty &&
        lengthTextController.text.isNotEmpty;
  }

  transferToAnagramList(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (key.currentState.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnagramList(
                characters: charactersTextController.text,
                length: int.parse(lengthTextController.text),
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

class LengthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.text.contains(RegExp('[^0-9]')) ? oldValue : newValue;
  }
}
