
#library("relative_time_locale_en");

#import("../src/internal.dart");
#import("../src/locale/en.dart", prefix: "en");

void init() {
  var locales = [en.locale];
  
  locales.forEach(registerSymbols);
}
