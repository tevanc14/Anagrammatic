import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Anagram>> generateAnagrams(String characters, int length) async {
  String apiUrl =
      'https://us-central1-stringpermutations.cloudfunctions.net/PermutationsInDictionary';

  http.Response response = await http.post(apiUrl,
      headers: {'Content-type': 'application/json'},
      body: json.encode({'characters': characters, 'length': length}));

  if (response.statusCode == 200) {
    List<dynamic> responseAnagrams = json.decode(response.body)['anagrams'];
    return createAnagramList(responseAnagrams);
  } else {
    throw Exception('Failed to retrieve anagrams, please try again');
  }
}

class Anagram {
  final String word;

  Anagram({this.word});
}

List<Anagram> createAnagramList(List data) {
  List<Anagram> list = new List();
  for (int i = 0; i < data.length; i++) {
    String word = data[i];
    Anagram anagram = new Anagram(word: word);
    list.add(anagram);
  }
  return list;
}
