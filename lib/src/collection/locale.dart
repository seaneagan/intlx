
library collection_locale;

import 'symbols.dart';
import '../../intlx.dart';
import '../internal.dart';
import '../plural/plural.dart';

class CollectionLocale {

  CollectionLocale(String locale) : _symbols = CollectionSymbols.map[locale], _locale = locale;

  String format(Collection collection) {
    var list = new List.from(collection);
    if(_symbols.indexed.containsKey(list.length.toString())) return _formatCustom(_symbols.indexed[list.length.toString()], list);
    return _formatAll(list);
  }

  String _formatCustom(String format, List elements) {
    var element, result;
    if (elements.length > 1) {
      result = format.replace(new RegExp("\{(\d+)\}"), () {
        return RegExp.$1;
      });
//      if (isRtl) {
//        result = TwitterCldr.Bidi.from_string(result, {
//          "direction": "RTL"
//        }).reorder_visually().toString();
//      }
      return result.replace(new RegExp("(\d+)"), () => elements[int.parse(RegExp.$1)]);
    }
    return elements[0].toString();
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

  final CollectionSymbols _symbols;
  final String _locale;

}

ifNull(v, d) => v == null ? d : v;
