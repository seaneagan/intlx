/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library relative_time_locale_hi;

  import 'package:intlx/src/internal.dart';
  import 'package:intlx/src/relative_time/symbols.dart';
  import 'package:intlx/src/relative_time/locale/hi.dart' as relative_time_symbols_hi;
    import '../plural/hi.dart' as plural_locale_hi;

  void init() {
    RelativeTimeSymbols.map['hi'] = relative_time_symbols_hi.symbols;
      plural_locale_hi.init();
  }
  