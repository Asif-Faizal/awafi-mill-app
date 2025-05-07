part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutInitiated extends CheckoutEvent {
  final CheckoutEntity checkoutEntity;

  const CheckoutInitiated(this.checkoutEntity);

  @override
  List<Object?> get props => [checkoutEntity];
}