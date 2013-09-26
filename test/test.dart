// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.test.test;

import 'duration_format_test.dart' as duration_format_test;
import 'age_format_test.dart' as age_format_test;
import 'duration_rounder_test.dart' as duration_rounder_test;
import 'iterable_format_test.dart' as iterable_format_test;
import 'plural_format_test.dart' as plural_format_test;
import 'locale_data_test.dart' as locale_data_test;

main() {
  duration_format_test.main();
  age_format_test.main();
  duration_rounder_test.main();
  iterable_format_test.main();
  plural_format_test.main();
  locale_data_test.main();
}
