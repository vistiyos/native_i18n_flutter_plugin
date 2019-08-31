import 'package:flutter/material.dart';
import 'package:native_i18n_flutter_plugin/native_i18n_flutter_plugin.dart';
import 'package:native_i18n_flutter_plugin/translation.dart';

typedef I18nWidgetBuilderFunction = Widget Function(BuildContext context, Map<String, String> translations);

class I18nWidgetBuilder extends StatelessWidget {
  final List<Translation> translations;
  final I18nWidgetBuilderFunction builder;

  I18nWidgetBuilder({
    Key key,
    @required this.translations,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => //
      FutureBuilder<Map<String, String>>(
        builder: (context, data) {
          if (data.hasData) {
            return builder(context, data.data);
          }

          return Container();
        },
        future: NativeI18nFlutterPlugin.getTranslations(translations),
      );
}
