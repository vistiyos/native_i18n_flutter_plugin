import 'package:sprintf/sprintf.dart';

class Translation {
  final String translationKey;
  List<dynamic> translationArguments = [];

  Translation(this.translationKey, {this.translationArguments});

  Map<String, dynamic> get toMap => //
      {'translationKey': translationKey, 'translationArguments': translationArguments};

  String format(String translation) => sprintf(translation, translationArguments ?? []);
}
