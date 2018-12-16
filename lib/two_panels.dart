import 'package:anagrammatic/backdrop.dart';
import 'package:anagrammatic/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Duration frontLayerSwitchDuration = Duration(milliseconds: 300);

class TwoPanels extends StatefulWidget {
  final String title = 'Anagrammatic';

  const TwoPanels({
    @required this.frontLayerWidget,
    @required this.showBackButton
  });

  final Widget frontLayerWidget;
  final bool showBackButton;

  @override
  TwoPanelsState createState() => TwoPanelsState();
}

class TwoPanelsState extends State<TwoPanels> {
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        bottom: false,
        child: Backdrop(
          backTitle: const Text(
            'Options',
          ),
          backLayer: Options(),
          frontAction: AnimatedSwitcher(
            duration: frontLayerSwitchDuration,
            switchOutCurve: switchOutCurve,
            switchInCurve: switchInCurve,
            // TODO: Insert logo here
            child: widget.showBackButton
                ? IconButton(
                  icon: const BackButtonIcon(),
                  tooltip: 'Back',
                  onPressed: () => Navigator.pop(context),
                )
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
          frontLayer: AnimatedSwitcher(
            duration: frontLayerSwitchDuration,
            switchOutCurve: switchOutCurve,
            switchInCurve: switchInCurve,
            child: widget.frontLayerWidget,
          ),
        ),
      ),
    );
  }
}
