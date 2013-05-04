
library iterable_symbols;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/iterable/iterable_locale_list.dart';

class IterableSymbols {

  final List _middle, _start, _end;
  final Map<String, List> indexed;

  List get start => ifNull(_start, middle);
  List get middle => ifNull(_middle, []);
  List get end =>  ifNull(_end, middle);

  const IterableSymbols({start, middle, end, this.indexed}) : _start = start, _middle = middle, _end = end;

  IterableSymbols.fromMap(Map map) : this(
    start: map["start"],
    middle: map["middle"],
    end: map["end"],
    indexed: map["indexed"]);
  
  static final map = new SymbolsMap<IterableSymbols>(iterableLocales);
  
}

// TODO: replace this with the resolution of http://dartbug.com/1236
ifNull(v, d) => v == null ? d : v;
