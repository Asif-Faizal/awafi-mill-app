part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}
class LoadOrders extends OrdersEvent {
  final int page;
  final int limit;

  const LoadOrders({required this.page, required this.limit});
}