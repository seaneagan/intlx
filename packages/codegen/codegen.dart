// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Utilities for generating dart code.
library codegen;

import 'dart:io';
import 'package:path/path.dart';

/// Utility for generating a dart library.
///
/// It can generate the following:
///
/// * library name
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
  String name;

  /// Creates a library.
  ///
  /// The library's entry point will be stored at [path], and contain
  /// declarations specified by [code], and a list of [imports].
  ///
  /// The [name] of the library if not specified, is calculated by removing any
  /// 'lib/src' or 'lib' prefix, converting [path] to dot-separated, and
  /// prepending the package name.  For example, if the library is in package
  /// "foo", then [path] maps to default [name] as follows:
  ///
  /// 'lib/src/bar.dart' => 'foo.bar'
  /// 'lib/foo.dart' => 'foo.foo'
  /// 'bar/baz.dart' => 'foo.bar.baz'
  ///
  /// A [comment] can be specified, which will be included directly before the
  /// "library" directive.  A list of static "part" directives for
  /// non-generated parts can be specified in [staticParts].
  Library(
      String path,
      String code,
      Iterable<Import> imports, {
      this.name,
      String comment,
      Iterable<String> staticParts : const []})
      : _staticParts = staticParts {

    var entryPointPath = absolute(path == null ? current : path);

    _package = new PubPackage.containing(entryPointPath);

    if(name == null) name =_package._getLibraryNameFromPath(entryPointPath);

    _entryPoint = new _LibraryEntryPoint(
        name, entryPointPath, code, imports, () => _parts, comment);
  }

  /// The paths of all "part"s of this library.
  Iterable<String> get _parts => [_staticParts, _dynamicParts.keys]
      .expand((i) => i)
      .map((part) {
        var libToEntryPoint =
            relative(dirname(_entryPoint.path), from: _package.lib);
        return _package.getPackageUri(normalize(join(libToEntryPoint, part)));
      });

  /// Adds a part to the library, at a relative [path] from the entry point,
  /// with declarations specified by [code].  A [comment] can be specified,
  /// which will be included directly before the "part of" directive.
  void addPart(
      String path,
      String code, {
      String comment}) {
    var partPath =
        isAbsolute(path) ? path : join(dirname(_entryPoint.path), path);
    _dynamicParts[path] = new _Part(name, partPath, code, comment);
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

  String _path;

  /// The path to this package on the file system.
  String get path {
    if(_path == null) _path = current;
    return _path;
  }

  String _name;

  /// The name of this package.
  String get name {
    if(_name == null) _name = basename(path);
    return _name;
  }

  PubPackage([this._path]);

  /// Represents the package containing the specified path.
  PubPackage.containing([String path])
      : this(_getPackageRoot(path));

  /// Gets the "package:" uri relative to the package root.
  ///
  /// For example, if [name == "foo"], then:
  ///     getPackageUri('foo.dart') == 'package:foo/foo.dart'
  String getPackageUri(String path) =>
      new Uri(
          scheme: 'package',
          pathSegments: [name]..addAll(split(path)))
      .toString();

  /// The path to the public source code of this package.
  String get lib => join(path, LIB);

  /// The path to the private source code of this package.
  String get src => join(path, SRC);

  String _getLibraryNameFromPath(String path) {

    var dir = dirname(path);

    var contextPath = [SRC, LIB, '']
        .map((subPath) => join(this.path, subPath))
        .firstWhere((container) => _containsPath(dir, container));

    var suffixPath = relative(dir, from: contextPath);

    var segments = split(suffixPath).where((segment) => segment != '.').toList()
        ..insert(0, this.name)
        ..add(basenameWithoutExtension(path));

    return segments.join('.');
  }

  /// The package root relative path to the public source code of a package.
  static final String LIB = "lib";

  /// The package root relative path to the private source code of a package.
  static final String SRC = join(LIB, "src");

  /// The [basename] of a pubpsec file.
  static final String PUBSPEC = "pubspec.yaml";

  /// Calculate the root of the package containing path.
  static String _getPackageRoot(String subPath) {
    subPath = absolute(subPath);
    var segments = split(subPath);
    var testPath = subPath;

    // Walk up directory hierarchy until we find a pubspec.
    for(int i = 0; i < segments.length; i++) {
      var testDir = new Directory(testPath);
      if(testDir.existsSync() && testDir.listSync().any((fse) =>
          basename(fse.path) == PUBSPEC)) {
        return testPath;
      }
      testPath = dirname(testPath);
    }

    throw new ArgumentError(
        "No package root (containing pubspec.yaml) "
        "found in hierarchy of path: $subPath");
  }
}

typedef Iterable<String> _GetParts();

/// Represents a library entry point file.
class _LibraryEntryPoint extends _DartFile {
  final Iterable<Import> imports;
  final _GetParts getParts;

  _LibraryEntryPoint(
      String libraryName,
      String path,
      String code,
      this.imports,
      this.getParts,
      [String comment])
      : super(libraryName, path, code, comment);

  String get body => '$importSection$partSection${super.body}';

  String get importSection =>
      imports.join('\n') + (imports.isEmpty ? '' : '\n\n');
  String get partSection {
    var parts = getParts();
    return parts.map((String part) => "part '$part';").join('\n') +
    (parts.isEmpty ? '' : '\n\n');
  }

  final String _headKeyWord = 'library';

}

/// Represents a library part file.
class _Part extends _DartFile {
  _Part(String libraryName, String path, String code, [String comment])
      : super(libraryName, path, code, comment);

  final String _headKeyWord = 'part of';
}

/// Represents a dart source code file.
abstract class _DartFile {

  _DartFile(this.libraryName, this.path, this.code, [this.comment]);

  /// The name of the library containing this file.
  final String libraryName;

  /// The absolute path of the file.
  final String path;

  /// The comment to place before the "library"/"partof" directive.
  final String comment;

  /// The declarations of the file.
  final String code;

  /// Either "library" or "part of".
  String get _headKeyWord;

  /// Everything below the "library"/"partof" directive.
  String get body => '''
$code
''';

  /// The complete text of the file.
  String get contents => '''
${comment == null ? '' : comment}
$_headKeyWord $libraryName;

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
