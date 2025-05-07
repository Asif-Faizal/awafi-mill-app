class CartItemModel {
  final String productId;
  final String variantId;
  final String name;
  final int quantity;
  final String weight;
  final double inPrice;
  final double outPrice;
  final String images;
  final int stockQuantity;
  final double rating;

  CartItemModel({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.quantity,
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.images,
    required this.stockQuantity,
    required this.rating,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      variantId: json['variantId'],
      name: json['name'],
      quantity: json['quantity'],
      weight: json['weight'],
      inPrice: (json['inPrice'] as num).toDouble(),
      outPrice: (json['outPrice'] as num).toDouble(),
      images: json['images'],
      stockQuantity: json['stockQuantity'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
