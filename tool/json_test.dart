
import 'dart:json';

main() {
  print(JSON.parse('﻿{"name":"bg","past":"%s ago","future":"преди %s","units":{"SECOND":{"other":"няколко секунди"},"MINUTE":{"one":"минута","other":"%d минути"},"HOUR":{"one":"час","other":"%d часа"},"DAY":{"one":"ден","other":"%d дни"},"MONTH":{"one":"месец","other":"%d месеца"},"YEAR":{"one":"година","other":"%d години"}}}'));
}