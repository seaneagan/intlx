
#library('relative_time_internal');

#import('package:intl/src/intl_helpers.dart');
#import("package:intl/src/lazy_locale_data.dart");

#import("symbols.dart");
#import("../locale/list.dart");

var relativeTimeSymbols = const UninitializedLocaleData('initializeDateFormatting(<locale>)');

/**
 * Initialize the symbols dictionary. This should be passed a function that
 * creates and returns the symbol data. We take a function so that if
 * initializing the data is an expensive operation it need only be done once,
 * no matter how many times this method is called.
 */
void initRelativeTimeSymbols(Function symbols) {
  if (relativeTimeSymbols is UninitializedLocaleData) {
    relativeTimeSymbols = symbols();
  }
}

Future initRelativeTimeIntl(Function init) {
  return init(relativeTimeSymbols);
}

void registerSymbols(RelativeTimeSymbols symbols) {
  relativeTimeSymbols[symbols.name] = symbols;
}

/**
 * This should be called for at least one [locale] before any date formatting
 * methods are called. It sets up the lookup for date symbols using [url].
 * The [url] parameter should end with a "/". For example,
 *   "http://localhost:8000/dates/"
 */
Future initLocale(String locale, LocaleDataReader reader) {
  initRelativeTimeSymbols(() => new LazyLocaleData(reader, _createRelativeTimeSymbols, relativeTimeLocales));
  return initRelativeTimeIntl((symbols) => symbols.initLocale(locale));
}

/** Defines how new date symbol entries are created. */
RelativeTimeSymbols _createRelativeTimeSymbols(Map map) {
  return new RelativeTimeSymbols.fromMap(map);
}