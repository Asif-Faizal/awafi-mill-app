part of 'cart_bloc.dart';
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class CartUpdated extends CartState {
  final List<CartItem> updatedItems;

  CartUpdated(this.updatedItems);

  @override
  List<Object?> get props => [updatedItems];
}

class CartRemoved extends CartState {
  final List<CartItem> updatedItems;

  CartRemoved(this.updatedItems);

  @override
  List<Object?> get props => [updatedItems];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartUnauthorized extends CartState {}

class CartNotFound extends CartState {}