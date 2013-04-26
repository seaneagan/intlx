
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart';
import 'paths.dart';
import 'locale_data.dart';

Future<String> fetchUri(String uri) => get(uri).then((Response response) => response.body);

void fetchAndWriteCldrData(String type, String outputPath, String transformJson(String locale, String json)) {
  fetchCldrData(type, baseLocales).then((localeJsonMap) => writeCldrData(localeDataPath.append(outputPath), localeJsonMap, transformJson));
}

void writeCldrData(Path path, Map<String, String> localeJsonMap, String transformJson(String locale, String json)) {
  localeJsonMap.forEach((locale, json){
    var targetFile = new File.fromPath(path.append("$locale.json"));
    targetFile.writeAsStringSync(transformJson(locale, json));
  });
}

final cldrTag = "unconfirmed";
final cldrUri = "http://i18ndata.appspot.com/cldr/tags/$cldrTag/";

Future fetchCldrData(String path, List<String> locales) {
  String getCldrDataUri(String locale, String path) => "${cldrUri}main/$locale/$path?depth=-1";

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
    return localeDataMap;
  });
}
