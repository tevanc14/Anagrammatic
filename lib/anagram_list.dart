import 'package:flutter/material.dart';
import 'package:anagrammatic/anagram.dart';
import 'package:anagrammatic/anagram_generator.dart';
import 'package:anagrammatic/anagram_tile.dart';

class AnagramList extends StatefulWidget {
  final String characters;

  AnagramList({@required this.characters});

  @override
  State createState() {
    return AnagramListState();
  }
}

class AnagramListState extends State<AnagramList> {
  final key = GlobalKey<AnagramListState>();
  List<Anagram> anagrams = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Container(
        child: FutureBuilder<List<Anagram>>(
          future: generateAnagrams(widget.characters),
          builder: (context, generatedAnagrams) {
            if (generatedAnagrams.hasData) {
              if (generatedAnagrams.data.length > 0) {
                anagrams = generatedAnagrams.data;

                return ListView.builder(
                  itemCount: anagrams.length,
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      return new Divider(
                        color: Theme.of(context).textTheme.title.color,
                      );
                    }

                    return AnagramTile(
                      anagram: anagrams[index],
                    );
                  },
                );
              } else {
                return const Text(
                  "No anagrams were found 😢",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                );
              }
            } else if (generatedAnagrams.hasError) {
              return Text(
                "${generatedAnagrams.error}",
                textAlign: TextAlign.center,
              );
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
        alignment: FractionalOffset.center,
      ),
    );
  }
}
