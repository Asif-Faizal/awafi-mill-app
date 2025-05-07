class WishlistModel {
  final String productId;
  final String variantId;
  final String name;
  final String weight;
  final int inPrice;
  final int outPrice;
  final String images;
  final int stockQuantity;
  final double? rating;

  WishlistModel({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.images,
    required this.stockQuantity,
    this.rating,
  });

  // Manually convert JSON to WishlistModel
  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      productId: json['productId'] as String,
      variantId: json['variantId'] as String,
      name: json['name'] as String,
      weight: json['weight'] as String,
      inPrice: json['inPrice'] as int,
      outPrice: json['outPrice'] as int,
      images: json['images'] as String,
      stockQuantity: json['stockQuantity'] as int,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert WishlistModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
      'name': name,
      'weight': weight,
      'inPrice': inPrice,
      'outPrice': outPrice,
      'images': images,
      'stockQuantity': stockQuantity,
      'rating': rating,
    };
  }
}
