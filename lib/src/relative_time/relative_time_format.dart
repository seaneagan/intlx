
part of intlx;

/// Formats [Duration]s.
/// See the [CLDR specification](http://cldr.unicode.org/translation/plurals#TOC-Localized-Units).
/// Example (english):
///     var durationFormat = new DurationFormat();
///     print(durationFormat.format(const Duration(minutes: 150))); // "2 hours"
///     print(durationFormat.format(const Duration(seconds: 30))); // "0 minutes"
class DurationFormat extends _RelativeTimeFormat<Duration> {

  /// The [locale] parameter defaults to [Intl.systemLocale].
  /// For [rounder], see [DurationRounder]. 
  /// For [length], see [FormatLength].
  DurationFormat({String locale, DurationRounder rounder: const DurationRounder(), FormatLength length: FormatLength.LONG}) : super(locale, rounder) {
    this._length = length;
  }

  String format(Duration duration) {
    return _locale.formatRoundDuration(_roundDuration(duration), _length);
  }

  FormatLength _length;
}

/// Formats [Date]s relative to now.
/// See the [CLDR specification](http://cldr.unicode.org/translation/plurals#TOC-Past-and-Future).
/// Example (english):
///     var ageFormat = new AgeFormat();
///     var now = new DateTime.now();
///     print(ageFormat.format(now.add(const Duration(hours: 2))))); // "In 2 hours"
///     print(ageFormat.format(now.subtract(const Duration(hours: 2))))); // "2 hours ago"
class AgeFormat extends _RelativeTimeFormat<DateTime> {

  AgeFormat({String locale, DurationRounder rounder: const DurationRounder()}) : super(locale, rounder);

  String format(DateTime date) {
    var now = new DateTime.now();
    var milliseconds = now.millisecondsSinceEpoch - date.millisecondsSinceEpoch;
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
///     print(durationFormat.format(new Duration(minutes: 5))); // "0 days"
///     print(ageFormat.format(new DateTime.now().add(oneHundredDays))); // "In 100 days"
class DurationRounder {
  const DurationRounder();
  const factory DurationRounder.staticUnit(TimeUnit unit) = _StaticUnitDurationRounder;
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
  _RelativeTimeFormat([String locale, this._rounder]) : _locale = new RelativeTimeLocale(locale);
  String format(T o);
  RoundDuration _roundDuration(Duration duration) => _rounder.roundDuration(duration);

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
