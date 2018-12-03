import 'package:anagrammatic/service/anagram_generator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnagramCard extends StatefulWidget {
  final Anagram anagram;

  AnagramCard({@required this.anagram});

  @override
  State createState() {
    return AnagramCardState();
  }
}

class AnagramCardState extends State<AnagramCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(
        15.0,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: FittedBox(
              child: Text(widget.anagram.word),
              fit: BoxFit.contain,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                RaisedButton(
                  child: Text(
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
        ],
      ),
    );
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
