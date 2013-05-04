
part of intlx;

/// Formats [Iterable]s.
/// See the [CLDR specification](http://cldr.unicode.org/translation/lists).
/// Example (english):
///     var iterableFormat = new IterableFormat();
///     print(iterableFormat.format([])); // ""
///     print(iterableFormat.format([1])); // "1"
///     print(iterableFormat.format([1, 2])); // "1 and 2"
///     print(iterableFormat.format([1, 2, 3])); // "1, 2, and 3"
class IterableFormat {
  /// The [locale] parameter defaults to [Intl.systemLocale].
  /// The [onSeparator] parameter transforms separators produced by [format], 
  /// for example to add HTML styling, strip whitespace, etc.
  /// To map actual Iterable items passed to [format], just use [Iterable.map].
  IterableFormat({String locale, _Unary<String, String> onSeparator: _noop}) : 
    _locale = new IterableLocale(locale, onSeparator);

  String format(Iterable iterable) => _locale.format(iterable);

  final IterableLocale _locale;
}

// TODO: there should a library to define common typedefs like this
typedef R _Unary<T, R>(T);
// TODO: there should be a library which defines common callbacks like this
_noop(x) => x;
