
import '../lib/tempora.dart'; 
import '../lib/locale/all.dart' as all;
import 'package:intl/intl_standalone.dart';

main() {
  
  go(String locale) {
    
    print("locale: $locale");
  
    all.init();
        
    final apocolypse = new Date(2012, 12, 21);
  
    var durationFormat = new DurationFormat(locale);
    print(durationFormat.format(const Duration(days: 50, hours: 3)));
    print(durationFormat.format(const Duration(days: 27, minutes: 2)));
  
    var ageFormat = new AgeFormat();
    print("The apocolypse is: ${ageFormat.format(apocolypse)}");
    print("A couple hours from now is: ${ageFormat.format(new Date.now().add(const Duration(hours: 2, minutes: 5)))}");
  };

  findSystemLocale().then(go);
}