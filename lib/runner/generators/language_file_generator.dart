import 'dart:convert';
import 'dart:io';

import 'i18n_generator.dart';

/// Flutter language files generator
class LanguageFileGenerator extends I18nGenerator {

  final Directory _outputDirectory;

  LanguageFileGenerator(this._outputDirectory);

  // @formatter:off
  final List<String> _supportedLocale = [
    'ab', 'aa', 'af', 'ak', 'sq', 'am', 'ar', 'an', 'hy', 'as', 'av', 'ae',
    'ay', 'az', 'bm', 'ba', 'eu', 'be', 'bn', 'bh', 'bi', 'bs', 'br', 'bg',
    'my', 'ca', 'km', 'ch', 'ce', 'ny', 'zh', 'cu', 'cv', 'kw', 'co', 'cr',
    'hr', 'cs', 'da', 'dv', 'nl', 'dz', 'en', 'eo', 'et', 'ee', 'fo', 'fj',
    'fi', 'fr', 'ff', 'gd', 'gl', 'lg', 'ka', 'de', 'ki', 'el', 'kl', 'gn',
    'gu', 'ht', 'ha', 'he', 'hz', 'hi', 'ho', 'hu', 'is', 'io', 'ig', 'id',
    'ia', 'ie', 'iu', 'ik', 'ga', 'it', 'ja', 'jv', 'kn', 'kr', 'ks', 'kk',
    'rw', 'kv', 'kg', 'ko', 'kj', 'ku', 'ky', 'lo', 'la', 'lv', 'lb', 'li',
    'ln', 'lt', 'lu', 'mk', 'mg', 'ms', 'ml', 'mt', 'gv', 'mi', 'mr', 'mh',
    'ro', 'mn', 'na', 'nv', 'nd', 'ng', 'ne', 'se', 'no', 'nb', 'nn', 'ii',
    'oc', 'oj', 'or', 'om', 'os', 'pi', 'pa', 'ps', 'fa', 'pl', 'pt', 'qu',
    'rm', 'rn', 'ru', 'sm', 'sg', 'sa', 'sc', 'sr', 'sn', 'sd', 'si', 'sk',
    'sl', 'so', 'st', 'nr', 'es', 'su', 'sw', 'ss', 'sv', 'tl', 'ty', 'tg',
    'ta', 'tt', 'te', 'th', 'bo', 'ti', 'to', 'ts', 'tn', 'tr', 'tk', 'tw',
    'ug', 'uk', 'ur', 'uz', 've', 'vi', 'vo', 'wa', 'cy', 'fy', 'wo', 'xh',
    'yi', 'yo', 'za', 'zu'];
  // @formatter:on

  @override
  void generate() {
    bool finished = false;
    List<String> locales = [];

    while (!finished) {
      out(
          'Type ISO 639-1 language code (https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) or quit to finish:');
      String locale = stdin.readLineSync();
      if (locale == 'quit') {
        finished = true;
      } else {
        if (!_supportedLocale.contains(locale)) {
          out(
              'Locale not supported, check that is on the list located on https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes');
        } else {
          locales.add(locale);
        }
      }
    }

    bool validIndex = false;
    Map<String, String> configuration = {};

    while (!validIndex) {
      out('Select the default language from the following list:');
      for (var i = 0; i < locales.length; i++) {
        out("${i + 1}. ${locales[i]}");
      }
      outSingle("Default language: ");
      var index = int.parse(stdin.readLineSync());

      if (index <= locales.length) {
        configuration['defaultLocale'] = locales[index - 1];
        validIndex = true;
      }
    }


    _outputDirectory.exists().then((exists) {
      if (!exists) _outputDirectory.createSync(recursive: true);
      locales.forEach((locale) {
        File("${_outputDirectory.path}/strings_$locale.json")
            .writeAsString("{}")
            .then((file) => out("${file.path} created."));
      });

      File("${_outputDirectory.path}/.i18n-config") //
          .writeAsString(json.encode(configuration));
    });
  }
}
