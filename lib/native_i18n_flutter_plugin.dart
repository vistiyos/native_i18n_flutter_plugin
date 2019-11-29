import 'dart:async';
import 'dart:convert';

import 'package:dcache/dcache.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:native_i18n_flutter_plugin/translation.dart';

/// Plugin that fetches translation using Native API.
class NativeI18nFlutterPlugin {
  static const MethodChannel _channel =
  const MethodChannel('native_i18n_flutter_plugin');
  static var _logger = Logger();
  static var cache = SimpleCache(storage: new SimpleStorage(size: 100));

  /// Get a single translation
  static Future<String> getTranslation(Translation translation) {
    Completer<String> translationCompletable = Completer();
    getTranslations([translation]).then((map) =>
        translationCompletable.complete(map[translation.translationKey]));

    return translationCompletable.future;
  }

  /// Get a map of translation where the key is the translation key and its translation.
  static Future<Map<String, String>> getTranslations(
      List<Translation> translations) {
    Completer<Map<String, String>> translationsCompletable = Completer();
    Map<String, Translation> translationMap = {};
    Map<String, String> translationCompleted = {};
    translations //
        .where((i) => i != null)
        .forEach((t) {
      var translationCached = cache.get(t.translationKey);
      if (translationCached == null) {
        translationMap[t.translationKey] = t;
      } else {
        _logger.d("${t.translationKey} cache found");
        translationCompleted[t.translationKey] = t.format(translationCached);
      }
    });

    if (translationMap.isEmpty) {
      return Future.value(translationCompleted);
    } else {
      _logger.d("Translating $translationMap");
      _channel //
          .invokeMapMethod(
          'getTranslations',
          jsonEncode(translations
              .where((i) => i != null)
              .map((i) => i.toMap)
              .toList()))
          .then((map) {
        map.forEach((translationKey, translation) {
          if (translationMap[translationKey] != null) {
            cache.set(translationKey, translation);
            translationCompleted[translationKey] =
                translationMap[translationKey].format(translation);
          }
        });
        translationsCompletable.complete(translationCompleted);
      });

      return translationsCompletable.future;
    }
  }
}
