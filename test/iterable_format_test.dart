
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/iterable/en.dart' as iterable_en;

main() {
  group('IterableFormat', () {

    IterableFormat iterableFormat;

    setUp(() {
      iterable_en.init();
      iterableFormat = new IterableFormat(locale: "en");
    });

    test("0 items", () => expect(iterableFormat.format([]), ""));
    test("1 items", () => expect(iterableFormat.format([1]), "1"));
    test("2 items", () => expect(iterableFormat.format([1, "x"]), "1 and x"));
    test("many items", () => expect(iterableFormat.format([1, 2, 3, "x", "y", "z"]), "1, 2, 3, x, y, and z"));

    group('mapSeparator', () {

      setUp(() {
        iterableFormat = new IterableFormat(locale: "en", mapSeparator: (sep) => "<$sep>");
      });

      test("2 items", () => expect(iterableFormat.format([1, "x"]), "1< and >x"));
      test("many items", () => expect(iterableFormat.format([1, 2, 3]), "1<, >2<, and >3"));
    });
  });
}
