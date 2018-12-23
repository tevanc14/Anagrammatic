import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/home.dart';
import 'package:anagrammatic/options.dart';
import 'package:anagrammatic/themes.dart';

class AnagrammaticApp extends StatefulWidget {
  static _AnagrammaticAppState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(OptionsContainer)
            as OptionsContainer)
        .data;
  }

  @override
  _AnagrammaticAppState createState() => _AnagrammaticAppState();
}

class _AnagrammaticAppState extends State<AnagrammaticApp> {
  Options options;

  @override
  void initState() {
    super.initState();
    options = Options(
      theme: darkTheme,
      anagramSizeLowerBound: 1,
      anagramSizeUpperBound: 20,
    );
  }

  void upateTheme({theme}) {
    setState(() {
      options.theme = theme;
    });
  }

  void updateAnagramSizeBounds({
    lowerBound,
    upperBound,
  }) {
    setState(() {
      options.anagramSizeLowerBound = lowerBound;
      options.anagramSizeUpperBound = upperBound;
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
  final _AnagrammaticAppState data;

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
