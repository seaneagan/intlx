
import 'package:intlx/intlx.dart';
import 'package:intlx/src/plural/load_locale.dart';
import 'package:intl/intl_standalone.dart';

main() {

  go(String locale) {

    print("system locale: $locale");

    // system locale is not work in Windows yet
    locale = "en";
    
    loadLocale(locale).then((_) {
      var pluralFormat = new PluralFormat({"0": "no books", "one": "{0} book", "other": "{0} books"}, locale: locale, pattern: "{0}");
      print(pluralFormat.format(0)); // "no books"
      print(pluralFormat.format(1)); // "1 book"
      print(pluralFormat.format(5)); // "5 books"
    });
  }

  findSystemLocale().then(go);
}