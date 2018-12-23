import 'package:anagrammatic/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/themes.dart';

final double _horizontalPadding = 28.0;
final double _verticalPadding = 16.0;

// Currently keeping text one color, regardless of theme
final TextStyle _whiteText = TextStyle(
  color: Colors.white,
);

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

class _LengthCounter extends StatefulWidget {
  _LengthCounter({
    this.counter,
  });

  int counter;

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
              'Minimum length',
              style: _whiteText
            ),
          ),
          _numberAdjustmentButton(
            buttonText: '-',
            onPressed: () {
              setState(() {
                widget.counter--;
                AnagrammaticApp.of(context).updateAnagramSizeBounds(
                  lowerBound: widget.counter,
                );
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Text(
              '${widget.counter}',
              style: _whiteText,
            ),
          ),
          _numberAdjustmentButton(
            buttonText: '+',
            onPressed: () {
              setState(() {
                widget.counter++;
                AnagrammaticApp.of(context).updateAnagramSizeBounds(
                  lowerBound: widget.counter,
                );
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
          text: 'Filter',
        ),
        _LengthCounter(
          counter: options.anagramSizeLowerBound,
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
