// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library iterable_symbols;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/iterable/iterable_locale_list.dart';
import 'package:intlx/src/util.dart';

class IterableSymbols {

  final List middle, start, end;
  final Map<String, List> indexed;

  IterableSymbols({start, middle, end, this.indexed}) : 
    this.start = ifNull(ifNull(start, middle), []), 
    this.middle = ifNull(middle, []), 
    this.end = ifNull(ifNull(end, middle), []);

  IterableSymbols.fromMap(Map map) : this(
    start: map["start"],
    middle: map["middle"],
    end: map["end"],
    indexed: map["indexed"]);
  
  static final map = new SymbolsMap<IterableSymbols>(iterableLocales);
  
}
