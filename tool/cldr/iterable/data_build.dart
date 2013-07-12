// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.cldr.iterable.data_build;

import 'package:parsers/parsers.dart';
import '../cldr_data_proxy.dart';
import 'package:intlx/src/cldr_template.dart';
import 'package:intlx/src/util.dart';

main() => new IterableDataProxy().proxy();

class IterableDataProxy extends CldrDataProxy {
  IterableDataProxy() : super("listPatterns/listPattern", "iterable");

  transformJson(String locale, Map data) {
    // Make sure there are no "3" templates, Cldr claims to allow it,
    // but as of yet it hasn't appeared in the locales supported here.
    assert(!data.containsKey("3"));

    // Rename "2" to "two", a valid Dart identifier.
    if(data.containsKey("2")) {
      data = new Map.from(data);
      data["two"] = data["2"];
      data.remove("2");
    }
    
    return mapValues(data, SeparatorTemplate.parse);
  }
}
