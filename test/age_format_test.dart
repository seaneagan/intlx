
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/relative_time/en.dart' as relative_time_en;

main() {
  group('AgeFormat', () {

    AgeFormat ageFormat;

    setUp(() {
      relative_time_en.init();
      ageFormat = new AgeFormat(locale: "en");
    });

    test("In 2 minutes", () => expect(ageFormat.format(new DateTime.now().add(new Duration(minutes: 2, seconds: 30))), "In 2 minutes"));
    test("5 hours ago", () => expect(ageFormat.format(new DateTime.now().subtract(new Duration(hours: 5))), "5 hours ago"));
    test("now is past", () => expect(ageFormat.format(new DateTime.now()), "0 minutes ago"));
  });
}

