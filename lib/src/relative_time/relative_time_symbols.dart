// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library relative_time_symbols;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/relative_time/relative_time_locale_list.dart';
import 'package:intlx/src/util.dart';
import 'package:intl/intl.dart';

class RelativeTimeSymbols {
  final String name;
  final Map<String, Map<String, String>> units, shortUnits, pastUnits, futureUnits;

  RelativeTimeSymbols({this.name, units, shortUnits, pastUnits, futureUnits}) : 
    units = units,
    shortUnits = shortUnits,
    pastUnits = ifEmpty(pastUnits, units),
    futureUnits = ifEmpty(futureUnits, units);
    
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

  static var map = new SymbolsMap<RelativeTimeSymbols>(relativeTimeLocales);

}
