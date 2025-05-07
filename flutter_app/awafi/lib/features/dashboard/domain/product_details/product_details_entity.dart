import '../../data/product_details/product_details_model.dart';

class ProductIndividualEntity {
  final String id;
  final String name;
  final List<Description> descriptions;
  final List<String> images;
  final List<Variant> variants;
  final bool isListed;
  final String ean;
  final String sku;
  final bool? inCart;
  final bool? inWishlist;
  final double? averageRating;
  final int totalReviews;
  // final Category mainCategory;
  // final Category subCategory;

  ProductIndividualEntity({
    required this.id,
    required this.name,
    required this.descriptions,
    required this.images,
    required this.variants,
    required this.isListed,
    required this.ean,
    required this.sku,
    this.inCart,
    this.inWishlist,
    required this.averageRating,
    required this.totalReviews
    // required this.mainCategory,
    // required this.subCategory,
  });
}
