// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;

main() {
  group('AgeFormat', () {

    AgeFormat ageFormat;

    setUp(() {
      relative_time_data.EN.load();
      ageFormat = new AgeFormat(locale: "en");
    });

    test("In 2 minutes", () => expect(ageFormat.format(new DateTime.now().add(new Duration(minutes: 2, seconds: 30))), "In 2 minutes"));
    test("5 hours ago", () => expect(ageFormat.format(new DateTime.now().subtract(new Duration(hours: 5))), "5 hours ago"));
    test("now is past", () => expect(ageFormat.format(new DateTime.now()), "0 minutes ago"));
  });
}

