import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/themes.dart';

class _BooleanItem extends StatelessWidget {
  const _BooleanItem(
    this.title,
    this.value,
    this.onChanged,
  );

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 20.0,
      ),
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
      'Dark Theme',
      options.theme == darkTheme,
      (bool value) {
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
  });

  final AnagrammaticTheme theme;

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
        _ThemeSwitch(
          options: options,
          onOptionsChanged: onOptionsChanged,
        ),
      ],
    );
  }
}
