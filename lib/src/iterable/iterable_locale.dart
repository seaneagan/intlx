
library iterable_locale;

import 'iterable_symbols.dart';
import '../../intlx.dart';
import '../symbols_map.dart';
import '../plural/plural.dart';

class IterableLocale {
  final IterableSymbols _symbols;
  final String _locale;
  var _onSeparator;
  
  IterableLocale(String locale, this._onSeparator) : 
    _symbols = IterableSymbols.map[locale], 
    _locale = locale;
  
  String format(Iterable iterable) {
    // 0 item case
    if(iterable.isEmpty) return "";
    // 1 item case
    if(iterable.length == 1) return iterable.single.toString();
    // make sure we have a List, so indexing is efficient
    var list = iterable is List ? iterable : iterable.toList();
    var length = list.length.toString();
    // item count exception case
    if(_symbols.indexed.containsKey(length)) 
      return _substituteItems(_symbols.indexed[length], list);
    // general case
    return _formatAll(list);
  }

  String _substituteItems(List template, Iterable elements) => 
    template.map((e) => 
      e is int ? 
        elements.elementAt(e) : 
        _onSeparator(e)).join();

  String _formatAll(List list) {
    var length = list.length;
    var result = _substituteItems(_symbols.end, list.skip(length - 2));
    if (length > 2) {
      var needsStart = length > 3;
      var reversedMiddleItems = 
        (needsStart ? list.skip(1).toList() : list).reversed.skip(2);
      result = reversedMiddleItems.fold(result, (result, item) =>
        _substituteItems(_symbols.middle, [item, result]));
      if (needsStart) 
        result = _substituteItems(_symbols.start, [list.first, result]);
    }
    return result;
  }

}

//void walk(Iterable iterable, callback(item)) => iterable.forEach(f)
