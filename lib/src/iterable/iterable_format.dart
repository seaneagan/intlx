
part of intlx;

class IterableFormat {
  IterableFormat({String locale}) : _locale = new IterableLocale(locale);

  String format(Iterable iterable) => _locale.format(iterable);

  final IterableLocale _locale;
}
