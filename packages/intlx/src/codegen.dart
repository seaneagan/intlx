// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: move this to its own "codegen" package.
library intlx.tool.codegen;

import 'dart:io';
import 'dart:json' as json;
import 'dart:async';
import 'package:pathos/path.dart';

/// Utility for generating a dart library
class LibraryBuilder {
  
  PubPackage _package;

  /// The entry point file for the library
  _LibraryFile _entryPoint;
  
  /// Paths of parts written by hand ahead of time.
  final Iterable<String> _staticParts;
  
  /// Map of package relative paths to parts to generate
  final Map<String, _Part> _dynamicParts = {};
  
  /// The identifier to use in the "library" clause
  String _libraryId;
    
  LibraryBuilder(
    /// For now this must be a relative path from the current directory
    /// which must be the root of the pub package.
    String path, 
    String code, 
    Iterable<Import> imports, 
    {String libraryId,
    String comment, 
    Iterable<String> staticParts : const []}) : 
      _staticParts = staticParts {
      
    _package = new PubPackage();
    var parts = [_staticParts, _dynamicParts.keys]
    .expand((i) => i)
    .map((part) => _package.getPackageUri(part));
    
    _libraryId = libraryId == null ? _package.getLibraryIdFromPath(join(_package.path, path)) : libraryId;
    
    _entryPoint = new _LibraryFile(_libraryId, path, code, imports, parts, comment);
  }
  
  /// Add a part to generate
  /// [path] is relative to the packageRoot
  void addPart(String path, String code, [String comment]) { 
    _dynamicParts[path] = new _Part(_libraryId, join(_package.path, "lib", path), code, comment);
  }
  
  /// Generate the library
  void generate() {
    _entryPoint.generate();
    _dynamicParts.values.forEach((_Part part) => part.generate());
  }
}

class _LibraryFile extends DartFile {
  final Iterable<Import> imports;
  final Iterable<String> parts;

  _LibraryFile(
    String libraryId, 
    String path, 
    String code, 
    this.imports, 
    this.parts, 
    [String comment]) : super(libraryId, path, code, comment);
  
  String get body => '''
$importSection$partSection$code
''';
  
  String get importSection => imports.join('\n') + (imports.isEmpty ? '' : '\n\n');
  String get partSection => 
    parts.map((String part) => "part '$part';").join('\n') + 
    (parts.isEmpty ? '' : '\n\n');
  
  final String _headKeyWord = 'library';
  
}

class _Part extends DartFile {
  _Part(String libraryId, String path, String code, [String comment]) : 
    super(libraryId, path, code, comment);

  final String _headKeyWord = 'part of';
}

abstract class DartFile {
  DartFile(this.libraryId, this.path, this.code, [this.comment]);
  
  final String libraryId;
  final String path;
  final String comment;
  final String code;
  String get _headKeyWord;
  String get body => code;
  String get contents => '''
$comment
$_headKeyWord $libraryId;

$body''';

  void generate() => new File(path).writeAsStringSync(contents);
}

/// Represents an import directive
class Import {
  final String uri;
  final String as;
  final Iterable<String> show;
  final Iterable<String> hide;
  final String metadata;

  String get _metadata => metadata.isEmpty ? '' : '''$metadata
''';
  String get _asClause => as == '' ? '' : ' as $as';
  String get _showClause => _getVisibilityClause("show", show);
  String get _hideClause => _getVisibilityClause("hide", hide);
  String _getVisibilityClause(String type, Iterable<String> values) => 
      values.isEmpty ? '' : ' $type ${values.join(', ')}';
  
  Import(
    this.uri, 
    {this.as : '', 
    this.show : const [], 
    this.hide : const [], 
    this.metadata : ''});
  
  String toString() => 
    "${_metadata}import '$uri'$_asClause$_showClause$_hideClause;";
}

class PubPackage {
  
  static final Builder _importBuilder = new Builder(style: Style.url);

  final String path;
  final String name;
  
  PubPackage._(String path) : 
    this.path = path, 
    name = basename(path);
  
  /// [path] defaults to the [current] path.
  // TODO: Consider instead calculating the root of the pub package, 
  // containing the currently executing script, 
  // so scripts may be run from anywhere.
  factory PubPackage([String path]) => 
    new PubPackage._(path == null ? current : path);
  
  String getPackageUri([String path]) => 
    _importBuilder.join("package:$name", path == null ? "$name.dart" : path);
  
  String getLibraryIdFromPath(String path) {
    
    var dir = dirname(path);
    
    var contextPath = ['lib/src', 'lib', ''].firstWhere(
        (i) => contains(dir, join(this.path, i)));
    
    var suffixPath = relative(dir, from: contextPath);
    
    var segments = split(suffixPath).where((i) => i != '.').toList()
      ..insert(0, this.name)
      ..add(basenameWithoutExtension(path));
    
    return segments.join('.');
  }

}

// TODO: Add something like this to package:pathos ?
bool contains(String path, String container) => 
    !relative(path, from: container).startsWith('..');
