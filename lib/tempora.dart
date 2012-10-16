
library tempora;

import 'package:intl/intl.dart';

import 'src/locale.dart';
import 'src/period.dart';

/// Internationalizes Durations
/// e.g.
/// print(new DurationFormat("en").format(const Duration(hours: 2)); // "two hours"
class DurationFormat extends _RelativeTimeFormat<Duration> {
  
  DurationFormat([String locale, DurationRounder rounder = const DurationRounder(), this._formatLength = FormatLength.LONG]) : super(locale, rounder);
  
  String format(Duration duration) {
    return _locale.formatRoundDuration(_roundDuration(duration), _formatLength);
  }

  final FormatLength _formatLength;
}

/// Internationalizes the "age" of Dates
/// e.g.
/// print(new AgeFormat("en").format(new Date.now().subtract(const Duration(hours: 2))); // "two hours ago"
class AgeFormat extends _RelativeTimeFormat<Date> {

  AgeFormat([String locale, DurationRounder rounder = const DurationRounder()]) : super(locale, rounder);
    
  String format(Date date) {
    var age = new Date.now().difference(date);
    var isFuture = age.inMilliseconds.isNegative();
    if(isFuture) age = new Duration(milliseconds: -age.inMilliseconds);
    return _locale.formatRoundAge(_roundDuration(age), isFuture);
  }
}

/// Strategy for rounding Durations
class DurationRounder {
  // TODO: Build in some other common strategies
  const DurationRounder();

  /// Rounds a [Duration].
  RoundDuration roundDuration(Duration duration) {
    var period = new ClockPeriod.wrap(duration);
    var potentialUnits = [TimeUnit.YEAR, TimeUnit.MONTH, TimeUnit.WEEK, TimeUnit.DAY, TimeUnit.HOUR, TimeUnit.MINUTE];
    
    for(TimeUnit unit in potentialUnits) {
      var q = period.inUnit(unit);
      if(q > 0) {
        return new RoundDuration(unit, q);
      }
    }
    return new RoundDuration(TimeUnit.MINUTE, 0);
  }
}

/// A round Duration
class RoundDuration {
  const RoundDuration(this.unit, this.quantity);
  
  final TimeUnit unit;
  final int quantity;
}

/// Enum to represent time units
class TimeUnit implements Comparable {
  
  static const SECOND = const TimeUnit._("second", 0); 
  static const MINUTE = const TimeUnit._("minute", 1); 
  static const HOUR = const TimeUnit._("hour", 2); 
  static const DAY = const TimeUnit._("day", 3); 
  static const WEEK = const TimeUnit._("week", 4); 
  static const MONTH = const TimeUnit._("month", 5); 
  static const YEAR = const TimeUnit._("year", 6); 
  
  const TimeUnit._(this._name, this._index);
  
  int compareTo(TimeUnit other) => _index.compareTo(other._index);
  
  String toString() => _name;
  
  
  final String _name;
  final int _index;

  static const values = const <TimeUnit> [SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, YEAR];
}

/// Enum to represent format lengths.
class FormatLength {
  static const SHORT = const FormatLength._("SHORT", 0); 
  static const LONG = const FormatLength._("LONG", 1); 
  
  const FormatLength._(this._name, this._index);

  final String _name;
  final int _index;
}

abstract class _RelativeTimeFormat<T> {
  _RelativeTimeFormat([String locale, this._rounder]) : _locale = new RelativeTimeLocale(locale);
  abstract String format(T o);
  RoundDuration _roundDuration(Duration duration) => _rounder.roundDuration(duration);
  
  final RelativeTimeLocale _locale;
  final DurationRounder _rounder;
}
