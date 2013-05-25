// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// internationalization APIs not yet in [the intl package](http://pub.dartlang.org/packages/intl).
library intlx;

import 'dart:math';
import 'package:intl/intl.dart';
import 'src/relative_time/relative_time_locale.dart';
import 'src/plural/plural.dart';
import 'src/iterable/iterable_locale.dart';
import 'src/relative_time/duration_converters.dart';
import 'src/cldr_template.dart';
import 'src/util.dart';

part 'src/relative_time/relative_time_format.dart';
part 'src/relative_time/time_unit.dart';
part 'src/plural/plural_format.dart';
part 'src/iterable/iterable_format.dart';
part 'src/format_length.dart';
part 'src/locale_data.dart';
