import 'package:awafi/core/config/api_config.dart';
import 'package:awafi/features/dashboard/presentation/order_placed_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService stripeService = StripeService._();

  Future<void> makePayment(BuildContext context, int amount, String secretKey) async {
    try {
      String? clientSecret = await _createPayment(amount, 'AED', secretKey);
      print('Client Secret: $secretKey');
      
      if (clientSecret == null) {
        throw Exception('Failed to create payment intent');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Awafi",
        ),
      );

      await processPayment(context);
    } catch (e) {
      print('Payment failed: ${e.toString()}');
      _navigateToFailurePage(context);
    }
  }

  Future<String?> _createPayment(int amount, String currency, String secretKey) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> body = {
        "amount": amount * 100, // Convert to cents
        "currency": currency,
      };

      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $secretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          },
        ),
      );

      print('Stripe API Response: ${response.data}');
      
      if (response.data != null && response.data["client_secret"] != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print('Error creating payment: ${e.toString()}');
      return null;
    }
  }

  Future<void> processPayment(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      _navigateToSuccessPage(context);
    } on StripeException catch (e) {
      print('StripeException: ${e.error.localizedMessage}');
      _navigateToFailurePage(context);
    } catch (e) {
      print('General error: ${e.toString()}');
      _navigateToFailurePage(context);
    }
  }

  void _navigateToSuccessPage(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => OrderPlacedScreen())
    );
  }

  void _navigateToFailurePage(BuildContext context) {
    print('Payment Failed');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Text('Payment failed. Please try again.'))
    );
  }
}