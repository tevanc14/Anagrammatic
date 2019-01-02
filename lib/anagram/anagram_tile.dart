import 'package:flutter/material.dart';
import 'package:anagrammatic/anagram/anagram.dart';
import 'package:url_launcher/url_launcher.dart';

class AnagramTile extends StatefulWidget {
  final Anagram anagram;

  AnagramTile({
    @required this.anagram,
  });

  @override
  State createState() {
    return AnagramTileState();
  }
}

class AnagramTileState extends State<AnagramTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.anagram.word,
        style: Theme.of(context).textTheme.headline,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.chevron_right,
        ),
        onPressed: () {
          launchURL(widget.anagram.word);
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
