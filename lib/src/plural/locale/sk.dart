/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library plural_symbols_sk;

import '../plural.dart';

final symbols = new PluralLocaleImpl('sk', (int n) {
if(n == 1) return PluralCategory.ONE;
else if(([2, 3, 4].contains(n))) return PluralCategory.FEW;
else return PluralCategory.OTHER;
  });
