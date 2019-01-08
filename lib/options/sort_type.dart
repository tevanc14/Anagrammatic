import 'package:anagrammatic/anagram/anagram.dart';

class SortType {
  final String displayName;
  final Comparator<Anagram> comparator;

  const SortType({
    this.displayName,
    this.comparator,
  });

  static Comparator<Anagram> _alphaComparator =
      (a, b) => a.word.compareTo(b.word);
  static Comparator<Anagram> _alphaReverseComparator =
      (a, b) => b.word.compareTo(a.word);
  static Comparator<Anagram> _lengthComparator =
      (a, b) => a.word.length.compareTo(b.word.length);
  static Comparator<Anagram> _lengthReverseComparator =
      (a, b) => b.word.length.compareTo(a.word.length);

  static final SortType _alpha = SortType(
    displayName: 'A-Z',
    comparator: combineComparators(
      _alphaComparator,
      _lengthComparator,
    ),
  );

  static final SortType _alphaReverse = SortType(
    displayName: 'Z-A',
    comparator: combineComparators(
      _alphaReverseComparator,
      _lengthComparator,
    ),
  );

  static final SortType _length = SortType(
    displayName: 'Length (Small -> Big)',
    comparator: combineComparators(
      _lengthComparator,
      _alphaComparator,
    ),
  );

  static final SortType _lengthReverse = SortType(
    displayName: 'Length (Big -> Small)',
    comparator: combineComparators(
      _lengthReverseComparator,
      _alphaComparator,
    ),
  );

  static List<SortType> _allSortTypes = <SortType>[
    _lengthReverse,
    _length,
    _alpha,
    _alphaReverse,
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
    return _lengthReverse;
  }
}
