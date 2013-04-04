#Intlx

  [![Build Status](https://drone.io/seaneagan/intlx/status.png)](https://drone.io/seaneagan/intlx/latest)

  Intlx is experimental internationalization APIs for Dart, 
  which have not yet made it into the intl package itslef.
  All data is sourced from CLDR.

##Features:

* TimelineFormat
  formats Dates into their relative Duration and direction from now e.g. "37 minutes ago" or "In 2 days"
* DurationFormat
  formats Durations e.g. "5 hours"
* DurationRounder
  customizable Duration rounding strategy.  Durations are rounded to a specific time unit and quantity

##CLDR
  Locale data is sourced from CLDR.

###data (for "en" locale)
  http://i18ndata.appspot.com/cldr/tags/unconfirmed/main/en/units?action=browse&depth=-1

###Processing scheme
  http://unicode.org/reports/tr35/#Unit_Elements
