
library iterable_json_build;

import '../cldr_data.dart';

main() {
  fetchAndWriteCldrData("listPatterns/listPattern", "iterable", (locale, json) => json);
}
