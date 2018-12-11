import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;

class Anagram {
  final String word;

  Anagram({this.word});
}

Future<List<Anagram>> generateAnagrams(String characters) async {
  String data = await loadWords();
  List<String> words = data.split('\n');
  List<List<Anagram>> anagramLists = List();

  for (int i = 1; i <= characters.length; i++) {
    anagramLists.add(await generateAnagramsOfLength(words, characters, i));
  }

  List<Anagram> anagramList = anagramLists.expand((x) => x).toList();
  anagramList.sort((a, b) => a.word.compareTo(b.word));

  return anagramList;
}

Future<List<Anagram>> generateAnagramsOfLength(
  List<String> words, String characters, int length) async {
  String uppercaseCharacters = characters.toUpperCase();
  List<Anagram> anagramList = List();
  for (String word in words) {
    if (containsCharacters(word, uppercaseCharacters, length)) {
      Anagram anagram = Anagram(word: word);
      anagramList.add(anagram);
    }
  }

  return anagramList;
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

Future<String> loadWords() async {
  final String wordsFilename = 'assets/words.txt';
  return await rootBundle.loadString(wordsFilename);
}
