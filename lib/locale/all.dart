
#library("relative_time_locale_all");

#import("../src/internal.dart");
#import("../src/locale/en.dart", prefix: "en");

void init() {
  var locales = [en.locale];
  
  locales.forEach(registerSymbols);
}
// yesiree!
