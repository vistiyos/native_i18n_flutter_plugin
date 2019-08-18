import 'dart:io';

/// Holds information about language file
class LanguageFile {
  final String locale;
  final FileSystemEntity file;

  LanguageFile(this.locale, this.file);
}
