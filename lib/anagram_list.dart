import 'package:anagrammatic/app.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   AnagrammaticApp.of(context).options.addListener(() {

  //   })
  // }

  @override
  Widget build(BuildContext context) {
    var options = AnagrammaticApp.of(context).options;
    return Scaffold(
      key: key,
      body: Container(
        child: FutureBuilder<List<Anagram>>(
          future: generateAnagrams(widget.characters),
          builder: (context, generatedAnagrams) {
            if (generatedAnagrams.hasData) {
              if (generatedAnagrams.data.length > 0) {
                _anagrams = generatedAnagrams.data;

                return ListView.builder(
                  itemCount: _anagrams.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Text(
                        options.anagramSizeLowerBound.toString(),
                        style: TextStyle(fontSize: 30.0),
                      );
                    }

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
