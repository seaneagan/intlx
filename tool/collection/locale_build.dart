
library collection_locale_build;

import 'dart:io';
import 'dart:json';
import '../util.dart';
import 'package:intlx/src/internal.dart';
import '../plural/locale_data.dart';

main() {
  getBuiltLocaleData("collection").then(writeLibraries);
}

List<String> localeList;
void writeLibraries(Map<String, Map> localeDataMap) {
  localeList = new List.from(localeDataMap.keys);
  // TODO: remove once default sort argument is allowed
  localeList.sort((a, b) => a.compareTo(b));
  writeLocaleLibraries();
  writeSymbolLibraries(localeDataMap);
  // TODO: run tests on new code
}

void writeLocaleLibraries() {
  for(String locale in localeList) {
    writeSingleLocaleLibrary(locale);
  }
  writeAllLocaleLibrary();
  writeLocaleListLibrary();
}

void writeSymbolLibraries(localeDataMap) {
  for(String locale in localeList) {
    writeSymbolLibrary(locale, localeDataMap[locale]);
  }
}

void writeSymbolLibrary(String locale, Map data) {

  String unitsCode(String unitType) {
    var units = data[unitType];
    if(units.isEmpty()) return "$unitType: const {}";
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

  var code = '''
import '../symbols.dart';

const RelativeTimeSymbols locale = const RelativeTimeSymbols(
  name: "$locale",
  ${unitsCode("units")},
  ${unitsCode("shortUnits")},
  ${unitsCode("pastUnits")},
  ${unitsCode("futureUnits")});
''';

  writeLibrary(localeSrcPath, locale, code, getSymbolsLibraryIdentifier(locale));
}

void writeSingleLocaleLibrary(String locale) {
  writeLocaleLibrary(
    locale,
    '${generateLocaleImport(locale)}',
    '''  registerSymbols(${getSymbolsLibraryIdentifier(locale)}.locale);
  $pluralLibraryIdentifier.init();''');
}

void writeAllLocaleLibrary() {
  var allImports = """${Strings.join(localeList.map(generateLocaleImport), "\n")}
  import '../plural/all.dart' as plural_locale_all;""";
  var allLocales = Strings.join(localeList.map((locale) => "${getSymbolsLibraryIdentifier(locale)}.locale"), ", ");
  var allLogic = '''
  var locales = [$allLocales];

  plural_locale_all.init();
  locales.forEach(registerSymbols);''';

  writeLocaleLibrary("all", allImports, allLogic);
}

String generateLocaleImport(String locale) => "import '../../src/collection/locale/$locale.dart' as ${getSymbolsLibraryIdentifier(locale)};";

void writeLocaleListLibrary() {

  String localeString = Strings.join(localeList.map((locale) => '"$locale"'), ", ");

  var code = '''
const relativeTimeLocales = const <String> [$localeString];
''';

  writeLibrary(libPath.append("src/collection/"), "collection_locale_list", code);
}

void writeLocaleLibrary(String locale, String imports, String logic) {
  String code = '''
import '../../src/internal.dart';
$imports

void init() {
$logic
}
''';

  writeLibrary(localeLibPath.append("collection/"), locale, code, "collection_locale_$locale");
}

Path _localeSrcPath;
Path get localeSrcPath {
  if(_localeSrcPath == null) {
    _localeSrcPath = libPath.append("src/collection/locale/");
  }
  return _localeSrcPath;
}

String getSymbolsLibraryIdentifier(String locale) => "collection_symbols_$locale";

