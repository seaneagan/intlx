// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:json' as json;
import 'package:path/path.dart';
import 'package:mockable_filesystem/filesystem.dart';
import 'package:cldr/cldr.dart';

/// A base implementation of [DataSet].
abstract class _BaseDataSet implements DataSet {

  /// Json file [basename].  The file [extension] is always "json".
  final String _jsonFileBasename;

  String get segment => _jsonFileBasename;

  /// Cldr top-level directory, either "main" or "supplemental".
  final String _subdirectory;

  /// Whether to include the locale in the path to files and data within files.
  final bool _pathIncludesLocale;

  _BaseDataSet(
      this._jsonFileBasename,
      this._subdirectory,
      this._pathIncludesLocale);

  /// Returns the json root relative path to the json file for [locale].
  String _getJsonFilePath(String locale) {
    var subSegments = _getFilePathSegments(locale);
    return join(
        joinAll(subSegments.take(subSegments.length - 1)),
        "${subSegments.last}.json");
  }

  /// Returns the json root relative path to the file for [locale].
  List<String> _getFilePathSegments(String locale) =>
      _getDirPathSegments(locale).toList()..add(_jsonFileBasename);

  /// Returns the json root relative path to the dir for [locale].
  List<String> _getDirPathSegments(String locale) {
    var segments = [_subdirectory];
    if(_pathIncludesLocale) segments.add(locale);
    return segments;
  }

  List<String> _getJsonStructureSegments(String locale) =>
      _getDirPathSegments(locale).toList()..add(segment);

  _getOutputStructure(String jsonRoot, [String locale]) {
    var jsonFilePath = join(jsonRoot, _getJsonFilePath(locale));
    var theJson = fileSystem.getFile(jsonFilePath).readAsStringSync();
    var jsonStructure = json.parse(theJson);
    return _getJsonSubstructure(jsonStructure, locale);
  }

  /// Returns the relevant substructure of [jsonStructure].
  _getJsonSubstructure(var jsonStructure, String locale) =>
      _getJsonStructureSegments(locale).fold(
          jsonStructure,
          (jsonStructure, segment) => jsonStructure[segment]);
}

class MainDataSet extends _BaseDataSet {

  final List<String> parentSegments;

  MainDataSet(String jsonFileBasename, {this.parentSegments: const <String>[]})
      : super(jsonFileBasename, 'main', true);

  Map<String, dynamic> extract(String jsonRoot) {

    var topLevelDir = fileSystem.getDirectory(join(jsonRoot, _subdirectory));
    var locales = topLevelDir
        .listSync()
        .map((dir) => basename(dir.path))
        // TODO: Remove this workaround of http://dartbug.com/10845.
        .where((locale) => locale != 'packages');

    return locales.fold(new Map<String, dynamic>(), (localeDataMap, locale) {
      localeDataMap[locale] = _getOutputStructure(jsonRoot, locale);
      return localeDataMap;
    });
  }

  List<String> _getJsonStructureSegments(String locale) =>
      _getDirPathSegments(locale)
          .toList()
          ..addAll(parentSegments)
          ..add(segment);
}

class SupplementalDataSet extends _BaseDataSet {

  String get segment => _segment == null ? super.segment : _segment;
  final String _segment;

  SupplementalDataSet(String jsonFileBasename, {String segment})
      : _segment = segment,
        super(jsonFileBasename, 'supplemental', false);

  Map<String, dynamic> extract(String jsonRoot) =>
      _getOutputStructure(jsonRoot);
}

class CalendarDataSet extends MainDataSet {

  final String calendarId;

  String get segment => calendarId;

  CalendarDataSet(String calendarId)
      : this.calendarId = calendarId,
        super('ca-$calendarId', parentSegments: ['dates', 'calendars']);
}