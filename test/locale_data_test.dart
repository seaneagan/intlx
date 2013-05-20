// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/src/iterable/iterable_locale_list.dart';
import 'package:intlx/src/relative_time/relative_time_locale_list.dart';
import 'package:intlx/src/plural/plural_locale_list.dart';
import 'package:intlx/iterable_locale_data.dart' as iterable_data;
import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;
import 'package:intlx/plural_locale_data.dart' as plural_data;

main() {
  group('LocaleData', () {

    group('iterable', () {

      setUp(() {
        iterable_data.ALL.load();
      });

      test("ALL", () => expect(getALLTest(
        iterableLocales, 
        ((String locale) => new IterableFormat(locale: locale).format([1, 2, 3]))), returnsNormally));
    });

    group('plural', () {

      setUp(() {
        plural_data.ALL.load();
      });

      test("ALL", () => expect(getALLTest(
        pluralLocales, 
        ((String locale) => new PluralFormat({"other": "{0} blah"}, locale: locale, pattern: "{0}").format(5000))), returnsNormally));
    });

    group('relative time', () {

      setUp(() {
        relative_time_data.ALL.load();
      });

      test("ALL", () => expect(getALLTest(
        relativeTimeLocales, 
        ((String locale) => new DurationFormat(locale: locale).format(const Duration(seconds: 90)))), returnsNormally));
    });
  });
}

getALLTest(Iterable<String> locales, test) => () => locales.forEach(test);
