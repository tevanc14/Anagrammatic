import 'package:anagrammatic/anagram/anagram_length_bounds.dart';
import 'package:anagrammatic/options/options.dart';
import 'package:anagrammatic/options/sort_type.dart';
import 'package:anagrammatic/options/text_scaling.dart';
import 'package:anagrammatic/options/themes.dart';
import 'package:anagrammatic/options/word_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionsLoader {
  final _defaultOptions = Options(
    isOpen: false,
    theme: darkTheme,
    anagramLengthLowerBound: AnagramLengthBounds.minimumAnagramLength,
    anagramLengthUpperBound: AnagramLengthBounds.maximumAnagramLength,
    sortType: SortType.getDefault(),
    textScaleFactor: TextScaleFactor.getDefault(),
    wordList: WordList.getDefault(),
  );
  final String themeParameterName = 'isDarkTheme';
  final String textScaleParameterName = 'textScaleFactor';
  final String wordListParameterName = 'wordList';

  Future<Options> readOptions() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      bool isDarkTheme = preferences.getBool(themeParameterName);
      int textScaleFactorId = preferences.getInt(textScaleParameterName);
      int wordListId = preferences.getInt(wordListParameterName);

      return getDefaultOptions().copyWith(
        theme: isDarkTheme ? darkTheme : lightTheme,
        textScaleFactor: TextScaleFactor.getByIdentifier(textScaleFactorId),
        wordList: WordList.getByIdentifier(wordListId),
      );
    } catch (e) {
      return getDefaultOptions();
    }
  }

  Future writeOptions(Options options) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool isDarkTheme = options.theme == darkTheme;
    int textScaleFactorId = options.textScaleFactor.identifier;
    int wordListId = options.wordList.identifier;

    preferences.setBool(themeParameterName, isDarkTheme);
    preferences.setInt(textScaleParameterName, textScaleFactorId);
    preferences.setInt(wordListParameterName, wordListId);
  }

  Options getDefaultOptions() {
    return _defaultOptions;
  }
}
