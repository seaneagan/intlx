@observable
library intlx.age.example;

import 'package:web_ui/web_ui.dart';
import 'package:intl/intl.dart';
import 'package:intlx/relative_time_locale_data.dart' as relative_time_data;

var dateTime = new DateTime.now();

void main() {
 var localeData = relative_time_data.EN;
 localeData.load();
 Intl.systemLocale = localeData.locale;
}
