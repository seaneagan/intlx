// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Exposes [DataSet]s which can be extracted from Cldr.
library cldr.data_sets;

import 'package:cldr/cldr.dart';
import 'package:cldr/src/data_set_impl.dart';

final DataSet calendarData = new SupplementalDataSet("calendarData");

final DataSet calendarPreferenceData = new SupplementalDataSet("calendarPreferenceData");

final DataSet characterFallbacks = new SupplementalDataSet("characterFallbacks", segment: "characters");

final DataSet characters = new MainDataSet("characters");

final DataSet codeMappings = new SupplementalDataSet("codeMappings");

final DataSet currencies = new MainDataSet("currencies");

final DataSet currencyData = new SupplementalDataSet("currencyData");

final DataSet dateFields = new MainDataSet("dateFields");

final DataSet dayPeriods = new SupplementalDataSet("dayPeriods", segment: "dayPeriodRuleSet");

final DataSet delimiters = new MainDataSet("delimiters");

final DataSet gender = new SupplementalDataSet("gender");

final DataSet languageData = new SupplementalDataSet("languageData");

final DataSet languageMatching = new SupplementalDataSet("languageMatching");

final DataSet languages = new MainDataSet("languages", parentSegments: ["localeDisplayNames"]);

final DataSet layout = new MainDataSet("layout");

final DataSet likelySubtags = new SupplementalDataSet("likelySubtags");

final DataSet listPatterns = new MainDataSet("listPatterns");

final DataSet localeDisplayNames = new MainDataSet("localeDisplayNames");

final DataSet measurementData = new SupplementalDataSet("measurementData");

final DataSet measurementSystemNames = new MainDataSet("measurementSystemNames", parentSegments: ["localeDisplayNames"]);

final DataSet metaZones = new SupplementalDataSet("metaZones");

final DataSet numberingSystems = new SupplementalDataSet("numberingSystems");

final DataSet numbers = new MainDataSet("numbers", parentSegments: ["currenties"]);

final DataSet ordinals = new SupplementalDataSet("ordinals");

final DataSet parentLocales = new SupplementalDataSet("parentLocales");

final DataSet plurals = new SupplementalDataSet("plurals");

final DataSet posix = new MainDataSet("posix");

final DataSet postalCodeData = new SupplementalDataSet("postalCodeData");

final DataSet primaryZones = new SupplementalDataSet("primaryZones");

final DataSet references = new SupplementalDataSet("references");

final DataSet scripts = new MainDataSet("scripts", parentSegments: ["localeDisplayNames"]);

final DataSet telephoneCodeData = new SupplementalDataSet("telephoneCodeData");

final DataSet territories = new MainDataSet("territories", parentSegments: ["localeDisplayNames"]);

final DataSet territoryContainment = new SupplementalDataSet("territoryContainment");

final DataSet territoryInfo = new SupplementalDataSet("territoryInfo");

final DataSet timeData = new SupplementalDataSet("timeData");

final DataSet timeZoneNames = new MainDataSet("timeZoneNames");

final DataSet units = new MainDataSet("units");

final DataSet variants = new MainDataSet("variants", parentSegments: ["localeDisplayNames"]);

final DataSet weekData = new SupplementalDataSet("weekData");

final DataSet windowsZones = new SupplementalDataSet("windowsZones");

final Map<CalendarSystem, DataSet> calendarSystems = {
  CalendarSystem.BUDDHIST: new CalendarDataSet("buddhist"),
  CalendarSystem.CHINESE: new CalendarDataSet("chinese"),
  CalendarSystem.COPTIC: new CalendarDataSet("coptic"),
  CalendarSystem.DANGI: new CalendarDataSet("dangi"),
  CalendarSystem.ETHIOPIC: new CalendarDataSet("ethiopic"),
  CalendarSystem.ETHIOPIC_AMETE_ALEM: new CalendarDataSet("ethiopic-amete-alem"),
  CalendarSystem.GENERIC: new CalendarDataSet("generic"),
  CalendarSystem.GREGORIAN: new CalendarDataSet("gregorian"),
  CalendarSystem.HEBREW: new CalendarDataSet("hebrew"),
  CalendarSystem.INDIAN: new CalendarDataSet("indian"),
  CalendarSystem.ISLAMIC: new CalendarDataSet("islamic"),
  CalendarSystem.ISLAMIC_CIVIL: new CalendarDataSet("islamic-civil"),
  CalendarSystem.JAPANESE: new CalendarDataSet("japanese"),
  CalendarSystem.PERSIAN: new CalendarDataSet("persian"),
  CalendarSystem.ROC: new CalendarDataSet("roc")
};

/// A [calendar system][wiki] for which Cldr has data.
/// [wiki]: http://en.wikipedia.org/wiki/Calendar#Calendar_systems
class CalendarSystem {
    
  final String _name;

  const CalendarSystem._(this._name);

  static const BUDDHIST = const CalendarSystem._('BUDDHIST');

  static const CHINESE = const CalendarSystem._('CHINESE');

  static const COPTIC = const CalendarSystem._('COPTIC');

  static const DANGI = const CalendarSystem._('DANGI');

  static const ETHIOPIC = const CalendarSystem._('ETHIOPIC');

  static const ETHIOPIC_AMETE_ALEM = const CalendarSystem._('ETHIOPIC_AMETE_ALEM');

  static const GENERIC = const CalendarSystem._('GENERIC');

  static const GREGORIAN = const CalendarSystem._('GREGORIAN');

  static const HEBREW = const CalendarSystem._('HEBREW');

  static const INDIAN = const CalendarSystem._('INDIAN');

  static const ISLAMIC = const CalendarSystem._('ISLAMIC');

  static const ISLAMIC_CIVIL = const CalendarSystem._('ISLAMIC_CIVIL');

  static const JAPANESE = const CalendarSystem._('JAPANESE');

  static const PERSIAN = const CalendarSystem._('PERSIAN');

  static const ROC = const CalendarSystem._('ROC');

  String toString() => 'CalendarSystem.$_name';
}

