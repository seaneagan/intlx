
library locale;

import 'symbols.dart';
import '../tempora.dart';
import 'internal.dart';
import 'plural.dart';

class RelativeTimeLocale {
  
  final RelativeTimeSymbols _symbols;
  final PluralLocale _pluralLocale;
  
  RelativeTimeLocale(String locale) : _symbols = lookupSymbols(locale), _pluralLocale = new PluralLocale();
  
  String formatUnits(Map<TimeUnit, int> units) {
    var unit = units.getKeys().iterator().next();
    var quantity = units[unit];
    var plurality = _pluralLocale.getPlurality(quantity);
    String symbol = _symbols.getUnitSymbol(unit, plurality);
    
    // TODO: possibly only support this with certain pluralities
    return symbol.replaceFirst("%d", quantity.toString());
  }
  
  String formatUnitsAge(Map<TimeUnit, int> units, bool isFuture) {
    String template = isFuture ? _symbols.future : _symbols.past;
    return template.replaceFirst("%s", formatUnits(units));
  }
  
}
