
/// internationalization APIs not yet in the intl package
library intlx;

import 'dart:math';
import 'src/relative_time/locale.dart';
import 'src/plural/plural.dart';
import 'src/collection/locale.dart';
import 'src/duration_converters.dart';

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

/// Enum to represent time units
class TimeUnit implements Comparable<TimeUnit> {

  // TODO: the names returned by should probably be uppercase to be forward compatible with enums
  static const SECOND = const TimeUnit._("SECOND", 0);
  static const MINUTE = const TimeUnit._("MINUTE", 1);
  static const HOUR = const TimeUnit._("HOUR", 2);
  static const DAY = const TimeUnit._("DAY", 3);
  static const WEEK = const TimeUnit._("WEEK", 4);
  static const MONTH = const TimeUnit._("MONTH", 5);
  static const YEAR = const TimeUnit._("YEAR", 6);

  const TimeUnit._(this._name, this._index);

  int compareTo(TimeUnit other) => _index.compareTo(other._index);

  String toString() => _name;

  final String _name;
  final int _index;

  static const values = const <TimeUnit> [SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, YEAR];
}

class PluralFormat {
  PluralFormat(this._cases, {String locale, String pattern}) : _locale = new PluralLocale(locale), _pattern = pattern;

  String format(int quantity) {
    var quantityString = quantity.toString();
    String key;
    if(_cases.containsKey(quantityString)) {
      key = quantityString;
    } else {
      var category = _locale.getPluralCategory(quantity).toString().toLowerCase();
      print("category: $category, _cases: $_cases");
      if(_cases.containsKey(category)) {
        key = category;
      } else {
        if(_cases.containsKey('other')) {
          key = 'other';
        } else {
          throw new Exception('No case found for quantity: $quantity');
        }
      }
    }
    var message = _cases[key];
    if(_pattern != null) {
      message = message.replaceFirst(_pattern, quantityString);
    }
    return message;

  }

  final Map<String, String> _cases;
  final String _pattern;
  final PluralLocale _locale;
}

class CollectionFormat {
  CollectionFormat({String locale}) : _locale = new CollectionLocale(locale);

  String format(Iterable collection) {
    return _locale.format(collection);
  }

  final CollectionLocale _locale;
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
  String format(T o);
  RoundDuration _roundDuration(Duration duration) => _rounder.roundDuration(duration);

  final RelativeTimeLocale _locale;
  final DurationRounder _rounder;
}

