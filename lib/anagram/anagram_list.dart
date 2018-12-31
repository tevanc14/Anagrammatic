import 'package:flutter/material.dart';
import 'package:anagrammatic/anagram/anagram.dart';
import 'package:anagrammatic/anagram/anagram_generator.dart';
import 'package:anagrammatic/anagram/anagram_tile.dart';
import 'package:anagrammatic/app_flow/app.dart';
import 'package:anagrammatic/options/options.dart';

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
    Options options,
  ) {
    List<Anagram> lengthRestrictedAnagrams = restrictAnagramsByLength(
      anagrams,
      options.anagramLengthLowerBound,
      options.anagramLengthUpperBound,
    );

    return sortAnagrams(
      lengthRestrictedAnagrams,
      options.sortType.comparator,
    );
  }

  List<Anagram> restrictAnagramsByLength(
    List<Anagram> anagrams,
    int lowerBound,
    int upperBound,
  ) {
    return anagrams.where((anagram) {
      return anagram.word.length >= lowerBound &&
          anagram.word.length <= upperBound;
    }).toList();
  }

  List<Anagram> sortAnagrams(
    List<Anagram> anagrams,
    Comparator<Anagram> comparator,
  ) {
    return anagrams..sort(comparator);
  }

  List<Widget> buildListTiles(
    BuildContext context,
    List<Anagram> anagrams,
  ) {
    Iterable<Widget> listTiles = _anagrams.map<Widget>(
      (Anagram anagram) => AnagramTile(
            anagram: anagram,
          ),
    );

    return ListTile.divideTiles(
      context: context,
      tiles: listTiles,
    ).toList();
  }

  Text noResultsText() {
    return Text(
      'No anagrams were found 😢\nPossibly try upping the complexity in the options menu',
      style: Theme.of(context).textTheme.title,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    Options options = AnagrammaticApp.of(context).options;
    return Scaffold(
      key: key,
      body: Container(
        child: FutureBuilder<List<Anagram>>(
          future: generateAnagrams(
            widget.characters,
            options.wordList,
          ),
          builder: (context, generatedAnagrams) {
            if (generatedAnagrams.hasData) {
              if (generatedAnagrams.data.length > 0) {
                _anagrams = generatedAnagrams.data;

                _anagrams = filterAnagrams(
                  _anagrams,
                  options,
                );

                if (_anagrams.length <= 0) {
                  return noResultsText();
                } else {
                  return ListView(
                    children: buildListTiles(
                      context,
                      _anagrams,
                    ),
                  );
                }
              } else {
                return noResultsText();
              }
            } else if (generatedAnagrams.hasError) {
              return Text(
                '${generatedAnagrams.error}',
                textAlign: TextAlign.center,
              );
            } else {
              // By default, show a loading spinner
              return CircularProgressIndicator();
            }
          },
        ),
        alignment: FractionalOffset.center,
      ),
    );
  }
}
