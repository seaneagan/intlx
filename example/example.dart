
#import("../lib/tempora.dart"); 
#import("../lib/locale/en.dart", prefix: "en");
#import("../lib/locale/es.dart", prefix: "es");
#import("package:intl/intl_standalone.dart");

main() {
  
  go(String s) {
  
    en.init();
    es.init();
        
    final apocolypse = new Date(2012, 12, 21);
  
    var durationFormat = new DurationFormat("es");
    print(durationFormat.format(const Duration(days: 50, hours: 3)));
    print(durationFormat.format(const Duration(days: 27, minutes: 2)));
  
  //  var dateFormat = new NowOffsetFormat();
  //  print(dateFormat.format(apocolypse));
  //  print(dateFormat.format(new Date.now().add(const Duration(hours: 2, minutes: 5))));
  }

  print("starting");
  
  findSystemLocale().then(go);
}