import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/api_config.dart';

part 'return_order_event.dart';
part 'return_order_state.dart';

class ReturnOrderBloc extends Bloc<ReturnOrderEvent, ReturnOrderState> {
  ReturnOrderBloc() : super(ReturnOrderInitial()) {
    on<OrderReturnEvent>(_onReturnOrder);
  }

  // Event handler method
  Future<void> _onReturnOrder(OrderReturnEvent event, Emitter<ReturnOrderState> emit) async {
    // Emit loading state when the event is triggered
    emit(ReturnOrderLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwtToken');
      final url = "${ApiConfig.baseUrl}/orders/order/user/return/${event.orderId}";

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Specify that we're sending JSON
      };

      // Creating the JSON body with the required fields
      final body = json.encode({
        'returnReason': event.reason, // Example reason
        'productId': event.productId, // Example product ID
        'variantId': event.variantId, // Example variant ID
      });

      // Sending the PUT request with raw JSON body
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        emit(ReturnOrderSuccess(responseData['message']));
      } else {
        emit(ReturnOrderFailure('Failed to return order. Please try again.'));
      }
    } catch (e) {
      emit(ReturnOrderFailure('An error occurred: $e'));
    }
  }
}
