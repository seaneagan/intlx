
library util;

import 'dart:io';
import 'dart:uri';
import 'dart:utf';
import 'dart:json';
import 'package:http/http.dart';
import 'locale_data.dart';

String readFile(filePath) {
  var file = new File.fromPath(filePath);
  return file.readAsStringSync();
}

void writeFile(Path path, String content) {
  var targetFile = new File.fromPath(path);
  // TODO: replace below with following line when it works
  // targetFile.writeAsStringSync(content);
  targetFile.createSync();
  var raf = targetFile.openSync(FileMode.WRITE);
  raf.truncateSync(0);
  raf.writeStringSync(content);
  raf.flushSync();
  raf.close();
}

abstract class LibraryWriter {
  Map<String, Map> localeDataMap;
  List<String> localeList;
  String get type;
  String get symbolsClass;
  String get symbolsClassLibrary;

  Future getBuiltLocaleData();

  Future writeLibraries() {
    getBuiltLocaleData().then((localeDataMap) {
      this.localeDataMap = localeDataMap;
      print('localeDataMap: $localeDataMap');
      localeList = new List.from(localeDataMap.keys)..sort();
      writeLibrariesSync();
    });
  }

  void writeLibrariesSync(){
    writeSymbolLibraries();
    writeLocaleLibraries();
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
      print('localeDataMap[locale]: ${localeDataMap[locale]}');
      writeSymbolLibrary(locale, localeDataMap[locale]);
    }
  }

  void writeSymbolLibrary(String locale, Map data) {
    writeLibrary(localeSrcPath, locale, getSymbolLibraryCode(locale, data), getSymbolsLibraryIdentifier(locale));
  }

  String getSymbolLibraryCode(String locale, Map data) => '''
${getSymbolsClassLibraryImport()}

final symbols = new $symbolsClass(${getSymbolsConstructorArgs(locale, data)});
''';

  String getSymbolsConstructorArgs(String locale, Map data);

  String getSymbolsLibraryIdentifier(String locale) => "${type}_symbols_$locale";

  void writeSingleLocaleLibrary(String locale) {
    writeLocaleLibrary(
        locale,
        generateLocaleImport(locale),
        "$symbolsClass.map['$locale'] = ${getSymbolsLibraryIdentifier(locale)}.symbols;");
  }

  void writeAllLocaleLibrary() {
    writeLocaleLibrary("all", getAllLocaleLibraryImports(), getAllLocaleLibraryLogic());
  }
  String getAllLocaleLibraryImports() => Strings.join(localeList.mappedBy(generateLocaleImport).toList(), "\n");

  String getAllLocaleLibraryLogic() {
    var symbolsMap = <String, dynamic> {};
    localeList.forEach((String locale){
      symbolsMap[locale] = '${getSymbolsLibraryIdentifier(locale)}.symbols';
    });
    return '''
      var symbolsMap = $symbolsMap;
      symbolsMap.forEach((String locale, symbols) => $symbolsClass.map[locale] = symbols);''';
  }

  String generateLocaleImport(String locale) => "import 'package:intlx/src/$type/locale/$locale.dart' as ${getSymbolsLibraryIdentifier(locale)};";

  String getSymbolsClassLibraryImport() => "import 'package:intlx/src/$type/$symbolsClassLibrary.dart';";

  void writeLocaleListLibrary() {
    String localeListString = JSON.stringify(localeList);

    var code = '''
  const ${type}Locales = const <String> $localeListString;
  ''';

    writeLibrary(libPath.append("src/$type/"), "${type}_locale_list", code);
  }

  void writeLocaleLibrary(String locale, String imports, String logic) {
    String code = '''
  import 'package:intlx/src/internal.dart';
  $imports

  void init() {
  $logic
  }
  ''';

    writeLibrary(localeLibPath.append("$type/"), locale, code, "${type}_locale_$locale");
  }

  Path _localeSrcPath;
  Path get localeSrcPath {
    if(_localeSrcPath == null) {
      _localeSrcPath = libPath.append("src/$type/locale/");
    }
    return _localeSrcPath;
  }

  Path _localeDataPath;
  Path get localeDataPath {
    if(_localeDataPath == null) {
      _localeDataPath = libPath.append("src/data/$type");
    }
    return _localeDataPath;
  }

}

