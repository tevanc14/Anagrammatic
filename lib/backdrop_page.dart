import 'package:anagrammatic/two_panel_manager.dart';
import 'package:anagrammatic/anagrammatic_app.dart';
import 'package:flutter/material.dart';

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
      body: TwoPanelManager(
        controller: menuButtonController,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
