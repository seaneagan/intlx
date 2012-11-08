
library relative_time_json_build;

import 'dart:io';
import 'dart:json';
import 'dart:uri';
import '../util.dart';
import 'package:intlx/intlx.dart';
import 'file:/C:/Users/se136c/dart/relative_time_intl/lib/src/plural/plural.dart';
import 'locale_data.dart';

final cldrTag = "unconfirmed";
final cldrUri = "http://i18ndata.appspot.com/cldr/tags/$cldrTag/";
String getLocaleUnitsUri(String locale) => "${cldrUri}main/$locale/units?depth=-1";

main() {
  print("starting");
  getLocaleData().then(writeJson);
  print("done");
}

void writeJson(Map<String, Map> localeDataMap) {
  localeDataMap.forEach((locale, unitsData){
    writeFile(localeDataPath.append("$locale.json"), cleanJson(locale, unitsData));
  });
}

String cleanJson(String locale, Map unitsData) {

  getUnits(String unitSuffix, [pluralitySuffix = '']) {
    var units = new Map<String, Map<String, String>>();
    for(var unit in TimeUnit.values) {
      var lowerCaseUnit = unit.toString().toLowerCase();
      var unitsKey = "$lowerCaseUnit$unitSuffix";
      if(unitsData.containsKey(unitsKey)) {
        var unitData = unitsData[unitsKey];
        var newUnitData = new Map<String, String>();
        for(String plurality in ["0", "1"]..addAll(PluralCategory.values.map((plurality) => plurality.toString()))) {
          var pluralityKey = "$plurality$pluralitySuffix";
          if(unitData.containsKey(pluralityKey)) {
            newUnitData[plurality] = unitData[pluralityKey];
          }
        }
        units[lowerCaseUnit] = newUnitData;
      }
    }
    return units;
  }
  
  var data = {
    "name": locale,
    "units": getUnits(''),
    "pastUnits": getUnits('-past'),
    "futureUnits": getUnits('-future'),
    "shortUnits": getUnits('', '-alt-short'),
  };
  
  return JSON.stringify(data);
  
}

Path _localeDataPath;
Path get localeDataPath {
  if(_localeDataPath === null) {
    _localeDataPath = libPath.append("src/data/relative_time");
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

Future getLocaleData() {

  var unitsRequests = <Future<String>> [];
  
  relativeTimeLocales.forEach((locale){
    unitsRequests.add(getUri(getLocaleUnitsUri(locale)));
  });
  
  var unitsRequestsFuture = Futures.wait(unitsRequests);
  
  return unitsRequestsFuture.transform((List<String> unitsBodies) {

    var localeDataMap = new Map<String, Map>();
    
    for(int i = 0; i < unitsBodies.length; i++) {
      localeDataMap[relativeTimeLocales[i]] = JSON.parse(unitsBodies[i]);
    }
    print("localeDataMap: $localeDataMap");
    return localeDataMap;
  });
}
