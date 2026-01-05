import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'payment_api.dart';

enum PaymentResult { success, cancelled, failed }

class StripeService {
  static Future<PaymentResult> pay({
    required double amount,
    required BuildContext context,
  }) async {
    try {
      final data = await PaymentApi.createPaymentSheet(
        amount: (amount * 100).toInt(),
        currency: 'eur',
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Flutter Flower Shop',
          paymentIntentClientSecret: data['paymentIntent'],
          customerId: data['customer'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment complete!')));

      return PaymentResult.success;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment cancelled')));
        return PaymentResult.cancelled;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.')),
      );
      return PaymentResult.failed;
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
      return PaymentResult.failed;
    }
  }
}
