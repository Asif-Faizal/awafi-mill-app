import 'wishlist_entity.dart';

abstract class WishlistRepository {
  Future<List<WishlistItemEntity>> getWishlistItems();
}