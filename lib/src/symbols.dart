
#library("relative_time_symbols");

#import("time_unit.dart");
#import("internal.dart");

class RelativeTimeSymbols {
  final String name, past, future;
  final Map<String, List<String>> units;
  
  const RelativeTimeSymbols([this.name, this.past, this.future, this.units]);
  
  RelativeTimeSymbols.fromMap(Map map) : this(
    map["name"],
    map["past"],
    map["future"],
    map["units"]);

  toJson() => {
    "name": name,
    "past": past,
    "future": future,
    "units": units
  };
  
  String toString() => toJson().toString();
  
  String getUnitSymbol(TimeUnit unit, bool isPlural) {
    print("unit: [$unit] isPlural: [$isPlural]");
    var index = (unit == TimeUnit.SECOND) || !isPlural ? 0 : 1;
    return units[unit.toString()][index];
  }
    
}
