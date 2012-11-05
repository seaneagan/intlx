
library relative_time_locale;

import 'symbols.dart';
import '../../tempora.dart';
import '../internal.dart';
import '../plural/plural.dart';

class RelativeTimeLocale {
  
  final RelativeTimeSymbols _symbols;
  final PluralLocale _pluralLocale;
  
  RelativeTimeLocale(String locale) : _symbols = lookupSymbols(locale), _pluralLocale = new PluralLocale(locale);
  
  String formatRoundDuration(RoundDuration roundDuration, FormatLength formatLength) =>
    _format((unit, plurality) => _symbols.getDurationSymbol(unit, plurality, formatLength), roundDuration);
  
  String formatRoundAge(RoundDuration roundAge, bool isFuture) =>
    _format((unit, plurality) => _symbols.getAgeSymbol(unit, plurality, isFuture), roundAge);
  
  String _format(_SymbolGetter symbolGetter, RoundDuration roundDuration) {
    String symbol;
    var quantity = roundDuration.quantity;
    if(quantity == 0 || quantity == 1) {
      symbol = symbolGetter(roundDuration.unit, quantity.toString());
    }
    if(symbol == null) {
      var plurality = _pluralLocale.getPlurality(quantity);
      symbol = symbolGetter(roundDuration.unit, plurality.toString());
    }
    return symbol.replaceFirst("{0}", quantity.toString());
  }
}

typedef String _SymbolGetter(TimeUnit unit, String plurality);
