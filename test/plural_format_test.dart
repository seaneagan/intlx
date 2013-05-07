// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/plural_locale_data.dart' as plural_data;

main() {
  group('PluralFormat', () {

    PluralFormat pluralFormat;

    setUp(() {
      plural_data.EN.load();
      pluralFormat = new PluralFormat({"0": "no books", "one": "{0} book", "other": "{0} books"}, locale: "en", pattern: "{0}");
    });

    test("exact integer case", () => expect(pluralFormat.format(0), "no books"));
    test("'one' case", () => expect(pluralFormat.format(1), "1 book"));
    test("'other' case", () => expect(pluralFormat.format(5), "5 books"));
  });
}



