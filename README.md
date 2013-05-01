#Intlx

[![Build Status](https://drone.io/seaneagan/intlx/status.png)](https://drone.io/seaneagan/intlx/latest)

Intlx is experimental internationalization APIs for Dart, 
which have not yet made it into [the intl package](http://pub.dartlang.org/packages/intl) itself.

##Supported locales:
  Same as the intl package.  See ___.

##Features:

####Formatters

| AgeFormat     | Dates relative to now| _2 days ago_ or _In 2 days_| [data][RT Data]       | [scheme][RT scheme]       |
| IterableFormat| Iterables            | _a, b, and c_              | [data][Iterable data] | [notes][Iterable scheme] |
| PluralFormat  | nums to a plural form| _1 octopus_ or _2 octopi_  | [data][Plural data]   | [notes][Plural scheme]   |
| DurationFormat| Durations            | _5 hours_ or _5 hrs_       | [data][RT data]       | [notes][RT scheme]       |
| AgeFormat     | Dates relative to now| _2 days ago_ or _In 2 days_| [data][RT data]       | [notes][RT scheme]       |

<!---
TODO: make API names link to generated API docs once they exist
-->

#####DurationRounder
  Duration rounding strategy interface.  An implementation of this interface can be passed to a RelativeTimeFormat (superclass of DurationFormat and AgeFormat) to customize how to round Durations to a time unit and quantity.
  
##CLDR data
  All data is sourced from CLDR, specifically http://i18ndata.appspot.com/.

[Iterable data]: http://i18ndata.appspot.com/cldr/tags/unconfirmed/main/en/listPatterns/listPattern?action=browse&depth=-1
[Plural data]: http://i18ndata.appspot.com/cldr/tags/unconfirmed/supplemental/plurals/plurals?action=browse&depth=-1
[RT data]: http://i18ndata.appspot.com/cldr/tags/unconfirmed/main/en/units?action=browse&depth=-1

[Iterable scheme]: http://unicode.org/reports/tr35/tr35-general.html#ListPatterns
[Plural scheme]: http://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
[RT scheme]: http://unicode.org/reports/tr35/#Unit_Elements
