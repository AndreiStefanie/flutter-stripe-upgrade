import 'package:cloud_functions/cloud_functions.dart';
import 'package:stripe_payment/stripe_payment.dart' as stripe;
import 'package:stripe_upgrade/locator.dart';
import 'package:stripe_upgrade/services/payments.dart';

class FirebasePaymentsService implements PaymentsService {
  @override
  Future<stripe.PaymentMethod> createPaymentMethod(stripe.Token token) async {
    HttpsCallable function = _getCallable('createPaymentMethod');

    final result = await function.call(<String, dynamic>{
      'token': token.toJson(),
    });

    return stripe.PaymentMethod.fromJson(result.data);
  }

  @override
  Future<PaymentIntentResult> createPaymentIntent(
    int amount,
    String currency,
    String paymentMethodId,
  ) async {
    HttpsCallable function = _getCallable('createPaymentIntent');

    final result = await function.call(
      <String, dynamic>{
        'amount': amount,
        'currency': currency.toLowerCase(),
        'paymentMethodId': paymentMethodId,
      },
    );

    return PaymentIntentResult(
      status: result.data['status'],
      customerId: result.data['customerId'],
      clientSecret: result.data['clientSecret'],
    );
  }

  HttpsCallable _getCallable(String function) {
    return locator<FirebaseFunctions>().httpsCallable(function);
  }
}
