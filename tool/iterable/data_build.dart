// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:parsers/parsers.dart';
import '../cldr_data_proxy.dart';

main() {
  new IterableDataProxy().proxy();
}

class IterableDataProxy extends CldrDataProxy {
  IterableDataProxy() : super("listPatterns/listPattern", "iterable");

  transformJson(String locale, Map unitsData) => 
    mapValues(unitsData, listPatternParser.parse);

}

// parses list pattern into a List of content and substition indexes
// e.g. "{0}, {1}" -> [0, ", ", 1]
Parser get listPatternParser {
  if(_listPatternParser == null) {
    var bracedDigit = (digit ^ int.parse).between(char('{'), char('}'));
    var separator = anyChar.manyUntil(bracedDigit.lookAhead).record;
    _listPatternParser = (bracedDigit | separator).many;
  }
  return _listPatternParser;
}
Parser _listPatternParser;

// TODO: replace with resolution of http://dartbug.com/9590 
Map mapValues(Map map, valueMapper(key)) => map.keys.fold({}, (result, key) {
  result[key] = valueMapper(map[key]);
  return result;
});
