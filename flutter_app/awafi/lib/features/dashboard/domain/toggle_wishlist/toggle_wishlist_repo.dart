import 'toggle_wishlist_entity.dart';

abstract class ToggleWishlistRepository {
  Future<void> addItemToWishlist(ToggleWishlistItem item);
  Future<void> removeItemFromWishlist(ToggleWishlistItem item);
}