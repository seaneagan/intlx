// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of intlx;

/// Formats [Iterable]s.
/// See the [CLDR specification][1].
/// Data for at least one locale must be loaded using 
/// [iterable_locale_data.dart][2] before instantiating this class.
/// Example:
///     import 'package:intlx/intlx.dart';
///     import 'package:intlx/iterable_locale_data.dart' as iterable_data;
///     
///     var localeData = iterable_data.EN; // english locale
///     localeData.load();
///     var iterableFormat = new IterableFormat(locale: localeData.locale);
///     print(iterableFormat.format([])); // ""
///     print(iterableFormat.format([1])); // "1"
///     print(iterableFormat.format([1, 2])); // "1 and 2"
///     print(iterableFormat.format([1, 2, 3])); // "1, 2, and 3"
/// [1]: http://cldr.unicode.org/translation/lists
/// [2]: iterable_locale_data.dart
class IterableFormat {
  /// The [locale] parameter defaults to [Intl.systemLocale].
  /// The [onSeparator] parameter transforms separators produced by [format], 
  /// for example to add HTML styling, strip whitespace, etc.
  /// To map actual Iterable items passed to [format], just use [Iterable.map].
  IterableFormat({String locale, Unary<String, String> onSeparator: noop}) : 
    _locale = new IterableLocale(locale, onSeparator);

  String format(Iterable iterable) => _locale.format(iterable);

  final IterableLocale _locale;
}
