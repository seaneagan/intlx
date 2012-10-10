
library from_file;

import 'dart:io';
import '../src/internal.dart';
import 'package:intl/src/file_data_reader.dart';

void initRelativeTimeLocale(String locale, String path) {
  initLocale(locale, new FileDataReader('${path}relative_time${Platform.pathSeparator}'));
}