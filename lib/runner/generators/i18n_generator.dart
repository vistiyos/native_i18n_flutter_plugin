import 'dart:io';

abstract class I18nGenerator {
  /// Generates the code
  void generate(bool watch);

  /// Outputs a message
  void out(String message) => stdout.writeln(message);

  void outSingle(String message) => stdout.write(message);
}
