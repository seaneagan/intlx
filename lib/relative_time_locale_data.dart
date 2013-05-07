
/// Exposes [LocaleData] constants for use with [DurationFormat] and [AgeFormat].
/// For example:
///     import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;
///     main() {
///       relative_timel_data.EN.load();
///       relative_time_data.DE.load();
///       // do something with DurationFormat and/or AgeFormat
///     }
library relative_time_locale_data;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/locale_data_impl.dart';
import 'package:intlx/src/relative_time/relative_time_symbols_data.dart';
import 'package:intlx/plural_locale_data.dart' as plural_locale_data;

part 'package:intlx/src/relative_time/relative_time_locale_data_constants.dart';
