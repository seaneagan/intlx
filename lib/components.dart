
library intlx.components;

import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'package:intlx/intlx.dart';

@observable
class AgeComponent extends WebComponent {
  static final _defaultAgeFormat = new AgeFormat();
  
  AgeComponent() {
    if(_dummyCounter == 0) {
      new Stream.periodic(const Duration(seconds: 1), (_) => _dummyCounter++).listen((_){});
    }
  }
  static var _dummyCounter = 0;
  static var _dummyCounterInit = (){
  }();
  DateTime value;
  AgeFormat format = _defaultAgeFormat;

  String get age {
    _dummyCounter;
    var v = value;
    if(format is DurationFormat) { 
      v = new DateTime.now().difference(v);
      var micros = v.inMicroseconds;
      if(micros.isNegative) {
        v = new Duration(microseconds: micros.abs());
      }
    }
    return format.format(v);
  }
}
