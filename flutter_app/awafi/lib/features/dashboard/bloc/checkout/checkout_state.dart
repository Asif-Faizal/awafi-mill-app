part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {}

class CheckoutFailure extends CheckoutState {
  final String message;

  const CheckoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UserUnauthorisedState extends CheckoutState {}