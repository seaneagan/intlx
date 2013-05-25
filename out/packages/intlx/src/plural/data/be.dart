// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// DO NOT EDIT. This file is autogenerated by script, see
// "intlx/tool/plural/code_build.dart"
// 
// Before checkin, this file could have been manually edited. This is
// to incorporate changes before we could correct CLDR. All manual
// modification must be documented in this section, and should be
// removed after those changes land to CLDR.
library plural_symbols_be;

  import 'package:intlx/src/util.dart';
  import 'package:intlx/src/plural/plural.dart';

final symbols = new PluralLocaleImpl('be', (int n) {
if(n % 10 == 1 && n % 100 != 11) return PluralCategory.ONE;
  else if((range(3, 2).contains(n % 10)) && !(range(3, 12).contains(n % 100))) return PluralCategory.FEW;
  else if(n % 10 == 0 || (range(5, 5).contains(n % 10)) || (range(4, 11).contains(n % 100))) return PluralCategory.MANY;
  else return PluralCategory.OTHER;
});
