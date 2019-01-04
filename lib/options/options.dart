import 'package:anagrammatic/anagram/anagram_length_bounds.dart';
import 'package:anagrammatic/options/sort_type.dart';
import 'package:anagrammatic/options/text_scaling.dart';
import 'package:anagrammatic/options/word_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/app_flow/app.dart';
import 'package:anagrammatic/options/themes.dart';

final double _horizontalPadding = 28.0;
final double _verticalPadding = 8.0;
final Color _optionsAccentColor = const Color(0xFF39CEFD);

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
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Icon(
              iconData,
              color: _optionsAccentColor,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: _optionsAccentColor),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
                activeColor: _optionsAccentColor,
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
        AnagrammaticApp.of(context).updateOptions(
            options.copyWith(theme: value ? darkTheme : lightTheme));
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
                widget.options.wordList = choice;
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
                AnagrammaticApp.of(context).updateOptions(
                    widget.options.copyWith(textScaleFactor: choice));
              });
            },
          ),
        ],
      ),
    );
  }
}

class _LengthSliderValueDisplay extends StatelessWidget {
  final String text;

  const _LengthSliderValueDisplay({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.0,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _optionLabelText,
      ),
    );
  }
}

class _LengthSliderLabel extends StatelessWidget {
  final String text;

  const _LengthSliderLabel({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108.0,
      child: _SettingLabel(
        text: text,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _LengthSlider extends StatelessWidget {
  final String labelText;
  final String displayText;
  final Slider slider;

  _LengthSlider({
    this.labelText,
    this.displayText,
    this.slider,
  });

  @override
  Widget build(BuildContext context) {
    Color _sliderColor = _optionLabelText.color;

    return _OptionsItem(
      child: Padding(
        padding: EdgeInsets.only(
          left: _horizontalPadding,
        ),
        child: Row(
          children: <Widget>[
            _LengthSliderLabel(
              text: labelText,
            ),
            _LengthSliderValueDisplay(
              text: displayText,
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayColor: Colors.white24,
                  activeTickMarkColor: _sliderColor,
                  activeTrackColor: _sliderColor,
                  inactiveTrackColor: _sliderColor,
                  thumbColor: _sliderColor,
                ),
                child: slider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinLengthSlider extends StatefulWidget {
  final Options options;

  _MinLengthSlider({
    this.options,
  });

  @override
  _MinLengthSliderState createState() {
    return new _MinLengthSliderState();
  }
}

class _MinLengthSliderState extends State<_MinLengthSlider> {
  @override
  Widget build(BuildContext context) {
    return _LengthSlider(
      labelText: 'Minimum',
      displayText: '${widget.options.anagramLengthLowerBound}',
      slider: Slider(
        value: widget.options.anagramLengthLowerBound.toDouble(),
        min: AnagramLengthBounds.minimumAnagramLength.toDouble(),
        max: AnagramLengthBounds.maximumAnagramLength.toDouble(),
        onChanged: (double newValue) {
          if (newValue <= widget.options.anagramLengthUpperBound) {
            setState(() {
              widget.options.anagramLengthLowerBound = newValue.ceil();
            });
          }
        },
      ),
    );
  }
}

class _MaxLengthSlider extends StatefulWidget {
  final Options options;

  _MaxLengthSlider({
    this.options,
  });

  @override
  _MaxLengthSliderState createState() {
    return new _MaxLengthSliderState();
  }
}

class _MaxLengthSliderState extends State<_MaxLengthSlider> {
  @override
  Widget build(BuildContext context) {
    return _LengthSlider(
      labelText: 'Maximum',
      displayText: '${widget.options.anagramLengthUpperBound}',
      slider: Slider(
        value: widget.options.anagramLengthUpperBound.toDouble(),
        min: AnagramLengthBounds.minimumAnagramLength.toDouble(),
        max: AnagramLengthBounds.maximumAnagramLength.toDouble(),
        onChanged: (double newValue) {
          if (newValue >= widget.options.anagramLengthLowerBound) {
            setState(() {
              widget.options.anagramLengthUpperBound = newValue.floor();
            });
          }
        },
      ),
    );
  }
}

class _LengthSliders extends StatefulWidget {
  final Options options;

  _LengthSliders({
    this.options,
  });

  @override
  _LengthSlidersState createState() => _LengthSlidersState();
}

class _LengthSlidersState extends State<_LengthSliders> {
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
        _MinLengthSlider(
          options: widget.options,
        ),
        _MaxLengthSlider(
          options: widget.options,
        ),
      ],
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
        _LengthSliders(
          options: options,
        ),
        _WordListComplexityDropdown(
          options: options,
        ),
        const Divider(),
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
