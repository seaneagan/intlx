// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../cldr_data_proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:json' as json;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intlx/src/deprecated_locale_map.dart';

main() {
  new PluralDataProxy().proxy();
}

class PluralDataProxy extends CldrDataProxy {
  
  PluralDataProxy() : super(null, "plural");

  final availableCldrLocales = mainCldrLocales;
  
  Future fetch() {
    var pluralRulesUri = '${cldrBaseUri}supplemental/plurals/plurals?depth=-1';
    return http.read(pluralRulesUri).then((String jsonText) {
      var data = json.parse(jsonText);
      // add deprecated (renamed) locales, 
      // which are not present in CLDR plural data
      deprecatedLocaleMap.forEach((k, v) {
        if(data.containsKey(v)) data[k] = data[v];
      });
      
      return data;
      
      return constrainLocales(data.keys).fold({}, (map, locale) {
        map[locale] = data[locale];
        return map;
      });
    });
  }
  
  transformJson(String locale, var jsonObject) {
    toUpperCaseKeys(Map map) {
      var uc = {};
      map.forEach((k, v) {
        uc[k.toUpperCase()] = v;
      });
      return uc;
    }
    return jsonObject == '' ? 
      const <String, String> {} : 
      toUpperCaseKeys(jsonObject);
  }

}
