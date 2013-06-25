// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of intlx.plural.plural;

class PluralCategory {

  static const ZERO = const PluralCategory._("ZERO");
  static const ONE = const PluralCategory._("ONE");
  static const TWO = const PluralCategory._("TWO");
  static const FEW = const PluralCategory._("FEW");
  static const MANY = const PluralCategory._("MANY");
  static const OTHER = const PluralCategory._("OTHER");

  const PluralCategory._(this._name);

  final String _name;

  String toString() => _name;

  static const values = const <PluralCategory> [ZERO, ONE, TWO, FEW, MANY, OTHER];
}


