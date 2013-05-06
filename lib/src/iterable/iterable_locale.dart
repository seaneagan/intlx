// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library iterable_locale;

import 'iterable_symbols.dart';
import '../../intlx.dart';
import '../symbols_map.dart';
import '../plural/plural.dart';
import 'package:intlx/src/cldr_template.dart';

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
      return renderCldrTemplate(_symbols.indexed[length], list, _onSeparator);
    // general case
    return _formatAll(list);
  }

  String _formatAll(List list) {
    var length = list.length;
    var result = renderCldrTemplate(_symbols.end, list.skip(length - 2),  _onSeparator);
    if (length > 2) {
      var needsStart = length > 3;
      var reversedMiddleItems = 
        (needsStart ? list.skip(1).toList() : list).reversed.skip(2);
      result = reversedMiddleItems.fold(result, (result, item) =>
          renderCldrTemplate(_symbols.middle, [item, result],  _onSeparator));
      if (needsStart) 
        result = renderCldrTemplate(_symbols.start, [list.first, result], _onSeparator);
    }
    return result;
  }

}
