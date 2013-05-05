// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// DO NOT EDIT. This file is autogenerated by script, see
/// "<this package>/tool/relative_time/code_build.dart"

library relative_time_locale_ja;

import 'package:intlx/src/relative_time/relative_time_symbols.dart';
import 'package:intlx/src/relative_time/locale/ja.dart' as relative_time_symbols_ja;
    import '../plural/ja.dart' as plural_locale_ja;

void init() {
    RelativeTimeSymbols.map['ja'] = relative_time_symbols_ja.symbols;
      plural_locale_ja.init();
}
  