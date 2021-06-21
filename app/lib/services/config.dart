abstract class ConfigService {
  Future<void> initialize();
  StripeInfo getStripeInfo();
}

class StripeInfo {
  // The Stripe account ID - https://stripe.com/docs/dashboard#find-account-id
  final String accountId;

  // The Stripe publishable key - https://stripe.com/docs/keys
  final String apiKey;

  // The Apple Pay Merchant ID - https://stripe.com/docs/apple-pay
  final String merchantId;

  // 'test' or 'prod' - relevant especially for native payment methods (GPay)
  // which do not provide credit cards for testing
  final String payMode;

  StripeInfo(this.accountId, this.apiKey, this.merchantId, this.payMode);
}
