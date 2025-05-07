import 'toggle_wishlist_entity.dart';
import 'toggle_wishlist_repo.dart';

class AddItemToWishlist {
  final ToggleWishlistRepository repository;

  AddItemToWishlist(this.repository);

  Future<void> execute(ToggleWishlistItem item) {
    return repository.addItemToWishlist(item);
  }
}