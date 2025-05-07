part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();
  
  @override
  List<Object> get props => [];
}


class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;

  const OrdersLoaded({required this.orders});
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required this.message});
}