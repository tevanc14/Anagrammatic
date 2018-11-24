import 'package:anagramatic/service/anagram_generator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnagramCard extends StatefulWidget {
  final Anagram anagram;

  AnagramCard({@required this.anagram});

  @override
  State createState() {
    return new AnagramCardState();
  }
}

class AnagramCardState extends State<AnagramCard> {
  @override
  Widget build(BuildContext context) {
    return new Card(
        color: Theme.of(context).primaryColor,
        elevation: 10.0,
        margin: new EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 15.0,
        ),
        child: new ListTile(
          title: new Text(widget.anagram.word,
              style: new TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              )),
          trailing: new IconButton(
            icon: Icon(Icons.keyboard_arrow_right, size: 30.0),
            tooltip: 'Define',
            onPressed: () => launchURL(widget.anagram.word),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 40.0,
          ),
        ));
  }

  launchURL(String word) async {
    var url = 'https://www.google.com/search?q=define+' + word;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
