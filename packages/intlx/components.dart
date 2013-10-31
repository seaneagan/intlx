// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.components;

import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:intlx/intlx.dart';

@CustomTag('intlx-age')
class AgeComponent extends PolymerElement with ChangeNotifier  {

  AgeComponent.created() : super.created();

  enteredView() {

    super.enteredView();

    _onUpdateInterval.listen((_) => notifyAge());

    onPropertyChange(this, #value, notifyAge);
  }

  notifyAge() => notifyPropertyChange(#age, null, age);

  bool get applyAuthorStyles => true;

  static final _defaultAgeFormat = new AgeFormat();

  static final _updateInterval = const Duration(seconds: 1);

  static final _onUpdateInterval =
      new Stream.periodic(_updateInterval)
      .asBroadcastStream();

  @reflectable @published
  DateTime get value => __$value; DateTime __$value; @reflectable set value(DateTime value) { __$value = notifyPropertyChange(#value, __$value, value); }

  @reflectable @published
  dynamic get format => __$format; dynamic __$format = _defaultAgeFormat; @reflectable set format(dynamic value) { __$format = notifyPropertyChange(#format, __$format, value); }

  @observable
  String get age {
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
