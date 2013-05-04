
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/relative_time/en.dart' as relative_time_en;
import 'package:intlx/src/relative_time/duration_converters.dart';

main() {
  group('DurationRounder', () {

    DurationFormat durationFormat;
    AgeFormat ageFormat;
    var oneHundredDays;

    setUp(() {
      relative_time_en.init();
      var dayRounder = const DurationRounder.staticUnit(TimeUnit.DAY);
      durationFormat = new DurationFormat(locale: "en", rounder: dayRounder);
      ageFormat = new AgeFormat(locale: "en", rounder: dayRounder);
      oneHundredDays = const Duration(hours: Duration.HOURS_PER_DAY * 100);
    });

    test("5 minutes = 0 days", () => expect(durationFormat.format(new Duration(minutes: 5)), "0 days"));
    test("100 days ago", () => expect(ageFormat.format(new DateTime.now().subtract(oneHundredDays)), "100 days ago"));
    test("In 100 days", () => expect(ageFormat.format(new DateTime.now().add(oneHundredDays)), "In 100 days"));
  });

}

