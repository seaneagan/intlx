
library plural_internal;

import '../plural.dart';

typedef PluralCategory PluralStrategy(int quantity);

class PluralLocaleImpl implements PluralLocale {
  const PluralLocaleImpl(this.locale, this._strategy);
  final String locale;
  final PluralStrategy _strategy;

  PluralCategory getPlurality(int n) => _strategy(n);
  toString() => "PluralLocale: $locale";
}

var pluralLocaleMap = new Map<String, PluralLocale>();

void registerLocale(PluralLocale locale) {
  pluralLocaleMap[locale.locale] = locale;
}

PluralCategory RulelessPluralStrategy(int n) => PluralCategory.OTHER;
PluralCategory BasicPluralStrategy(int n) => (n == 1) ? PluralCategory.ONE : PluralCategory.OTHER;
PluralCategory ZeroOrOnePluralStrategy(int n) => (n == 0 || n == 1) ? PluralCategory.ONE : PluralCategory.OTHER;
PluralCategory RuPluralStrategy(int n) {
  if (n % 10 == 1 && !(n % 100 == 11)) {
    return PluralCategory.ONE;
  } else if ([2, 3, 4].contains(n % 10) && !([12, 13, 14].contains(n % 100))) {
    return PluralCategory.FEW;
  } else if (n % 10 == 0 || [5, 6, 7, 8, 9].contains(n % 10) || [11, 12, 13, 14].contains(n % 100)) {
    return PluralCategory.MANY;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory CsSkPluralStrategy(int n) {
if (n == 1) {
    return PluralCategory.ONE;
  } else if ([2, 3, 4].contains(n)) {
    return PluralCategory.FEW;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory ArPluralStrategy(int n) {
  if (n == 0) {
    return PluralCategory.ZERO;
  } else if (n == 1) {
    return PluralCategory.ONE;
  } else if (n == 2) {
    return PluralCategory.TWO;
  } else if ([3, 4, 5, 6, 7, 8, 9, 10].contains(n % 10)) {
    return PluralCategory.FEW;
  } else if ([11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99].contains(n % 100)) {
    return PluralCategory.MANY;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory FrPluralStrategy(int n) {
if ((n >= 0 && n <= 2) && n != 2) {
    return PluralCategory.ONE;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory PlPluralStrategy(int n) {
  if (n == 1) {
    return PluralCategory.ONE;
  } else if ([2, 3, 4].contains(n % 10) && !([12, 13, 14].contains(n % 100))) {
    return PluralCategory.FEW;
  } else if (n != 1 && [0, 1].contains(n % 10) || [5, 6, 7, 8, 9].contains(n % 10) || [11, 12, 13, 14].contains(n % 100)) {
    return PluralCategory.MANY;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory LtPluralStrategy(int n) {
  if ([2, 3, 4, 5, 6, 7, 8, 9].contains(n % 10) && !([11, 12, 13, 14, 15, 16, 17, 18, 19].contains(n % 100))) {
    return PluralCategory.ONE;
  } else if (n % 10 == 1 && !([11, 12, 13, 14, 15, 16, 17, 18, 19].contains(n % 100))) {
    return PluralCategory.FEW;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory LvPluralStrategy(int n) {
  if(n == 0) {
    return PluralCategory.ZERO;
  } else if (n % 10 == 1 && !(n % 100 == 11)) {
    return PluralCategory.ONE;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory MtPluralStrategy(int n) {
  if (n == 1) {
    return PluralCategory.ONE;
  } else if (n == 0 || [2, 3, 4, 5, 6, 7, 8, 9, 10].contains(n % 100)) {
    return PluralCategory.FEW;
  } else if ([11, 12, 13, 14, 15, 16, 17, 18, 19].contains(n % 100)) {
    return PluralCategory.MANY;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory RoPluralStrategy(int n) {
  if (n == 1) {
    return PluralCategory.ONE;
  } else if (n == 0 || n != 1 && !([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19].contains(n % 100))) {
    return PluralCategory.FEW;
  } else {
    return PluralCategory.OTHER;
  }
}
PluralCategory SlPluralStrategy(int n) {
  if (n % 100 == 1) {
    return PluralCategory.ONE;
  } else if (n % 100 == 2) {
    return PluralCategory.TWO;
  } else if ([3, 4].contains(n % 100)) {
    return PluralCategory.FEW;
  } else {
    return PluralCategory.OTHER;
  }
}
