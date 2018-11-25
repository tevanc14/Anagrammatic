import 'package:anagrammatic/service/anagram_generator.dart';
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
        elevation: 10.0,
        margin: new EdgeInsets.all(15.0),
        child: new Column(children: <Widget>[
          new ListTile(
            title: new FittedBox(
              child: Text(widget.anagram.word),
              fit: BoxFit.contain,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
          ),
          new ButtonTheme.bar(
            child: new ButtonBar(
              children: <Widget>[
                new RaisedButton(
                  child: new Text(
                    'DEFINE',
                    style: Theme.of(context).textTheme.title,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    launchURL(widget.anagram.word);
                  },
                ),
              ],
            ),
          ),
        ]));
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
