
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/relative_time/en.dart' as relative_time_en;
import 'package:intlx/locale/collection/en.dart' as collection_en;
import 'package:intlx/src/duration_converters.dart';

class StaticUnitDurationRounder implements DurationRounder {
  const StaticUnitDurationRounder(this.unit);
  
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

main() {

  relative_time_en.init();
  collection_en.init();

  group('DurationFormat', () {

    DurationFormat durationFormat;

    setUp(() {
      durationFormat = new DurationFormat(locale: "en");
    });

    test("0 seconds = 0 minutes", () => expect(durationFormat.format(new Duration(seconds: 0)), "0 minutes"));
    test("1 second = 0 minutes", () => expect(durationFormat.format(new Duration(seconds: 1)), "0 minutes"));
    test("1 minute = 1 minute", () => expect(durationFormat.format(new Duration(minutes: 1)), "1 minute"));
    test("59 minutes = 59 minutes", () => expect(durationFormat.format(new Duration(minutes: 59)), "59 minutes"));
    test("1 hour = 1 hour", () => expect(durationFormat.format(new Duration(hours: 1)), "1 hour"));
    test("23 hours = 23 hours", () => expect(durationFormat.format(new Duration(hours: 23)), "23 hours"));
    test("1 day = 1 day", () => expect(durationFormat.format(new Duration(days: 1)), "1 day"));
    test("6 days = 6 days", () => expect(durationFormat.format(new Duration(days: 6)), "6 days"));
    test("7 days = 1 week", () => expect(durationFormat.format(new Duration(days: 7)), "1 week"));
    test("29 days = 4 weeks", () => expect(durationFormat.format(new Duration(days: 29)), "4 weeks"));
    test("30 days = 1 month", () => expect(durationFormat.format(new Duration(days: 30)), "1 month"));
    test("364 days = 11 months", () => expect(durationFormat.format(new Duration(days: 364)), "11 months"));
    test("365 days = 1 year", () => expect(durationFormat.format(new Duration(days: 365)), "1 year"));
    test("730 days = 2 years", () => expect(durationFormat.format(new Duration(days: 730)), "2 years"));
  });

  group('AgeFormat', () {

    AgeFormat ageFormat;

    setUp(() {
      ageFormat = new AgeFormat(locale: "en");
    });

    test("In 2 minutes", () => expect(ageFormat.format(new DateTime.now().add(new Duration(minutes: 2, seconds: 30))), "In 2 minutes"));
    test("5 hours ago", () => expect(ageFormat.format(new DateTime.now().subtract(new Duration(hours: 5))), "5 hours ago"));
    test("now is past", () => expect(ageFormat.format(new DateTime.now()), "0 minutes ago"));
  });

  group('DurationRounder', () {

    DurationFormat durationFormat;
    AgeFormat ageFormat;

    setUp(() {
      var dayRounder = const StaticUnitDurationRounder(TimeUnit.DAY);
      durationFormat = new DurationFormat(locale: "en", rounder: dayRounder);
      ageFormat = new AgeFormat(locale: "en", rounder: dayRounder);
    });

    test("5 minutes = 0 days", () => expect(durationFormat.format(new Duration(minutes: 5)), "0 days"));
    test("100 days ago", () => expect(ageFormat.format(new DateTime.now().subtract(new Duration(hours: Duration.HOURS_PER_DAY * 100))), "100 days ago"));
    test("In 100 days", () => expect(ageFormat.format(new DateTime.now().add(new Duration(hours: Duration.HOURS_PER_DAY * 100))), "In 100 days"));
  });

  group('PluralFormat', () {

    PluralFormat pluralFormat;

    setUp(() {
      pluralFormat = new PluralFormat({"0": "no books", "one": "{0} book", "other": "{0} books"}, locale: "en", pattern: "{0}");
    });

    test("exact integer case", () => expect(pluralFormat.format(0), "no books"));
    test("'one' case", () => expect(pluralFormat.format(1), "1 book"));
    test("'other' case", () => expect(pluralFormat.format(5), "5 books"));
  });

  group('CollectionFormat', () {

    CollectionFormat collectionFormat;

    setUp(() {
      collectionFormat = new CollectionFormat(locale: "en");
    });

    test("empty collection is empty string", () => expect(collectionFormat.format([]), ""));
    test("single item", () => expect(collectionFormat.format([1]), "1"));
    test("many items", () => expect(collectionFormat.format([1, 2, 3, "x", "y", "z"]), "1, 2, 3, x, y, and z"));
  });

}