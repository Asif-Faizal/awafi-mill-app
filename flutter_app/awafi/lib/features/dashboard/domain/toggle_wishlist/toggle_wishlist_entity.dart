import 'package:equatable/equatable.dart';

class ToggleWishlistItem extends Equatable {
  final String productId;
  final String variantId;

  const ToggleWishlistItem({required this.productId, required this.variantId});

  @override
  List<Object> get props => [productId, variantId];
}
