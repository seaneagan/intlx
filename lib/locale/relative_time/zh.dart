/// DO NOT EDIT. This file is autogenerated by script.
/// See "<this package>/tool/relative_time/code_build.dart"

library relative_time_locale_zh;

  import 'package:intlx/src/relative_time/relative_time_symbols.dart';
  import 'package:intlx/src/relative_time/locale/zh.dart' as relative_time_symbols_zh;
    import '../plural/zh.dart' as plural_locale_zh;

  void init() {
    RelativeTimeSymbols.map['zh'] = relative_time_symbols_zh.symbols;
      plural_locale_zh.init();
  }
  