
library iterable_locale;

import 'iterable_symbols.dart';
import '../../intlx.dart';
import '../symbols_map.dart';
import '../plural/plural.dart';

class IterableLocale {

  IterableLocale(String locale) : _symbols = IterableSymbols.map[locale], _locale = locale;

  String format(Iterable iterable) {
    if(iterable.isEmpty) return "";
    if(iterable.length == 1) return iterable.single.toString();
    var list = iterable is List ? iterable : iterable.toList();
    var length = list.length.toString();
    if(_symbols.indexed.containsKey(length)) return _formatCustom(_symbols.indexed[length], list);
    return _formatAll(list);
  }

  String _formatCustom(String format, Iterable elements) {
    return format.splitMapJoin(new RegExp(r'\{(\d+)\}'), onMatch: (Match match) {
      return elements.elementAt(int.parse(match.group(1))).toString();
    });
  }

  String _formatAll(List list) {
    var length = list.length;
    var result = _formatCustom(_symbols.end, list.skip(length - 2));
    if (length > 2) {
      var needsStart = length > 3;
      result = (needsStart ? list.skip(1).toList() : list).reversed.skip(2).fold(result, (result, item) {
        return _formatCustom(_symbols.middle, [item, result]);
      });
      if (needsStart) result = _formatCustom(_symbols.start, [list.first, result]);
    }
    return result;
  }

  final IterableSymbols _symbols;
  final String _locale;

}

