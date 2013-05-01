
import 'dart:io';
import 'dart:json' as json;
import '../library_writer.dart';
import 'package:intlx/src/plural/plural_locale_list.dart';
import 'package:intl/intl.dart';
import 'package:intlx/intlx.dart';

main() {
  new RelativeTimeLibraryWriter().writeLibraries();
}

class RelativeTimeLibraryWriter extends LibraryWriter {
  final type = "relative_time";
  final symbolsClass = "RelativeTimeSymbols";
  String getPluralLibraryIdentifier(String locale) => "plural_locale_$locale";

  getSymbolsConstructorArgs(String locale, Map data) {
    String unitsCode(String unitType) {
      var units = data[unitType];
      var mapContents = '';
      if(!units.isEmpty) {
        mapContents = TimeUnit.values.map((TimeUnit unit) {
          var unitString = unit.toString();
          return '"$unitString": const ${json.stringify(units[unitString])}';
        }).join(''',
      ''');
      }
      return '''
  $unitType: const {
      $mapContents
    }''';
    }

    var ret = ["units", "shortUnits", "pastUnits", "futureUnits"].map(unitsCode).join(''',
    ''');
    return '''
    $ret''';
  }

  String getAllLocaleLibraryImports() => '''${super.getAllLocaleLibraryImports()}
import '../plural/all.dart' as ${getPluralLibraryIdentifier('all')};''';

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
