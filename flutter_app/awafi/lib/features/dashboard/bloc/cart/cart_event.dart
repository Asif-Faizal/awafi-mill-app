part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCartItems extends CartEvent {}

class UpdateCartQuantity extends CartEvent {
  final String productId;
  final String variantId;
  final int quantity;

  UpdateCartQuantity({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, variantId, quantity];
}

class RemoveCartItem extends CartEvent {
  final String productId;
  final String variantId;

  RemoveCartItem({
    required this.productId,
    required this.variantId,
  });

  @override
  List<Object?> get props => [productId, variantId];
}