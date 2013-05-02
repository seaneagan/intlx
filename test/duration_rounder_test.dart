
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
      var dayRounder = const StaticUnitDurationRounder(TimeUnit.DAY);
      durationFormat = new DurationFormat(locale: "en", rounder: dayRounder);
      ageFormat = new AgeFormat(locale: "en", rounder: dayRounder);
      oneHundredDays = const Duration(hours: Duration.HOURS_PER_DAY * 100);
    });

    test("5 minutes = 0 days", () => expect(durationFormat.format(new Duration(minutes: 5)), "0 days"));
    test("100 days ago", () => expect(ageFormat.format(new DateTime.now().subtract(oneHundredDays)), "100 days ago"));
    test("In 100 days", () => expect(ageFormat.format(new DateTime.now().add(oneHundredDays)), "In 100 days"));
  });

}

// TODO: expose this via a DurationRounder.staticUnit constructor ?
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