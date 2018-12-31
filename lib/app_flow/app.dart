import 'package:anagrammatic/options/options_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/app_flow/home.dart';
import 'package:anagrammatic/options/options.dart';

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
  OptionsLoader _settingLoader = OptionsLoader();

  @override
  void initState() {
    super.initState();
    options = _settingLoader.getDefaultOptions();
    _settingLoader.readOptions().then((Options readOptions) {
      setState(() {
        options = readOptions;
      });
    });
  }

  void updateOptions(Options newOptions) {
    setState(() {
      options = newOptions;
    });

    _settingLoader.writeOptions(options);
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
          return _applyTextScaleFactor(child);
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
