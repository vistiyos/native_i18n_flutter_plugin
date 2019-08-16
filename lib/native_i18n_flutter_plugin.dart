import 'dart:async';

import 'package:flutter/services.dart';

/// Plugin that fetches translation using Native API.
class NativeI18nFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('native_i18n_flutter_plugin');

  /// Get a single translation
  static Future<String> getTranslation(String translationKey) {
    Completer<String> translationCompletable = Completer();
    _channel.invokeMapMethod('getTranslations', {
      'translationKeys': [translationKey]
    }).then((map) => translationCompletable.complete(map[translationKey]));

    return translationCompletable.future;
  }

  /// Get a map of translation where the key is the translation key and the
  /// its translation.
  static Future<Map<String, String>> getTranslations(
          List<String> translationKeys) =>
      _channel.invokeMapMethod(
          'getTranslations', {'translationKeys': translationKeys});
}
