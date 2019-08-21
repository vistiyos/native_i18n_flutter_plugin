import 'package:flutter/material.dart';
import 'package:i18n_plugin_example/i18n.dart';
import 'package:native_i18n_flutter_plugin/i18n_text.dart';

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
          child: I18nText(I18n.test),
        ),
      ),
    );
  }
}
