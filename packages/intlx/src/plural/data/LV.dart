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
library intlx.plural.data.LV;

import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/util.dart';

final symbols = new PluralLocaleImpl('lv', (int n) {
if(n == 0) return PluralCategory.ZERO;
  else if(n % 10 == 1 && n % 100 != 11) return PluralCategory.ONE;
  else return PluralCategory.OTHER;
});

