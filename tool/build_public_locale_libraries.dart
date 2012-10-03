
#import("dart:io");
#import("dart:json");

main() {
  getLocaleData().then(writeLibraries);
}

void writeLibraries(ignored) {
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
  
var code = '''

#library("relative_time_${locale}_symbols");

#import("../symbols.dart");

const RelativeTimeSymbols locale = const RelativeTimeSymbols(
  name: "$locale",
  past: "%s ago",
  future: "in %s",
  units: const {
    "SECOND": const ["a few seconds"],
    "MINUTE": const ["a minute", "%d minutes"],
    "HOUR": const ["an hour", "%d hours"],
    "DAY": const ["a day", "%d days"],
    "MONTH": const ["a month", "%d months"],
    "YEAR": const ["a year", "%d years"]});

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

String generateLocaleImport(String locale) => '#import("../src/locale/$locale.dart", prefix: "$locale");';

void writeLocaleListLibrary() {
  
  String localeString = Strings.join(localeList.map((locale) => '"$locale"'), ", ");
  
  var code = '''

#library("relative_time_locale_list");

const relativeTimeLocales = const [$localeString];
''';
  
    writeLibrary(localeLibPath, "list", code);
}

void writeLocaleLibrary(String locale, String imports, String logic) {
  String code = '''

#library("relative_time_locale_$locale");

#import("../src/internal.dart");
$imports

void init() {
$logic
}
''';

  writeLibrary(localeLibPath, locale, code);

}

writeLibrary(Path path, String name, String code) {
  writeFile(path.append("$name.dart"), code);
}

writeLocaleDataFile(String name, String code) {
  writeFile(localeLibPath.append("$name.dart"), code);
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
    _localeDataPath = libPath.append("src/data/relative_time/");
  }
  return _localeDataPath;
}

Path _libPath;
Path get libPath {
  if(_libPath === null) {
    var cwd = new Path(new Directory.current().path);
    var scriptPath = cwd.append(new Options().script).directoryPath;
    _libPath = scriptPath.append("lib");
  }
  return _libPath;
}

Map<String, Map> localeDataMap;
List<String> localeList;
Future getLocaleData() {
    var completer = new Completer<List<String>>();
    
    var lister = new Directory.fromPath(localeDataPath).list(false);
    
    lister.onFile = (String file) {
      String locale = file.replaceFirst(new RegExp(r"\.json$"), "");
      
      var filePath = localeDataPath.append("$locale.json");
      String json = readFile(filePath);
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
  var file = new File(filePath);
  return file.readAsTextSync();
}
