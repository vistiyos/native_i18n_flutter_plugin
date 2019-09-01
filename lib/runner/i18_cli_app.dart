import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/base_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/i18n_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/language_file_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/language_string_class_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/native_files_generator.dart';

class I18nCliApp {
  final List<String> _availableCommands = ['generateLangFiles', 'generateI18n', 'generateClass'];

  void process(List<String> args) {
    var argParser = _createArgParser();
    ArgResults options;

    try {
      options = argParser.parse(args);
    } on FormatException catch (ex) {
      stdout.writeln(ex.message);
      exit(2);
    }

    I18nGenerator i18Generator;

    if (options.rest.isEmpty || !_availableCommands.contains(options.rest[0])) {
      i18Generator = BaseGenerator();
    } else {
      switch (options.rest[0]) {
        case 'generateLangFiles':
          if (!options.wasParsed('input')) throw ArgumentError('languages argument is required');
          if (!options.wasParsed('output')) throw ArgumentError('output argument is required');

          i18Generator = LanguageFileGenerator(
            Directory(options['output']),
            options['input'].toString().split(',').map((i) => i.trim()).toList(),
          );
          break;
        case 'generateNative':
          if (!options.wasParsed('input')) throw ArgumentError('input argument is required');
          Map<String, dynamic> configuration = _readConfiguration(options['input']);
          i18Generator = NativeFilesGenerator(configuration['defaultLocale'], Directory(options['input']));
          break;
        case 'generateClass':
          if (!options.wasParsed('input')) throw ArgumentError('input argument is required');
          if (!options.wasParsed('output')) throw ArgumentError('output argument is required');
          Map<String, dynamic> configuration = _readConfiguration(options['input']);
          i18Generator = LanguageStringClassGenerator(
            Directory(options['input']),
            Directory(options['output']),
            configuration['defaultLocale'],
          );
          break;
      }
    }

    i18Generator.generate(options.wasParsed('watch'));
  }

  Map<String, dynamic> _readConfiguration(String inputDirectory) =>
      jsonDecode(File("${Directory(inputDirectory).path}/.i18n-config").readAsStringSync());

  ArgParser _createArgParser() => ArgParser() //
    ..addOption('input', abbr: 'i', help: 'Input directory to read from')
    ..addOption('output', abbr: 'o', help: 'Output directory')
    ..addFlag('watch', abbr: 'w');
}
