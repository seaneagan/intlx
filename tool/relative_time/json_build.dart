
library relative_time_json_build;

import 'dart:io';
import 'dart:json' as json;
import 'package:intlx/intlx.dart';
import 'package:intlx/src/plural/plural.dart';
import '../util.dart';

main() {
  writeLocaleJson("units", "relative_time", transformJson);
}

String transformJson(String locale, String jsonText) {

  Map unitsData = json.parse(jsonText);

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
    "units": getUnits(''),
    "pastUnits": getUnits('-past'),
    "futureUnits": getUnits('-future'),
    "shortUnits": getUnits('', '-alt-short'),
  };

  return json.stringify(data);

}
