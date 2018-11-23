import 'package:anagramatic/anagram_generator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnagramList extends StatefulWidget {
  final String characters;
  final int length;

  AnagramList({@required this.characters, @required this.length});

  @override
  State createState() {
    return AnagramListState();
  }
}

class AnagramListState extends State<AnagramList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new FutureBuilder<List<Anagram>>(
          future: generateAnagrams(widget.characters, widget.length),
          builder: (context, anagramResponse) {
            if (anagramResponse.hasData) {
              return new ListView.builder(
                  itemCount: anagramResponse.data.length,
                  itemBuilder: (context, index) {
                    return new AnagramCard(
                        anagram: anagramResponse.data[index]);
                  });
            } else if (anagramResponse.hasError) {
              return new Text(
                "${anagramResponse.error}",
                textAlign: TextAlign.center,
              );
            }

            // By default, show a loading spinner
            return new CircularProgressIndicator();
          },
        ),
        alignment: FractionalOffset.center,
      ),
    );
  }
}

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
        margin: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: ListTile(
          title: Text(widget.anagram.word,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.keyboard_arrow_right, size: 30.0),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        ));
  }
}
