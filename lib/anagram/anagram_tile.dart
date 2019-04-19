import 'package:flutter/material.dart';

import 'package:anagrammatic/anagram/anagram.dart';
import 'package:anagrammatic/view/backdrop.dart';
import 'package:anagrammatic/anagram/anagram_details.dart';

class AnagramTile extends StatefulWidget {
  final Anagram anagram;
  final String characters;

  AnagramTile({
    @required this.anagram,
    @required this.characters,
  });

  @override
  State createState() {
    return AnagramTileState();
  }
}

class AnagramTileState extends State<AnagramTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(
          widget.anagram.word,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext builderContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
                borderRadius: BorderRadius.circular(
                  frontHeadingHeight,
                ),
              ),
              child: AnagramDetails(
                anagram: widget.anagram,
                characters: widget.characters,
              ),
            );
          },
        );
      },
    );
  }
}
