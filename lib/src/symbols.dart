
library symbols;

import '../tempora.dart';
import 'internal.dart';
import 'plural.dart';
import 'package:intl/intl.dart';

class RelativeTimeSymbols {
  final String name, past, future;
  final Map<String, Map<String, String>> units, pastUnits, futureUnits;
  
  const RelativeTimeSymbols([this.name, this.past, this.future, this.units, this.pastUnits = const {}, this.futureUnits = const {}]);
  
  RelativeTimeSymbols.fromMap(Map map) : this(
    map["name"],
    map["past"],
    map["future"],
    map["units"],
    map["pastUnits"],
    map["futureUnits"]);

  String getUnitSymbol(TimeUnit unit, Plurality plurality, [bool isFuture]) {
    var unitString = unit.toString();
    var _units = units;
    if(isFuture != null) {
      var _ageUnits = isFuture ? futureUnits : pastUnits;
      if(_units.containsKey(unitString)) _units = _ageUnits;
    }
    
    return _units[unitString][plurality.toString()];
  }

}
