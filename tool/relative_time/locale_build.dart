
library relative_time_locale_build;

import 'dart:io';
import 'dart:json';
import '../util.dart';
import 'package:intlx/src/internal.dart';
import 'package:intlx/src/plural/locale_list.dart';
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
      "second": const ${JSON.stringify(units["second"])},
      "minute": const ${JSON.stringify(units["minute"])},
      "hour": const ${JSON.stringify(units["hour"])},
      "day": const ${JSON.stringify(units["day"])},
      "week": const ${JSON.stringify(units["week"])},
      "month": const ${JSON.stringify(units["month"])},
      "year": const ${JSON.stringify(units["year"])}
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
