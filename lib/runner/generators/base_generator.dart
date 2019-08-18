import 'i18n_generator.dart';

class BaseGenerator extends I18nGenerator {
  @override
  void generate() => out('''
  🇪🇸  i18n runner for Flutter.  🇪🇸
       This command line app will generate all you need to get your app internationalized.
       Available commands:
        - generateLangFiles -o <output_dir> 
        - generatei18n
  ''');
}
