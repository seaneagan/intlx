
library locale;

import 'symbols.dart';
import '../tempora.dart';
import 'internal.dart';
import 'plural.dart';

class RelativeTimeLocale {
  
  final RelativeTimeSymbols _symbols;
  final PluralLocale _pluralLocale;
  
  RelativeTimeLocale(String locale) : _symbols = lookupSymbols(locale), _pluralLocale = new PluralLocale();
  
  String formatRoundDuration(RoundDuration roundDuration, FormatLength formatLength) =>
    _format((unit, plurality) => _symbols.getDurationSymbol(unit, plurality, formatLength), roundDuration);
  
  String formatRoundAge(RoundDuration roundAge, bool isFuture) =>
    _format((unit, plurality) => _symbols.getAgeSymbol(unit, plurality, isFuture), roundAge);
  
  String _format(_SymbolGetter symbolGetter, RoundDuration roundDuration) {
    var plurality = _pluralLocale.getPlurality(roundDuration.quantity);
    String symbol = symbolGetter(roundDuration.unit, plurality);
    return symbol.replaceFirst("{0}", roundDuration.quantity.toString());
  }
}

typedef String _SymbolGetter(TimeUnit unit, Plurality plurality);
