import 'wishlist_entity.dart';
import 'wishlist_repo.dart';

class GetWishlistItemsUseCase {
  final WishlistRepository repository;

  GetWishlistItemsUseCase({required this.repository});

  Future<List<WishlistItemEntity>> call() async {
    return await repository.getWishlistItems();
  }
}
