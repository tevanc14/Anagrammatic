import 'package:anagrammatic/anagram_length_bounds.dart';
import 'package:anagrammatic/text_scaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/home.dart';
import 'package:anagrammatic/options.dart';
import 'package:anagrammatic/themes.dart';
import 'package:anagrammatic/sort_type.dart';

class AnagrammaticApp extends StatefulWidget {
  static AnagrammaticAppState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(OptionsContainer)
            as OptionsContainer)
        .data;
  }

  @override
  AnagrammaticAppState createState() => AnagrammaticAppState();
}

class AnagrammaticAppState extends State<AnagrammaticApp> {
  Options options;

  @override
  void initState() {
    super.initState();
    options = Options(
      theme: darkTheme,
      anagramLengthLowerBound: AnagramLengthBounds.minimumAnagramLength,
      anagramLengthUpperBound: AnagramLengthBounds.maximumAnagramLength,
      sortType: SortType.getDefault(),
      textScaleFactor: TextScaleFactor.getDefault(),
    );
  }

  void updateOptions(Options newOptions) {
    setState(() {
      options = newOptions;
    });
  }

  Widget _applyTextScaleFactor(Widget child) {
    return Builder(
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: options.textScaleFactor.scaleFactor,
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OptionsContainer(
      data: this,
      child: MaterialApp(
        theme: options.theme.data,
        builder: (BuildContext context, Widget child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: _applyTextScaleFactor(child),
          );
        },
        home: Home(
          optionsPage: OptionsPage(
            options: options,
          ),
        ),
      ),
    );
  }
}

class OptionsContainer extends InheritedWidget {
  final AnagrammaticAppState data;

  OptionsContainer({
    Key key,
    this.data,
    Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}
