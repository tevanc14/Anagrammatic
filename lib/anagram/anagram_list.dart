import 'dart:math';

import 'package:anagrammatic/anagram/anagram.dart';
import 'package:anagrammatic/anagram/anagram_generator.dart';
import 'package:anagrammatic/anagram/anagram_tile.dart';
import 'package:anagrammatic/view/app.dart';
import 'package:anagrammatic/view/options.dart';
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
            _filteredAnagrams = _filterAnagrams(
              generatedAnagrams.data,
              options,
            );

            if (_filteredAnagrams.length <= 0) {
              return _NoResultsText();
            } else {
              return _AnagramPages(
                anagrams: _filteredAnagrams,
                characters: widget.characters,
              );
            }
          } else {
            return _NoResultsText();
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

  List<Anagram> _filterAnagrams(
    List<Anagram> anagrams,
    Options options,
  ) {
    List<Anagram> lengthRestrictedAnagrams = _restrictAnagramsByLength(
      anagrams,
      options.anagramLengthLowerBound,
      options.anagramLengthUpperBound,
    );

    List<Anagram> sortedAnagrams = _sortAnagrams(
      lengthRestrictedAnagrams,
      options.sortType.comparator,
    );

    return sortedAnagrams;
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
}

class _AnagramPages extends StatefulWidget {
  final List<Anagram> anagrams;
  final String characters;

  _AnagramPages({
    @required this.anagrams,
    @required this.characters,
  });

  @override
  _AnagramPagesState createState() => _AnagramPagesState();
}

class _AnagramPagesState extends State<_AnagramPages> {
  final int _numPerPage = 20;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    int numPages = (widget.anagrams.length / _numPerPage).ceil();
    List<List<Anagram>> pages = paginateAnagrams(
      widget.anagrams,
      numPages,
    );

    return PageView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: pages.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Text(
                _resultCountLabel(
                  widget.anagrams,
                  index,
                ),
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Expanded(
              child: _buildAnagramList(
                pages[index % pages.length],
              ),
            ),
          ],
        );
      },
    );
  }

  List<List<Anagram>> paginateAnagrams(
    List<Anagram> filteredAnagrams,
    int numPages,
  ) {
    List<List<Anagram>> paginatedAnagrams = [];

    for (int index = 0; index < numPages; index++) {
      int lowerIndex = _lowerIndexOfPage(index);
      int upperIndex = _upperIndexOfPage(
        index,
        filteredAnagrams.length,
      );

      paginatedAnagrams.add(
        filteredAnagrams.sublist(
          lowerIndex,
          upperIndex,
        ),
      );
    }

    return paginatedAnagrams;
  }

  Widget _buildAnagramList(List<Anagram> anagrams) {
    return ListView(
      children: _buildAnagramTiles(
        context,
        widget.characters,
        anagrams,
      ),
    );
  }

  List<Widget> _buildAnagramTiles(
    BuildContext context,
    String characters,
    List<Anagram> anagrams,
  ) {
    Iterable<Widget> listTiles = anagrams.map<Widget>(
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

  String _resultCountLabel(
    List<Anagram> anagrams,
    int pageIndex,
  ) {
    if (anagrams.length == 1) {
      return '${anagrams.length} result';
    } else if (anagrams.length <= _numPerPage) {
      return '${anagrams.length} results';
    } else {
      int lowerIndex = _lowerIndexOfPage(pageIndex);
      int upperIndex = _upperIndexOfPage(
        pageIndex,
        anagrams.length,
      );

      return '${lowerIndex + 1} - $upperIndex of ${anagrams.length} results';
    }
  }

  int _lowerIndexOfPage(int pageIndex) {
    return pageIndex * _numPerPage;
  }

  int _upperIndexOfPage(
    int pageIndex,
    int numOfAnagrams,
  ) {
    return min(
      (_numPerPage * (pageIndex + 1)),
      numOfAnagrams,
    );
  }
}

class _NoResultsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
