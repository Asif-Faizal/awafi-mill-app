part of 'add_cart_bloc.dart';

abstract class AddCartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCartItemEvent extends AddCartEvent {
  final AddCartItem cartItem;

  AddCartItemEvent({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}