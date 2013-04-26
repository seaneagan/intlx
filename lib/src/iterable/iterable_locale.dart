
library collection_locale;

import 'iterable_symbols.dart';
import '../../intlx.dart';
import '../symbols_map.dart';
import '../plural/plural.dart';

class IterableLocale {

  IterableLocale(String locale) : _symbols = IterableSymbols.map[locale], _locale = locale;

  String format(Iterable iterable) {
    if(iterable.isEmpty) return "";
    if(iterable.length == 1) return iterable.single.toString();
    var list = iterable.toList();
    var length = list.length.toString();
    if(_symbols.indexed.containsKey(length)) return _formatCustom(_symbols.indexed[length], list);
    return _formatAll(list);
  }

  String _formatCustom(String format, List elements) {
    var element, result;
    if (elements.length > 1) {
      return format.splitMapJoin(new RegExp(r'\{(\d+)\}'), onMatch: (Match match) {
        return elements[int.parse(match.group(1))].toString();
      });
//      if (isRtl) {
//        result = TwitterCldr.Bidi.from_string(result, {
//          "direction": "RTL"
//        }).reorder_visually().toString();
//      }
    }
    return elements.single.toString();
  }

  String _formatAll(List list) {
    var result = _formatCustom(ifNull(_symbols.end, ifNull(_symbols.middle, "")), [list[list.length - 2], list[list.length - 1]]);
    if (list.length > 2) {
      var format, _i = 3, _ref;
      for (var i = _i, _ref = list.length; 3 <= _ref ? _i <= _ref : _i >= _ref; i = 3 <= _ref ? ++_i : --_i) {
        format = i == list.length ? _symbols.start : _symbols.middle;
        format = ifNull(format, _symbols.middle);
        result = _formatCustom(ifNull(format, ""), [list[list.length - i], result]);
      }
    }
    return result;
  }

  final IterableSymbols _symbols;
  final String _locale;

}

ifNull(v, d) => v == null ? d : v;
