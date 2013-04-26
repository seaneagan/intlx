
library relative_time_locale;

import 'relative_time_symbols.dart';
import '../../intlx.dart';
import '../symbols_map.dart';
import '../plural/plural.dart';

class RelativeTimeLocale {

  RelativeTimeLocale(String locale) : _symbols = RelativeTimeSymbols.map[locale], _locale = locale;

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
