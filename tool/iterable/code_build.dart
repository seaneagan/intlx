
import 'dart:io';
import 'dart:json' as json;
import '../library_writer.dart';

main() {
  new IterableLibraryWriter().writeLibraries();
}

class IterableLibraryWriter extends LibraryWriter {
  final type = "iterable";
  final symbolsClass = "IterableSymbols";

  getSymbolsConstructorArgs(String locale, Map data) {

    var indexed = <String, List> {};
    for(int i = 2; i <= 3; i++) {
      var indexString = i.toString();
      if(data.containsKey(indexString)) {
        indexed[indexString] = data[indexString];
      }
    }

    return """
    start: const ${json.stringify(data["start"])},
    middle: const ${json.stringify(data["middle"])},
    end: const ${json.stringify(data["end"])},
    indexed: ${json.stringify(indexed)}""";
  }

}
