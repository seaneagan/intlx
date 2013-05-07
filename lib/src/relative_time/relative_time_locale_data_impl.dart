
part of locale_data_impl;

class RelativeTimeLocaleDataImpl extends LocaleDataImpl {
  LocaleData _pluralLocaleData;
  RelativeTimeLocaleDataImpl(String locale, var getSymbols, LocaleData pluralLocaleData) : super(locale, getSymbols) {
    this._pluralLocaleData = pluralLocaleData;
  }
  SymbolsMap _getSymbolsMap() => RelativeTimeSymbols.map;
  load() {
    super.load();
    _pluralLocaleData.load();
  }
}
