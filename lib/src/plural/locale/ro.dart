/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library plural_symbols_ro;

import '../plural.dart';

final symbols = new PluralLocaleImpl('ro', (int n) {
if(n == 1) return PluralCategory.ONE;
else if(n == 0 || n != 1 && ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19].contains(n % 100))) return PluralCategory.FEW;
else return PluralCategory.OTHER;
  });
