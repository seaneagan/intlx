
#library("relative_time_intl");

#import("src/locale.dart");

class DurationFormat {
  
  final RelativeTimeLocale _locale;
  
  DurationFormat(String locale) _locale = new RelativeTimeLocale(locale);
  
  String format(Duration duration) {
    
  }
  
}

class DateOffsetFormat {
  
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
