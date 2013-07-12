// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library iterable_symbols;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/iterable/iterable_locale_list.dart';
import 'package:intlx/src/util.dart';
import 'package:intlx/src/cldr_template.dart';

class IterableSymbols {

  final SeparatorTemplate middle, start, end, two;

  IterableSymbols({SeparatorTemplate start, SeparatorTemplate middle, this.end, this.two}) : 
    this.start = ifNull(start, middle),
    this.middle = middle;

  IterableSymbols.fromMap(Map map) : this(
    start: map["start"],
    middle: map["middle"],
    end: map["end"],
    two: map["two"]);
  
  static var map = new SymbolsMap<IterableSymbols>(iterableLocales);
  
}
