// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.test.codegen_test;

import 'dart:io';
import 'package:unittest/unittest.dart';
import 'package:pathos/path.dart';
import 'package:intlx/src/codegen.dart';

main() {
  group('Library', () {

    var library, entryPointPath, packageDir, code, imports, tempDir;

    setUp(() {
      tempDir = _createtempDir();
      packageDir = _createPackage(join(tempDir.path, "foo"));
      entryPointPath = join(packageDir.path, "lib", "foo.dart");
      code = 'class A {}';
      imports = [new Import("dart:async"), new Import("dart:io")];
      library = new Library(
        entryPointPath, 
        code, 
      imports, 
      comment: "/// This library is foo",
      staticParts: [join("src", "static1.dart"), join("src", "static2.dart")]);
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    group('generate', () {
      
      var partFromEntryPoint = join('src', 'dynamic.dart');

      test('entry point', () { 

        library.generate();

        var entryPoint = new File(entryPointPath);
        expect(entryPoint.existsSync(), isTrue);
        var contents = entryPoint.readAsStringSync();
        expect(contents, '''
/// This library is foo
library foo.foo;

import 'dart:async';
import 'dart:io';

part 'package:foo/src/static1.dart';
part 'package:foo/src/static2.dart';

class A {}
''');
      });
    
      test("part", () { 
        
        library.addPart(
          partFromEntryPoint, 
          'class B {}', 
          comment: '/// A dynamic part');
        library.generate();
        
        var part = new File(join(dirname(entryPointPath), partFromEntryPoint));
        expect(part.existsSync(), isTrue);
        var contents = part.readAsStringSync();
        expect(contents, '''
/// A dynamic part
part of foo.foo;

class B {}
''');
      });

    });
    
    group('id from path', () {

      void expectLibraryIdFromPath(String path, String expectedLibraryId) {
        var fullPath = join(packageDir.path, path);
        var library = new Library(
          fullPath, 
          '''
class A {}''', 
          []);
        expect(library.id, expectedLibraryId);
      }
  
      test("lib/src", () => 
        expectLibraryIdFromPath(join("lib", "src", "bar.dart"), "foo.bar"));
      
      test("lib", () => 
        expectLibraryIdFromPath(join("lib", "foo.dart"), "foo.foo"));
      
      test("outside lib", () => 
        expectLibraryIdFromPath(join("bar", "baz.dart"), "foo.bar.baz"));
      
    });

  });

  group('Import', () {

    var import;
    
    setUp(() {
      import = new Import(
        "package:foo/foo.dart", 
        as: "foo", 
        show: ["a", "b"], 
        metadata: "@baz");
    });
    
    test("toString outputs correctly formatted import statement", () => 
      expect(import.toString(), '''
@baz
import 'package:foo/foo.dart' as foo show a, b;'''));
  });

  group('PubPackage', () {

    var tempDir, packageDir, package;

    setUp(() {
      tempDir = _createtempDir();
      packageDir = _createPackage(join(tempDir.path, "foo"));
      package = new PubPackage(packageDir.path);
    });
    
    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test("path defaults to current path", () => 
      expect(new PubPackage().path, current));

    test("correct containing path", () => expect(
      new PubPackage.containing(join(packageDir.path, "bar", "baz")).path, 
      packageDir.path));

    test("correct package name", () => 
      expect(package.name, "foo"));

    test("correct package uri", () => expect(
      package.getPackageUri("bar/baz.dart"), 
      "package:foo/bar/baz.dart"));
  });
  
}

// create a basic temp directory
Directory _createtempDir() => new Directory("").createTempSync();

// create a package root and a dummy pubspec within
Directory _createPackage(String packageRoot) {
  // create package root
  var packageDir = new Directory(packageRoot)..createSync();
  // create pubspec
  new File(join(packageDir.path, "pubspec.yaml")).createSync();
  return packageDir;
}  
