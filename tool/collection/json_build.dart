
library collection_json_build;

import 'dart:io';
import '../util.dart';

main() {
  writeLocaleJson("listPatterns/listPattern", "collection", (locale, json) => json);
}
