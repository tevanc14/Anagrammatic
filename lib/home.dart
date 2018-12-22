import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anagrammatic/backdrop.dart';
import 'package:anagrammatic/input.dart';

const Duration frontLayerSwitchDuration = Duration(
  milliseconds: 300,
);

class Home extends StatefulWidget {
  final String title = 'Anagrammatic';

  Home({
    this.optionsPage,
  });

  final Widget optionsPage;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget frontPage;
  bool showBackButton = false;

  Widget _getInputWidget() {
    return Input(
      transition: _listTransition,
    );
  }

  void _listTransition(Widget newPage) {
    setState(() {
      showBackButton = true;
      frontPage = newPage;
    });
  }

  void _inputTransition() {
    setState(() {
      showBackButton = false;
      frontPage = _getInputWidget();
    });
  }

  @override
  void initState() {
    super.initState();
    frontPage = _getInputWidget();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
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
        child: Backdrop(
          backTitle: const Text(
            'Options',
          ),
          backLayer: widget.optionsPage,
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
                : const Text(
                    '',
                  ),
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
        ),
      ),
    );
  }
}
