import 'dart:math';

import 'package:anagrammatic/anagram/anagram.dart';
import 'package:anagrammatic/anagram/anagram_generator.dart';
import 'package:anagrammatic/anagram/anagram_tile.dart';
import 'package:anagrammatic/util/dots_indicator.dart';
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
  List<Anagram> _unfilteredAnagrams = List();
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
            _unfilteredAnagrams = generatedAnagrams.data;
            _filteredAnagrams = _filterAnagrams(
              _unfilteredAnagrams,
              options,
            );

            if (_filteredAnagrams.length <= 0) {
              return _NoResultsText();
            } else {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: Text(
                      _resultCountLabel(
                        _unfilteredAnagrams,
                      ),
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Expanded(
                    child: _AnagramPages(
                      anagrams: _filteredAnagrams,
                      characters: widget.characters,
                    ),
                  ),
                ],
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
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    int numPages = (widget.anagrams.length / _numPerPage).ceil();
    List<List<Anagram>> pages = paginateAnagrams(
      widget.anagrams,
      _numPerPage,
      numPages,
    );

    return Stack(
      children: <Widget>[
        PageView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemCount: pages.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return _buildAnagramList(
              pages[index % pages.length],
            );
          },
        ),
        _buildDotsIndicator(
          pages,
        ),
      ],
    );
  }

  Positioned _buildDotsIndicator(List<List<Anagram>> pages) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        height: 35.0,
        color: Colors.grey[800].withOpacity(0.5),
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Center(
          child: DotsIndicator(
            controller: _controller,
            itemCount: pages.length,
            onPageSelected: (int page) {
              _controller.animateToPage(
                page,
                duration: _duration,
                curve: _curve,
              );
            },
          ),
        ),
      ),
    );
  }

  List<List<Anagram>> paginateAnagrams(
    List<Anagram> filteredAnagrams,
    int numPerPage,
    int numPages,
  ) {
    List<List<Anagram>> paginatedAnagrams = [];

    for (int index = 0; index < numPages; index++) {
      int lowerIndex = _numPerPage * index;
      int upperIndex = min(
        (_numPerPage * (index + 1)),
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
