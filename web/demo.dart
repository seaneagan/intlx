// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.demo;

import 'dart:html';
import 'dart:convert';
//@MirrorsUsed(targets: 'dart.core.Iterable.keys', override: '*')
//import 'dart:mirrors';
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
class IntlxDemo extends PolymerElement {

  IntlxDemo.created() : super.created() {

    var propertyDependencies = {
      #locales: [#localeNames],
      #localeNames: [#selectedLocale],
      #defaultAgeFormat: [#selectedLocale],
      #secondsAgeFormat: [#selectedLocale],
      #durationFormat: [#selectedLocale, #durationFormatLength],
      #duration: [#durationFormat, #timeUnit, #timeUnitCount],
      #dateTime: [#selectedTime],
      #selectedLocale: [#selectedLocaleIndex]
    };

    propertyDependencies.forEach((property, dependencies) =>
        dependencies.forEach((dependency) =>
            onPropertyChange(this, dependency, () =>
                notifyChange(new PropertyChangeRecord(this, property, null, null)))));

    onPropertyChange(this, #selectedLocale, () => Intl.systemLocale = selectedLocale);
  }

  enteredView() {

    super.enteredView();

    HttpRequest.getString('packages/intlx/languages.json')
        .then((languagesJson) {
          var allLanguageNames = JSON.decode(languagesJson);
          localeNames = _filterLocaleNames(allLanguageNames);
        })
        .then((_) => findSystemLocale())
        .then((systemLocale) {
          var foundLocale = Intl.verifiedLocale(systemLocale, localeNames.keys.contains, onFailure: (_) => null);
          if(foundLocale != null) {
            selectedLocale = foundLocale;
          }
        });
  }

  final iterableCounts = [0, 1, 2, 5];
  final pluralCounts = [0, 1, 2];

  bool get applyAuthorStyles => true;

  @observable
  var selectedLocaleIndex = 0;

  String get selectedLocale {
    var locales = localeNames.keys;
    if(locales.length - 1 < selectedLocaleIndex) return 'en';
    return locales.elementAt(selectedLocaleIndex);
  }

  void set selectedLocale(String v) {
    selectedLocaleIndex = localeNames.keys.toList().indexOf(v);
  }

  @observable
  Map<String, String> localeNames = const {};

  Iterable<String> get locales => localeNames.keys;

  @observable
  var durationFormatLength = 1;

  @observable
  var timeUnit = 1;

  @observable
  var timeUnitCount = '60';

  // iterable
  var iterableData = iterable_data.ALL;
  String toStringCount(int count) => range(count, 1).toList().toString();

  // plural
  var pluralData = plural_data.ALL;
  get pluralFormat => new PluralFormat(pluralCases, locale: 'en_US', pattern: "{0}");
  var pluralCases = {
    "0": "no books",
    "one": "{0} book",
    "other": "{0} books"};
  String formatPlural(int plural) => pluralFormat.format(plural);

  // relative time
  var relativeTimeData = relative_time_data.ALL;

  // duration
  DurationFormat get durationFormat => new DurationFormat(locale: selectedLocale, length: FormatLength.values[durationFormatLength]);

  var timeUnits = TimeUnit.values.take(4).toList();

  Iterable<String> get timeUnitsToDisplay =>
      timeUnits.map((unit) => '${unit.toString().toLowerCase()}s');


  Iterable<String> get formatLengths =>
      FormatLength.values.map((formatLength) => formatLength.toString());

  String get duration => durationFormat.format(new RoundDuration(timeUnits[timeUnit], int.parse(timeUnitCount, onError: (_) => 0)).toDuration());

  // age
  get defaultAgeFormat => new AgeFormat(locale: selectedLocale);
  get secondsAgeFormat => new AgeFormat(locale: selectedLocale, rounder: new DurationRounder.staticUnit(TimeUnit.SECOND));

  get dateTimes => {
    'startOfYear()': soy,
    'startOfMonth()': som,
    'startOfDay()': sod,
    'new DateTime.now()': () => new DateTime.now(),
    'endOfDay()':  eod,
    'endOfMonth()': eom,
    'endOfYear()': eoy
  };

  get dateTimeLabels => dateTimes.keys;

  DateTime get dateTime => dateTimes.values.elementAt(selectedTime)();

  @observable
  var selectedTime = 3;

  DateTime sod() => _withNow((now) => new DateTime(now.year, now.month, now.day));
  DateTime som() => _withNow((now) => new DateTime(now.year, now.month));
  DateTime soy() => _withNow((now) => new DateTime(now.year));
  DateTime eod() => _withNow((now) => new DateTime(now.year, now.month, now.day + 1));
  DateTime eom() => _withNow((now) => new DateTime(now.year, now.month + 1));
  DateTime eoy() => _withNow((now) => new DateTime(now.year + 1));
  DateTime _withNow(transform) => transform(new DateTime.now());

  String mustachify(String content) => '{{$content}}';

}

@initMethod
loadLocaleData() {
  relative_time_data.ALL.load();
  iterable_data.ALL.load();
  plural_data.ALL.load();
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

@CustomTag('intlx-iterable-demo')
class IterableDemo extends PolymerElement {

  bool get applyAuthorStyles => true;

  @published
  String locale;

  @published
  int count;

  int get _countAsInt => count == null ? 0 : count;

  IterableDemo.created() : super.created() {
    onPropertyChange(this, #locale, _update);
  }

  enteredView() {
    super.enteredView();
    _update();
  }

  void _update() {
    if(shadowRoot != null) shadowRoot.setInnerHtml(_content);
  }

  IterableFormat get iterableFormat => new IterableFormat(
    locale: locale,
    onSeparator: (sep) => '<span class="text-muted">$sep</span>');

  String get _content {
    return bidiFormatter.wrapWithSpan(iterableFormat.format(range(_countAsInt, 1).map((i) => '<b class="text-info">$i</b>')), isHtml: true);
  }

  BidiFormatter bidiFormatter = new BidiFormatter.UNKNOWN(true);
}
