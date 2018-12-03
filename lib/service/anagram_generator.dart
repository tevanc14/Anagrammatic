import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;

class Anagram {
  final String word;

  Anagram({this.word});
}

bool containsCharacters(String word, String characters, int length) {
  if (word.length != length) {
    return false;
  } else {
    for (String character in word.split('')) {
      if (!characters.contains(character)) {
        return false;
      }
      characters = characters.replaceFirst(character, '');
    }
    return true;
  }
}

Future<List<Anagram>> generateAnagrams(String characters, int length) async {
  String data = await loadWords();
  List<String> words = data.split('\n');

  String uppercaseCharacters = characters.toUpperCase();
  List<Anagram> anagramList = List();
  for (String word in words) {
    if (containsCharacters(word, uppercaseCharacters, length)) {
      Anagram anagram = Anagram(word: word);
      anagramList.add(anagram);
    }
  }

  anagramList.sort((a, b) => a.word.compareTo(b.word));

  return anagramList;
}

Future<String> loadWords() async {
  final String wordsFilename = 'assets/words.txt';
  return await rootBundle.loadString(wordsFilename);
}
