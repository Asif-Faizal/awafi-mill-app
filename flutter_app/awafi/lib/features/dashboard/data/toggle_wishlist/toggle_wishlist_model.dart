class ToggleWishlistItemModel {
  final String productId;
  final String variantId;

  ToggleWishlistItemModel({required this.productId, required this.variantId});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
    };
  }

  factory ToggleWishlistItemModel.fromJson(Map<String, dynamic> json) {
    return ToggleWishlistItemModel(
      productId: json['productId'],
      variantId: json['variantId'],
    );
  }
}
