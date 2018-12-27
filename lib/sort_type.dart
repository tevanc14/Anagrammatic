import 'package:anagrammatic/anagram.dart';

enum SortTypeName {
  alpha,
  alphaReverse,
  length,
  lengthReverse,
}

class SortType {
  static const String _alphaString = 'A-Z';
  static const String _alphaReverseString = 'Z-A';
  static const String _lengthString = 'Length (Ascending)';
  static const String _lengthReverseString = 'Length (Descending)';

  static Comparator<Anagram> _alphaComparator =
      (a, b) => a.word.compareTo(b.word);
  static Comparator<Anagram> _alphaReverseComparator =
      (a, b) => b.word.compareTo(a.word);
  static Comparator<Anagram> _lengthComparator =
      (a, b) => a.word.length.compareTo(b.word.length);
  static Comparator<Anagram> _lengthReverseComparator =
      (a, b) => b.word.length.compareTo(a.word.length);

  static final Map<String, Comparator<Anagram>> _sortTypes = {
    _alphaString: (a, b) =>
        combineComparators(_alphaComparator, _lengthComparator, a, b),
    _alphaReverseString: (a, b) =>
        combineComparators(_alphaReverseComparator, _lengthComparator, a, b),
    _lengthString: (a, b) =>
        combineComparators(_lengthComparator, _alphaComparator, a, b),
    _lengthReverseString: (a, b) =>
        combineComparators(_lengthReverseComparator, _alphaComparator, a, b),
  };

  static int combineComparators(
    Comparator<Anagram> c1,
    Comparator<Anagram> c2,
    Anagram a1,
    Anagram a2,
  ) {
    int result = c1(a1, a2);
    if (result != 0) return result;
    return c2(a1, a2);
  }

  static List<String> sortTypeStrings() {
    return _sortTypes.keys.toList();
  }

  static Comparator<Anagram> getSortComparatorFromString(String sortType) {
    return getSortComparator(
      getSortTypeEnum(sortType),
    );
  }

  static SortTypeName getSortTypeEnum(String sortType) {
    switch (sortType) {
      case _alphaString:
        return SortTypeName.alpha;
      case _alphaReverseString:
        return SortTypeName.alphaReverse;
      case _lengthString:
        return SortTypeName.length;
      case _lengthReverseString:
        return SortTypeName.lengthReverse;
      default:
        return SortTypeName.alpha;
    }
  }

  static String getSortName(SortTypeName sortTypeName) {
    switch (sortTypeName) {
      case SortTypeName.alpha:
        return _alphaString;
      case SortTypeName.alphaReverse:
        return _alphaReverseString;
      case SortTypeName.length:
        return _lengthString;
      case SortTypeName.lengthReverse:
        return _lengthReverseString;
      default:
        return _alphaString;
    }
  }

  static Comparator<Anagram> getSortComparator(SortTypeName sortTypeName) {
    switch (sortTypeName) {
      case SortTypeName.alpha:
        return _sortTypes[_alphaString];
      case SortTypeName.alphaReverse:
        return _sortTypes[_alphaReverseString];
      case SortTypeName.length:
        return _sortTypes[_lengthString];
      case SortTypeName.lengthReverse:
        return _sortTypes[_lengthReverseString];
      default:
        return _sortTypes[_alphaString];
    }
  }
}
