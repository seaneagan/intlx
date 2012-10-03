

#import("../lib/relative_time_intl.dart"); 
#import("../lib/locale/en.dart", prefix: "en");
#import("package:intl/intl_standalone.dart");
#import("dart:io");

main() {
  
  en.init();
  
  findSystemLocale();
  
  final apocolypse = new Date(2012, 12, 21);

  var durationFormat = new DurationFormat("en");
  print(durationFormat.format(const Duration(days: 50, hours: 3)));
  print(durationFormat.format(const Duration(days: 27, minutes: 2)));

//  var dateFormat = new NowOffsetFormat();
//  print(dateFormat.format(apocolypse));
//  print(dateFormat.format(new Date.now().add(const Duration(hours: 2, minutes: 5))));
}