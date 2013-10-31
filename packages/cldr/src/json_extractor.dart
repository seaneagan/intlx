// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of cldr;

/// Mechanism to extract data from existing [Ldml2Json] output.
class JsonExtractor {

  /// Path to the root of the [Ldml2Json] output.
  final String jsonRoot;

  JsonExtractor(this.jsonRoot);

  /// Extracts and parses json from [Ldml2Json] output and returns it.
  Map<String, dynamic> extract(DataSet dataSet) => dataSet.extract(jsonRoot);
}

/// Represents a set of data within Cldr that can be extracted.
///
/// Available DataSets to extract can be found in the
/// [data sets library].
///
/// [data sets library]: package:cldr/data_sets.dart
abstract class DataSet {
  /// Extracts this DataSet from [Ldml2Json] output at [jsonRoot].
  Map<String, dynamic> extract(String jsonRoot);
}
