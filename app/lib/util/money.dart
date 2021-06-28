import 'package:money2/money2.dart';

class MoneyHelper {
  /// Converts a string amount (no currency, no separators) to a money instance
  static Money convertUserInput(String amount, String currencyCode) {
    Currency currency = _getCurrency(currencyCode);
    double _amount = double.parse(amount);
    return Money.from(_amount, currency);
  }

  static String toAmountString(Money money) => money.minorUnits.toString();

  static String toStringWithoutCurrency(Money money) => money.format(
        money.currency.pattern.replaceAll('S', ''),
      );

  static Currency _getCurrency(String currencyCode) {
    var curr = Currencies.find(currencyCode.toUpperCase());

    if (curr == null) {
      throw Exception('Unsupported currency $currencyCode');
    }

    return curr;
  }

  static Money convertToMoney(int amount, String currency) =>
      Money.fromInt(amount, MoneyHelper._getCurrency(currency));

  static Money convertDoubleToMoney(double amount, String currency) =>
      Money.from(amount, MoneyHelper._getCurrency(currency));
}
