import 'dart:async' show Future;

import 'package:anagrammatic/anagram.dart';
import 'package:anagrammatic/word_list.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Anagram>> generateAnagrams(
  String characters,
  WordList wordList,
) async {
  List<String> words = await loadWords(wordList.fileName);
  List<List<Anagram>> anagramLists = List();

  for (int i = 1; i <= characters.length; i++) {
    anagramLists.add(await generateAnagramsOfLength(words, characters, i));
  }

  List<Anagram> anagramList = anagramLists.expand((x) => x).toList();
  return anagramList..sort((a, b) => a.word.compareTo(b.word));
}

Future<List<Anagram>> generateAnagramsOfLength(
  List<String> words,
  String characters,
  int length,
) async {
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

bool containsCharacters(
  String word,
  String characters,
  int length,
) {
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

Future<List<String>> loadWords(String fileName) async {
  final String wordsFilename = fileName;
  String wordsString = await rootBundle.loadString(wordsFilename);
  return wordsString.split('\n');
}
