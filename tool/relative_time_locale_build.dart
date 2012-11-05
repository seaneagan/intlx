
import 'dart:io';
import 'dart:json';
import 'util.dart';
import 'package:tempora/src/internal.dart';
import 'plural_locale_data.dart';

main() {
  getLocaleData().then(writeLibraries);
}

void writeLibraries(_) {
  writeLocaleLibraries();
  writeSymbolLibraries();
  // TODO: run tests on new code
}

void writeLocaleLibraries() {
  for(String locale in localeList) {
    writeSingleLocaleLibrary(locale);
  }
  writeAllLocaleLibrary();
  writeLocaleListLibrary();
}

void writeSymbolLibraries() {
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
  var pluralLocale = getVerifiedLocale(locale, pluralLocaleList);
  String pluralLibraryIdentifier = getPluralLibraryIdentifier(pluralLocale);
  writeLocaleLibrary(
    locale, 
    '''${generateLocaleImport(locale)}
import '../plural/$pluralLocale.dart' as $pluralLibraryIdentifier;''', 
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

String generateLocaleImport(String locale) => "import '../../src/relative_time/locale/$locale.dart' as ${getSymbolsLibraryIdentifier(locale)};";

void writeLocaleListLibrary() {
  
  String localeString = Strings.join(localeList.map((locale) => '"$locale"'), ", ");
  
  var code = '''
const relativeTimeLocales = const <String> [$localeString];
''';

  writeLibrary(libPath.append("src/relative_time/"), "relative_time_locale_list", code);
}

void writeLocaleLibrary(String locale, String imports, String logic) {
  String code = '''
import '../../src/internal.dart';
$imports

void init() {
$logic
}
''';

  writeLibrary(localeLibPath.append("relative_time/"), locale, code, "relative_time_locale_$locale");
}

Path _localeSrcPath;
Path get localeSrcPath {
  if(_localeSrcPath === null) {
    _localeSrcPath = libPath.append("src/relative_time/locale/");
  }
  return _localeSrcPath;
}

Path _localeDataPath;
Path get localeDataPath {
  if(_localeDataPath === null) {
    _localeDataPath = libPath.append("src/data/relative_time");
  }
  return _localeDataPath;
}

var localeDataMap = new Map<String, Map>();
List<String> localeList;
Future getLocaleData() {
    var completer = new Completer<List<String>>();
    
    var lister = new Directory.fromPath(localeDataPath).list();
    
    lister.onFile = (String file) {
      String locale = new Path.fromNative(file).filenameWithoutExtension;
            
      var filePath = localeDataPath.append("$locale.json");
      String json = readFile(filePath);
      print("json: $json");
      localeDataMap[locale] = JSON.parse(json);
    };
    
    lister.onDone = (completed) {
      if(completed) {
        localeList = new List.from(localeDataMap.getKeys());
        // TODO: remove once default sort argument is allowed
        localeList.sort((a, b) => a.compareTo(b));
        completer.complete(null);
      }
    };
    
    return completer.future;
}

String getSymbolsLibraryIdentifier(String locale) => "relative_time_symbols_$locale";
String getPluralLibraryIdentifier(String locale) => "plural_locale_$locale";

