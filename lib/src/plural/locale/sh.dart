/// DO NOT EDIT. This file is autogenerated by script.
/// See "<this package>/tool/plural/code_build.dart"

library plural_symbols_sh;

import 'package:intlx/src/plural/plural.dart';

final symbols = new PluralLocaleImpl('sh', (int n) {
if(n % 10 == 1 && n % 100 != 11) return PluralCategory.ONE;
else if((range(3, 2).contains(n % 10)) && !(range(3, 12).contains(n % 100))) return PluralCategory.FEW;
else if(n % 10 == 0 || (range(5, 5).contains(n % 10)) || (range(4, 11).contains(n % 100))) return PluralCategory.MANY;
else return PluralCategory.OTHER;
  });
