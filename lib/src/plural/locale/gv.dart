/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library plural_symbols_gv;

import 'package:intlx/src/plural/plural.dart';

final symbols = new PluralLocaleImpl('gv', (int n) {
if((range(2, 1).contains(n % 10)) || n % 20 == 0) return PluralCategory.ONE;
else return PluralCategory.OTHER;
  });