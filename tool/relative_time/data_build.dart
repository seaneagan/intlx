// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:json' as json;
import 'package:intlx/intlx.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/cldr_template.dart';
import '../cldr_data_proxy.dart';

main() {
  new RelativeTimeDataProxy().proxy();
}

class RelativeTimeDataProxy extends CldrDataProxy {
  RelativeTimeDataProxy() : super("units", "relative_time");

  transformJson(String locale, Map unitsData) {

    getUnits(String unitSuffix, [pluralitySuffix = '']) {
      var units = new Map<String, Map<String, String>>();
      for(var unit in TimeUnit.values) {
        var unitString = unit.toString();
        var unitsKey = "${unitString.toLowerCase()}$unitSuffix";
        if(unitsData.containsKey(unitsKey)) {
          var unitData = unitsData[unitsKey];
          var newUnitData = new Map<String, String>();
          var pluralities = ["0", "1"]..addAll(
            PluralCategory.values.map((plurality) => 
              plurality.toString().toLowerCase()));
          for(String plurality in pluralities) {
            var pluralityKey = "$plurality$pluralitySuffix";
            if(unitData.containsKey(pluralityKey)) {
              newUnitData[plurality] = unitData[pluralityKey];
            }
          }
          units[unitString] = newUnitData;
        }
      }
      return units;
    }
  
    return {
      "units": getUnits(''),
      "pastUnits": getUnits('-past'),
      "futureUnits": getUnits('-future'),
      "shortUnits": getUnits('', '-alt-short'),
    };
  
  }
}