import 'package:anagrammatic/options.dart';
import 'package:flutter/material.dart';

class AnagrammaticAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  AnagrammaticAppBar({
    this.hasSettings,
  });

  bool hasSettings;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Anagrammatic',
      ),
      actions: hasSettings
          ? <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  transferToOptions(context);
                },
              ),
            ]
          : <Widget>[],
    );
  }

  transferToOptions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionsPage(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        56.0,
      );
}
