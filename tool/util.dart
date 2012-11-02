
library util;

import 'dart:io';
import 'dart:uri';
import 'dart:utf';

String readFile(filePath) {
  var file = new File.fromPath(filePath);
  return file.readAsTextSync();
}

void writeFile(Path path, String content) {
  var targetFile = new File.fromPath(path);
  targetFile.createSync();
  var raf = targetFile.openSync(FileMode.WRITE);
  raf.truncateSync(0);
  raf.writeStringSync(content);
  raf.flushSync();
  raf.close();
}

writeLibrary(Path path, String name, String code, [String identifier]) {
  if(identifier == null) identifier = name;
  String fullCode = '''
$generatedFileWarning

library $identifier;

$code''';
  writeFile(path.append("$name.dart"), fullCode);
}

const String generatedFileWarning = '''
/// DO NOT EDIT. This file is autogenerated by script.
/// See "tool/build_locale_libraries.dart"''';

Future<String> getUri(String uri) {
  var completer = new Completer();
  var connection = new HttpClient().getUrl(new Uri(uri));
  connection.onResponse = (HttpClientResponse response) {
    // var input = new StringInputStream(response.inputStream, Encoding.UTF_8);
    var input = response.inputStream;
    var listInput = new ListInputStream();
    input.onData = () {
      listInput.write(input.read());
    };
    input.onClosed = () {
      var charCodes = utf8ToCodepoints(listInput.read());
      var body = new String.fromCharCodes(charCodes);
      print("body: $body");
      completer.complete(body);
    };
  };
  connection.onError = (var e) {
    print("getUri error: $e");
  };
  return completer.future;
}

Path _libPath;
Path get libPath {
  if(_libPath === null) {
    var packageRoot = new Path(new Directory.current().path);
    _libPath = packageRoot.append("lib");
  }
  return _libPath;
}

Path _localeLibPath;
Path get localeLibPath {
  if(_localeLibPath === null) {
    _localeLibPath = libPath.append("locale/");
  }
  return _localeLibPath;
}
