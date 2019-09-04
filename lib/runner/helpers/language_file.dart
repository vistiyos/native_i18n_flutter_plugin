import 'dart:convert';
import 'dart:io';

import 'package:native_i18n_flutter_plugin/runner/helpers/language_string.dart';

/// Holds information about language file
class LanguageFile {
  final String locale;
  final FileSystemEntity file;

  LanguageFile(this.locale, this.file);

  List<LanguageString> get languageStrings {
    List<LanguageString> strings = [];

    Map<String, dynamic> languageStringJson = jsonDecode(File(file.path).readAsStringSync());

    languageStringJson.forEach((key, value) => strings.addAll(_nestedKeys(key, value)));

    return strings;

  }

  List<LanguageString> _nestedKeys(String key, dynamic value) {
    var languageGetters = <LanguageString>[];
    if (value is String) {
      languageGetters.add(LanguageString(key, value));
    } else {
      (value as Map)
          .forEach((innerKey, innerValue) => languageGetters.addAll(_nestedKeys("${key}_$innerKey", innerValue)));
    }

    return languageGetters;
  }
}
