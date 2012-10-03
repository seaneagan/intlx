
#library("relative_time_locale");

#import("symbols.dart");


class RelativeTimeLocale {
  
  final RelativeTimeSymbols _symbols;
  
  RelativeTimeLocale(String locale) : _symbols = new RelativeTimeSymbols(locale);
  
  String formatUnit(TimeUnit unit, int quantity) {
    bool isPlural = quantity == 1;
    String symbol = _symbols.getUnitSymbol(unit, isPlural);
    
    return isPlural ? symbol.replaceFirst("%d", quantity.toString()) : symbol;
  }
  
  String nowOffsetPhrase(String formattedDuration, bool isFuture) {
    String template = isFuture ? _sumbols.future : _symbols.past;
    return template.replaceFirst("%s", formattedDuration);
  }
}
