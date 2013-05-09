// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library symbols_map;

import 'package:intl/src/intl_helpers.dart';
import 'package:intl/src/lazy_locale_data.dart';
import 'package:intl/intl.dart';
import 'package:intlx/intlx.dart';

class SymbolsMap<T> {
  final List<String> _localeList;
  final Map<String, T> _map;

  SymbolsMap(this._localeList, [Map<String, T> map]) :
    _map = map == null ? <String, T> {} : map;

  void operator []= (String locale, T symbols) {
    _map[locale] = symbols;
  }

  T operator [] (String locale) {
    locale = Intl.verifiedLocale(locale, (String locale) => 
      _localeList.contains(locale));
    if(!_map.containsKey(locale)) 
      throw new LocaleDataException(
        "Locale data has not been loaded for locale: '$locale'");
    return _map[locale];
  }
}
