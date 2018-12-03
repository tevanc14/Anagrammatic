import 'package:anagrammatic/common/anagrammatic_app_bar.dart';
import 'package:anagrammatic/common/form_input_elements.dart';
import 'package:anagrammatic/visualization/anagram_list.dart';
import 'package:flutter/material.dart';

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
                    autofocus: true,
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    style: FormInputElements.textStyle,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Characters',
                      border: FormInputElements.inputBorder,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (characters) {
                      if (characters.contains(RegExp(r'[^a-zA-Z]'))) {
                        return 'Must be only letters';
                      } else if (characters.length <= 0) {
                        return 'Must contain at least one character';
                      }
                    },
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
                    focusNode: lengthFocus,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: FormInputElements.textStyle,
                    decoration: InputDecoration(
                      labelText: 'Length',
                      border: FormInputElements.inputBorder,
                    ),
                    validator: (length) {
                      if (length.contains(RegExp(r'[^0-9]'))) {
                        return 'Must be a number';
                      } else if (length.length <= 0) {
                        return 'Must be at least 1';
                      } else if (int.parse(length) >= 20) {
                        return 'Must be less than 20';
                      }
                    },
                    onFieldSubmitted: (value) {
                        transferToAnagramList(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: RaisedButton(
                    child: const Text('Generate'),
                    color: Theme.of(context).primaryColor,
                    elevation: 8.0,
                    onPressed: () {
                      transferToAnagramList(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void transferToAnagramList(BuildContext context) {
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
