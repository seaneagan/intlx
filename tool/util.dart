
library utils;

import 'dart:io';
import 'dart:uri';

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

Future<String> getUri(String uri) {
  var completer = new Completer();
  var connection = new HttpClient().getUrl(new Uri(uri));
  connection.onResponse = (HttpClientResponse response) {
    var input = new StringInputStream(response.inputStream);
    String body = '';
    input.onData = () {
      body = "$body${input.read()}";
    };
    input.onClosed = () {
      print("body: $body");
      completer.complete(body);
    };
  };
  connection.onError = (var e) {
    print("getUri error: $e");
  };
  return completer.future;
}
