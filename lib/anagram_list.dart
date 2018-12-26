import 'package:anagrammatic/app.dart';
import 'package:anagrammatic/app_bar.dart';
import 'package:anagrammatic/constants.dart';
import 'package:anagrammatic/options.dart';
import 'package:flutter/material.dart';
import 'package:anagrammatic/anagram.dart';
import 'package:anagrammatic/anagram_generator.dart';
import 'package:anagrammatic/anagram_tile.dart';

class AnagramList extends StatefulWidget {
  final String characters;

  AnagramList({
    @required this.characters,
  });

  @override
  State createState() {
    return AnagramListState();
  }
}

class AnagramListState extends State<AnagramList> {
  final key = GlobalKey<AnagramListState>();
  List<Anagram> _anagrams = List();

  String resultCountLabel(List<Anagram> anagrams) {
    if (anagrams.length == 1) {
      return '${anagrams.length} result';
    } else {
      return '${anagrams.length} results';
    }
  }

  List<Anagram> filterAnagrams(
    List<Anagram> anagrams,
    int lowerBound,
    int upperBound,
  ) {
    return anagrams.where((anagram) {
      return anagram.word.length >= lowerBound &&
          anagram.word.length <= upperBound;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var options = AnagrammaticApp.of(context).options;
    return Scaffold(
      key: key,
      appBar: AnagrammaticAppBar(
        hasSettings: true,
      ),
      body: Container(
        child: FutureBuilder<List<Anagram>>(
          future: generateAnagrams(widget.characters),
          builder: (context, generatedAnagrams) {
            if (generatedAnagrams.hasData) {
              if (generatedAnagrams.data.length > 0) {
                _anagrams = generatedAnagrams.data;

                _anagrams = filterAnagrams(
                  _anagrams,
                  options.anagramSizeLowerBound,
                  options.anagramSizeUpperBound,
                );

                return ListView.builder(
                  itemCount: _anagrams.length,
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      return Divider(
                        color: Theme.of(context).textTheme.title.color,
                      );
                    }

                    return AnagramTile(
                      anagram: _anagrams[index],
                    );
                  },
                );
              } else {
                return const Text(
                  "No anagrams were found 😢",
                  style: TextStyle(
                    fontSize: 24.0,
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
