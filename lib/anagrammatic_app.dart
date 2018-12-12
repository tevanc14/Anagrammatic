import 'package:anagrammatic/input/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnagrammaticApp extends StatefulWidget {
  static final String title = 'Anagrammatic';

  @override
  AnagrammaticAppState createState() => AnagrammaticAppState();
}

class AnagrammaticAppState extends State<AnagrammaticApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[600],
        accentColor: Colors.grey[600],
      ),
      home: BackdropPage(),
    );
  }
}

class BackdropPage extends StatefulWidget {
  @override
  BackdropPageState createState() => BackdropPageState();
}

class BackdropPageState extends State<BackdropPage>
    with TickerProviderStateMixin {
  AnimationController menuButtonController;

  @override
  void initState() {
    super.initState();
    menuButtonController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    menuButtonController.dispose();
  }

  bool get isBackdropVisible {
    final AnimationStatus status = menuButtonController.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AnagrammaticApp.title),
        actions: <Widget>[
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: menuButtonController.view,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              menuButtonController.fling(
                  velocity: isBackdropVisible ? -1.0 : 1.0);
            },
          ),
        ],
        elevation: 0.0,
      ),
      body: TwoPanels(
        controller: menuButtonController,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  TwoPanels({this.controller});

  @override
  TwoPanelsState createState() => TwoPanelsState();
}

class TwoPanelsState extends State<TwoPanels> {
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
                style: TextStyle(fontSize: 24.0, color: Colors.white),
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
