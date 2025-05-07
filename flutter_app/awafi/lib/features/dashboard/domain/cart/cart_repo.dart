import 'cart_entity.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<List<CartItem>> updateCartQuantity(String productId, String variantId, int quantity);
  Future<List<CartItem>> removeCartItem(String productId, String variantId);
}