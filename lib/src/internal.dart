
library internal;

import 'package:intl/src/intl_helpers.dart';
import 'package:intl/src/lazy_locale_data.dart';
import 'package:intl/intl.dart';

import '../intlx.dart';
import 'relative_time/symbols.dart';
import 'relative_time/locale_list.dart';

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
  var symbols = relativeTimeSymbols[getVerifiedLocale(locale, relativeTimeLocales)];
  if(symbols === null) throw new LocaleDataException("Locale data has not been loaded for locale: '$locale'");
  return symbols;
}

/**
 * Return a locale name turned into xx_YY where it might possibly be
 * in the wrong case or with a hyphen instead of an underscore.
 */
String canonicalizedLocale(String aLocale) {
  if (aLocale == "C") return "en_ISO";
  if ((aLocale.length < 5) || (aLocale.length > 6)) return aLocale;
  var re = const RegExp("([a-zA-Z]+)[_-]([a-zA-Z]+)");
  var match = re.firstMatch(aLocale);
  if(match == null) return aLocale;
  return "${match.group(1).toLowerCase()}_${match.group(2).toUpperCase()}";
}

// TODO: this is copied from package:intl, remove if it becomes public there
String shortLocale(String aLocale) {
  if (aLocale.length < 2) return aLocale;
  var re = const RegExp("[_-]");
  var match = re.firstMatch(aLocale);
  if(match == null) return aLocale;
  return aLocale.substring(0, match.start()).toLowerCase();
}

String getVerifiedLocale(String newLocale, List<String> locales) {
  
  if (newLocale == null) newLocale = Intl.systemLocale;
  
  for (var locale in [newLocale, Intl.canonicalizedLocale(newLocale), shortLocale(newLocale)]) { 
    if (locales.indexOf(locale) != -1) {
      return locale;
    }
  }
  throw new ArgumentError("Invalid or unsupported locale '$newLocale'");
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