abstract class JsonSourcedLibraryWriter extends LibraryWriter {

  String get symbolsClassLibrary => 'symbols';
  Path get dataPath => localeDataPath.append(type);

  Future getBuiltLocaleData() {
    var localeDataMap = new Map<String, Map>();
    var completer = new Completer<Map<String, Map>>();

    var lister = new Directory.fromPath(dataPath).list();

    lister.onFile = (String file) {
      String locale = new Path.fromNative(file).filenameWithoutExtension;

      var filePath = dataPath.append("$locale.json");
      String json = readFile(filePath);
      print("json: $json");
      localeDataMap[locale] = JSON.parse(json);
    };

    lister.onDone = (completed) {
      if(completed) {
        completer.complete(localeDataMap);
      }
    };

    return completer.future;
  }

}

writeLibrary(Path path, String name, String code, [String identifier]) {
  if(identifier == null) identifier = name;
  String fullCode = '''
$generatedFileWarning

library $identifier;

$code''';
  writeFile(path.append("$name.dart"), fullCode);
}

Future<String> fetchUri(String uri) {
  var completer = new Completer();
  var connection = new HttpClient().getUrl(new Uri(uri));
  connection.onResponse = (HttpClientResponse response) {
    // var input = new StringInputStream(response.inputStream, Encoding.UTF_8);
    var input = response.inputStream;
    var listInput = new ListInputStream();
    input.onData = () {
      listInput.write(input.read());
    };
    input.onClosed = () {
      var charCodes = utf8ToCodepoints(listInput.read());
      var body = new String.fromCharCodes(charCodes);
      print("body: $body");
      completer.complete(body);
    };
  };
  connection.onError = (var e) {
    print("getUri error: $e");
  };
  return completer.future;
}

void writeLocaleJson(String type, String outputPath, String transformJson(String locale, String json)) {
  getLocaleData(type, baseLocales).then((localeJsonMap) => writeLocaleJsonFiles(localeDataPath.append(outputPath), localeJsonMap, transformJson));
}

void writeLocaleJsonFiles(Path path, Map<String, String> localeJsonMap, String transformJson(String locale, String json)) {
  localeJsonMap.forEach((locale, json){
    writeFile(path.append("$locale.json"), transformJson(locale, json));
    print("completed writing json file for $locale");
  });
}

const String generatedFileWarning = '''
/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"''';

Path _libPath;
Path get libPath {
  if(_libPath == null) {
    var packageRoot = new Path(new Directory.current().path);
    _libPath = packageRoot.append("lib");
  }
  return _libPath;
}

Path _localeLibPath;
Path get localeLibPath {
  if(_localeLibPath == null) {
    _localeLibPath = libPath.append("locale/");
  }
  return _localeLibPath;
}

Path _localeDataPath;
Path get localeDataPath {
  if(_localeDataPath == null) {
    _localeDataPath = libPath.append("src/data/");
  }
  return _localeDataPath;
}

final cldrTag = "unconfirmed";
final cldrUri = "http://i18ndata.appspot.com/cldr/tags/$cldrTag/";
String getCldrDataUri(String locale, String path) => "${cldrUri}main/$locale/$path?depth=-1";

Future getLocaleData(String path, List<String> locales) {

  var dataRequests = <Future<String>> [];

  locales.forEach((locale){
    dataRequests.add(fetchUri(getCldrDataUri(locale, path)));
  });

  var dataRequestsFuture = Future.wait(dataRequests);

  return dataRequestsFuture.then((List<String> unitsBodies) {

    var localeDataMap = new Map<String, String>();

    for(int i = 0; i < unitsBodies.length; i++) {
      localeDataMap[locales[i]] = unitsBodies[i];
    }
    print("localeDataMap: $localeDataMap");
    print("locale count: ${baseLocales.length}");
    print("localeDataMap length: ${localeDataMap.length}");
    return localeDataMap;
  });
}
