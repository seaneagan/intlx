
import '../lib/tempora.dart'; 
import '../lib/locale/en.dart' as en;
import 'package:intl/intl_standalone.dart';
import 'package:unittest/unittest.dart';

main() {

  DurationFormat durationFormat;
  en.init();

  group('DurationFormat', () {

    setUp(() {
      durationFormat = new DurationFormat("en");
    });
  
    test("0 seconds = a few seconds", () => expect(durationFormat.format(new Duration(seconds: 0)), "a few seconds"));
    test("59 seconds = a few seconds", () => expect(durationFormat.format(new Duration(seconds: 59)), "a few seconds"));
    test("1 minute = a minute", () => expect(durationFormat.format(new Duration(minutes: 1)), "a minute"));
    test("2 minutes = 2 minutes", () => expect(durationFormat.format(new Duration(minutes: 2)), "2 minutes"));
    test("59 minutes = 59 minutes", () => expect(durationFormat.format(new Duration(minutes: 59)), "59 minutes"));
    test("1 hour = an hour", () => expect(durationFormat.format(new Duration(hours: 1)), "an hour"));
    test("2 hours = 2 hours", () => expect(durationFormat.format(new Duration(hours: 2)), "2 hours"));
    test("23 hours = 23 hours", () => expect(durationFormat.format(new Duration(hours: 23)), "23 hours"));
    test("1 day = a day", () => expect(durationFormat.format(new Duration(days: 1)), "a day"));
    test("2 days = 2 days", () => expect(durationFormat.format(new Duration(days: 2)), "2 days"));
    test("30 days = 30 days", () => expect(durationFormat.format(new Duration(days: 30)), "30 days"));
    test("31 days = a month", () => expect(durationFormat.format(new Duration(days: 31)), "a month"));
    test("60 days = a month", () => expect(durationFormat.format(new Duration(days: 60)), "a month"));
    test("61 days = 2 months", () => expect(durationFormat.format(new Duration(days: 61)), "2 months"));
    test("365 days = 11 months", () => expect(durationFormat.format(new Duration(days: 365)), "11 months"));
    test("366 days = a year", () => expect(durationFormat.format(new Duration(days: 366)), "a year"));
  });

//  test.equal(moment.humanizeDuration(44, "seconds"),  "a few seconds", "44 seconds = a few seconds");
//  test.equal(moment.humanizeDuration(45, "seconds"),  "a minute",      "45 seconds = a minute");
//  test.equal(moment.humanizeDuration(89, "seconds"),  "a minute",      "89 seconds = a minute");
//  test.equal(moment.humanizeDuration(90, "seconds"),  "2 minutes",     "90 seconds = 2 minutes");
//  test.equal(moment.humanizeDuration(44, "minutes"),  "44 minutes",    "44 minutes = 44 minutes");
//  test.equal(moment.humanizeDuration(45, "minutes"),  "an hour",       "45 minutes = an hour");
//  test.equal(moment.humanizeDuration(89, "minutes"),  "an hour",       "89 minutes = an hour");
//  test.equal(moment.humanizeDuration(90, "minutes"),  "2 hours",       "90 minutes = 2 hours");
//  test.equal(moment.humanizeDuration(5, "hours"),     "5 hours",       "5 hours = 5 hours");
//  test.equal(moment.humanizeDuration(21, "hours"),    "21 hours",      "21 hours = 21 hours");
//  test.equal(moment.humanizeDuration(22, "hours"),    "a day",         "22 hours = a day");
//  test.equal(moment.humanizeDuration(35, "hours"),    "a day",         "35 hours = a day");
//  test.equal(moment.humanizeDuration(36, "hours"),    "2 days",        "36 hours = 2 days");
//  test.equal(moment.humanizeDuration(1, "days"),      "a day",         "1 day = a day");
//  test.equal(moment.humanizeDuration(5, "days"),      "5 days",        "5 days = 5 days");
//  test.equal(moment.humanizeDuration(1, "weeks"),     "7 days",        "1 week = 7 days");
//  test.equal(moment.humanizeDuration(25, "days"),     "25 days",       "25 days = 25 days");
//  test.equal(moment.humanizeDuration(26, "days"),     "a month",       "26 days = a month");
//  test.equal(moment.humanizeDuration(30, "days"),     "a month",       "30 days = a month");
//  test.equal(moment.humanizeDuration(45, "days"),     "a month",       "45 days = a month");
//  test.equal(moment.humanizeDuration(46, "days"),     "2 months",      "46 days = 2 months");
//  test.equal(moment.humanizeDuration(74, "days"),     "2 months",      "75 days = 2 months");
//  test.equal(moment.humanizeDuration(76, "days"),     "3 months",      "76 days = 3 months");
//  test.equal(moment.humanizeDuration(1, "months"),    "a month",       "1 month = a month");
//  test.equal(moment.humanizeDuration(5, "months"),    "5 months",      "5 months = 5 months");
//  test.equal(moment.humanizeDuration(344, "days"),    "11 months",     "344 days = 11 months");
//  test.equal(moment.humanizeDuration(345, "days"),    "a year",        "345 days = a year");
//  test.equal(moment.humanizeDuration(547, "days"),    "a year",        "547 days = a year");
//  test.equal(moment.humanizeDuration(548, "days"),    "2 years",       "548 days = 2 years");
//  test.equal(moment.humanizeDuration(1, "years"),     "a year",        "1 year = a year");
//  test.equal(moment.humanizeDuration(5, "years"),     "5 years",       "5 years = 5 years");
//  test.equal(moment.humanizeDuration(7200000),        "2 hours",     "7200000 = 2 minutes");  
//  findSystemLocale();
//  
//  final apocolypse = new Date(2012, 12, 21);
//
//  var durationFormat = new DurationFormat();
//  print(durationFormat.format(const Duration(days: 50, hours: 3)));
//  print(durationFormat.format(const Duration(days: 27, minutes: 2)));
//
//  var dateFormat = new NowOffsetFormat();
//  print(dateFormat.format(apocolypse));
//  print(dateFormat.format(new Date.now().add(const Duration(hours: 2, minutes: 5))));
}