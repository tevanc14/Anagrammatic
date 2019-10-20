import 'package:anagrammatic/anagram/anagram_length_bounds.dart';
import 'package:anagrammatic/view/options.dart';
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
  final String themeParameterName = 'theme';
  final String textScaleParameterName = 'textScaleFactor';
  final String wordListParameterName = 'wordList';

  Future<Options> readOptions() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      int themeId = preferences.getInt(themeParameterName);
      int textScaleFactorId = preferences.getInt(textScaleParameterName);
      int wordListId = preferences.getInt(wordListParameterName);

      return getDefaultOptions().copyWith(
        theme: AnagrammaticTheme.getByIdentifier(themeId),
        textScaleFactor: TextScaleFactor.getByIdentifier(textScaleFactorId),
        wordList: WordList.getByIdentifier(wordListId),
      );
    } catch (e) {
      return getDefaultOptions();
    }
  }

  Future writeOptions(Options options) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int themeId = options.theme.identifier;
    int textScaleFactorId = options.textScaleFactor.identifier;
    int wordListId = options.wordList.identifier;

    await preferences.setInt(themeParameterName, themeId);
    await preferences.setInt(textScaleParameterName, textScaleFactorId);
    await preferences.setInt(wordListParameterName, wordListId);
  }

  Options getDefaultOptions() {
    return _defaultOptions;
  }
}
