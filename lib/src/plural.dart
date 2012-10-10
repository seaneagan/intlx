
library plural;

class PluralLocale {
  PluralLocale([String locale]) {
    
  }

  Plurality getPlurality(int quantity) {
    return quantity == 1 ? Plurality.ONE : Plurality.OTHER;
  }
}

class Plurality {

  static const ZERO = const Plurality._("zero");
  static const ONE = const Plurality._("one");
  static const TWO = const Plurality._("two");
  static const FEW = const Plurality._("few");
  static const MANY = const Plurality._("many");
  static const OTHER = const Plurality._("other");
  
  const Plurality._(this._name);

  final String _name;

  String toString() => _name;
}