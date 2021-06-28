import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:stripe_upgrade/services/config.dart';
import 'package:stripe_upgrade/.env.dart';

class FirebaseConfigService implements ConfigService {
  final RemoteConfig _rc = RemoteConfig.instance;

  Future<void> initialize() async {
    await _rc.setDefaults({
      'stripe_account_id': stripeAccountId,
      'stripe_api_key': stripePublishableKey,
      'merchant_id': merchantId,
      'pay_mode': 'test',
      'default_currency': 'usd',
      'min_topup_amount_usd': 5,
    });

    await _rc.fetchAndActivate();
  }

  @override
  StripeInfo getStripeInfo() {
    return StripeInfo(
      accountId: _rc.getString('stripe_account_id'),
      apiKey: _rc.getString('stripe_api_key'),
      merchantId: _rc.getString('merchant_id'),
      payMode: _rc.getString('pay_mode'),
    );
  }

  @override
  String getDefaultCurrency() => _rc.getString('default_currency');

  @override
  int getMinimumTopup(String currency) =>
      _rc.getInt('min_topup_amount_${currency.toLowerCase()}');
}
