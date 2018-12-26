import 'package:anagrammatic/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/constants.dart';
import 'package:anagrammatic/options.dart';
import 'package:anagrammatic/themes.dart';

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
      anagramSizeLowerBound: minimumAnagramLength,
      anagramSizeUpperBound: maximumAnagramLength,
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

  void updateAnagramSizeLowerBound(lowerBound) {
    setState(() {
      options.anagramSizeLowerBound = lowerBound;
    });
  }

  void updateAnagramSizeUpperBound(upperBound) {
    setState(() {
      options.anagramSizeUpperBound = upperBound;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OptionsContainer(
      data: this,
      child: MaterialApp(
        theme: options.theme.data,
        home: Input(),
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
