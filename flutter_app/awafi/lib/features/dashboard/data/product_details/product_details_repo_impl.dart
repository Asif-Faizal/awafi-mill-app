import '../../domain/product_details/product_details_entity.dart';
import '../../domain/product_details/product_details_repo.dart';
import 'product_details_datasource.dart';

class ProductIndividualRepositoryImpl implements ProductIndividualRepository {
  final ProductIndividualRemoteDataSource remoteDataSource;

  ProductIndividualRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProductIndividualEntity> getProductDetails(String productId) async {
    final model = await remoteDataSource.getProductDetails(productId);
    return ProductIndividualEntity(
      id: model.id,
      name: model.name,
      descriptions: model.descriptions,
      images: model.images,
      variants: model.variants,
      isListed: model.isListed,
      ean: model.ean,
      sku: model.sku,
      inCart: model.inCart,
      inWishlist: model.inWishlist,
      averageRating: model.averageRating ?? 0.00,
      totalReviews: model.totalReviews?? 0
      // mainCategory: model.mainCategoryData,
      // subCategory: model.subCategoryData,
    );
  }
}
