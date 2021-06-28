import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:stripe_upgrade/services/config.dart';
import 'package:stripe_upgrade/.env.dart';

class FirebaseConfigService implements ConfigService {
  RemoteConfig _remoteConfig = RemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setDefaults({
      'stripe_account_id': stripeAccountId,
      'stripe_api_key': stripePublishableKey,
      'merchant_id': merchantId,
      'pay_mode': 'test',
    });

    // TODO: Here you can fetch and activate the real remote config values
    // await _remoteConfig.fetchAndActivate();
  }

  @override
  StripeInfo getStripeInfo() {
    return StripeInfo(
      accountId: _remoteConfig.getString('stripe_account_id'),
      apiKey: _remoteConfig.getString('stripe_api_key'),
      merchantId: _remoteConfig.getString('merchant_id'),
      payMode: _remoteConfig.getString('pay_mode'),
    );
  }
}
