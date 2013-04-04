
library collection_symbols;

import '../../intlx.dart';
import '../internal.dart';
import '../plural/plural.dart';
import 'package:intl/intl.dart';
import 'collection_locale_list.dart';

class CollectionSymbols {
  final String start, middle, end;
  final Map<String, String> indexed;

  const CollectionSymbols({this.start, this.middle, this.end, this.indexed});

  CollectionSymbols.fromMap(Map map) : this(
    start: map["start"],
    middle: map["middle"],
    end: map["end"],
    indexed: map["indexed"]);
  
  static final map = new SymbolsMap<CollectionSymbols>(collectionLocales);
  
}
