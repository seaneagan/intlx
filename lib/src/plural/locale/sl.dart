/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library plural_symbols_sl;

import '../plural.dart';

final symbols = new PluralLocaleImpl('sl', (int n) {
if(n % 100 == 1) return PluralCategory.ONE;
else if(n % 100 == 2) return PluralCategory.TWO;
else if(([3, 4].contains(n % 100))) return PluralCategory.FEW;
else return PluralCategory.OTHER;
  });
