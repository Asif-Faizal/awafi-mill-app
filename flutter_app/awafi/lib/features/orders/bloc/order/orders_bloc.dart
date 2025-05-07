import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/purchase_history/fetch_orders.dart';
import '../../domain/purchase_history/order_entity.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final FetchOrdersUseCase fetchOrdersUseCase;

  OrdersBloc({required this.fetchOrdersUseCase}) : super(OrdersInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await fetchOrdersUseCase(event.page, event.limit);
        emit(OrdersLoaded(orders: orders));
      } catch (e) {
        emit(OrdersError(message: e.toString()));
      }
    });
  }
}