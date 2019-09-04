import 'dart:io';

import 'package:native_i18n_flutter_plugin/runner/generators/i18n_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/helpers/language_file.dart';
import 'package:watcher/watcher.dart';

/// Generate Dart class with the
class LanguageStringClassGenerator extends I18nGenerator {
  final Directory _inputDirectory;
  final String _defaultLocale;
  final Directory _outputDirectory;

  LanguageStringClassGenerator(this._inputDirectory, this._outputDirectory, this._defaultLocale);

  @override
  void generate(bool watch) {
    _generateClassFile();

    if (watch) {
      FileWatcher(_getDefaultLanguageFile.file.absolute.path) //
          .events
          .listen((event) {
        if (event.type == ChangeType.MODIFY) _generateClassFile();
      });
    }
  }

  void _generateClassFile() {
    List<_LanguageStringGetter> strings = [];

    out("Generating class file...");

    _getDefaultLanguageFile.languageStrings
        .forEach((languageString) => strings.add(_LanguageStringGetter(languageString.key, languageString.value)));

    final classTemplate = """
      /// DO NOT MODIFY, MANUALLY CHANGES WILL BE OVERWRITTEN
      import 'package:native_i18n_flutter_plugin/translation.dart';
  
      /// Internationalized strings keys
      class I18n {
        static final _TranslationKeys keys = _TranslationKeys();
      
        ${strings.map((f) => f.toString()).join("\n")}
      }
      
      class _TranslationKeys {
        ${strings.map((f) => f.translationKey).join("\n")}
      }
    """;

    File("${_outputDirectory.path}/i18n.dart") //
        .writeAsString(classTemplate)
        .then((file) => Process.run('dartfmt', [file.absolute.path]) //
            .then((result) => result.exitCode == 0
                ? file.writeAsString(result.stdout).then((_) => out("Class file generated."))
                : print(result.stderr)));
  }

  LanguageFile get _getDefaultLanguageFile =>
      LanguageFile(_defaultLocale, File("${_inputDirectory.path}/strings_$_defaultLocale.json"));
}

/// Language String IDE Getter
class _LanguageStringGetter {
  final String _key;
  final String _value;
  final RegExp _formatRegexp = RegExp(r"%(u|o|x|X|f|lf|e|E|c|s|d)");

  _LanguageStringGetter(this._key, this._value);

  @override
  String toString() => _valueContainsFormatString
      ? "static Translation $_keyToCamelCase($_argumentList) => Translation('$_key', translationArguments: [$_argumentList]);"
      : "static Translation get $_keyToCamelCase => Translation('$_key');";

  String get _keyToCamelCase {
    var keyParts = _key.split("_");

    return keyParts[0] + keyParts.sublist(1).map((item) => item[0].toUpperCase() + item.substring(1)).join();
  }

  String get translationKey => "String get $_keyToCamelCase => '$_key';";

  bool get _valueContainsFormatString => _formatRegexp.hasMatch(_value);

  int get _arguments => _formatRegexp.allMatches(_value).length;

  String get _argumentList => List.generate(_arguments, (i) => "arg$i").join(", ");
}
