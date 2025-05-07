
import '../../domain/wishlist/wishlist_entity.dart';
import '../../domain/wishlist/wishlist_repo.dart';
import 'wishlist_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WishlistItemEntity>> getWishlistItems() async {
    final wishlistModels = await remoteDataSource.getWishlistItems();
    return wishlistModels
        .map((wishlistModel) => WishlistItemEntity(
              productId: wishlistModel.productId,
              variantId: wishlistModel.variantId,
              name: wishlistModel.name,
              weight: wishlistModel.weight,
              inPrice: wishlistModel.inPrice,
              outPrice: wishlistModel.outPrice,
              images: wishlistModel.images,
              stockQuantity: wishlistModel.stockQuantity,
              rating: wishlistModel.rating ?? 0.0,
            ))
        .toList();
  }
}