// models/product_model.dart
class ProductModel {
  final String id;
  final String name;
  final String ean;
  final String sku;
  final bool? inCart;
  final bool? inWishlist;
  final bool isListed;
  final double? averageRating;
  final int totalReviews;
  final List<String> images;
  final List<ProductVariant> variants;

  ProductModel({
    required this.id,
    required this.name,
    required this.ean,
    required this.sku,
    required this.images,
    required this.variants,
    required this.inCart,
    required this.inWishlist,
    required this.isListed,
    this.averageRating,
    required this.totalReviews
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      ean: json['ean'],
      sku: json['sku'],
      totalReviews: json['totalReviews'],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List<dynamic>)
          .where((image) => image != null)  // Filter out null values
          .map((image) => image as String)
          .toList(),
      variants: List<ProductVariant>.from(json['variants'].map((variant) => ProductVariant.fromJson(variant))), inCart: json['inCart'],inWishlist: json['inWishlist'],isListed: json['isListed']
    );
  }
}
class ProductVariant {
  final String weight;
  final double inPrice;
  final double outPrice;
  final int stockQuantity;
  final String id;

  ProductVariant({
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.stockQuantity,
    required this.id,
  });

  // fromJson method to parse JSON data into ProductVariant instance
  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      weight: json['weight'] as String,
      inPrice: (json['inPrice'] as num).toDouble(),
      outPrice: (json['outPrice'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      id: json['_id'] as String,
    );
  }

  // toJson method to convert ProductVariant instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'inPrice': inPrice,
      'outPrice': outPrice,
      'stockQuantity': stockQuantity,
      '_id': id,
    };
  }
}
