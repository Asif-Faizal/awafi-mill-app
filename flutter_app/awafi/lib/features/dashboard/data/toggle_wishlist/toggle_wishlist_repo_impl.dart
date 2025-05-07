

import '../../domain/toggle_wishlist/toggle_wishlist_entity.dart';
import '../../domain/toggle_wishlist/toggle_wishlist_repo.dart';
import 'toggle_wishlist_datasource.dart';
import 'toggle_wishlist_model.dart';

class ToggleWishlistRepositoryImpl implements ToggleWishlistRepository {
  final ToggleWishlistRemoteDataSource remoteDataSource;

  ToggleWishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addItemToWishlist(ToggleWishlistItem item) async {
    final itemModel = ToggleWishlistItemModel(
      productId: item.productId,
      variantId: item.variantId,
    );
    return remoteDataSource.addItemToWishlist(itemModel);
  }

  @override
  Future<void> removeItemFromWishlist(ToggleWishlistItem item) async {
    final itemModel = ToggleWishlistItemModel(
      productId: item.productId,
      variantId: item.variantId,
    );
    return remoteDataSource.removeItemFromWishlist(itemModel);
  }
}
