// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// DO NOT EDIT. This file is autogenerated by script, see
// "package:intl_data_gen/bin/intl_data_gen.dart"
// 
// Before checkin, this file could have been manually edited. This is
// to incorporate changes before we could correct CLDR. All manual
// modification must be documented in this section, and should be
// removed after those changes land to CLDR.
library intlx.plural.data.SMS;

import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/util.dart';

final symbols = new PluralLocaleImpl('sms', (int n) {
if(n == 1) return PluralCategory.ONE;
  else if(n == 2) return PluralCategory.TWO;
  else return PluralCategory.OTHER;
});

