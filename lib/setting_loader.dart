import 'package:anagrammatic/anagram_length_bounds.dart';
import 'package:anagrammatic/options.dart';
import 'package:anagrammatic/sort_type.dart';
import 'package:anagrammatic/text_scaling.dart';
import 'package:anagrammatic/themes.dart';
import 'package:anagrammatic/word_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingLoader {
  final _defaultOptions = Options(
    theme: darkTheme,
    anagramLengthLowerBound: AnagramLengthBounds.minimumAnagramLength,
    anagramLengthUpperBound: AnagramLengthBounds.maximumAnagramLength,
    sortType: SortType.getDefault(),
    textScaleFactor: TextScaleFactor.getDefault(),
    wordList: WordList.getDefault(),
  );
  final String themeParameterName = 'isDarkTheme';
  final String textScaleParameterName = 'textScaleFactor';

  Future<Options> readOptions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool isDarkTheme = prefs.getBool(themeParameterName);
      int textScaleFactorId = prefs.getInt(textScaleParameterName);

      return getDefaultOptions().copyWith(
        theme: isDarkTheme ? darkTheme : lightTheme,
        textScaleFactor: TextScaleFactor.getByIdentifier(textScaleFactorId),
      );
    } catch (e) {
      return getDefaultOptions();
    }
  }

  Future writeOptions(Options options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isDarkTheme = options.theme == darkTheme;
    int textScaleFactorId = options.textScaleFactor.identifier;

    prefs.setBool(themeParameterName, isDarkTheme);
    prefs.setInt(textScaleParameterName, textScaleFactorId);
  }

  Options getDefaultOptions() {
    return _defaultOptions;
  }
}
