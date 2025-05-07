import 'toggle_wishlist_entity.dart';
import 'toggle_wishlist_repo.dart';

class RemoveItemFromWishlist {
  final ToggleWishlistRepository repository;

  RemoveItemFromWishlist(this.repository);

  Future<void> execute(ToggleWishlistItem item) {
    return repository.removeItemFromWishlist(item);
  }
}