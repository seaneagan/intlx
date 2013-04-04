
library collection_locale_build;

import 'dart:io';
import 'dart:json' as json;
import '../util.dart';
import 'package:intlx/src/internal.dart';

main() {
  new CollectionLibraryWriter().writeLibraries();
}

class CollectionLibraryWriter extends JsonSourcedLibraryWriter {
  final type = "collection";
  final symbolsClass = "CollectionSymbols";

  getSymbolsConstructorArgs(String locale, Map data) {

    var indexed = <String, String> {};
    for(int i = 2; i <= 3; i++) {
      var indexString = i.toString();
      if(data.containsKey(indexString)) {
        indexed[indexString] = data[indexString];
      }
    }

    return """
    start: '${data["start"]}',
    middle: '${data["middle"]}',
    end: '${data["end"]}',
    indexed: const ${json.stringify(indexed)}""";
  }

}
