
library tempora;

import 'package:intl/intl.dart';

import 'src/locale.dart';
import 'src/period.dart';

/// Internationalizes Durations
/// e.g.
/// print(new DurationFormat("en").format(const Duration(hours: 2)); // "two hours"
class DurationFormat extends _RelativeTimeFormat<Duration> {
  
  DurationFormat([String locale, DurationRounder rounder = const DurationRounder()]) : super(locale, rounder);
  
  String format(Duration duration) {
    _locale.formatUnits(_roundDuration(duration));
  }
}

/// Internationalizes the "age" of Dates
/// e.g.
/// print(new AgeFormat("en").format(new Date.now().subtract(const Duration(hours: 2))); // "two hours ago"
class AgeFormat extends _RelativeTimeFormat<Date> {

  AgeFormat([String locale, DurationRounder rounder = const DurationRounder()]) : super(locale, rounder);
    
  String format(Date date) {
    var age = date.difference(new Date.now());
    var isFuture = age.inMilliseconds.isNegative();
    _locale.formatUnitsAge(_roundDuration(age), isFuture);
  }
}

/// Strategy for rounding Durations
class DurationRounder {
  const DurationRounder();

  /// Rounds a [Duration] to a integer quantity of a single [TimeUnit].
  /// For now, the returned Map should only contain one [TimeUnit] 
  /// which should not be [TimeUnit.WEEK] or [TimeUnit.MILLISECOND].
  /// These restrictions may be lifted in the future.
  Map<TimeUnit, int> roundDuration(Duration duration) {
    var period = new ClockPeriod.wrap(duration);
    var potentialUnits = [TimeUnit.YEAR, TimeUnit.MONTH, TimeUnit.DAY, TimeUnit.HOUR, TimeUnit.MINUTE, TimeUnit.SECOND];
    
    for(TimeUnit unit in potentialUnits) {
      var q = period.inUnit(unit);
      if(q > 0 || unit == TimeUnit.SECOND) {
        var rounded = new Map<TimeUnit, int>();
        rounded[unit] = q;
        return rounded;
      }
    }
  }
}

/// Enum to represent time units
class TimeUnit {
  
  final String _name;
  
  static const MILLISECOND = const TimeUnit._("MILLISECOND"); 
  static const SECOND = const TimeUnit._("SECOND"); 
  static const MINUTE = const TimeUnit._("MINUTE"); 
  static const HOUR = const TimeUnit._("HOUR"); 
  static const DAY = const TimeUnit._("DAY"); 
  static const WEEK = const TimeUnit._("WEEK"); 
  static const MONTH = const TimeUnit._("MONTH"); 
  static const YEAR = const TimeUnit._("YEAR"); 
  
  const TimeUnit._(this._name);
  
  String toString() => _name;
}

abstract class _RelativeTimeFormat<T> {
  _RelativeTimeFormat([String locale, this._rounder]) : _locale = new RelativeTimeLocale(locale);
  abstract String format(T o);
  Map<TimeUnit, int> _roundDuration(Duration duration) => _rounder.roundDuration(duration);
  
  final RelativeTimeLocale _locale;
  final DurationRounder _rounder;
}

