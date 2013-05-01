
import '../cldr_data_proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:json' as json;
import 'dart:async';
import 'package:intl/intl.dart';

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
      // add deprecated (renamed) locales, which are not present in CLDR plural data
      deprecatedLocaleMap.forEach((k, v) {
        data[k] = data[v];
      });
      
      return data;
      
      return constrainLocales(data.keys).fold(<String, dynamic> {}, (map, locale) {
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
    return jsonObject == '' ? const <String, String> {} : toUpperCaseKeys(jsonObject);
  }

}

const deprecatedLocaleMap = const <String, String> {
  'iw': 'he',
  // 'ji': 'yi',
  'in': 'id'
};
