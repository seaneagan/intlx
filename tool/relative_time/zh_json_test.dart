
import '../util.dart';
import 'dart:json';

main() {
  fetchUri("http://i18ndata.appspot.com/cldr/tags/unconfirmed/main/zh/units?depth=-1").then((json) {
    print("json: $json");
    print("parsed: ${JSON.parse(json)}");
  });
}