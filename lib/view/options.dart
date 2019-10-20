import 'package:anagrammatic/anagram/anagram_length_bounds.dart';
import 'package:anagrammatic/view/app.dart';
import 'package:anagrammatic/options/sort_type.dart';
import 'package:anagrammatic/options/themes.dart';
import 'package:anagrammatic/options/text_scaling.dart';
import 'package:anagrammatic/options/word_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final double _horizontalPadding = 28.0;
final double _verticalPadding = 8.0;

// Currently keeping text one color, regardless of theme
final TextStyle _optionLabelText = TextStyle(
  color: Colors.white,
);

class _OptionsItem extends StatelessWidget {
  final Widget child;

  const _OptionsItem({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: child,
    );
  }
}

class _CategoryHeading extends StatelessWidget {
  final String text;
  final IconData iconData;

  const _CategoryHeading({
    this.text,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).accentColor;

    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Icon(
              iconData,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.subhead.copyWith(
                    color: textColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingLabel extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const _SettingLabel({
    this.text,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _optionLabelText,
    );
  }
}

class _BooleanItem extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget infoButton;

  _BooleanItem({
    this.text,
    this.value,
    this.onChanged,
    this.infoButton,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isDark = themeData.brightness == Brightness.dark;
    final Color color = themeData.accentColor;

    return _OptionsItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _SettingLabel(
                    text: text,
                  ),
                  infoButton != null ? infoButton : Container(),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: color,
                activeTrackColor: isDark ? Colors.white30 : Colors.black26,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeSwitch extends StatelessWidget {
  final Options options;

  const _ThemeSwitch({
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      text: 'Dark theme',
      value: options.theme == darkTheme,
      onChanged: (bool value) {
        AnagrammaticApp.of(context).updateOptions(options.copyWith(
          theme: value ? darkTheme : lightTheme,
        ));
      },
    );
  }
}

class _WordListComplexityDropdown extends StatefulWidget {
  final Options options;

  _WordListComplexityDropdown({
    this.options,
  });

  @override
  _WordListComplexityDropdownState createState() =>
      _WordListComplexityDropdownState();
}

class _WordListComplexityDropdownState
    extends State<_WordListComplexityDropdown> {
  final String text = 'Complexity';
  final List<WordList> items = WordList.getAllWordLists();

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SettingLabel(
              text: text,
            ),
          ),
          _SettingLabel(
            text: widget.options.wordList.displayName,
          ),
          PopupMenuButton<WordList>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: _optionLabelText.color,
            ),
            itemBuilder: (BuildContext context) {
              return items.map((item) {
                return PopupMenuItem<WordList>(
                  value: item,
                  child: Text(
                    item.displayName,
                  ),
                );
              }).toList();
            },
            onSelected: (WordList choice) {
              setState(() {
                if (widget.options.wordList != choice) {
                  widget.options.wordList = choice;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _TextScaleDropdown extends StatefulWidget {
  final Options options;

  _TextScaleDropdown({
    this.options,
  });

  @override
  _TextScaleDropdownState createState() => _TextScaleDropdownState();
}

class _TextScaleDropdownState extends State<_TextScaleDropdown> {
  final String text = 'Text size';
  final List<TextScaleFactor> items = TextScaleFactor.getAllTextScaleFactors();

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SettingLabel(
              text: text,
            ),
          ),
          _SettingLabel(
            text: widget.options.textScaleFactor.displayName,
          ),
          PopupMenuButton<TextScaleFactor>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: _optionLabelText.color,
            ),
            itemBuilder: (BuildContext context) {
              return items.map((item) {
                return PopupMenuItem<TextScaleFactor>(
                  value: item,
                  child: Text(
                    item.displayName,
                  ),
                );
              }).toList();
            },
            onSelected: (TextScaleFactor choice) {
              setState(() {
                if (widget.options.textScaleFactor != choice) {
                  AnagrammaticApp.of(context)
                      .updateOptions(widget.options.copyWith(
                    textScaleFactor: choice,
                  ));
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _LengthRangeSlider extends StatefulWidget {
  final Options options;

  _LengthRangeSlider({
    this.options,
  });

  @override
  _LengthRangeSliderState createState() => _LengthRangeSliderState();
}

class _LengthRangeSliderState extends State<_LengthRangeSlider> {
  RangeValues _rangeValues = RangeValues(
    AnagramLengthBounds.minimumAnagramLength.toDouble(),
    AnagramLengthBounds.maximumAnagramLength.toDouble(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _OptionsItem(
          child: _SettingLabel(
            text: 'Length',
          ),
        ),
        _OptionsItem(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: SliderTheme(
                    child: _buildSlider(),
                    data: SliderThemeData(
                      showValueIndicator: ShowValueIndicator.always,
                      minThumbSeparation: 0,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return RangeSlider(
      values: _rangeValues,
      min: AnagramLengthBounds.minimumAnagramLength.toDouble(),
      max: AnagramLengthBounds.maximumAnagramLength.toDouble(),
      onChanged: (RangeValues rangeValues) {
        widget.options.anagramLengthLowerBound = rangeValues.start.toInt();
        widget.options.anagramLengthUpperBound = rangeValues.end.toInt();
        setState(() {
          _rangeValues = rangeValues;
        });
      },
      activeColor: _optionLabelText.color,
      inactiveColor: _optionLabelText.color.withOpacity(
        0.2,
      ),
      divisions: AnagramLengthBounds.maximumAnagramLength,
      labels: RangeLabels(
        '${_rangeValues.start.toInt()}',
        '${_rangeValues.end.toInt()}',
      ),
    );
  }
}

class _SortTypeDropdown extends StatefulWidget {
  final Options options;

  _SortTypeDropdown({
    this.options,
  });

  @override
  _SortTypeDropdownState createState() {
    return _SortTypeDropdownState();
  }
}

class _SortTypeDropdownState extends State<_SortTypeDropdown> {
  final String text = 'Sort';
  final List<SortType> items = SortType.getAllSortTypes();

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SettingLabel(
              text: text,
            ),
          ),
          _SettingLabel(
            text: widget.options.sortType.displayName,
          ),
          PopupMenuButton<SortType>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: _optionLabelText.color,
            ),
            itemBuilder: (BuildContext context) {
              return items.map((item) {
                return PopupMenuItem<SortType>(
                  value: item,
                  child: Text(
                    item.displayName,
                  ),
                );
              }).toList();
            },
            onSelected: (SortType choice) {
              if (widget.options.sortType != choice) {
                setState(() {
                  widget.options.sortType = choice;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class Options {
  bool isOpen;
  AnagrammaticTheme theme;
  int anagramLengthLowerBound;
  int anagramLengthUpperBound;
  SortType sortType;
  TextScaleFactor textScaleFactor;
  WordList wordList;

  Options({
    this.isOpen,
    this.theme,
    this.anagramLengthLowerBound,
    this.anagramLengthUpperBound,
    this.sortType,
    this.textScaleFactor,
    this.wordList,
  });

  Options copyWith({
    AnagrammaticTheme theme,
    int anagramLengthLowerBound,
    int anagramLengthUpperBound,
    SortType sortType,
    TextScaleFactor textScaleFactor,
    WordList wordList,
  }) {
    return Options(
      isOpen: isOpen ?? this.isOpen,
      theme: theme ?? this.theme,
      anagramLengthLowerBound:
          anagramLengthLowerBound ?? this.anagramLengthLowerBound,
      anagramLengthUpperBound:
          anagramLengthUpperBound ?? this.anagramLengthUpperBound,
      sortType: sortType ?? this.sortType,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      wordList: wordList ?? this.wordList,
    );
  }
}

class OptionsPage extends StatelessWidget {
  final Options options;

  OptionsPage({
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const _CategoryHeading(
          text: 'Anagram results',
          iconData: Icons.filter_list,
        ),
        _SortTypeDropdown(
          options: options,
        ),
        _LengthRangeSlider(
          options: options,
        ),
        _WordListComplexityDropdown(
          options: options,
        ),
        const Divider(
          color: Color(
            0x1F000000,
          ),
        ),
        const _CategoryHeading(
          text: 'Display',
          iconData: Icons.palette,
        ),
        _ThemeSwitch(
          options: options,
        ),
        _TextScaleDropdown(
          options: options,
        ),
      ]..add(
          // Unsure how to manipulate the viewable area to cooperate with scrolling
          Padding(
            padding: const EdgeInsets.only(
              bottom: 100.0,
            ),
          ),
        ),
    );
  }
}
