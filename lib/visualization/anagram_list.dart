import 'package:anagramatic/service/anagram_generator.dart';
import 'package:anagramatic/visualization/anagram_card.dart';
import 'package:flutter/material.dart';

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
              if (anagramResponse.data.length > 0) {
                return new ListView.builder(
                    itemCount: anagramResponse.data.length,
                    itemBuilder: (context, index) {
                      return new AnagramCard(
                          anagram: anagramResponse.data[index]);
                    });
              } else {
                return new Text("No anagrams were found 😢",
                    style: new TextStyle(fontSize: 25.0));
              }
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
