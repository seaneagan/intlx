
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/plural/en.dart' as plural_en;

main() {
  group('PluralFormat', () {

    PluralFormat pluralFormat;

    setUp(() {
      plural_en.init();
      pluralFormat = new PluralFormat({"0": "no books", "one": "{0} book", "other": "{0} books"}, locale: "en", pattern: "{0}");
    });

    test("exact integer case", () => expect(pluralFormat.format(0), "no books"));
    test("'one' case", () => expect(pluralFormat.format(1), "1 book"));
    test("'other' case", () => expect(pluralFormat.format(5), "5 books"));
  });
}


