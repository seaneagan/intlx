
library iterable_locale_build;

import 'dart:io';
import 'dart:json' as json;
import '../library_writer.dart';

main() {
  new IterableLibraryWriter().writeLibraries();
}

class IterableLibraryWriter extends JsonSourcedLibraryWriter {
  final type = "iterable";
  final symbolsClass = "IterableSymbols";

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
