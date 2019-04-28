import 'package:anagrammatic/anagram/anagram_length_bounds.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  bool showInfoText = false;

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
        body: Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
            left: 40.0,
            right: 40.0,
          ),
          child: Form(
            key: key,
            child: ScrollConfiguration(
              behavior: NoOverscrollBehavior(),
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _textField(theme),
                      // _infoButton(),
                      // _infoText(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _submitButton(theme),
      ),
    );
  }

  Widget _textField(ThemeData theme) {
    final BorderRadius borderRadius = BorderRadius.circular(24.0);

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
        counterText: '',
        labelText: 'Characters',
        labelStyle: theme.textTheme.title,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.textTheme.title.color,
          ),
          borderRadius: borderRadius,
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

  Widget _infoButton() {
    return IconButton(
      onPressed: () {
        _infoButtonPressed();
      },
      icon: Icon(
        showInfoText ? Icons.clear : Icons.info,
      ),
      tooltip: showInfoText ? 'Hide input assistance' : 'Show input assistance',
    );
  }

  _infoButtonPressed() {
    setState(() {
      showInfoText = !showInfoText;
    });

    if (showInfoText) {
      _dismissKeyboard();
    }
  }

  Widget _infoText() {
    if (showInfoText) {
      return _buildInfoText();
    } else {
      return Container();
    }
  }

  Widget _buildInfoText() {
    List<String> infoTextStrings = [
      'Use an asterisk (*) for an unknown character',
      'Maximum length of ${AnagramLengthBounds.maximumAnagramLength} characters'
    ];
    List<Widget> infoTextTiles = [];
    infoTextStrings.forEach((infoTextString) {
      infoTextTiles.add(
        ListTile(
          leading: Text(
            '•',
          ),
          title: Text(
            infoTextString,
          ),
        ),
      );
    });

    return Flexible(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: infoTextTiles,
          ),
        ],
      ),
    );
  }

  Widget _submitButton(ThemeData theme) {
    if (showSubmitButton) {
      return FloatingActionButton(
        onPressed: () {
          _transferToAnagramList(context);
        },
        tooltip: 'Generate anagrams',
        child: Icon(
          Icons.done,
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      );
    } else {
      return Container();
    }
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
      FirebaseAnalytics().logEvent(
        name: 'generate_anagrams',
        parameters: {'characters': charactersTextController.text},
      );

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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp('[^a-zA-Z]');
    // final RegExp regExp = RegExp('[^a-zA-Z\*]');
    if (newValue.text.contains(regExp)) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: newValue.text?.toUpperCase(),
        selection: newValue.selection,
      );
    }
  }
}

class NoOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
