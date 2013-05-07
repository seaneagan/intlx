// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/iterable_locale_data.dart' as iterable_data;

main() {
  group('IterableFormat', () {

    IterableFormat iterableFormat;

    setUp(() {
      iterable_data.EN.load();
      iterableFormat = new IterableFormat(locale: "en");
    });

    test("0 items", () => expect(iterableFormat.format([]), ""));
    test("1 items", () => expect(iterableFormat.format([1]), "1"));
    test("2 items", () => expect(iterableFormat.format([1, "x"]), "1 and x"));
    test("many items", () => expect(
      iterableFormat.format([1, 2, 3, "x", "y", "z"]), 
      "1, 2, 3, x, y, and z"));

    group('onSeparator', () {

      setUp(() {
        iterableFormat = new IterableFormat(
          locale: "en", 
          onSeparator: (sep) => "<$sep>");
      });

      test("2 items", () => expect(
        iterableFormat.format([1, "x"]), 
        "1< and >x"));
      test("many items", () => expect(
        iterableFormat.format([1, 2, 3]), 
        "1<, >2<, and >3"));
    });
  });
}
