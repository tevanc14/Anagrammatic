import 'package:anagrammatic/anagrammatic_app.dart';
import 'package:anagrammatic/service/anagram_generator.dart';
import 'package:anagrammatic/visualization/anagram_card.dart';
import 'package:flutter/material.dart';

class AnagramList extends StatefulWidget {
  final String characters;
  final int length;

  AnagramList({@required this.characters, @required this.length});

  @override
  State createState() {
    return AnagramListState();
  }
}

class AnagramListState extends State<AnagramList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AnagrammaticApp.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<Anagram>>(
          future: generateAnagrams(
            widget.characters,
          ),
          builder: (context, generatedAnagrams) {
            if (generatedAnagrams.hasData) {
              if (generatedAnagrams.data.length > 0) {
                return ListView.builder(
                    itemCount: generatedAnagrams.data.length,
                    itemBuilder: (context, index) {
                      if (index.isOdd)
                        return new Divider(
                          color: Theme.of(context).textTheme.title.color,
                        );

                      return AnagramCard(
                        anagram: generatedAnagrams.data[index],
                      );
                    });
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
