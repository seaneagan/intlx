
library internal;

import 'package:intl/src/intl_helpers.dart';
import 'package:intl/src/lazy_locale_data.dart';
import 'package:intl/intl.dart';

import 'symbols.dart';
import 'locale.dart';
import '../tempora.dart';
import 'locale_list.dart';

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

RelativeTimeSymbols lookupSymbols(String locale) {
  var symbols = relativeTimeSymbols[verifiedLocale(locale)];
  if(symbols === null) throw new LocaleDataException("Locale data has not been loaded for locale: '$locale'");
  return symbols;
}


// TODO: this is copied from package:intl, remove if it becomes valid beyond DateFormat there
String verifiedLocale(String newLocale) {
  
  if (newLocale == null) newLocale = Intl.systemLocale;
  
  if (_localeExists(newLocale)) return newLocale;
  
  for (var each in [Intl.canonicalizedLocale(newLocale), shortLocale(newLocale)]) { 
    if (_localeExists(each)) {
      return each;
    }
  }
  throw new ArgumentError("Invalid or unsupported locale '$newLocale'");
}

// TODO: this is copied from package:intl, remove if it becomes public there
String shortLocale(String aLocale) {
  if (aLocale.length < 2) return aLocale;
  return aLocale.substring(0, 2).toLowerCase();
}

bool _localeExists(String locale) => relativeTimeLocales.indexOf(locale) != -1;

void registerSymbols(RelativeTimeSymbols symbols) {
  initRelativeTimeSymbols(() => new Map<String, RelativeTimeSymbols>());
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