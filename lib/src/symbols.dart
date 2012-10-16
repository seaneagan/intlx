
library symbols;

import '../tempora.dart';
import 'internal.dart';
import 'plural.dart';
import 'package:intl/intl.dart';

class RelativeTimeSymbols {
  final String name;
  final Map<String, Map<String, String>> units, shortUnits, pastUnits, futureUnits;
  
  const RelativeTimeSymbols({this.name, this.units, this.shortUnits, this.pastUnits, this.futureUnits});
  
  RelativeTimeSymbols.fromMap(Map map) : this(
    map["name"],
    map["units"],
    map["shortUnits"],
    map["pastUnits"],
    map["futureUnits"]);

  String getDurationSymbol(TimeUnit unit, Plurality plurality, FormatLength formatLength) => 
      _getSymbol(formatLength == FormatLength.SHORT ? shortUnits : units, unit, plurality);

  String getAgeSymbol(TimeUnit unit, Plurality plurality, bool isFuture) => 
    _getSymbol(isFuture ? futureUnits : pastUnits, unit, plurality);
  
  String _getSymbol(Map<String, Map<String, String>> units, TimeUnit unit, Plurality plurality) {
    return units[unit.toString()][plurality.toString()];
  }

}
