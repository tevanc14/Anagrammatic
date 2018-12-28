import 'package:anagrammatic/anagram.dart';

class SortType {
  const SortType({
    this.displayName,
    this.comparator,
  });

  final String displayName;
  final Comparator<Anagram> comparator;

  static Comparator<Anagram> _alphaComparator =
      (a, b) => a.word.compareTo(b.word);
  static Comparator<Anagram> _alphaReverseComparator =
      (a, b) => b.word.compareTo(a.word);
  static Comparator<Anagram> _lengthComparator =
      (a, b) => a.word.length.compareTo(b.word.length);
  static Comparator<Anagram> _lengthReverseComparator =
      (a, b) => b.word.length.compareTo(a.word.length);

  static List<SortType> _allSortTypes = <SortType>[
    SortType(
      displayName: 'A-Z',
      comparator: combineComparators(
        _alphaComparator,
        _lengthComparator,
      ),
    ),
    SortType(
      displayName: 'Z-A',
      comparator: combineComparators(
        _alphaReverseComparator,
        _lengthComparator,
      ),
    ),
    SortType(
      displayName: 'Length (Ascending)',
      comparator: combineComparators(
        _lengthComparator,
        _alphaComparator,
      ),
    ),
    SortType(
      displayName: 'Length (Descending)',
      comparator: combineComparators(
        _lengthReverseComparator,
        _alphaComparator,
      ),
    ),
  ];

  static Comparator<Anagram> combineComparators(
    Comparator<Anagram> c1,
    Comparator<Anagram> c2,
  ) {
    return (Anagram a1, Anagram a2) {
      int result = c1(a1, a2);
      if (result != 0) return result;
      return c2(a1, a2);
    };
  }

  static List<SortType> getAllSortTypes() {
    return _allSortTypes;
  }

  static SortType getDefault() {
    return _allSortTypes[0];
  }
}
