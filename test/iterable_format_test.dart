
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

    test("empty iterable is empty string", () => expect(iterableFormat.format([]), ""));
    test("single item", () => expect(iterableFormat.format([1]), "1"));
    test("many items", () => expect(iterableFormat.format([1, 2, 3, "x", "y", "z"]), "1, 2, 3, x, y, and z"));
  });
}

