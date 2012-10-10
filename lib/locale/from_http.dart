
library from_http;

import '../src/internal.dart';
import 'package:intl/src/http_request_data_reader.dart';

void initRelativeTimeLocale(String locale, String url) {
  initLocale(locale, new HTTPRequestDataReader('${url}relative_time/'));
}