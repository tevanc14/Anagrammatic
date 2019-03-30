import 'package:anagrammatic/anagram/anagram.dart';
import 'package:anagrammatic/anagram/anagram_generator.dart';
import 'package:anagrammatic/anagram/anagram_tile.dart';
import 'package:anagrammatic/app_flow/app.dart';
import 'package:anagrammatic/options/options.dart';
import 'package:flutter/material.dart';

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
  final int _maxDisplayCount = 1000;
  List<Anagram> _anagrams = List();
  List<Anagram> _filteredAnagrams = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _anagramListBuilder(),
        alignment: FractionalOffset.center,
      ),
    );
  }

  Widget _anagramListBuilder() {
    Options options = AnagrammaticApp.of(context).options;

    return FutureBuilder<List<Anagram>>(
      future: generateAnagrams(
        widget.characters,
        options.wordList,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot generatedAnagrams,
      ) {
        if (generatedAnagrams.hasData) {
          if (generatedAnagrams.data.length > 0) {
            _anagrams = generatedAnagrams.data;

            _filterAnagrams(
              options,
            );

            if (_filteredAnagrams.length <= 0) {
              return _noResultsText();
            } else {
              return _buildAnagramList();
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
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  Widget _buildAnagramList() {
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

  String _resultCountLabel() {
    if (_anagrams.length == 1) {
      return '${_anagrams.length} result';
    } else if (_anagrams.length > _maxDisplayCount) {
      return '${_anagrams.length} results, ${_filteredAnagrams.length} shown';
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

  _truncateResults() {
    _filteredAnagrams = _anagrams.take(_maxDisplayCount).toList();
  }

  List<Widget> _buildAnagramTiles(
    BuildContext context,
    String characters,
  ) {
    Iterable<Widget> listTiles = _filteredAnagrams.map<Widget>(
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

  Widget _noResultsText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 64.0,
      ),
      child: Text(
        'No anagrams were found with the current settings\n\n😢',
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
