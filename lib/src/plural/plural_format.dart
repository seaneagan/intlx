
part of intlx;

class PluralFormat {
  PluralFormat(this._cases, {String locale, String pattern}) : _locale = new PluralLocale(locale), _pattern = pattern;

  String format(int quantity) {
    var quantityString = quantity.toString();
    String key;
    if(_cases.containsKey(quantityString)) {
      key = quantityString;
    } else {
      var category = _locale.getPluralCategory(quantity).toString().toLowerCase();
      if(_cases.containsKey(category)) {
        key = category;
      } else {
        if(_cases.containsKey('other')) {
          key = 'other';
        } else {
          throw new Exception('No case found for quantity: $quantity');
        }
      }
    }
    var message = _cases[key];
    if(_pattern != null) {
      message = message.replaceFirst(_pattern, quantityString);
    }
    return message;

  }

  final Map<String, String> _cases;
  final String _pattern;
  final PluralLocale _locale;
}
