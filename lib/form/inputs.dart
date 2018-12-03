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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70.0,
                  ),
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
                      }
                    },
                    onFieldSubmitted: (v) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70.0,
                  ),
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
                      print(length);
                      print(length.contains(RegExp(r'[^0-9]')));
                      print(length.length);
                      if (length.contains(RegExp(r'[^0-9]')) ||
                          length.length <= 0) {
                        return 'Must be a number';
                      }
                    },
                    onFieldSubmitted: (value) {
                      if (key.currentState.validate()) {
                        transferToAnagramList(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () => {},
//        tooltip: 'Generate Anagrams',
//        child: Icon(Icons.done),
//        backgroundColor: Theme.of(context).primaryColor,
//      ),
    );
  }

  void transferToAnagramList(BuildContext context) {
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
