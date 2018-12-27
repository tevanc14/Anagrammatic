import 'package:anagrammatic/anagram.dart';
import 'package:anagrammatic/sort_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/app.dart';
import 'package:anagrammatic/constants.dart';
import 'package:anagrammatic/themes.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

final double _horizontalPadding = 28.0;
final double _verticalPadding = 16.0;

// Currently keeping text one color, regardless of theme
final TextStyle _labelText = TextStyle(
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
      style: _labelText,
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
        AnagrammaticApp.of(context).updateOptions(
            options.copyWith(theme: value ? darkTheme : lightTheme));
      },
    );
  }
}

class _SliderValueDisplay extends StatelessWidget {
  const _SliderValueDisplay({
    this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _labelText,
      ),
    );
  }
}

class LengthSlider extends StatefulWidget {
  const LengthSlider({
    this.options,
  });

  final Options options;

  @override
  _LengthSliderState createState() => _LengthSliderState();
}

class _LengthSliderState extends State<LengthSlider> {
  final EdgeInsets _sliderItemPadding = EdgeInsets.symmetric(
    horizontal: _horizontalPadding,
  );

  @override
  Widget build(BuildContext context) {
    Color _sliderColor = _labelText.color;

    return Padding(
      padding: _sliderItemPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: _verticalPadding,
              bottom: _verticalPadding * 3.25,
            ),
            child: _SettingLabel(
              text: 'Anagram length',
            ),
          ),
          Row(
            children: <Widget>[
              _SliderValueDisplay(
                text: '${widget.options.anagramLengthLowerBound}',
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    overlayColor: Colors.white24,
                    activeTickMarkColor: _sliderColor,
                    activeTrackColor: _sliderColor,
                    inactiveTrackColor: _sliderColor,
                    thumbColor: _sliderColor,
                    valueIndicatorColor: _sliderColor,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: RangeSlider(
                    min: minimumAnagramLength.toDouble(),
                    max: maximumAnagramLength.toDouble(),
                    lowerValue:
                        widget.options.anagramLengthLowerBound.toDouble(),
                    upperValue:
                        widget.options.anagramLengthUpperBound.toDouble(),
                    showValueIndicator: true,
                    valueIndicatorMaxDecimals: 0,
                    onChanged: (double newLowerValue, double newUpperValue) {
                      setState(() {
                        widget.options.anagramLengthLowerBound =
                            newLowerValue.toInt();
                        widget.options.anagramLengthUpperBound =
                            newUpperValue.toInt();
                      });
                    },
                  ),
                ),
              ),
              _SliderValueDisplay(
                text: '${widget.options.anagramLengthUpperBound}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortTypeDropdown extends StatefulWidget {
  _SortTypeDropdown({
    this.options,
  });

  final Options options;

  @override
  _SortTypeDropdownState createState() {
    return _SortTypeDropdownState();
  }
}

class _SortTypeDropdownState extends State<_SortTypeDropdown> {
  final EdgeInsets _dropdownItemPadding = EdgeInsets.symmetric(
    horizontal: _horizontalPadding,
  );
  final String text = 'Sort';
  final List<String> items = SortType.sortTypeStrings();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _dropdownItemPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SettingLabel(
              text: text,
            ),
          ),
          _SettingLabel(
            text: widget.options.sortType,
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: _labelText.color,
            ),
            itemBuilder: (BuildContext context) {
              return items.map((item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                  ),
                );
              }).toList();
            },
            onSelected: (String choice) {
              setState(() {
                widget.options.sortType = choice;
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
    this.anagramLengthLowerBound,
    this.anagramLengthUpperBound,
    this.sortType,
  });

  AnagrammaticTheme theme;
  int anagramLengthLowerBound;
  int anagramLengthUpperBound;
  String sortType;

  Options copyWith({
    AnagrammaticTheme theme,
    int anagramLengthLowerBound,
    int anagramLengthUpperBound,
    String sortType,
  }) {
    return Options(
      theme: theme ?? this.theme,
      anagramLengthLowerBound:
          anagramLengthLowerBound ?? this.anagramLengthLowerBound,
      anagramLengthUpperBound:
          anagramLengthUpperBound ?? this.anagramLengthUpperBound,
      sortType: sortType ?? this.sortType,
    );
  }
}

class OptionsPage extends StatelessWidget {
  OptionsPage({
    this.options,
  });

  final Options options;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _CategoryHeading(
          text: 'Result organization',
        ),
        _SortTypeDropdown(
          options: options,
        ),
        LengthSlider(
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
