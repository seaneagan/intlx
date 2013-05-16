#Intlx

[![Build Status](https://drone.io/seaneagan/intlx/status.png)](https://drone.io/seaneagan/intlx/latest)

Intlx is internationalization APIs for Dart, 
which have not yet made it into [the intl package](http://pub.dartlang.org/packages/intl) itself.

##API docs

See the [dartdocs](http://seaneagan.github.com/intlx).

The docs for each API include basic examples.

##Formats

The core APIs of this package are Formats, which format various data types to locale specific Strings, similar to DateFormat and NumberFormat from the intl package.
APIs include [IterableFormat](http://seaneagan.me/intlx/intlx/IterableFormat.html), [PluralFormat](http://seaneagan.me/intlx/intlx/PluralFormat.html), [DurationFormat](http://seaneagan.me/intlx/intlx/DurationFormat.html), and [AgeFormat](http://seaneagan.me/intlx/intlx/AgeFormat.html).

##CLDR data
  All data is sourced from CLDR, specifically http://i18ndata.appspot.com/.

####Supported locales:
  Supported locales are currently intentionally constrained to be the same as [DateFormat's supported locales] (https://code.google.com/p/dart/source/browse/trunk/dart/pkg/intl/lib/src/data/dates/localeList.dart).
  However CLDR does support many more locales, which could easily be supported later.
