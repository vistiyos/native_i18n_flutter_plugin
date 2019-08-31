import 'package:flutter/material.dart';
import 'package:i18n_plugin_example/i18n.dart';
import 'package:native_i18n_flutter_plugin/widgets/i18n_widget_builder.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: I18nWidgetBuilder(
            translations: [I18n.test('Paco')],
            builder: (context, translations) => Text(translations[I18n.keys.test]),
          ),
        ),
      ),
    );
  }
}
