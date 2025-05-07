class CartItem {
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

  CartItem({
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
}
