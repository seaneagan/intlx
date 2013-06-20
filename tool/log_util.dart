// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.log_util;

import 'package:logging/logging.dart';
import 'dart:async';

class LogStep {
  final Logger _logger;
  final String _description;
  final Level _level;
  LogStep(this._logger, this._description, {Level level: Level.INFO}) : _level = level;
  
  start() => _logBoundary("START");
  end() => _logBoundary("END  ");
  execute(f()) {
    start();
    var ret = f();
    if(ret is Future) return ret.then((v) {
      end();
      return v;
    });
    end();
    return ret;
  }
  
  _logBoundary(String boundary) => _logger.log(_level, "$boundary STEP: $_description");
}

getLogger(String name) {
  var _logger = new Logger(name);
  _logger.onRecord.listen((record) => print(_logRecordToString(record)));
  return _logger;
}

String _logRecordToString(LogRecord record) => '[${record.level}] ${record.message}';
