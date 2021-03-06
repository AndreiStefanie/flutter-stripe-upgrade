abstract class ConfigService {
  Future<void> initialize();
  StripeInfo getStripeInfo();
  int getMinimumTopup(String currency);
  String getDefaultCurrency();
}

class StripeInfo {
  /// The Stripe account ID - https://stripe.com/docs/dashboard#find-account-id
  final String accountId;

  /// The Stripe publishable key - https://stripe.com/docs/keys
  final String apiKey;

  /// The Apple Pay Merchant ID - https://stripe.com/docs/apple-pay
  final String merchantId;

  /// 'test' or 'prod' - relevant especially for native payment methods (GPay)
  /// which do not provide credit cards for testing
  final String payMode;

  StripeInfo({
    required this.accountId,
    required this.apiKey,
    required this.merchantId,
    required this.payMode,
  });
}
