/**
 * Credit goes to Github user prestigegodson:
 * https://github.com/prestigegodson/pin-entry-text-field/tree/master/pin_entry_text_field
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterEntryField extends StatefulWidget {
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final keyboardType;

  CharacterEntryField(
      {this.fields: 4,
      this.onSubmit,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.keyboardType})
      : assert(fields > 0);

  @override
  State createState() {
    return CharacterEntryFieldState();
  }
}

class CharacterEntryFieldState extends State<CharacterEntryField> {
  List<String> text;
  List<FocusNode> focusNodes;
  List<TextEditingController> textControllers;

  @override
  void initState() {
    super.initState();
    text = List<String>(widget.fields);
    focusNodes = List<FocusNode>(widget.fields);
    textControllers = List<TextEditingController>(widget.fields);
  }

  @override
  void dispose() {
    textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  void clearTextFields() {
    textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
    text.clear();
  }

  Widget buildTextField(int index, BuildContext context) {
    focusNodes[index] = new FocusNode();
    textControllers[index] = new TextEditingController();

    return new Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: new TextField(
        inputFormatters: [new TextFormatter(widget.keyboardType)],
        controller: textControllers[index],
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: Theme.of(context).textTheme.title,
        focusNode: focusNodes[index],
        decoration: new InputDecoration(counterText: ''),
        onChanged: (String character) {
          text[index] = character;
          if (index + 1 != widget.fields && character.trim() != '') {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          }
        },
        onSubmitted: (String str) {
//          _text.removeWhere((value) => value == null);
          // DEBT: removeWhere would stall everything, so take out nulls here
          widget.onSubmit(text.join().replaceAll(new RegExp('(null)+'), ''));
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    FocusScope.of(context).requestFocus(focusNodes[0]);

    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: generateTextFields(context),
    );
  }
}

class TextFormatter extends TextInputFormatter {
  final keyboardType;

  TextFormatter(this.keyboardType);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Deleting a character
    if (newValue.text.length < oldValue.text.length) {
      return new TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
      );
    }

    // Only allow letters, and capitalize them
    if (keyboardType == TextInputType.text) {
      if (newValue.text.contains(new RegExp('[^a-zA-Z]'))) {
        return new TextEditingValue(
            text: oldValue.text, selection: oldValue.selection);
      }
      return new TextEditingValue(
        text: newValue.text?.toUpperCase(),
        selection: newValue.selection,
      );
    } else {
      // Only allow numbers less than 8
      if (newValue.text.contains(new RegExp('[^0-9]'))) {
        return new TextEditingValue(
            text: oldValue.text, selection: oldValue.selection);
      } else {
        return new TextEditingValue(
          text: newValue.text,
          selection: newValue.selection,
        );
      }
    }
  }
}
