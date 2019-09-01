import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:native_i18n_flutter_plugin/translation.dart';

/// Plugin that fetches translation using Native API.
class NativeI18nFlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('native_i18n_flutter_plugin');

  /// Get a single translation
  static Future<String> getTranslation(Translation translation) {
    Completer<String> translationCompletable = Completer();
    getTranslations([translation]).then((map) => translationCompletable.complete(map[translation.translationKey]));

    return translationCompletable.future;
  }

  /// Get a map of translation where the key is the translation key and its translation.
  static Future<Map<String, String>> getTranslations(List<Translation> translations) {
    Completer<Map<String, String>> translationsCompletable = Completer();
    Map<String, Translation> translationMap = {};
    translations //
        .where((i) => i != null)
        .forEach((t) => translationMap[t.translationKey] = t);
    _channel //
        .invokeMapMethod(
            'getTranslations', jsonEncode(translations.where((i) => i != null).map((i) => i.toMap).toList()))
        .then((map) {
      Map<String, String> translationCompleted = {};
      map.forEach((translationKey, translation) =>
          translationCompleted[translationKey] = translationMap[translationKey].format(translation));
      translationsCompletable.complete(translationCompleted);
    });

    return translationsCompletable.future;
  }
}
