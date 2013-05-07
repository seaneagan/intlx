
/// Exposes [LocaleData] constants for use with [PluralFormat].
/// For example:
///     import 'package:intlx/plural_locale_data.dart' as plural_data;
///     main() {
///       plural_data.EN.load();
///       plural_data.DE.load();
///       // do something with PluralFormat
///     }
library plural_locale_data;

import 'package:intlx/intlx.dart';
import 'package:intlx/src/locale_data_impl.dart';
import 'package:intlx/src/plural/plural_symbols_data.dart';

part 'package:intlx/src/plural/plural_locale_data_constants.dart';
