/// Holds information about a language string
class LanguageString {
  final String key;
  final String value;

  LanguageString(this.key, this.value);

  /// Only used when generates iOS language files
  String get iOS => """"$key" = "$value";""";

  // Only used when generate Android language files
  String get android => """<string name="$key">$value</string>""";
}
