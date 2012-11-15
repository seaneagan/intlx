
library plural_locale_build;

import 'dart:io';
import '../util.dart';
import 'locale_data.dart';

main() {
  writeLocaleLibraries();
}

void writeLocaleLibraries() {
  for(String locale in pluralLocaleList) {
    writeSingleLocaleLibrary(locale);
  }
  writeAllLocaleLibrary();
  writeLocaleListLibrary();
}

void writeSingleLocaleLibrary(String locale) {
  writeLocaleLibrary(locale, '  registerLocale(${generateLocaleInstantiation(locale)});');
}

void writeAllLocaleLibrary() {
  var allLocales = Strings.join(pluralLocaleList.map(generateLocaleInstantiation), ", ");
  var allLogic = '''
  var locales = [$allLocales];

  locales.forEach(registerLocale);''';

  writeLocaleLibrary("all", allLogic);
}

String generateLocaleInstantiation(String locale) => 'const PluralLocaleImpl("$locale", ${getPluralStrategy(locale)})';

void writeLocaleLibrary(String locale, String logic) {
  String code = '''
import '../../src/plural/internal.dart';

void init() {
$logic
}
''';

  writeLibrary(localeLibPath.append("plural/"), locale, code, "plural_locale_$locale");
}

void writeLocaleListLibrary() {
  String localeString = Strings.join(pluralLocaleList.map((locale) => '"$locale"'), ", ");

  var code = '''

const pluralLocales = const <String> [$localeString];
''';

  writeLibrary(libPath.append("src/plural"), "locale_list", code, "plural_locale_list");
}
