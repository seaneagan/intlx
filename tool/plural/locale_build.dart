
library plural_locale_build;

import 'dart:io';
import 'dart:json';
import '../util.dart';
import 'plural_rule_parser.dart';
import 'package:intlx/src/plural/plural.dart';

main() {
  new PluralLibraryWriter().writeLibraries();
}

class PluralLibraryWriter extends LibraryWriter {
  final String type = "plural";
  final String symbolsClass = "PluralLocaleImpl";
  final String symbolsClassLibrary = "plural";

  Future getBuiltLocaleData() {
    var pluralRulesUri = '${cldrUri}supplemental/plurals/plurals?depth=-1';
    return fetchUri(pluralRulesUri).then((String json) {
      var data = JSON.parse(json);
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
