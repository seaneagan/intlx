
part of intlx;

typedef R _Unary<T, R>(T);

class IterableFormat {
  IterableFormat({String locale, _Unary<String, String> mapSeparator: _noop}) : 
    _locale = new IterableLocale(locale, mapSeparator);
    // _mapSeparator = mapSeparator == null ? noop : mapSeparator;

  String format(Iterable iterable) => _locale.format(iterable);

  final IterableLocale _locale;
}

_noop(x) => x;
