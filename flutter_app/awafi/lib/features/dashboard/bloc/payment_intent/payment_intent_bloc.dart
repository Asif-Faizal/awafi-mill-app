import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/api_config.dart';
import '../../data/stripe/stripe_service.dart';
import 'payment_intent_event.dart';
import 'payment_intent_state.dart';

class PaymentIntentBloc extends Bloc<PaymentIntentEvent, PaymentIntentState> {
  final http.Client _client = http.Client();
  final StripeService _stripeService = StripeService.stripeService;
  
  PaymentIntentBloc() : super(PaymentIntentInitial()) {
    on<GetPaymentIntent>((event, emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
      try {
        emit(PaymentIntentLoading());
        
        final response = await _client.get(
          Uri.parse('${ApiConfig.baseUrl}/checkout?paymentMethod=Stripe'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        print(response.body);
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data != null && data['secretKey'] != null) {
            await _stripeService.makePayment(event.context, event.amount, data['secretKey']);
            emit(PaymentIntentLoaded(data['secretKey']));
          } else {
            emit(PaymentIntentError('Invalid response format: missing secret key'));
          }
        } else {
          emit(PaymentIntentError('Failed to get payment intent. Status: ${response.statusCode}'));
        }
      } catch (e) {
        print('Error getting payment intent: $e');
        emit(PaymentIntentError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _client.close();
    return super.close();
  }
} 