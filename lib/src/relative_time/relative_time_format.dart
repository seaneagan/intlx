
part of intlx;

/// formats Durations
/// e.g. "2 hours"
class DurationFormat extends _RelativeTimeFormat<Duration> {

  DurationFormat({String locale, DurationRounder rounder: const DurationRounder(), FormatLength length: FormatLength.LONG}) : super(locale, rounder) {
    this._length = length;
  }

  String format(Duration duration) {
    return _locale.formatRoundDuration(_roundDuration(duration), _length);
  }

  FormatLength _length;
}

/// Formats Dates relative to now
/// e.g. "2 hours ago" or "In 2 hours"
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

/// Strategy for rounding Durations
class DurationRounder {
  // TODO: Build in some other common strategies
  const DurationRounder();

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

