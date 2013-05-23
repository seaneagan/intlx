@observable
library intlx.age.example;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;
import 'package:intlx/iterable_locale_data.dart' as iterable_data;
import 'package:intlx/plural_locale_data.dart' as plural_data;
import 'package:intlx/src/relative_time/relative_time_locale_list.dart';
import 'package:intlx/src/deprecated_locale_map.dart';
import 'package:intlx/src/util.dart';

part 'locale_names.dart';

// locale data (use relative time for no particular reason since they're all the same)
var selectedLocale = 'en';
var locales = relativeTimeLocales;

// iterable
var iterableData = iterable_data.ALL;
get iterableFormat => new IterableFormat(locale: selectedLocale);
var counts = range(4);
String formatCount(int count) => iterableFormat.format(range(count, 1));
String toStringCount(int count) => range(count, 1).toList().toString();

// plural
var pluralData = plural_data.ALL;
get pluralFormat => new PluralFormat(pluralCases, locale: selectedLocale, pattern: "{0}");
var pluralCases = {
  "0": "no books", 
  "one": "{0} book", 
  "other": "{0} books"};
String get formattedPlural => pluralFormat.format(plural);
var plural = 0;

// relative time
var relativeTimeData = relative_time_data.ALL;
get secondsFormat => new AgeFormat(locale: selectedLocale, rounder: new DurationRounder.staticUnit(TimeUnit.SECOND));
get defaultFormat => new AgeFormat(locale: selectedLocale);
var dateTime = new DateTime.now().add(const Duration(seconds: 30));
DateTime sod() => _withNow((now) => new DateTime(now.year, now.month, now.day));
DateTime som() => _withNow((now) => new DateTime(now.year, now.month));
DateTime soy() => _withNow((now) => new DateTime(now.year));
DateTime eod() => _withNow((now) => new DateTime(now.year, now.month, now.day + 1));
DateTime eom() => _withNow((now) => new DateTime(now.year, now.month + 1));
DateTime eoy() => _withNow((now) => new DateTime(now.year + 1));
DateTime _withNow(transform) => transform(new DateTime.now());

pillClass(String locale) => locale == selectedLocale ? 'active' : '';

void main() {
  relativeTimeData.load();
  iterableData.load();
  pluralData.load();
  findSystemLocale().then((locale) {
    var foundLocale = Intl.verifiedLocale(locale, locales.contains, onFailure: (_) => null);
    if(foundLocale != null) {
      Intl.systemLocale = selectedLocale = foundLocale;
    }
  });
}
