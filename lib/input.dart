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
  List<String> _text;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _text = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
    _text.clear();
  }

  Widget buildTextField(int index, BuildContext context) {
    _focusNodes[index] = FocusNode();
    _textControllers[index] = TextEditingController();

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        inputFormatters: [TextFormatter(widget.keyboardType)],
        controller: _textControllers[index],
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        maxLength: 1,
        enableInteractiveSelection: false,
        style: Theme.of(context).textTheme.title,
        focusNode: _focusNodes[index],
        decoration: InputDecoration(counterText: ''),
        onChanged: (String character) {
          _text[index] = character;
          if (index + 1 != widget.fields && character.trim() != '') {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
        },
        onSubmitted: (String str) {
//          _text.removeWhere((value) => value == null);
          // DEBT: removeWhere would stall everything, so take out nulls here
          widget.onSubmit(_text.join().replaceAll(new RegExp('(null)+'), ''));
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    FocusScope.of(context).requestFocus(_focusNodes[0]);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      if (newValue.text.contains(new RegExp('[^0-9]')) ||
          int.parse(newValue.text) > 7) {
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
