// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:parsers/parsers.dart';
import '../cldr_data_proxy.dart';
import 'package:intlx/src/cldr_template.dart';
import 'package:intlx/src/util.dart';

main() {
  new IterableDataProxy().proxy();
}

class IterableDataProxy extends CldrDataProxy {
  IterableDataProxy() : super("listPatterns/listPattern", "iterable");

  transformJson(String locale, Map unitsData) => 
    mapValues(unitsData, cldrTemplateParser.parse);
}
