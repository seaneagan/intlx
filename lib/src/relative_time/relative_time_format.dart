// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of intlx;

/// Formats [Duration]s.
/// See the [CLDR specification][1].
/// Data for at least one locale must be loaded using 
/// [relative_time_locale_data.dart][2] before instantiating this class.
/// Example:
///     import 'package:intlx/intlx.dart';
///     import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;
///     
///     var localeData = relative_time_data.EN; // english locale
///     localeData.load();
///     var df = new DurationFormat(locale: localeData.locale);
///     print(df.format(const Duration(minutes: 150))); // "2 hours"
///     print(df.format(const Duration(seconds: 30))); // "0 minutes"
/// [1]: http://cldr.unicode.org/translation/plurals#TOC-Localized-Units
/// [2]: relative_time_locale_data.dart
class DurationFormat extends _RelativeTimeFormat<Duration> {

  /// The [locale] parameter defaults to [Intl.systemLocale].
  /// For [rounder], see [DurationRounder]. 
  /// For [length], see [FormatLength].
  DurationFormat({
    String locale, 
    DurationRounder rounder: const DurationRounder(), 
    FormatLength length: FormatLength.LONG
  }) : super(locale, rounder) {
    this._length = length;
  }

  String format(Duration duration) {
    return _locale.formatRoundDuration(_roundDuration(duration), _length);
  }

  FormatLength _length;
}

/// Formats [DateTime]s relative to now.
/// See the [CLDR specification][1].
/// Data for at least one locale must be loaded using 
/// [relative_time_locale_data.dart][2] before instantiating this class.
/// Example:
///     import 'package:intlx/intlx.dart';
///     import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;
///     
///     var localeData = relative_time_data.EN; // english locale
///     localeData.load();
///     var ageFormat = new AgeFormat(locale: localeData.locale);
///     var now = new DateTime.now();
///     var twoHours = const Duration(hours: 2);
///     print(ageFormat.format(now.add(twoHours)))); // "In 2 hours"
///     print(ageFormat.format(now.subtract(twoHours)))); // "2 hours ago"
/// [1]: http://cldr.unicode.org/translation/plurals#TOC-Past-and-Future
class AgeFormat extends _RelativeTimeFormat<DateTime> {

  AgeFormat({
    String locale, 
    DurationRounder rounder: const DurationRounder()
  }) : super(locale, rounder);

  String format(DateTime date) {
    var now = new DateTime.now();
    var milliseconds = 
      now.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    var age = new Duration(milliseconds: milliseconds.abs());
    var isFuture = milliseconds.isNegative;
    return _locale.formatRoundAge(_roundDuration(age), isFuture);
  }
}

/// Strategy for rounding [Duration]s, used by 
/// [DurationFormat]s and [AgeFormat]s.
/// Example (english):
///     var dayRounder = const DurationRounder.staticUnit(TimeUnit.DAY);
///     var durationFormat = new DurationFormat(rounder: dayRounder);
///     var ageFormat = new AgeFormat(rounder: dayRounder);
///     var now = new DateTime.now();
///     print(durationFormat.format(new Duration(minutes: 5))); // "0 days"
///     print(ageFormat.format(now.add(oneHundredDays))); // "In 100 days"
class DurationRounder {
  const DurationRounder();
  const factory DurationRounder.staticUnit(TimeUnit unit) = 
    _StaticUnitDurationRounder;
  // TODO: Any other common strategies to include here?

  /// Rounds a [Duration].
  RoundDuration roundDuration(Duration duration) {
    TimeUnit unit;
    int q;
    if((q = inYears(duration)) > 0) { unit = TimeUnit.YEAR;
    } else if((q = min(inMonths(duration), 11)) > 0) { unit = TimeUnit.MONTH;
    } else if((q = inWeeks(duration)) > 0) { unit = TimeUnit.WEEK;
    } else if((q = duration.inDays) > 0) { unit = TimeUnit.DAY;
    } else if((q = duration.inHours) > 0) { unit = TimeUnit.HOUR;
    } else {
      unit = TimeUnit.MINUTE;
      q = duration.inMinutes;
    }
    return new RoundDuration(unit, q);
  }
}

/// A round Duration
class RoundDuration {
  const RoundDuration(this.unit, this.quantity);

  final TimeUnit unit;
  final int quantity;
}

abstract class _RelativeTimeFormat<T> {
  _RelativeTimeFormat([String locale, this._rounder]) : 
    _locale = new RelativeTimeLocale(locale);
  String format(T o);
  RoundDuration _roundDuration(Duration duration) => 
    _rounder.roundDuration(duration);

  final RelativeTimeLocale _locale;
  final DurationRounder _rounder;
}

class _StaticUnitDurationRounder implements DurationRounder {
  const _StaticUnitDurationRounder(this.unit);
  
  RoundDuration roundDuration(Duration duration) {
    int q;
    switch(unit) {
      case TimeUnit.YEAR: q = inYears(duration); break;
      case TimeUnit.MONTH: q = inMonths(duration); break;
      case TimeUnit.WEEK: q = inWeeks(duration); break;
      case TimeUnit.DAY: q = duration.inDays; break;
      case TimeUnit.HOUR: q = duration.inHours; break;
      case TimeUnit.MINUTE: q = duration.inMinutes; break;
      case TimeUnit.SECOND: q = duration.inSeconds; break;
    }
    return new RoundDuration(unit, q);
  }
  
  final TimeUnit unit;
}
