import 'dart:math';

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

  final _controller = PageController();
  final int _numPerPage = 20;
  static const _duration = const Duration(milliseconds: 300);
  static const _curve = Curves.ease;

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
              int numPages = (_filteredAnagrams.length / _numPerPage).ceil();
              List<List<Anagram>> pages = paginateAnagrams(
                _filteredAnagrams,
                _numPerPage,
                numPages,
              );
              return Stack(
                children: <Widget>[
                  PageView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: pages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildAnagramList(pages[index % pages.length]);
                    },
                  ),
                  Positioned(
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
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  Widget _buildAnagramList(List<Anagram> anagrams) {
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
              anagrams,
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
        _filteredAnagrams.length,
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
}

// Thanks to Collin Jackson https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _dotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _maxZoom = 2.0;

  // The distance between the center of each dot
  static const double _dotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_maxZoom - 1.0) * selectedness;
    return Container(
      width: _dotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            width: _dotSize * zoom,
            height: _dotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List<Widget>.generate(
        itemCount,
        _buildDot,
      ),
    );
  }
}
