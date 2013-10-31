#!/usr/bin/env dart

import 'dart:io';
import 'package:path/path.dart';
import 'package:polymer/builder.dart';

var entryPoint = join('web', 'index.html');
var dartOutput = join('out', '${entryPoint}_bootstrap.dart');
var jsOutput = '$dartOutput.js';

void main() {
  build(entryPoints: [entryPoint]).then(compileToJs);
}

compileToJs(_) {
  print("Running dart2js");
  var dart2js = join(dirname(Platform.executable), 'dart2js');
  var result =
    Process.runSync(dart2js, [ // '--minify',
        '-o', jsOutput,
        dartOutput], runInShell: true);
  print(result.stdout);
  print("Done");
}
