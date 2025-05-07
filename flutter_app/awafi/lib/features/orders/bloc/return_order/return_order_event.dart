part of 'return_order_bloc.dart';

abstract class ReturnOrderEvent {}

class OrderReturnEvent extends ReturnOrderEvent {
  final String orderId;
  final String productId;
  final String variantId;
  final String reason;

  OrderReturnEvent({required this.orderId, required this.reason, required this.productId, required this.variantId});
}