
library plural;

import '../internal.dart';
import 'package:intl/intl.dart';

abstract class PluralLocale {
  factory PluralLocale(String locale) {
    String verifiedLocale = Intl.verifiedLocale(locale, pluralLocales.contains);
    if(!pluralLocaleMap.containsKey(verifiedLocale)) {
      throw new ArgumentError('PluralLocale "$verifiedLocale" is not loaded');
    }
    return map[verifiedLocale];
  }

  final String locale;

  PluralCategory getPluralCategory(int n);

  static final map = <String, PluralLocale> {};
}

typedef PluralCategory PluralStrategy(int quantity);

class PluralLocaleImpl implements PluralLocale {
  const PluralLocaleImpl(this.locale, this._strategy);
  final String locale;
  final PluralStrategy _strategy;

  PluralCategory getPluralCategory(int n) => _strategy(n);
  toString() => "PluralLocale: $locale";
}

class PluralCategory {

  static const ZERO = const PluralCategory._("zero");
  static const ONE = const PluralCategory._("one");
  static const TWO = const PluralCategory._("two");
  static const FEW = const PluralCategory._("few");
  static const MANY = const PluralCategory._("many");
  static const OTHER = const PluralCategory._("other");

  const PluralCategory._(this._name);

  final String _name;

  String toString() => _name;

  static const values = const <PluralCategory> [ZERO, ONE, TWO, FEW, MANY, OTHER];
}
