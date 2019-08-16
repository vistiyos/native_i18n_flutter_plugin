import 'package:flutter/material.dart';
import 'package:native_i18n_flutter_plugin/native_i18n_flutter_plugin.dart';

/// Widget that shows an internationalized text
class I18nText extends StatelessWidget {
  /// Translation key
  final String _translationKey;

  /// Other [Text] widget properties.
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final TextWidthBasis textWidthBasis;

  I18nText(
    this._translationKey, {
    key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => //
      FutureBuilder<String>(
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textDirection: textDirection,
              locale: locale,
              softWrap: softWrap,
              overflow: overflow,
              textScaleFactor: textScaleFactor,
              maxLines: maxLines,
              semanticsLabel: semanticsLabel,
              textWidthBasis: textWidthBasis,
            );
          }

          return Container();
        },
        future: NativeI18nFlutterPlugin.getTranslation(_translationKey),
      );
}
