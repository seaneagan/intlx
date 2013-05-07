// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library plural;

import 'package:intl/intl.dart';
import 'package:intlx/src/util.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural_locale_list.dart';

part 'plural_category.dart';

abstract class PluralLocale {
  factory PluralLocale(String locale) {
    return PluralLocaleImpl.map[locale];
  }

  final String locale;

  PluralCategory getPluralCategory(int n);

}

typedef PluralCategory PluralStrategy(int quantity);

class PluralLocaleImpl implements PluralLocale {
  const PluralLocaleImpl(this.locale, this._strategy);
  final String locale;
  final PluralStrategy _strategy;

  PluralCategory getPluralCategory(int n) => _strategy(n);
  toString() => "PluralLocale: $locale";
  static final map = new SymbolsMap<PluralLocaleImpl>(pluralLocales);
}
