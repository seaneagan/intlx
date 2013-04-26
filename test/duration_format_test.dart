
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/relative_time/en.dart' as relative_time_en;

main() {
  group('DurationFormat', () {

    DurationFormat durationFormat;

    setUp(() {
      relative_time_en.init();
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
}

