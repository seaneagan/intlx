// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Mechanisms to extract data from [Cldr].
///
/// It is a multi-step process:
///
/// 1.  Install [Cldr core and tools][cldr_downloads] by running:
///     <this_package>/bin/install_cldr.dart
/// 1.  Use [Ldml2Json] to convert Ldml data files to Json files.
///   * A convenience script for this is provided at:
///         <this package>/bin/ldml2json.dart
/// 1.  Use [JsonExtractor] to extract data from [Ldml2Json] output files.
///
/// This library is meant to be imported with a prefix (such as "cldr")
/// as necessary.
///
/// [cldr]: http://cldr.unicode.org
/// [cldr_downloads]: http://unicode.org/Public/cldr/latest
library cldr;

import 'dart:io';
import 'package:cli/cli.dart';
import 'package:mockable_filesystem/filesystem.dart';
import 'package:cldr/cldr_installation.dart';
import 'package:cldr/src/ldml2json_converter_command.dart';
import 'package:cldr/src/util.dart';

part 'src/ldml2json.dart';
part 'src/json_extractor.dart';
