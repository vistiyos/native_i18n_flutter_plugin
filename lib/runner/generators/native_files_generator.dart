import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:native_i18n_flutter_plugin/runner/generators/i18n_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/helpers/language_file.dart';
import 'package:native_i18n_flutter_plugin/runner/helpers/language_string.dart';
import 'package:native_i18n_flutter_plugin/runner/helpers/language_string_map.dart';
import 'package:xml/xml.dart' as xml;

/// Native language files generator
class NativeFilesGenerator extends I18nGenerator {
  final Directory _inputDirectory;
  String _defaultLocale;
  final RegExp _languageFileRegExp = RegExp(r"strings_(.*)\.json$");

  NativeFilesGenerator(this._defaultLocale, this._inputDirectory);

  void generate() async {
    _getLanguageFiles().then((languageFiles) {
      var locales = _getAllLocales(languageFiles);
      var languageStrings = _getLanguageStrings(languageFiles);

      _generateAndroidFiles(locales, languageStrings);
      _generateIosAndroidFiles(locales, languageStrings);
    });
  }

  /// Generates all necessary files for Android
  void _generateAndroidFiles(List<String> locales, LanguageStringMap languageStrings) {
    Directory resourceDirectory = Directory("${Directory.current.path}/android/app/src/main/res");

    _createLocaleFile(
      "${resourceDirectory.path}/values",
      languageStrings.getLanguageStrings(_defaultLocale),
    );

    locales.forEach((locale) => //
        _createLocaleFile(
          "${resourceDirectory.path}/values-$locale",
          languageStrings.getLanguageStrings(locale),
        ));
  }

  void _generateIosAndroidFiles(List<String> locales, LanguageStringMap languageStrings) {
    Directory runnerRepository = Directory("${Directory.current.path}/ios/Runner");
    List<String> incompleteLocales = [];

    var completeLocale = locales //
        .where((element) => _hasAllFiles(Directory("${runnerRepository.path}/$element.lproj")))
        .first;

    locales.forEach(
      (locale) => //
          Directory("${runnerRepository.path}/$locale.lproj") //
              .create(recursive: true)
              .then((localeFolder) {
        if (!_hasAllFiles(localeFolder)) {
          File("${runnerRepository.path}/$completeLocale.lproj/LaunchScreen.storyboard") //
              .copy("${localeFolder.path}/LaunchScreen.storyboard");

          File("${runnerRepository.path}/$completeLocale.lproj/Main.storyboard") //
              .copy("${localeFolder.path}/Main.storyboard");
        }

        File("${localeFolder.path}/Localizable.strings") //
            .writeAsString(_generateIosStrings(languageStrings.getLanguageStrings(locale)));
      }),
    );

    incompleteLocales.forEach((incompleteLocale) {});
  }

  bool _hasAllFiles(Directory localeFolder) => //
      localeFolder.listSync().map((f) => f.path).where(_isBasicFile).toList().isNotEmpty;

  bool _isBasicFile(String filePath) => //
      filePath.contains("LaunchScreen.storyboard") || filePath.contains("Main.storyboard");

  /// Creates locale file for Android
  void _createLocaleFile(String resourceDirectoryPath, List<LanguageString> languageStrings) => //
      Directory(resourceDirectoryPath) //
          .create(recursive: true)
          .then((_) => //
              File("$resourceDirectoryPath/strings.xml") //
                  .writeAsString(_generateLocaleXml(languageStrings)));

  /// Generates locale XML file as String
  String _generateLocaleXml(List<LanguageString> languageStrings) => //
      xml.parse("""
        <?xml version="1.0" encoding="utf-8" ?>
        <resources>
            ${_generateAndroidStrings(languageStrings)}
        </resources>
        """).toXmlString(pretty: true);

  /// Generates Android string elements.
  String _generateAndroidStrings(List<LanguageString> languageStrings) => //
      languageStrings //
          .map((t) => t.android)
          .where((s) => s.isNotEmpty)
          .join('\n');

  /// Generates iOS string elements.
  String _generateIosStrings(List<LanguageString> languageStrings) => //
      languageStrings //
          .map((t) => t.iOS)
          .where((s) => s.isNotEmpty)
          .join('\n');

  /// Get a list of [LanguageFile]s from given input folder.
  Future<List<LanguageFile>> _getLanguageFiles() {
    List<LanguageFile> languageFiles = [];
    var languageFilesFuture = Completer<List<LanguageFile>>();

    _inputDirectory //
        .list()
        .toList()
        .then((files) {
      files.forEach((item) {
        var match = _languageFileRegExp.firstMatch(item.path);
        if (match != null && match.groupCount > 0) {
          languageFiles.add(LanguageFile(match.group(1), item));
        }
      });

      languageFilesFuture.complete(languageFiles);
    });

    return languageFilesFuture.future;
  }

  /// Reads the string from the files
  LanguageStringMap _getLanguageStrings(List<LanguageFile> languageFiles) {
    LanguageStringMap languageStrings = LanguageStringMap();

    languageFiles.forEach((languageFile) => //
        languageStrings.addLanguageStrings(
            languageFile.locale, json.decode(File(languageFile.file.path).readAsStringSync())));

    return languageStrings;
  }

  /// Gets all the locales based on the naming convention
  List<String> _getAllLocales(List<LanguageFile> languageFiles) {
    List<String> locales = [];
    languageFiles.forEach((languageFile) => locales.add(languageFile.locale));

    return locales;
  }
}
