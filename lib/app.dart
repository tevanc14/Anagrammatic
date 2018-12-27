import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/constants.dart';
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
      anagramLengthLowerBound: minimumAnagramLength,
      anagramLengthUpperBound: maximumAnagramLength,
      sortType: SortType.getSortName(SortTypeName.alpha),
    );
  }

  void updateOptions(Options newOptions) {
    setState(() {
      options = newOptions;
    });
  }

  void upateTheme(theme) {
    setState(() {
      options.theme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OptionsContainer(
      data: this,
      child: MaterialApp(
        theme: options.theme.data,
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
