import 'package:anagrammatic/common/anagrammatic_app_bar.dart';
import 'package:anagrammatic/service/anagram_generator.dart';
import 'package:anagrammatic/visualization/anagram_card.dart';
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
        appBar: AnagrammaticAppBar.appBar,
        body: Container(
          child: FutureBuilder<List<Anagram>>(
            future: generateAnagrams(widget.characters, widget.length),
            builder: (context, anagramResponse) {
              if (anagramResponse.hasData) {
                if (anagramResponse.data.length > 0) {
                  return ListView.builder(
                      itemCount: anagramResponse.data.length,
                      itemBuilder: (context, index) {
                        return AnagramCard(
                            anagram: anagramResponse.data[index]);
                      });
                } else {
                  return Text("No anagrams were found 😢",
                      style: TextStyle(fontSize: 25.0));
                }
              } else if (anagramResponse.hasError) {
                return Text(
                  "${anagramResponse.error}",
                  textAlign: TextAlign.center,
                );
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
          alignment: FractionalOffset.center,
        ));
  }
}
