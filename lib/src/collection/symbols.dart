
library relative_time_symbols;

import '../../intlx.dart';
import '../internal.dart';
import '../plural/plural.dart';
import 'package:intl/intl.dart';

class RelativeTimeSymbols {
  final String name;
  final Map<String, Map<String, String>> units, shortUnits, pastUnits, futureUnits;

  const RelativeTimeSymbols({this.name, this.units, this.shortUnits, this.pastUnits, this.futureUnits});

  RelativeTimeSymbols.fromMap(Map map) : this(
    name: map["name"],
    units: map["units"],
    shortUnits: map["shortUnits"],
    pastUnits: map["pastUnits"],
    futureUnits: map["futureUnits"]);

  String getDurationSymbol(TimeUnit unit, String plurality, FormatLength formatLength) =>
      _getSymbol(formatLength == FormatLength.SHORT ? shortUnits : units, unit, plurality);

  String getAgeSymbol(TimeUnit unit, String plurality, bool isFuture) =>
    _getSymbol(isFuture ? futureUnits : pastUnits, unit, plurality);

  String _getSymbol(Map<String, Map<String, String>> units, TimeUnit unit, String plurality) {
    return units[unit.toString()][plurality];
  }

}
