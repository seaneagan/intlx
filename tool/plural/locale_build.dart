
library plural_locale_build;

import 'dart:io';
import 'dart:json' as json;
import '../util.dart';
import 'plural_rule_parser.dart';
import 'package:intlx/src/plural/plural.dart';
import 'dart:async';

main() {
  new PluralLibraryWriter().writeLibraries();
}

class PluralLibraryWriter extends LibraryWriter {
  final String type = "plural";
  final String symbolsClass = "PluralLocaleImpl";
  final String symbolsClassLibrary = "plural";
  
  void writeLibrariesSync(){
    super.writeLibrariesSync();
    writeLoadLocaleLibrary();
  }

  void writeLoadLocaleLibrary() {
    var loadLocaleLibraryPath = libPath.append("src/$type/");
    
    var imports = localeList.map((locale) => '''@library_$locale
import 'package:intlx/src/plural/locale/$locale.dart' as plural_locale_$locale;
''').join();

    var deferredLibraries = localeList.map((locale) => '''  const library_$locale = const DeferredLibrary('plural_symbols_$locale');
''').join();
    
    var libraryMapEntries = localeList.map((locale) => '''    '$locale': library_$locale''').join(',\n');
    
    var switchCases = localeList.map((locale) => '''  case '$locale': init(plural_locale_$locale.symbols); break;
''').join();

    var code = '''
import 'dart:async';
import 'package:intlx/src/plural/plural.dart';
$imports

Future<bool> loadLocale([String locale]) {
$deferredLibraries
  const libraryMap = const <String, DeferredLibrary> {
$libraryMapEntries
  };
 
  if(PluralLocaleImpl.map.containsKey(locale)) return new Future.immediate(false);
  return libraryMap[locale].load().then((_) {
    init(PluralLocale pluralLocale) => PluralLocaleImpl.map[locale] = pluralLocale;
    switch(locale) {
$switchCases
    }
    return true;
  });
}''';
    
    writeLibrary(loadLocaleLibraryPath, "load_locale", code);
    
  }

  Future getBuiltLocaleData() {
    var pluralRulesUri = '${cldrUri}supplemental/plurals/plurals?depth=-1';
    return fetchUri(pluralRulesUri).then((String jsonText) {
      var data = json.parse(jsonText);
      data.forEach((String locale, var rules) {
        if(rules == '') data[locale] = <String, String> {};
      });
      return data;
    });
  }

  String getSymbolsConstructorArgs(String locale, Map data) => """'$locale', (int n) {
${getPluralRulesCode(data)}
  }""";
}

String getPluralRulesCode(Map<String, String> pluralRules) {
  String code = "return PluralCategory.OTHER;";
  for(PluralCategory category in [PluralCategory.MANY, PluralCategory.FEW, PluralCategory.TWO, PluralCategory.ONE, PluralCategory.ZERO]) {
    var categoryString = category.toString();
    if(pluralRules.containsKey(categoryString)) {
      String categoryTest = pluralParser.parse(pluralRules[categoryString]).toDart();
      code = '''if($categoryTest) return PluralCategory.${categoryString.toUpperCase()};
else $code''';
    }
  }
  return code;
}
