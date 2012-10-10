
import 'dart:io';
import 'dart:json';

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
  
  var units = data["units"];
  
  var code = '''
import '../symbols.dart';

const RelativeTimeSymbols locale = const RelativeTimeSymbols(
  name: "$locale",
  past: "${data["past"]}",
  future: "${data["future"]}",
  units: const {
    "SECOND": const ${JSON.stringify(units["SECOND"])},
    "MINUTE": const ${JSON.stringify(units["MINUTE"])},
    "HOUR": const ${JSON.stringify(units["HOUR"])},
    "DAY": const ${JSON.stringify(units["DAY"])},
    "MONTH": const ${JSON.stringify(units["MONTH"])},
    "YEAR": const ${JSON.stringify(units["YEAR"])}});

''';
  
  writeLibrary(localeSrcPath, locale, code);
}

void writeSingleLocaleLibrary(String locale) {
  writeLocaleLibrary(locale, generateLocaleImport(locale), '  registerSymbols($locale.locale);');
}

void writeAllLocaleLibrary() {
  var allImports = Strings.join(localeList.map(generateLocaleImport), "\n");
  var allLocales = Strings.join(localeList.map((locale) => "$locale.locale"), ", ");
  var allLogic = '''
  var locales = [$allLocales];
  
  locales.forEach(registerSymbols);''';
  
  writeLocaleLibrary("all", allImports, allLogic);
}

String generateLocaleImport(String locale) => 'import \'../src/locale/$locale.dart\' as $locale;';

void writeLocaleListLibrary() {
  
  String localeString = Strings.join(localeList.map((locale) => '"$locale"'), ", ");
  
  var code = '''
const relativeTimeLocales = const <String> [$localeString];
''';

  writeLibrary(libPath.append("src/"), "locale_list", code);
}

void writeLocaleLibrary(String locale, String imports, String logic) {
  String code = '''
import '../src/internal.dart';
$imports

void init() {
$logic
}
''';

  writeLibrary(localeLibPath, locale, code);

}

writeLibrary(Path path, String name, String code) {
  String fullCode = '''
$generatedFileWarning

library $name;

$code''';
  writeFile(path.append("$name.dart"), fullCode);
}

void writeFile(Path path, String content) {
  var targetFile = new File.fromPath(path);
  targetFile.createSync();
  var raf = targetFile.openSync(FileMode.WRITE);
  raf.truncateSync(0);
  raf.writeStringSync(content);
  raf.flushSync();
  raf.close();
}

Path _localeLibPath;
Path get localeLibPath {
  if(_localeLibPath === null) {
    _localeLibPath = libPath.append("locale/");
  }
  return _localeLibPath;
}

Path _localeSrcPath;
Path get localeSrcPath {
  if(_localeSrcPath === null) {
    _localeSrcPath = libPath.append("src/locale/");
  }
  return _localeSrcPath;
}

Path _localeDataPath;
Path get localeDataPath {
  if(_localeDataPath === null) {
    _localeDataPath = libPath.append("src/data/relative_time/new");
  }
  return _localeDataPath;
}

Path _libPath;
Path get libPath {
  if(_libPath === null) {
    var packageRoot = new Path(new Directory.current().path);
    _libPath = packageRoot.append("lib");
  }
  return _libPath;
}

var localeDataMap = new Map<String, Map>();
List<String> localeList;
Future getLocaleData() {
    var completer = new Completer<List<String>>();
    
    var lister = new Directory.fromPath(localeDataPath).list(false);
    
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

String readFile(filePath) {
  var file = new File.fromPath(filePath);
  return file.readAsTextSync();
}

const String generatedFileWarning = '''
/// DO NOT EDIT. This file is autogenerated by script.
/// See "tool/build_locale_libraries.dart"''';

