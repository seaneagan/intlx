
#library("relative_time_intl");

#import("package:intl/intl.dart");

#import("src/locale.dart");
#import("src/period.dart");
#import("src/time_unit.dart");

#source("src/locale_list.dart");

class DurationFormat {
  
  final RelativeTimeLocale _locale;
  
  DurationFormat([String locale]) : _locale = new RelativeTimeLocale(locale);
  
  String format(Duration duration) {
    
    var period = new ClockPeriod.wrap(duration);
    var potentialUnits = [TimeUnit.YEAR, TimeUnit.MONTH, TimeUnit.DAY, TimeUnit.HOUR, TimeUnit.MINUTE, TimeUnit.SECOND];
    
    for(TimeUnit unit in potentialUnits) {
      var q = period.inUnit(unit);
      if(q > 0 || unit == TimeUnit.SECOND) {
        return _locale.formatUnit(unit, q);
      }
    }

    return "[unknown duration]";
  }
  
}

/*class DateOffsetFormat {
  
  final DurationFormat _durationFormat;
  
  DateOffsetFormat([DurationFormat durationFormat, Date referenceDate]);
  
  String format(Date date) {
    
  }
  
  String _format(Date date, Date referenceDate) {
    
  }
  
  
}

class NowOffsetFormat extends DateOffsetFormat {

  NowOffsetFormat([DurationFormat durationFormat]) : super(durationFormat);
  
  String format(Date date) {
    
  }

  
}
*/