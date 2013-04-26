
library iterable_json_build;

import 'dart:io';
import '../util.dart';

main() {
  writeLocaleJson("listPatterns/listPattern", "iterable", (locale, json) => json);
}
