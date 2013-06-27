// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.plural.plural;

import 'package:intl/intl.dart';
import 'package:intlx/src/util.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural_locale_list.dart';

part 'plural_category.dart';

abstract class PluralLocale {
  factory PluralLocale(String locale) {
    if(locale == null) locale = Intl.systemLocale;
    var pluralLocale = Intl.verifiedLocale(locale, pluralLocales.contains);
    return PluralLocaleImpl.map[pluralLocale];
  }

  final String locale;

  PluralCategory getPluralCategory(int n);

}

typedef PluralCategory PluralStrategy(int quantity);

class PluralLocaleImpl implements PluralLocale {
  const PluralLocaleImpl(this.locale, this._strategy);
  final PluralStrategy _strategy;
  final String locale;

  PluralCategory getPluralCategory(int n) => _strategy(n);
  toString() => "PluralLocale: $locale";
  static var map = new SymbolsMap<PluralLocaleImpl>(pluralLocales);
}
