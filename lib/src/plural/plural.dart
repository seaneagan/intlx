
library plural;

import '../internal.dart';
import 'package:intl/intl.dart';
import 'plural_locale_list.dart';

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

class PluralCategory {

  static const ZERO = const PluralCategory._("ZERO");
  static const ONE = const PluralCategory._("ONE");
  static const TWO = const PluralCategory._("TWO");
  static const FEW = const PluralCategory._("FEW");
  static const MANY = const PluralCategory._("MANY");
  static const OTHER = const PluralCategory._("OTHER");

  const PluralCategory._(this._name);

  final String _name;

  String toString() => _name;

  static const values = const <PluralCategory> [ZERO, ONE, TWO, FEW, MANY, OTHER];
}

Iterable<int> range(int length, [int start = 0]) => new Iterable.generate(length, (int index) => start + index);