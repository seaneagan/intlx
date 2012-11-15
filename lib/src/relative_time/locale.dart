
library relative_time_locale;

import 'symbols.dart';
import '../../intlx.dart';
import '../internal.dart';
import '../plural/plural.dart';

class RelativeTimeLocale {

  final RelativeTimeSymbols _symbols;
  // final PluralLocale _pluralLocale;
  final String _locale;

  RelativeTimeLocale(String locale) : _symbols = lookupSymbols(locale), _locale = locale;

  String formatRoundDuration(RoundDuration roundDuration, FormatLength formatLength) =>
    _format(formatLength == FormatLength.SHORT ? _symbols.shortUnits : _symbols.units, roundDuration);

  String formatRoundAge(RoundDuration roundAge, bool isFuture) =>
    _format(isFuture ? _symbols.futureUnits : _symbols.pastUnits, roundAge);

  String _format(Map<String, Map<String, String>> units, RoundDuration roundDuration) {
    var cases = units[roundDuration.unit.toString()];
    var pluralFormat = new PluralFormat(cases, locale: _locale, pattern: "{0}");
    return pluralFormat.format(roundDuration.quantity);
  }
}
