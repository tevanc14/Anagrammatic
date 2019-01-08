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
  List<Anagram> _showAnagrams = List();
  int _maxDisplayCount = 1000;

  String _resultCountLabel() {
    if (_anagrams.length == 1) {
      return '${_anagrams.length} result';
    } else if (_anagrams.length > _maxDisplayCount) {
      return '${_anagrams.length} results, ${_showAnagrams.length} shown';
    } else {
      return '${_anagrams.length} results';
    }
  }

  _filterAnagrams(
    Options options,
  ) {
    _restrictAnagramsByLength(
      options.anagramLengthLowerBound,
      options.anagramLengthUpperBound,
    );

    _sortAnagrams(
      options.sortType.comparator,
    );

    _truncateResults();
  }

  _restrictAnagramsByLength(
    int lowerBound,
    int upperBound,
  ) {
    _anagrams = _anagrams.where((anagram) {
      return anagram.word.length >= lowerBound &&
          anagram.word.length <= upperBound;
    }).toList();
  }

  _sortAnagrams(
    Comparator<Anagram> comparator,
  ) {
    _anagrams..sort(comparator);
  }

  List<Widget> _buildAnagramTiles(
    BuildContext context,
    String characters,
  ) {
    Iterable<Widget> listTiles = _showAnagrams.map<Widget>(
      (Anagram anagram) => AnagramTile(
            anagram: anagram,
            characters: characters,
          ),
    );

    return ListTile.divideTiles(
      context: context,
      tiles: listTiles,
    ).toList();
  }

  _truncateResults() {
    _showAnagrams = _anagrams.take(_maxDisplayCount).toList();
  }

  Text _noResultsText() {
    return Text(
      'No anagrams were found with the current settings\n\n😢',
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

                _filterAnagrams(
                  options,
                );

                if (_showAnagrams.length <= 0) {
                  return _noResultsText();
                } else {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        child: Text(
                          _resultCountLabel(),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: _buildAnagramTiles(
                            context,
                            widget.characters,
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
