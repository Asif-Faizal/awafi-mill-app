part of 'cancel_order_bloc.dart';

abstract class OrderCancellationEvent {}

class CancelOrderEvent extends OrderCancellationEvent {
  final String orderId;
  final String reason;

  CancelOrderEvent({required this.orderId, required this.reason});
}