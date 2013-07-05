// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Utilities for generating dart code.
// TODO: move this to its own "codegen" package.
library intlx.codegen;

import 'dart:io';
import 'dart:json' as json;
import 'dart:async';
import 'package:pathos/path.dart';
import 'package:intlx/src/util.dart';

/// Utility for generating a dart library.
/// 
/// It can generate the following:
/// 
/// * library identifier
/// * "library", "import", "part" and "part of" directives
/// * entry point file
/// * part files
/// 
/// Any parts must be within the containing pub package's "lib" directory,
/// as the generated "part" directives use "package:" Uri's.  
/// Any relative part paths given are relative to the entry point path.
class Library {
  
  /// The package which contains this library.
  PubPackage _package;

  /// The entry point file for the library
  _LibraryEntryPoint _entryPoint;
  
  final Iterable<String> _staticParts;
  
  /// Map of package relative paths to parts to generate there.
  final Map<String, _Part> _dynamicParts = {};
  
  /// The identifier to use in "library" and "part of" directives.
  String id;
  
  Library(
    /// The path at which to store the library entry point.
    String path, 
    /// The code for the declarations to place in the library entry point.
    /// No directives should be included in this.
    String code, 
    /// The imports to include in this library.
    Iterable<Import> imports, {
    /// The default is calculated by removing any 'lib/src' or 'lib' prefix,
    /// converting [path] to dot-separated, and prepending the package name.
    /// For example, if the library is in package "foo", then [path] 
    /// maps to default [id] as follows:
    /// 
    /// 'lib/src/bar.dart' => 'foo.bar'
    /// 'lib/foo.dart' => 'foo.foo'
    /// 'bar/baz.dart' => 'foo.bar.baz'
    this.id,
    /// Comment(s) to include directly before the "library" directive.
    String comment, 
    /// Paths of parts written by hand ahead of time, i.e. non-generated.
    Iterable<String> staticParts : const []}) : 
      _staticParts = staticParts {
    
    path = path == null ? current : path;
    path = absolute(path);
    _package = new PubPackage.containing(path);
    var parts = [_staticParts, _dynamicParts.keys]
    .expand((i) => i)
    .map((part) {
      var libToEntryPoint = 
        relative(dirname(_entryPoint.path), from: join(_package.path, "lib"));
      return _package.getPackageUri(normalize(join(libToEntryPoint, part)));
    });
    
    this.id = id == null ? 
      _package._getLibraryIdFromPath(path) : 
      id;
    
    _entryPoint = 
      new _LibraryEntryPoint(id, path, code, imports, parts, comment);
  }
  
  /// Add a part to the library.
  void addPart(
    /// The path of the part relative to the library entry point.
    String path, 
    /// The code for the declarations to place in the part.
    /// No directives should be included in this.
    String code, {
    /// Comment(s) to include directly before the "part of" directive.
    String comment}) { 
    var partPath = 
      isAbsolute(path) ? path : join(dirname(_entryPoint.path), path);
    _dynamicParts[path] = new _Part(id, partPath, code, comment);
  }
  
  /// Generate the library, by writing its entry point file, 
  /// and any dynamic part files to the file system.
  void generate() {
    _entryPoint.generate();
    _dynamicParts.values.forEach((_Part part) => part.generate());
  }
}

/// Represents an import directive.
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
  
  /// Returns formatted code representing this "import" directive.
  String toString() => 
    "${_metadata}import '$uri'$_asClause$_showClause$_hideClause;";
}

/// Represents a pub package.
// TODO: Add mechanism to create/edit pubspecs.
class PubPackage {
  
  static final _importBuilder = new Builder(style: Style.url);

  /// The path to this package on the file system
  final String path;
  /// The name of this package.
  final String name;
  
  PubPackage([String path]) : 
    this.path = ifNull(path, current), 
    this.name = basename(ifNull(path, current));
  
  /// The package containing the specified path
  PubPackage.containing([String path]) : this(_getPackageRoot(path));

  /// Gets the "package:" uri relative to the package root.  
  /// For example, if [name == "foo"], then:
  /// [getPackageUri(['foo.dart']) == 'package:foo/foo.dart'].
  // TODO: Use Uri constructor instead?
  String getPackageUri(String path) =>
    _importBuilder.joinAll(["package:$name"]..addAll(split(path)));
  
  String _getLibraryIdFromPath(String path) {
    
    var dir = dirname(path);
    
    var contextPath = [join('lib', 'src'), 'lib', '']
    .map((i) => join(this.path, i))
    .firstWhere((i) => _containsPath(dir, i));
    
    var suffixPath = relative(dir, from: contextPath);
    
    var segments = split(suffixPath).where((i) => i != '.').toList()
      ..insert(0, this.name)
      ..add(basenameWithoutExtension(path));
    
    return segments.join('.');
  }
  
  /// The standard directory within a package which contains public code.
  static String LIB = "lib";
  /// The standard directory within a package which contains private code.
  static String SRC = join(LIB, "src");
  
  /// Calculate the root of the package containing path.
  static String _getPackageRoot(String path) {
    path = absolute(path);
    var segments = split(path);
    
    // walk up directory hierarchy until we find a pubspec
    for(int i = 0; i < segments.length; i++) {
      var testPath = joinAll(segments.take(segments.length - i));
      var testDir = new Directory(testPath);
      if(testDir.existsSync() && testDir.listSync().any((fse) => 
        basename(fse.path) == "pubspec.yaml")) {
        return testPath;
      }
    }
    
    throw new ArgumentError(
      "No package root (containing pubspec.yaml) "
      "found in hierarchy of path: $path");
  }

}

/// A library entry point file
class _LibraryEntryPoint extends _DartFile {
  final Iterable<Import> imports;
  final Iterable<String> parts;

  _LibraryEntryPoint(
    String libraryId, 
    String path, 
    String code, 
    this.imports, 
    this.parts, 
    [String comment]) : super(libraryId, path, code, comment);
  
  String get body => '$importSection$partSection${super.body}';
  
  String get importSection => 
    imports.join('\n') + (imports.isEmpty ? '' : '\n\n');
  String get partSection => 
    parts.map((String part) => "part '$part';").join('\n') + 
    (parts.isEmpty ? '' : '\n\n');
  
  final String _headKeyWord = 'library';
  
}

/// A library part file
class _Part extends _DartFile {
  _Part(String libraryId, String path, String code, [String comment]) : 
    super(libraryId, path, code, comment);

  final String _headKeyWord = 'part of';
}

/// A dart source code file
abstract class _DartFile {
  _DartFile(this.libraryId, this.path, this.code, [this.comment]);
  
  final String libraryId;
  final String path;
  final String comment;
  final String code;
  String get _headKeyWord;
  String get body => '''
$code
''';
  String get contents => '''
$comment
$_headKeyWord $libraryId;

$body''';

  /// Writes the file to [path].
  void generate() {
    var file = new File(path);
    file.directory.createSync(recursive: true);
    file.writeAsStringSync(contents);
  }
}

// TODO: Add something like this to package:pathos ?
bool _containsPath(String path, String container) => 
  !relative(path, from: container).startsWith('..');
