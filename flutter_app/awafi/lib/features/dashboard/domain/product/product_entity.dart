// entities/product.dart
class Product {
  final String id;
  final String name;
  final String ean;
  final String sku;
  final bool inCart;
  final bool inWishlist;
  final bool isListed;
  final double? averageRating;
  final int totalReviews;
  final List<String> images;
  final List<ProductVariantEntity> variants;

  Product({
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
}
class ProductVariantEntity {
  final String id;
  final String weight;
  final double inPrice;
  final double outPrice;
  final int stockQuantity;

  ProductVariantEntity({
    required this.id,
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.stockQuantity,
  });
}