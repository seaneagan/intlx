// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.demo;

import 'dart:html';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;
import 'package:intlx/iterable_locale_data.dart' as iterable_data;
import 'package:intlx/plural_locale_data.dart' as plural_data;
import 'package:intlx/src/relative_time/relative_time_locale_list.dart';
import 'package:intlx/src/deprecated_locale_map.dart';
import 'package:intlx/src/util.dart';
import 'package:polymer/polymer.dart';

@CustomTag('intlx-demo')
class IntlxDemo extends PolymerElement with ObservableMixin {

  created() {

    loadLocaleData();

    super.created();

    onPropertyChange(this, #selectedLocale, () => notifyProperty(this, #localeNames));
    onPropertyChange(this, #selectedLocale, () => notifyProperty(this, #durationFormat));
    onPropertyChange(this, #durationFormatLength, () => notifyProperty(this, #durationFormat));
    onPropertyChange(this, #durationFormat, () => notifyProperty(this, #duration));
    onPropertyChange(this, #timeUnit, () => notifyProperty(this, #duration));
    onPropertyChange(this, #timeUnitCount, () => notifyProperty(this, #duration));

    HttpRequest.getString('packages/intlx/languages.json').then((languagesJson) {
      var allLanguageNames = JSON.decode(languagesJson);
      localeNames = _filterLocaleNames(allLanguageNames);
    });
  }

  bool get applyAuthorStyles => true;

  var _selectedLocale = 'en';
  String get selectedLocale => _selectedLocale;
  selectLocale(_1, _2, AnchorElement target) {
    var locale = target.attributes['value'];
    Intl.systemLocale = _selectedLocale = locale;
    notifyProperty(this, #selectedLocale);
  }

  @observable
  Map<String, String> localeNames = const {};

  // iterable
  BidiFormatter bidiFormatter = new BidiFormatter.UNKNOWN(true);

  var iterableData = iterable_data.ALL;
  IterableFormat get iterableFormat => new IterableFormat(
    locale: selectedLocale,
    onSeparator: (sep) => '<span class="muted">$sep</span>');
  var counts = range(4);
  String formatCount(int count) => bidiFormatter.wrapWithSpan(iterableFormat.format(range(count, 1).map((i) => '<b class="text-info">$i</b>')), isHtml: true);
  String toStringCount(int count) => range(count, 1).toList().toString();

  // plural
  var pluralData = plural_data.ALL;
  get pluralFormat => new PluralFormat(pluralCases, locale: 'en_US', pattern: "{0}");
  var pluralCases = {
    "0": "no books",
    "one": "{0} book",
    "other": "{0} books"};
  String get formattedPlural => pluralFormat.format(plural);
  var plural = 0;

  // relative time
  var relativeTimeData = relative_time_data.ALL;
  // duration
  @observable
  var durationFormatLength = 1;

  DurationFormat get durationFormat => new DurationFormat(locale: selectedLocale, length: FormatLength.values[durationFormatLength]);

  @observable
  var timeUnit = 1;

  @observable
  var timeUnitCount = '60';

  String get duration => durationFormat.format(new RoundDuration(TimeUnit.values[timeUnit], int.parse(timeUnitCount, onError: (_) => 0)).toDuration());

  // age
  get defaultAgeFormat => new AgeFormat(locale: selectedLocale);
  get secondsAgeFormat => new AgeFormat(locale: selectedLocale, rounder: new DurationRounder.staticUnit(TimeUnit.SECOND));
  var dateTime = new DateTime.now();
  String _selectedTime = "3";
  String get selectedTime => _selectedTime;
  void set selectedTime (String v) {
    _selectedTime = v;
    var i = int.parse(v);
    var cases = [soy, som, sod, () => new DateTime.now(), eod, eom, eoy];
    dateTime = cases[i]();
  }
  DateTime sod() => _withNow((now) => new DateTime(now.year, now.month, now.day));
  DateTime som() => _withNow((now) => new DateTime(now.year, now.month));
  DateTime soy() => _withNow((now) => new DateTime(now.year));
  DateTime eod() => _withNow((now) => new DateTime(now.year, now.month, now.day + 1));
  DateTime eom() => _withNow((now) => new DateTime(now.year, now.month + 1));
  DateTime eoy() => _withNow((now) => new DateTime(now.year + 1));
  DateTime _withNow(transform) => transform(new DateTime.now());

  String mustachify(String content) => '{{$content}}';

  loadLocaleData() {
    relativeTimeData.load();
    iterableData.load();
    pluralData.load();
    findSystemLocale().then((locale) {
      var foundLocale = Intl.verifiedLocale(locale, _locales.contains, onFailure: (_) => null);
      if(foundLocale != null) {
        Intl.systemLocale = _selectedLocale = foundLocale;
      }
    });
  }

  pillClass(String locale) => locale == selectedLocale ? 'active' : '';
}

// locale data (use relative time for no particular reason since they're all the same)
var _locales = relativeTimeLocales;

Map<String, String> _filterLocaleNames(Map<String, String> localeNames) {
  var constrainedLocales = _locales
      .where((locale) => !deprecatedLocaleMap.containsKey(locale))
      .map((String locale) => Intl.verifiedLocale(
          locale,
          localeNames.containsKey,
          onFailure: (_) => null))
      .where((locale) => locale != null)
      .toList();
  constrainedLocales.sort((a, b) => localeNames[a].compareTo(localeNames[b]));
  return constrainedLocales.fold({}, (filtered, locale) {
    if(!filtered.containsKey(locale)) {
      filtered[locale] = localeNames[locale];
    }
    return filtered;
  });
}
