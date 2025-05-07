// models/add_cart_item_model.dart
import 'package:equatable/equatable.dart';

class AddCartItemModel extends Equatable {
  final String productId;
  final String variantId;
  final int quantity;

  const AddCartItemModel({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  factory AddCartItemModel.fromJson(Map<String, dynamic> json) {
    return AddCartItemModel(
      productId: json['productId'],
      variantId: json['variantId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "variantId": variantId,
      "quantity": quantity,
    };
  }

  @override
  List<Object?> get props => [productId, variantId, quantity];
}
