// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.test.duration_format_test;

import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;

main() {
  group('DurationFormat', () {

    DurationFormat unit;

    setUp(() {
      relative_time_data.EN.load();
      unit = new DurationFormat(locale: "en");
    });

    test("0 seconds = 0 minutes", () => 
      expect(unit.format(new Duration(seconds: 0)), "0 minutes"));
    test("1 second = 0 minutes", () => 
      expect(unit.format(new Duration(seconds: 1)), "0 minutes"));
    test("1 minute = 1 minute", () => 
      expect(unit.format(new Duration(minutes: 1)), "1 minute"));
    test("59 minutes = 59 minutes", () => 
      expect(unit.format(new Duration(minutes: 59)), "59 minutes"));
    test("1 hour = 1 hour", () => 
      expect(unit.format(new Duration(hours: 1)), "1 hour"));
    test("23 hours = 23 hours", () => 
      expect(unit.format(new Duration(hours: 23)), "23 hours"));
    test("1 day = 1 day", () => 
      expect(unit.format(new Duration(days: 1)), "1 day"));
    test("6 days = 6 days", () => 
      expect(unit.format(new Duration(days: 6)), "6 days"));
    test("7 days = 1 week", () => 
      expect(unit.format(new Duration(days: 7)), "1 week"));
    test("29 days = 4 weeks", () => 
      expect(unit.format(new Duration(days: 29)), "4 weeks"));
    test("30 days = 1 month", () => 
      expect(unit.format(new Duration(days: 30)), "1 month"));
    test("364 days = 11 months", () => 
      expect(unit.format(new Duration(days: 364)), "11 months"));
    test("365 days = 1 year", () => 
      expect(unit.format(new Duration(days: 365)), "1 year"));
    test("730 days = 2 years", () => 
      expect(unit.format(new Duration(days: 730)), "2 years"));
  });
}
