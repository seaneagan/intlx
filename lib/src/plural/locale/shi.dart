/// DO NOT EDIT. This file is autogenerated by script, see
/// "<this package>/tool/plural/code_build.dart"/// 
/// Before checkin, this file could have been manually edited. This is
/// to incorporate changes before we could correct CLDR. All manual
/// modification must be documented in this section, and should be
/// removed after those changes land to CLDR.

library plural_symbols_shi;

import 'package:intlx/src/plural/plural.dart';

final symbols = new PluralLocaleImpl('shi', (int n) {
if(((n >= 0 && n <= 1))) return PluralCategory.ONE;
else if((range(9, 2).contains(n))) return PluralCategory.FEW;
else return PluralCategory.OTHER;
  });
