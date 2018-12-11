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
    return ListTile(
      title: Text(
        widget.anagram.word,
        style: TextStyle(
          fontSize: 40.0,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.chevron_right,
        ),
        onPressed: () {
          launchURL(
            widget.anagram.word,
          );
        },
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
