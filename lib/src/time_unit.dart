
#library("time_unit");

class TimeUnit {
  
  final String _name;
  
  static const MILLISECOND = const TimeUnit._("MILLISECOND"); 
  static const SECOND = const TimeUnit._("SECOND"); 
  static const MINUTE = const TimeUnit._("MINUTE"); 
  static const HOUR = const TimeUnit._("HOUR"); 
  static const DAY = const TimeUnit._("DAY"); 
  static const WEEK = const TimeUnit._("WEEK"); 
  static const MONTH = const TimeUnit._("MONTH"); 
  static const YEAR = const TimeUnit._("YEAR"); 
  
  const TimeUnit._(this._name);
  
  String toString() => _name;
}
