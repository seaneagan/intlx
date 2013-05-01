
import 'dart:io';
import 'dart:async';
import 'dart:json' as json;
import 'package:http/http.dart' as http;
import 'package_paths.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';

final cldrTag = "unconfirmed";
final cldrBaseUri = "http://i18ndata.appspot.com/cldr/tags/$cldrTag/";
final mainCldrLocales = json.parse(new File.fromPath(mainLocaleListFilePath).readAsStringSync());

class CldrDataProxy {
  final String _path;
  final String outputPath;
  final availableCldrLocales = mainCldrLocales;

  // TODO: is it necessary to artificially constrain the locales?
  Iterable<String> constrainLocales(Iterable<String> constraint) => constraint.map((locale) => Intl.verifiedLocale(locale, availableCldrLocales.contains)).toSet();
      
  CldrDataProxy(this._path, this.outputPath);

  Future proxy() => fetch().then(transform).then(store);

  Future fetch() {
    String getCldrDataUri(String locale) => "${cldrBaseUri}main/$locale/${_path}?depth=-1";
    var locales = constrainLocales(availableLocalesForDateFormatting).toList();
    var dataRequests = locales.map((locale) => http.read(getCldrDataUri(locale)));
  
    return Future.wait(dataRequests).then((List<String> unitsBodies) {
      return unitsBodies.asMap().keys.fold(new Map<String, dynamic>(), (localeDataMap, i){
        localeDataMap[locales[i]] = json.parse(unitsBodies[i]);
        return localeDataMap;
      });
    });
  }
  
  transform(Map<String, dynamic> localeJsonMap) => localeJsonMap.keys.fold(<String, String> {}, (map, locale) {
    map[locale] = json.stringify(transformJson(locale, localeJsonMap[locale]));
    return map;
  });

  transformJson(String locale, var jsonObject) => jsonObject;

  void store(Map<String, String> localeJsonMap) {
    localeJsonMap.forEach((locale, json){
      var dataFile = new File.fromPath(getLocaleDataFilePath(outputPath, locale));
      dataFile.writeAsStringSync(json);
    });
  }

}
