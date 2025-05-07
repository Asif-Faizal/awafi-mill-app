import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/api_config.dart';

part 'cancel_order_event.dart';
part 'cancel_order_state.dart';

class OrderCancellationBloc extends Bloc<OrderCancellationEvent, OrderCancellationState> {
  OrderCancellationBloc() : super(OrderCancellationInitial()) {
    on<CancelOrderEvent>(_onCancelOrder);
  }

  // Event handler method
  Future<void> _onCancelOrder(CancelOrderEvent event, Emitter<OrderCancellationState> emit) async {
    // Emit loading state when the event is triggered
    emit(OrderCancellationLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwtToken');
      final url = "${ApiConfig.baseUrl}/orders/order/user/cancel/${event.orderId}";

      final request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });
      request.fields['reason'] = event.reason;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        print(responseData);
        emit(OrderCancellationSuccess(responseData['message']));
      } else {
        emit(OrderCancellationFailure('Failed to cancel order. Please try again.'));
      }
    } catch (e) {
      emit(OrderCancellationFailure('An error occurred: $e'));
    }
  }
}