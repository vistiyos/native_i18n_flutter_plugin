import 'dart:convert';
import 'dart:io';

import 'package:native_i18n_flutter_plugin/runner/generators/i18n_generator.dart';

/// Generate Dart class with the
class LanguageStringClassGenerator extends I18nGenerator {
  final Directory _inputDirectory;
  final String _defaultLocale;
  final Directory _outputDirectory;
  final List<_LanguageStringGetter> strings = [];

  LanguageStringClassGenerator(this._inputDirectory, this._outputDirectory, this._defaultLocale);

  @override
  void generate() {
    _getLanguageStrings().keys.forEach((key) => strings.add(_LanguageStringGetter(key)));

    final classTemplate = """
  /// DO NOT MODIFY, MANUALLY CHANGES WILL BE OVERWRITTEN
  
  /// Internationalized strings keys
  class I18n {
    ${strings.map((f) => f.toString()).join("\n")}
  }
  """;

    File("${_outputDirectory.path}/i18n.dart") //
        .writeAsString(classTemplate)
        .then((file) => Process.run('dartfmt', [file.absolute.path]) //
            .then((result) => file.writeAsString(result.stdout)));
  }

  Map<String, dynamic> _getLanguageStrings() =>
      jsonDecode(File("${_inputDirectory.path}/strings_$_defaultLocale.json").readAsStringSync());
}

class _LanguageStringGetter {
  final String key;

  _LanguageStringGetter(this.key);

  @override
  String toString() => "static String get ${_keyToCamelCase()} => '$key';";

  String _keyToCamelCase() {
    var keyParts = key.split("_");

    return keyParts[0] + keyParts.sublist(1).map((item) => item[0].toUpperCase() + item.substring(1)).join();
  }
}
