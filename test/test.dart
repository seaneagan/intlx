
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/relative_time/en.dart' as en;

main() {

  DurationFormat durationFormat;
  TimelineFormat timelineFormat;
  PluralFormat pluralFormat;
  en.init();

  group('DurationFormat', () {

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

  group('TimelineFormat', () {

    setUp(() {
      timelineFormat = new TimelineFormat(locale: "en");
    });

    test("In 2 minutes", () => expect(timelineFormat.format(new Date.now().add(new Duration(minutes: 2, seconds: 30))), "In 2 minutes"));
    test("5 hours ago", () => expect(timelineFormat.format(new Date.now().subtract(new Duration(hours: 5))), "5 hours ago"));
    test("now is past", () => expect(timelineFormat.format(new Date.now()), "0 minutes ago"));
  });

  group('PluralFormat', () {

    setUp(() {
      pluralFormat = new PluralFormat({"0": "no books", "one": "{0} book", "other": "{0} books"}, locale: "en", pattern: "{0}");
    });

    test("Cases for exact integers work", () => expect(pluralFormat.format(0)), "no books");
    test("'one' case", () => expect(pluralFormat.format(0)), "1 book");
    test("'other' case", () => expect(timelineFormat.format(new Date.now()), "5 books");
  });
}