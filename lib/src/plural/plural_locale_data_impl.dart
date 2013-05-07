
part of locale_data_impl;

class PluralLocaleDataImpl extends LocaleDataImpl {
  PluralLocaleDataImpl(String locale, var getSymbols) : super(locale, getSymbols);
  SymbolsMap _getSymbolsMap() => PluralLocaleImpl.map;
}
