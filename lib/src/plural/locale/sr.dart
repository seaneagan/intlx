/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library plural_symbols_sr;

import '../plural.dart';

final symbols = new PluralLocaleImpl('sr', (int n) {
if(n % 10 == 1 && n % 100 != 11) return PluralCategory.ONE;
else if(([2, 3, 4].contains(n % 10)) && !([12, 13, 14].contains(n % 100))) return PluralCategory.FEW;
else if(n % 10 == 0 || ([5, 6, 7, 8, 9].contains(n % 10)) || ([11, 12, 13, 14].contains(n % 100))) return PluralCategory.MANY;
else return PluralCategory.OTHER;
  });
