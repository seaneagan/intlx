// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of intlx;

/// Enum to represent time units.
class TimeUnit implements Comparable<TimeUnit> {
  // TODO: this class should be in a generic calendar library, 
  // such as that referenced in http://dartbug.com/5627
  
  static const SECOND = const TimeUnit._("SECOND", 0);
  static const MINUTE = const TimeUnit._("MINUTE", 1);
  static const HOUR = const TimeUnit._("HOUR", 2);
  static const DAY = const TimeUnit._("DAY", 3);
  static const WEEK = const TimeUnit._("WEEK", 4);
  static const MONTH = const TimeUnit._("MONTH", 5);
  static const YEAR = const TimeUnit._("YEAR", 6);

  const TimeUnit._(this._name, this._index);

  int compareTo(TimeUnit other) => _index.compareTo(other._index);

  String toString() => _name;

  final String _name;
  final int _index;

  static const values = const <TimeUnit> [SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, YEAR];
}

