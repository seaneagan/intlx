
#library("relative_time_en_symbols");

#import("../symbols.dart");

const RelativeTimeSymbols locale = const RelativeTimeSymbols(
  name: "en",
  past: "%s ago",
  future: "in %s",
  units: const {
    "SECOND": const ["a few seconds"],
    "MINUTE": const ["a minute", "%d minutes"],
    "HOUR": const ["an hour", "%d hours"],
    "DAY": const ["a day", "%d days"],
    "MONTH": const ["a month", "%d months"],
    "YEAR": const ["a year", "%d years"]});
