// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of intlx;

/// Formats text into a plural form, given a quantity ([num]).
/// See the [CLDR specification][1].
/// Data for at least one locale must be loaded using 
/// [plural_locale_data.dart][2] before instantiating this class.
/// Example:
///     import 'package:intlx/intlx.dart';
///     import 'package:intlx/plural_locale_data.dart' as plural_data;
///     
///     var localeData = plural_data.EN; // english locale
///     localeData.load();
///     var pluralFormat = new PluralFormat({
///       "0": "no books", 
///       "one": "{0} book", 
///       "other": "{0} books"
///     }, locale: localeData.locale, pattern: "{0}");
///     print(pluralFormat.format(0)); // "no books"
///     print(pluralFormat.format(1)); // "1 books"
///     print(pluralFormat.format(2)); // "2 books"
/// [1]: http://cldr.unicode.org/index/cldr-spec/plural-rules
/// [2]: plural_locale_data.dart
class PluralFormat {

  /// The [cases] parameter maps plural category identifiers to templates,
  /// which may include [pattern], which will be substituted 
  /// by the [num] passed to format.
  /// The [locale] parameter defaults to [Intl.systemLocale].
  PluralFormat(Map<String, String> cases, {String locale, String pattern}) : 
    _cases = cases, 
    _locale = new PluralLocale(locale), 
    _pattern = pattern;
  
  String format(num quantity) {
    var quantityString = quantity.toString();
    String key;
    if(_cases.containsKey(quantityString)) {
      key = quantityString;
    } else {
      var category = 
        _locale.getPluralCategory(quantity).toString().toLowerCase();
      if(_cases.containsKey(category)) {
        key = category;
      } else {
        if(_cases.containsKey('other')) {
          key = 'other';
        } else {
          throw new Exception('No case found for quantity: $quantity');
        }
      }
    }
    var template = _cases[key];
    if(_pattern != null) {
      template = 
        template.splitMapJoin(_pattern, onMatch: (Match) => quantityString);
    }
    return template;

  }

  final Map<String, String> _cases;
  final String _pattern;
  final PluralLocale _locale;
}
