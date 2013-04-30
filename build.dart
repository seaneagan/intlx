import 'package:web_ui/component_build.dart';
import 'dart:io';

void main() {
  var arguments = new Options().arguments;
  print("arguments: $arguments");
  return;
  build(arguments, ['web/index_source.html']);
}

