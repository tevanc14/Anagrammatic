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

  String _resultCountLabel(List<Anagram> anagrams) {
    if (anagrams.length == 1) {
      return '${anagrams.length} result';
    } else {
      return '${anagrams.length} results';
    }
  }

  List<Anagram> _filterAnagrams(
    List<Anagram> anagrams,
    Options options,
  ) {
    List<Anagram> lengthRestrictedAnagrams = _restrictAnagramsByLength(
      anagrams,
      options.anagramLengthLowerBound,
      options.anagramLengthUpperBound,
    );

    return _sortAnagrams(
      lengthRestrictedAnagrams,
      options.sortType.comparator,
    );
  }

  List<Anagram> _restrictAnagramsByLength(
    List<Anagram> anagrams,
    int lowerBound,
    int upperBound,
  ) {
    return anagrams.where((anagram) {
      return anagram.word.length >= lowerBound &&
          anagram.word.length <= upperBound;
    }).toList();
  }

  List<Anagram> _sortAnagrams(
    List<Anagram> anagrams,
    Comparator<Anagram> comparator,
  ) {
    return anagrams..sort(comparator);
  }

  List<Widget> _buildAnagramTiles(
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

  Text _noResultsText() {
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

                _anagrams = _filterAnagrams(
                  _anagrams,
                  options,
                );

                if (_anagrams.length <= 0) {
                  return _noResultsText();
                } else {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        child: Text(
                          _resultCountLabel(_anagrams),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: _buildAnagramTiles(
                            context,
                            _anagrams,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return _noResultsText();
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
