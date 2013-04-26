
import 'package:unittest/unittest.dart';
import 'package:intlx/intlx.dart';
import 'package:intlx/locale/collection/en.dart' as collection_en;

main() {
  group('CollectionFormat', () {

    CollectionFormat collectionFormat;

    setUp(() {
      collection_en.init();
      collectionFormat = new CollectionFormat(locale: "en");
    });

    test("empty collection is empty string", () => expect(collectionFormat.format([]), ""));
    test("single item", () => expect(collectionFormat.format([1]), "1"));
    test("many items", () => expect(collectionFormat.format([1, 2, 3, "x", "y", "z"]), "1, 2, 3, x, y, and z"));
  });
}

