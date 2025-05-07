part of 'cancel_order_bloc.dart';

abstract class OrderCancellationState {}

class OrderCancellationInitial extends OrderCancellationState {}

class OrderCancellationLoading extends OrderCancellationState {}

class OrderCancellationSuccess extends OrderCancellationState {
  final String message;

  OrderCancellationSuccess(this.message);
}

class OrderCancellationFailure extends OrderCancellationState {
  final String error;

  OrderCancellationFailure(this.error);
}