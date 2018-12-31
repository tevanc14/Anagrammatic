import 'package:path/path.dart' as path;

class WordList {
  final String displayName;
  String fileName;

  WordList({
    this.displayName,
    this.fileName,
  }) {
    fileName = path.join('assets', 'scowl_word_lists', this.fileName);
  }

  static final WordList _small = WordList(
    displayName: 'Simple',
    fileName: '35.txt',
  );

  static final WordList _default = WordList(
    displayName: 'Normal',
    fileName: '60.txt',
  );

  static final WordList _insane = WordList(
    displayName: 'Insane',
    fileName: '95.txt',
  );

  static List<WordList> _allWordLists = <WordList>[
    _small,
    _default,
    _insane,
  ];

  static List<WordList> getAllWordLists() {
    return _allWordLists;
  }

  static WordList getDefault() {
    return _default;
  }
}
