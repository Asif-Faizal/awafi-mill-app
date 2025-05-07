// entities/add_cart_item.dart
import 'package:equatable/equatable.dart';

class AddCartItem extends Equatable {
  final String productId;
  final String variantId;
  final int quantity;

  const AddCartItem({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, variantId, quantity];
}
