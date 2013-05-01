/// DO NOT EDIT. This file is autogenerated by script, see
/// "<this package>/tool/plural/code_build.dart"/// 
/// Before checkin, this file could have been manually edited. This is
/// to incorporate changes before we could correct CLDR. All manual
/// modification must be documented in this section, and should be
/// removed after those changes land to CLDR.

library plural_symbols_mt;

import 'package:intlx/src/plural/plural.dart';

final symbols = new PluralLocaleImpl('mt', (int n) {
if(n == 1) return PluralCategory.ONE;
else if(n == 0 || (range(9, 2).contains(n % 100))) return PluralCategory.FEW;
else if((range(9, 11).contains(n % 100))) return PluralCategory.MANY;
else return PluralCategory.OTHER;
  });
