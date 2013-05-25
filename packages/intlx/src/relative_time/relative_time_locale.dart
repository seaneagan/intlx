// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library relative_time_locale;

import 'package:intl/intl.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/util.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/relative_time/relative_time_symbols.dart';

class RelativeTimeLocale {

  RelativeTimeLocale(String locale) : _symbols = RelativeTimeSymbols.map[locale], _locale = ifNull(locale, Intl.systemLocale);

  String formatRoundDuration(RoundDuration roundDuration, FormatLength formatLength) =>
    _format(formatLength == FormatLength.SHORT ? _symbols.shortUnits : _symbols.units, roundDuration);

  String formatRoundAge(RoundDuration roundAge, bool isFuture) =>
    _format(isFuture ? _symbols.futureUnits : _symbols.pastUnits, roundAge);

  String _format(Map<String, Map<String, String>> units, RoundDuration roundDuration) {
    var cases = units[roundDuration.unit.toString()];
    var pluralFormat = new PluralFormat(cases, locale: _locale, pattern: "{0}");
    return pluralFormat.format(roundDuration.quantity);
  }

  final RelativeTimeSymbols _symbols;
  final String _locale;
}
