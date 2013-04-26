
library collection_symbols;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/iterable/iterable_locale_list.dart';

class IterableSymbols {
  final String start, middle, end;
  final Map<String, String> indexed;

  const IterableSymbols({this.start, this.middle, this.end, this.indexed});

  IterableSymbols.fromMap(Map map) : this(
    start: map["start"],
    middle: map["middle"],
    end: map["end"],
    indexed: map["indexed"]);
  
  static final map = new SymbolsMap<IterableSymbols>(iterableLocales);
  
}
