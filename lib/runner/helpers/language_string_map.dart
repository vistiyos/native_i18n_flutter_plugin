import 'package:native_i18n_flutter_plugin/runner/helpers/language_string.dart';

/// Holds the information about language strings
class LanguageStringMap {
  Map<String, List<LanguageString>> _languageStrings = {};

  void addLanguageStrings(String locale, List<LanguageString> languageStrings) =>
      _languageStrings[locale] = languageStrings;

  List<LanguageString> getLanguageStrings(String locale) =>
      _languageStrings.containsKey(locale) ? _languageStrings[locale] : [];
}
