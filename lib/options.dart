import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/themes.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

class _Heading extends StatelessWidget {
  const _Heading({
    this.title,
  });

  final String title;

  final EdgeInsets _headingPadding = const EdgeInsets.only(
    top: 16.0,
    left: 40.0,
    right: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _headingPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: switchColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BooleanItem extends StatelessWidget {
  _BooleanItem({
    this.title,
    this.value,
    this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  final EdgeInsets _booleanItemPadding = const EdgeInsets.only(
    left: 60.0,
    right: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: _booleanItemPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: switchColor,
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
    this.onOptionsChanged,
  });

  final Options options;
  final ValueChanged<Options> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      title: 'Dark Theme',
      value: options.theme == darkTheme,
      onChanged: (bool value) {
        onOptionsChanged(
          options.copyWith(
            theme: value ? darkTheme : lightTheme,
          ),
        );
      },
    );
  }
}

class Options {
  Options({
    this.theme,
    this.anagramSizeLowerBound,
    this.anagramSizeUpperBound,
  });

  final AnagrammaticTheme theme;
  final double anagramSizeLowerBound;
  final double anagramSizeUpperBound;

  Options copyWith({
    AnagrammaticTheme theme,
  }) {
    return Options(
      theme: theme ?? this.theme,
    );
  }
}

class OptionsPage extends StatelessWidget {
  const OptionsPage({
    this.options,
    this.onOptionsChanged,
  });

  final Options options;
  final ValueChanged<Options> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _Heading(
          title: 'Filter',
        ),
        _Heading(
          title: 'Personalization',
        ),
        _ThemeSwitch(
          options: options,
          onOptionsChanged: onOptionsChanged,
        ),
      ],
    );
  }
}
