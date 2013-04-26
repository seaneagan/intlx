
library relative_time_locale_build;

import 'dart:io';
import 'dart:json' as json;
import '../util.dart';
import 'package:intlx/src/plural/plural_locale_list.dart';
import 'package:intl/intl.dart';

main() {
  new RelativeTimeLibraryWriter().writeLibraries();
}

class RelativeTimeLibraryWriter extends JsonSourcedLibraryWriter {
  final type = "relative_time";
  final symbolsClass = "RelativeTimeSymbols";
  String getPluralLibraryIdentifier(String locale) => "plural_locale_$locale";

  getSymbolsConstructorArgs(String locale, Map data) {
    String unitsCode(String unitType) {
      var units = data[unitType];
      if(units.isEmpty) return "$unitType: const {}";
      return '''
  $unitType: const {
      "SECOND": const ${json.stringify(units["SECOND"])},
      "MINUTE": const ${json.stringify(units["MINUTE"])},
      "HOUR": const ${json.stringify(units["HOUR"])},
      "DAY": const ${json.stringify(units["DAY"])},
      "WEEK": const ${json.stringify(units["WEEK"])},
      "MONTH": const ${json.stringify(units["MONTH"])},
      "YEAR": const ${json.stringify(units["YEAR"])}
    }''';
    }

    return '''
    ${unitsCode("units")},
    ${unitsCode("shortUnits")},
    ${unitsCode("pastUnits")},
    ${unitsCode("futureUnits")}''';
  }

  String getAllLocaleLibraryImports() => '''${super.getAllLocaleLibraryImports()}
import '../plural/all.dart' as plural_locale_all;''';

  String getAllLocaleLibraryLogic() => '''
    plural_locale_all.init();
    ${super.getAllLocaleLibraryLogic()}''';

  void writeSingleLocaleLibrary(String locale) {
    var pluralLocale = Intl.verifiedLocale(locale, pluralLocales.contains);
    String pluralLibraryIdentifier = getPluralLibraryIdentifier(pluralLocale);
    writeLocaleLibrary(
        locale,
        '''${generateLocaleImport(locale)}
    import '../plural/$pluralLocale.dart' as $pluralLibraryIdentifier;''',
        '''  $symbolsClass.map['$locale'] = ${getSymbolsLibraryIdentifier(locale)}.symbols;
      $pluralLibraryIdentifier.init();''');
    }
}
