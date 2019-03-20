import 'package:path/path.dart' as path;

class WordList {
  final String displayName;
  String fileName;
  final int identifier;

  WordList({
    this.displayName,
    this.fileName,
    this.identifier,
  }) {
    fileName = path.join(
      'assets',
      'scowl_word_lists',
      this.fileName,
    );
  }

  bool operator ==(other) {
    return (identifier == other.identifier);
  }

  int get hashCode {
    return identifier;
  }

  static final WordList _small = WordList(
    displayName: 'Simple',
    fileName: '35.txt',
    identifier: 0,
  );

  static final WordList _default = WordList(
    displayName: 'Normal',
    fileName: '60.txt',
    identifier: 1,
  );

  static final WordList _insane = WordList(
    displayName: 'Insane',
    fileName: '95.txt',
    identifier: 2,
  );

  static final List<WordList> _allWordLists = <WordList>[
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

  static WordList getByIdentifier(int id) {
    return getAllWordLists()
        .firstWhere((WordList wordList) => wordList.identifier == id);
  }
}
