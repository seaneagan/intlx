
// TODO: replace this library with whatever support is provided
// for this in the library referenced by http://dartbug.com/5627.
library duration_converters;

// TODO: should these be more precise averages, or is that too unpredictable ?
const int DAYS_PER_YEAR = 365;
const int DAYS_PER_MONTH = 30;

int inYears(Duration duration) => duration.inDays ~/ DAYS_PER_YEAR;
int inMonths(Duration duration) => duration.inDays ~/ DAYS_PER_MONTH;
int inWeeks(Duration duration) => duration.inDays ~/ DateTime.DAYS_PER_WEEK;
