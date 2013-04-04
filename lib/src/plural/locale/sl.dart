/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library plural_symbols_sl;

import 'package:intlx/src/plural/plural.dart';

final symbols = new PluralLocaleImpl('sl', (int n) {
if(n % 100 == 1) return PluralCategory.ONE;
else if(n % 100 == 2) return PluralCategory.TWO;
else if((range(2, 3).contains(n % 100))) return PluralCategory.FEW;
else return PluralCategory.OTHER;
  });