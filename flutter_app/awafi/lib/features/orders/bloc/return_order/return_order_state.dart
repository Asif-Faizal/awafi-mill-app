part of 'return_order_bloc.dart';

abstract class ReturnOrderState {}

class ReturnOrderInitial extends ReturnOrderState {}

class ReturnOrderLoading extends ReturnOrderState {}

class ReturnOrderSuccess extends ReturnOrderState {
  final String message;

  ReturnOrderSuccess(this.message);
}

class ReturnOrderFailure extends ReturnOrderState {
  final String error;

  ReturnOrderFailure(this.error);
}