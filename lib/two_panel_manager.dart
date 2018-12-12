import 'package:anagrammatic/input/input.dart';
import 'package:flutter/material.dart';

class TwoPanelManager extends StatefulWidget {
  final AnimationController controller;

  TwoPanelManager({this.controller});

  @override
  TwoPanelManagerState createState() => TwoPanelManagerState();
}

class TwoPanelManagerState extends State<TwoPanelManager> {
  static const headerHeight = 80.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - headerHeight;
    final frontPanelHeight = -headerHeight;

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        backPanelHeight,
        0.0,
        frontPanelHeight,
      ),
      end: RelativeRect.fromLTRB(
        0.0,
        0.0,
        0.0,
        0.0,
      ),
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.linear,
      ),
    );
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: theme.primaryColor,
            child: Center(
              child: Text(
                "Back Panel",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: headerHeight,
                    child: Center(
                      child: Text(
                        'Character Entry',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Input(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,
    );
  }
}
