// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library iterable_locale;

import 'package:intl/intl.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/src/symbols_map.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/cldr_template.dart';
import 'package:intlx/src/iterable/iterable_symbols.dart';
import 'package:intlx/src/util.dart';

class IterableLocale {
  final IterableSymbols _symbols;
  var _onSeparator;
  
  IterableLocale(String locale, this._onSeparator) :
    _symbols = IterableSymbols.map[locale];
  
  String format(Iterable iterable) {

    // 0 item case
    if(iterable.isEmpty) return "";

    // 1 item case
    if(iterable.length == 1) return iterable.first.toString();

    // general case

    // Make sure we have a List, so indexing is efficient, but avoid
    // unnecessary copying.
    var list = iterable is List ? iterable : iterable.toList();
    
    // Calculate end template
    SeparatorTemplate end = _symbols.end;
    if(list.length == 2 && _symbols.two != null) { 
      end = _symbols.two;
    }

    return _formatAll(end, list);
  }

  String _formatAll(SeparatorTemplate end, List list) {

    // A list of String parts to concatenate.
    // 
    // This gives O(n) performance, where n is list.length,
    // as opposed to creating intermediate Strings for each item addition, 
    // which would be O(n*log(n)).  The parts are stored in reverse, since the 
    // algorithm acts on the list in reverse, and it's much more efficient to 
    // add to the end of a List.
    var parts = [list.last];

    // Add parts for a given template and item.
    void _addItemParts(SeparatorTemplate template, var newItem) {
      parts.add(_onSeparator(template.separator));
      parts.add(newItem);
      if(template.head != null) parts.add(_onSeparator(template.head));
      if(template.tail != null) parts.insert(0, _onSeparator(template.tail));
    }

    var length = list.length;
    
    // end
    _addItemParts(end, list[length - 2]);
    
    if (length > 2) {
      
      var needsStart = length > 3;
      
      // middle
      var reversedMiddleItems = 
        (needsStart ? list.skip(1).toList() : list).reversed.skip(2);
      reversedMiddleItems.forEach((item) =>
        _addItemParts(_symbols.middle, item));
      
      // start
      if (needsStart) _addItemParts(_symbols.start, list.first);
    }

    // Re-reverse items and concatenate
    return parts.reversed.join();
  }

}
