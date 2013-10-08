// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Internationalization APIs not yet in [the intl package][pkg].
///
/// [pkg]: http://pub.dartlang.org/packages/intl
library intlx;

import 'dart:math';
import 'package:intlx/src/relative_time/relative_time_locale.dart';
import 'package:intlx/src/plural/plural.dart';
import 'package:intlx/src/iterable/iterable_locale.dart';
import 'package:intlx/src/relative_time/duration_converters.dart';
import 'package:intlx/src/util.dart';

part 'src/relative_time/relative_time_format.dart';
part 'src/relative_time/time_unit.dart';
part 'src/plural/plural_format.dart';
part 'src/iterable/iterable_format.dart';
part 'src/format_length.dart';
part 'src/locale_data.dart';
