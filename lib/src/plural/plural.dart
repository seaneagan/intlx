
library plural;

import '../internal.dart';
import 'src/internal.dart';
import 'src/locale_list.dart';

abstract class PluralLocale {
  factory PluralLocale(String locale) {
    String verifiedLocale = getVerifiedLocale(locale, pluralLocales);
    if(!pluralLocaleMap.containsKey(verifiedLocale)) {
      throw new ArgumentError('PluralLocale does not support the locale: "$locale"');
    }
    return pluralLocaleMap[verifiedLocale];
  }
  
  final String locale;

  PluralCategory getPlurality(int n);
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
