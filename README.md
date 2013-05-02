
#Intlx

[![Build Status](https://drone.io/seaneagan/intlx/status.png)](https://drone.io/seaneagan/intlx/latest)

Intlx is internationalization APIs for Dart, 
which have not yet made it into [the intl package](http://pub.dartlang.org/packages/intl) itself.

##Features:

####Formats

The core APIs of this package are Formats, which format various data types to locale specific Strings, similar to DateFormat and NumberFormat from the intl package.

| API            | What does it format?  | Examples (for "en" locale) | CLDR data source      | LDML notes              |
| -------------- | --------------------- | -------------------------- | --------------------- | ----------------------- |
| IterableFormat | Iterables             | _a, b, and c_              | [data][Iterable data] | [notes][Iterable notes] | 
| PluralFormat   | nums to a plural form | _1 octopus_ or _2 octopi_  | [data][Plural data]   | [notes][Plural notes]   |
| DurationFormat | Durations             | _5 hours_ or _5 hrs_       | [data][RT data]       | [notes][RT notes]       |
| AgeFormat      | Dates relative to now | _2 days ago_ or _In 2 days_| [data][RT data]       | [notes][RT notes]       |

<!---
TODO: make API names link to generated API docs once they exist
-->

####Configuration

######DurationRounder
  Duration rounding strategy interface.  An implementation of this interface can be passed to a RelativeTimeFormat (superclass of DurationFormat and AgeFormat) to customize how to round Durations to a TimeUnit and quantity.

######FormatLength
  An "enum" of format lengths, currently used by DurationFormat, could be used by DateFormat as well.

##CLDR data
  All data is sourced from CLDR, specifically http://i18ndata.appspot.com/.

####Supported locales:
  Supported locales are currently intentionally constrained to be the same as [DateFormat's supported locales] (https://code.google.com/p/dart/source/browse/trunk/dart/pkg/intl/lib/src/data/dates/localeList.dart).
  However CLDR does support many more locales, which could easily be supported later.

[Iterable data]: http://i18ndata.appspot.com/cldr/tags/unconfirmed/main/en/listPatterns/listPattern?action=browse&depth=-1
[Plural data]: http://i18ndata.appspot.com/cldr/tags/unconfirmed/supplemental/plurals/plurals?action=browse&depth=-1
[RT data]: http://i18ndata.appspot.com/cldr/tags/unconfirmed/main/en/units?action=browse&depth=-1

[Iterable notes]: http://unicode.org/reports/tr35/tr35-general.html#ListPatterns
[Plural notes]: http://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
[RT notes]: http://unicode.org/reports/tr35/#Unit_Elements
