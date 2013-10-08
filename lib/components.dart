// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.components;

import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:intlx/intlx.dart';

@CustomTag('intlx-age')
class AgeComponent extends PolymerElement with ObservableMixin {

  bool get applyAuthorStyles => true;

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

  @observable
  String get age {
    _dummyCounter;
    var v = value;
    if(v == null) return '';
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
