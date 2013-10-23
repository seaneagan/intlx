// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.components;

import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:intlx/intlx.dart';

@CustomTag('intlx-age')
class AgeComponent extends PolymerElement {

  created() {
    super.created();

    _onUpdateInterval.listen((_) {
      notifyProperty(this, #age);
    });

    onPropertyChange(this, #value, () => notifyProperty(this, #age));
  }

  bool get applyAuthorStyles => true;

  static final _defaultAgeFormat = new AgeFormat();

  static final _updateInterval = const Duration(seconds: 1);

  static final _onUpdateInterval =
      new Stream.periodic(_updateInterval)
      .asBroadcastStream();

  @published
  DateTime value;

  @published
  var format = _defaultAgeFormat;

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
