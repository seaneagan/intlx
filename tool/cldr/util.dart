// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.cldr.util;

import 'package:logging/logging.dart';
import 'dart:async';
import 'dart:io';

/// Allows one to log the start and end of a logical step in a DRY manner
class LogStep {
  final Logger _logger;
  final String _description;
  final Level _level;
  LogStep(this._logger, this._description, {Level level: Level.INFO}) : 
    _level = level;
  
  /// logs the start of the step
  start() => _logBoundary("START");
  
  /// logs the end of the step
  end() => _logBoundary("END  ");
  
  /// The step as defined by [f] is [start]ed, executed, and then [end]ed, 
  /// which if [f] returns a [Future], will not occur until its completion.
  execute(f()) {
    start();
    var ret = f();
    if(ret is Future) return ret.then((v) {
      end();
      return v;
    }, onError: (e) {_logger.severe("FAIL STEP: $_description");});
    end();
    return ret;
  }
  
  _logBoundary(String boundary) => 
    _logger.log(_level, "$boundary STEP: $_description");
}

// get a Logger with a preattached [Logger.onRecord] handler
// TODO: the logging package needs an Appender concept,
// and external configuration thereof.
Logger getLogger(String name) {
  var _logger = new Logger(name);
  _logger.onRecord.listen((record) => print(_logRecordToString(record)));
  return _logger;
}

// a basic serialization of a [LogRecord]
// TODO: the logging package needs a log message formatting concept 
// and external configuration thereof.
String _logRecordToString(LogRecord record) => 
  '[${record.level}] ${record.message}';

// deletes all files from Directory synchronously
void truncateDirectorySync(Directory directory) {
  var files = directory.listSync() as List<File>;
  files.forEach((File file) => file.deleteSync());
}