class WishlistItemEntity {
  final String productId;
  final String variantId;
  final String name;
  final String weight;
  final int inPrice;
  final int outPrice;
  final String images;
  final int stockQuantity;
  final double? rating;

  WishlistItemEntity({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.weight,
    required this.inPrice,
    required this.outPrice,
    required this.images,
    required this.stockQuantity,
    required this.rating,
  });
}
