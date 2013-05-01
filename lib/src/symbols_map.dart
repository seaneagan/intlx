
library symbols_map;

import 'package:intl/src/intl_helpers.dart';
import 'package:intl/src/lazy_locale_data.dart';
import 'package:intl/intl.dart';
import 'package:intlx/intlx.dart';

class SymbolsMap<T> {
  SymbolsMap(this._localeList);

  void operator []= (String locale, T symbols) {
    _map[locale] = symbols;
  }

  T operator [] (String locale) {
    locale = Intl.verifiedLocale(locale, (String locale) => _localeList.contains(locale));
    if(!_map.containsKey(locale)) throw new LocaleDataException("Locale data has not been loaded for locale: '$locale'");
    return _map[locale];
  }

  final _map = <String, T> {};
  final List<String> _localeList;
}
