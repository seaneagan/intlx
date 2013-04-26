
library plural;

import '../symbols_map.dart';
import 'package:intl/intl.dart';
import 'plural_locale_list.dart';

part 'plural_category.dart';

abstract class PluralLocale {
  factory PluralLocale(String locale) {
    String verifiedLocale = Intl.verifiedLocale(locale, pluralLocales.contains);
    if(!PluralLocaleImpl.map.containsKey(verifiedLocale)) {
      throw new ArgumentError('PluralLocale "$verifiedLocale" is not loaded');
    }
    return PluralLocaleImpl.map[verifiedLocale];
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
  static final map = <String, PluralLocale> {};
}

// TODO: find a better place for this
Iterable<int> range(int length, [int start = 0]) => new Iterable.generate(length, (int index) => start + index);
