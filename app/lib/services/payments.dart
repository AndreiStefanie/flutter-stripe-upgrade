import 'package:stripe_payment/stripe_payment.dart';

abstract class PaymentsService {
  /**
   * Add a new payment method to the authenticated user in Stripe
   */
  Future<PaymentMethod> createPaymentMethod(
    Token token,
  );

  /**
   * Handles the required setup for performing a payment using
   * Stripe Payment Intents
   */
  Future<PaymentIntentResult> createPaymentIntent(
    int amount,
    String currency,
    String paymentMethodId,
  );
}

class PaymentIntentResult {
  final String status;
  final String customerId;
  final String clientSecret;

  PaymentIntentResult(this.status, this.customerId, this.clientSecret);
}
