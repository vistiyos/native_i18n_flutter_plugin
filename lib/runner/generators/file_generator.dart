import 'dart:io';

import 'package:native_i18n_flutter_plugin/runner/generators/base_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/language_string_class_generator.dart';
import 'package:native_i18n_flutter_plugin/runner/generators/native_files_generator.dart';

class FileGenerator extends BaseGenerator {
  final Directory _inputDirectory;
  final Directory _outputDirectory;
  final String _defaultLocale;

  FileGenerator(this._inputDirectory, this._outputDirectory, this._defaultLocale);

  @override
  void generate(bool watch) {
    var classGenerator = LanguageStringClassGenerator(_inputDirectory, _outputDirectory, _defaultLocale);
    classGenerator.generate(false);
    var nativeGenerator = NativeFilesGenerator(_defaultLocale, _inputDirectory);
    nativeGenerator.generate(false);

    if (watch) {
      classGenerator.setUpFileWatcher();
      nativeGenerator.setUpFileWatcher();
    }
  }
}
