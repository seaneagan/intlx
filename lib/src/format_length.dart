// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of intlx;

/// Enum to represent format lengths.
class FormatLength {
  // TODO: can DateFormat use this as well ? others ?
  static const SHORT = const FormatLength._("SHORT", 0);
  static const LONG = const FormatLength._("LONG", 1);

  const FormatLength._(this._name, this._index);

  final String _name;
  final int _index;
}
