
library locale_data_impl;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/iterable/iterable_symbols.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/relative_time/relative_time_symbols.dart';
import 'package:intlx/src/symbols_map.dart';

part 'package:intlx/src/iterable/iterable_locale_data_impl.dart';
part 'package:intlx/src/plural/plural_locale_data_impl.dart';
part 'package:intlx/src/relative_time/relative_time_locale_data_impl.dart';

abstract class LocaleDataImpl implements LocaleData {
  final String locale;
  final _getSymbols;
  LocaleDataImpl(this.locale, this._getSymbols);
  void load() {
    _getSymbolsMap()[locale] = _getSymbols();
  }
  SymbolsMap _getSymbolsMap();
}

class AllLocaleDataImpl implements LocaleData {
  String get locale => 'ALL';
  final _setSymbolsMap;
  AllLocaleDataImpl(this._setSymbolsMap);
  void load() {
    _setSymbolsMap();
  }
}
