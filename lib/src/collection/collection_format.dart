
part of intlx;

class CollectionFormat {
  CollectionFormat({String locale}) : _locale = new CollectionLocale(locale);

  String format(Iterable collection) {
    return _locale.format(collection);
  }

  final CollectionLocale _locale;
}
