// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// DO NOT EDIT. This file is autogenerated by script, see
/// "<this package>/tool/relative_time/code_build.dart"

library relative_time_locale_uk;

import 'package:intlx/src/relative_time/relative_time_symbols.dart';
import 'package:intlx/src/relative_time/locale/uk.dart' as relative_time_symbols_uk;
    import '../plural/uk.dart' as plural_locale_uk;

void init() {
    RelativeTimeSymbols.map['uk'] = relative_time_symbols_uk.symbols;
      plural_locale_uk.init();
}
  