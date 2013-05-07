
part of locale_data_impl;

class IterableLocaleDataImpl extends LocaleDataImpl {
  IterableLocaleDataImpl(String locale, var getSymbols) : super(locale, getSymbols);
  SymbolsMap _getSymbolsMap() => IterableSymbols.map;
}

