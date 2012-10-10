
library period;

import '../tempora.dart';

class Period {
  // exact
  static const int MONTHS_PER_YEAR = 12;
  static const int DAYS_PER_WEEK = 7;
  static const int MINUTES_PER_HOUR = 60;
  static const int SECONDS_PER_MINUTE = 60;
  static const int SECONDS_PER_HOUR = SECONDS_PER_MINUTE * MINUTES_PER_HOUR;
  static const int MILLISECONDS_PER_HOUR = MILLISECONDS_PER_MINUTE * MINUTES_PER_HOUR;
  static const int MILLISECONDS_PER_MINUTE = MILLISECONDS_PER_SECOND * SECONDS_PER_MINUTE;
  static const int MILLISECONDS_PER_SECOND = 1000;

  // non-exact
  static const int STANDARD_DAYS_PER_YEAR = 365;
  static const int DAYS_PER_LEAP_YEAR = STANDARD_DAYS_PER_YEAR + 1;
  static const int STANDARD_HOURS_PER_DAY = 24;
  static const int STANDARD_MINUTES_PER_DAY = MINUTES_PER_HOUR * STANDARD_HOURS_PER_DAY;
  static const int STANDARD_SECONDS_PER_DAY = SECONDS_PER_HOUR * STANDARD_HOURS_PER_DAY;
  static const int STANDARD_MILLISECONDS_PER_DAY = MILLISECONDS_PER_HOUR * STANDARD_HOURS_PER_DAY;
  
  // averages
  static const num AVERAGE_DAYS_PER_YEAR = STANDARD_DAYS_PER_YEAR + 1/4 - 1/100 + 1/400;
  static const num AVERAGE_DAYS_PER_MONTH = AVERAGE_DAYS_PER_YEAR / MONTHS_PER_YEAR;
  static const num AVERAGE_WEEKS_PER_YEAR = AVERAGE_DAYS_PER_YEAR / DAYS_PER_WEEK;
  static const num AVERAGE_WEEKS_PER_MONTH = AVERAGE_DAYS_PER_MONTH / DAYS_PER_WEEK;

  static final ClockPeriod ZERO = const ClockPeriod();
  
  const Period([
    int years = 0, 
    int months = 0, 
    int weeks = 0, 
    int days = 0, 
    int hours = 0, 
    int minutes = 0, 
    int seconds = 0, 
    int milliseconds = 0]) : 

    months = years * MONTHS_PER_YEAR + months,

    days = weeks * DAYS_PER_WEEK + days,

    milliseconds = 
      hours * MILLISECONDS_PER_HOUR +
      minutes * MILLISECONDS_PER_MINUTE +
      seconds * MILLISECONDS_PER_SECOND +
      milliseconds;
  
  final int months, days, milliseconds;

  int get yearsFromMonths() => months ~/ MONTHS_PER_YEAR;
  int get weeksFromDays() => days ~/ DAYS_PER_WEEK;
  int get hoursFromMilliseconds() => milliseconds ~/ MILLISECONDS_PER_HOUR;
  int get minutesFromMilliseconds() => milliseconds ~/ MILLISECONDS_PER_MINUTE;
  int get secondsFromMilliseconds() => milliseconds ~/ MILLISECONDS_PER_SECOND;

  operator + (Period other) => 
    new Period(0, months + other.months, 0, days + other.days, milliseconds: milliseconds + other.milliseconds);
  operator - (Period other) => this + (- other);
  operator - () => new Period(0, -months, 0, -days, 0, 0, 0, -milliseconds);
  
  // non-exact
  int get inYears() => _inYears.floor().toInt();
  int get inMonths() => _inMonths.floor().toInt();
  int get inWeeks() => _inWeeks.floor().toInt();
  int get inDays() => _inDays.floor().toInt();
  int get inHours() => _inHours.floor().toInt();
  int get inMinutes() => _inMinutes.floor().toInt();
  int get inSeconds() => _inSeconds.floor().toInt();
  int get inMilliseconds() => _inMilliseconds.floor().toInt();
  int inUnit(TimeUnit unit) {
    switch(unit) {
      case TimeUnit.YEAR: return inYears;
      case TimeUnit.MONTH: return inMonths;
      case TimeUnit.WEEK: return inWeeks;
      case TimeUnit.DAY: return inDays;
      case TimeUnit.HOUR: return inHours;
      case TimeUnit.MINUTE: return inMinutes;
      case TimeUnit.SECOND: return inSeconds;
      case TimeUnit.MILLISECOND: return inMilliseconds;
    }
  }
  
  Duration unwrap() => new Duration(milliseconds: inMilliseconds);

  num get _inYears() => _inMonths / MONTHS_PER_YEAR;
  num get _inMonths() => months + (days + _millisecondsAsDays) / AVERAGE_DAYS_PER_MONTH;
  num get _inWeeks() => _inDays / DAYS_PER_WEEK;
  num get _inDays() => days + _monthsAsDays + _millisecondsAsDays;
  num get _inHours() => _inMilliseconds / MILLISECONDS_PER_HOUR;
  num get _inMinutes() => _inMilliseconds / MILLISECONDS_PER_MINUTE;
  num get _inSeconds() => _inMilliseconds / MILLISECONDS_PER_SECOND;
  num get _inMilliseconds() => milliseconds + (days + _monthsAsDays) * STANDARD_MILLISECONDS_PER_DAY;

  num get _monthsAsDays() => months * AVERAGE_DAYS_PER_MONTH;
  num get _millisecondsAsDays() => milliseconds / STANDARD_MILLISECONDS_PER_DAY;
  
}

// Period whose months and days are guaranteed to be 0, an exact Duration
class ClockPeriod extends Period implements Comparable {
  const ClockPeriod([
    int hours = 0, 
    int minutes = 0, 
    int seconds = 0, 
    int milliseconds = 0]) : super(0, 0, 0, 0, hours, minutes, seconds, milliseconds);
  ClockPeriod.wrap(Duration duration) : this(milliseconds: duration.inMilliseconds);

  int compareTo(ClockPeriod other) => milliseconds.compareTo(other.milliseconds);
  bool operator < (ClockPeriod other) => compareTo(other) < 0;
  bool operator <= (ClockPeriod other) => compareTo(other) <= 0;
  bool operator > (ClockPeriod other) => compareTo(other) > 0;
  bool operator >= (ClockPeriod other) => compareTo(other) >= 0;
  bool operator == (ClockPeriod other) => compareTo(other) == 0;
}
