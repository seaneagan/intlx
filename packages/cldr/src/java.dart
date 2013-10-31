// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Utilities for working with java programs.
library java;

import 'dart:io';
import 'package:cli/cli.dart';

class JavaCommand extends Command {

  final String javaClass;
  final String classPath;
  final List<String> classArguments;
  final Map<String, String> systemProperties;

  JavaCommand(
      this.javaClass,
      {this.classPath,
       this.classArguments: const [],
       this.systemProperties: const {}})
      : super(
            'java',
            null);

  List<String> get arguments => getJavaArgs(
      javaClass,
      classPath: classPath,
      classArguments: classArguments,
      systemProperties: systemProperties);
}

/// Returns args to send to a java process.
List<String> getJavaArgs(
    String javaClass, {
      String classPath,
      List<String> classArguments: const [],
      Map<String, String> systemProperties: const {}}) {

    var args = systemProperties.keys.map((key) =>
        '-D$key=${systemProperties[key]}')
        .toList();
    if(classPath != null) args.addAll(['-cp', classPath]);
    return args..add(javaClass)..addAll(classArguments);
  }

/// Returns a class path consisting of [paths] using the platform dependent
/// class path separator.
String getClassPath(Iterable<String> paths) => paths.join(classPathSeparator);

/// The platform dependent separator of items in a java class path.
final String classPathSeparator = Platform.isWindows ? ";" : ":";
