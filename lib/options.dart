import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/app.dart';
import 'package:anagrammatic/constants.dart';
import 'package:anagrammatic/themes.dart';

final double _horizontalPadding = 28.0;
final double _verticalPadding = 16.0;

// Currently keeping text one color, regardless of theme
final TextStyle _whiteText = TextStyle(
  color: Colors.white,
);

typedef LengthCounterValidityCallback = bool Function(int counter);

class _CategoryHeading extends StatelessWidget {
  _CategoryHeading({
    this.text,
  });

  final String text;

  final EdgeInsets _headingPadding = EdgeInsets.symmetric(
    horizontal: _horizontalPadding,
    vertical: _verticalPadding,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _headingPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: optionsAccentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingLabel extends StatelessWidget {
  const _SettingLabel({
    this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _whiteText,
    );
  }
}

class _BooleanItem extends StatelessWidget {
  _BooleanItem({
    this.text,
    this.value,
    this.onChanged,
  });

  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  final EdgeInsets _booleanItemPadding = EdgeInsets.symmetric(
    horizontal: _horizontalPadding,
  );

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: _booleanItemPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SettingLabel(
              text: text,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: optionsAccentColor,
            activeTrackColor: isDark ? Colors.white30 : Colors.black26,
          ),
        ],
      ),
    );
  }
}

class _ThemeSwitch extends StatelessWidget {
  const _ThemeSwitch({
    this.options,
  });

  final Options options;

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      text: 'Dark theme',
      value: options.theme == darkTheme,
      onChanged: (bool value) {
        AnagrammaticApp.of(context).upateTheme(
          theme: value ? darkTheme : lightTheme,
        );
      },
    );
  }
}

class _MinimumLengthCounter extends StatelessWidget {
  const _MinimumLengthCounter({
    this.options,
  });

  final Options options;

  bool isValid(int newValue) {
    return newValue <= options.anagramSizeUpperBound &&
        newValue >= minimumAnagramLength;
  }

  @override
  Widget build(BuildContext context) {
    final AnagrammaticAppState appState = AnagrammaticApp.of(context);

    return _LengthCounter(
      text: 'Minimum length',
      counter: options.anagramSizeLowerBound,
      onChanged: appState.updateAnagramSizeLowerBound,
      isValid: isValid,
    );
  }
}

class _MaximumLengthCounter extends StatelessWidget {
  const _MaximumLengthCounter({
    this.options,
  });

  final Options options;

  bool isValid(int newValue) {
    return newValue >= options.anagramSizeLowerBound &&
        newValue <= maximumAnagramLength;
  }

  @override
  Widget build(BuildContext context) {
    final AnagrammaticAppState appState = AnagrammaticApp.of(context);

    return _LengthCounter(
      text: 'Maximum length',
      counter: options.anagramSizeUpperBound,
      onChanged: appState.updateAnagramSizeUpperBound,
      isValid: isValid,
    );
  }
}

class _LengthCounter extends StatefulWidget {
  _LengthCounter({
    this.text,
    this.counter,
    this.onChanged,
    this.isValid,
  });

  final String text;
  int counter;
  final ValueChanged<int> onChanged;
  final LengthCounterValidityCallback isValid;

  @override
  _LengthCounterState createState() => _LengthCounterState();
}

// Needs a verify function argument to check if greater than zero
// and either less than or greater than counterpart
class _LengthCounterState extends State<_LengthCounter> {
  _numberAdjustmentButton({
    buttonText,
    onPressed,
  }) {
    return ButtonTheme(
      minWidth: 20.0,
      height: 20.0,
      child: OutlineButton(
        child: Text(
          buttonText,
          style: _whiteText,
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.text,
              style: _whiteText,
            ),
          ),
          _numberAdjustmentButton(
            buttonText: '-',
            onPressed: () {
              setState(() {
                int newValue = widget.counter - 1;
                if (widget.isValid(newValue)) {
                  widget.counter = newValue;
                  widget.onChanged(
                    newValue,
                  );
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: SizedBox(
              width: 16.0,
              child: Text(
                '${widget.counter}',
                style: _whiteText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _numberAdjustmentButton(
            buttonText: '+',
            onPressed: () {
              setState(() {
                int newValue = widget.counter + 1;
                if (widget.isValid(newValue)) {
                  widget.counter = newValue;
                  widget.onChanged(
                    newValue,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class Options {
  Options({
    this.theme,
    this.anagramSizeLowerBound,
    this.anagramSizeUpperBound,
  });

  AnagrammaticTheme theme;
  int anagramSizeLowerBound;
  int anagramSizeUpperBound;

  Options copyWith({
    AnagrammaticTheme theme,
    int anagramSizeLowerBound,
    int anagramSizeUpperBound,
  }) {
    return Options(
      theme: theme ?? this.theme,
      anagramSizeLowerBound:
          anagramSizeLowerBound ?? this.anagramSizeLowerBound,
      anagramSizeUpperBound:
          anagramSizeUpperBound ?? this.anagramSizeUpperBound,
    );
  }
}

class OptionsPage extends StatelessWidget {
  const OptionsPage({
    this.options,
  });

  final Options options;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CategoryHeading(
          text: 'Result organization',
        ),
        _MinimumLengthCounter(
          options: options,
        ),
        _MaximumLengthCounter(
          options: options,
        ),
        _CategoryHeading(
          text: 'Display',
        ),
        _ThemeSwitch(
          options: options,
        ),
      ],
    );
  }
}
