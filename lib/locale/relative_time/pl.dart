/// DO NOT EDIT. This file is autogenerated by script.
/// See "intlx/tool/"

library relative_time_locale_pl;

  import '../../src/internal.dart';
  import 'package:intlx/src/relative_time/locale/pl.dart' as relative_time_symbols_pl;
    import '../plural/pl.dart' as plural_locale_pl;
  
  void init() {
    RelativeTimeSymbols.map['pl'] = relative_time_symbols_pl.symbols;
      plural_locale_pl.init();
  }
  