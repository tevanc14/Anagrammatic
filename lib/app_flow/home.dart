import 'package:anagrammatic/app_flow/app.dart';
import 'package:anagrammatic/options/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/app_flow/backdrop.dart';
import 'package:anagrammatic/app_flow/input.dart';

const Duration frontLayerSwitchDuration = Duration(
  milliseconds: 300,
);

class Home extends StatefulWidget {
  final String title = 'Anagrammatic';
  final OptionsPage optionsPage;

  Home({
    this.optionsPage,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget frontPage;
  bool showBackButton = false;
  bool shouldSystemBackExit = true;

  @override
  void initState() {
    super.initState();
    frontPage = _getInputWidget();
  }

  Input _getInputWidget() {
    return Input(
      transition: _listTransition,
    );
  }

  void _listTransition(Widget newPage) {
    setState(() {
      showBackButton = true;
      shouldSystemBackExit = false;
      frontPage = newPage;
    });
  }

  void _inputTransition() {
    if (!AnagrammaticApp.of(context).options.isOpen) {
      setState(() {
        showBackButton = false;
        shouldSystemBackExit = true;
        frontPage = _getInputWidget();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Curve switchOutCurve = Interval(
      0.4,
      1.0,
      curve: Curves.fastOutSlowIn,
    );
    const Curve switchInCurve = Interval(
      0.4,
      1.0,
      curve: Curves.fastOutSlowIn,
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          child: Backdrop(
            frontAction: AnimatedSwitcher(
              duration: frontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              child: showBackButton
                  ? IconButton(
                      icon: const BackButtonIcon(),
                      tooltip: 'Back',
                      onPressed: () => _inputTransition(),
                    )
                  // TODO: Insert logo here
                  : Container(),
            ),
            frontTitle: AnimatedSwitcher(
              duration: frontLayerSwitchDuration,
              child: Text(
                widget.title,
              ),
            ),
            frontHeading: Container(
              height: 24.0,
            ),
            frontLayer: AnimatedSwitcher(
              duration: frontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              child: frontPage,
            ),
            // TODO: Insert logo here
            backAction: Container(),
            backTitle: const Text(
              'Options',
            ),
            backLayer: widget.optionsPage,
          ),
          onWillPop: () {
            if (shouldSystemBackExit) {
              SystemNavigator.pop();
            } else {
              _inputTransition();
            }
          },
        ),
      ),
    );
  }
}