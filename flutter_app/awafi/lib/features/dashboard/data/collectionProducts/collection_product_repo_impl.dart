import '../../domain/collectionProducts/collection_product_entity.dart';
import '../../domain/collectionProducts/collection_product_repo.dart';
import 'collection_product_datasource.dart';

class CollectionProductRepositoryImpl implements CollectionProductRepository {
  final CollectionProductRemoteDataSource remoteDataSource;

  CollectionProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CollectionProductEntity>> getCollectionProducts(String subCategoryId) async {
    final models = await remoteDataSource.getCollectionProducts(subCategoryId);
    return models
        .map((model) => CollectionProductEntity(
              id: model.id,
              sku: model.sku,
              name: model.name,
              descriptions: model.descriptions
                  .map((desc) => DescriptionEntity(
                        header: desc.header,
                        content: desc.content,
                      ))
                  .toList(),
              isListed: model.isListed,
              isDelete: model.isDelete,
              images: model.images,
              variants: model.variants
                  .map((variant) => VariantEntity(
                        weight: variant.weight,
                        inPrice: variant.inPrice,
                        outPrice: variant.outPrice,
                        stockQuantity: variant.stockQuantity,
                      ))
                  .toList(),
              averageRating: model.averageRating,
              totalReviews: model.totalReviews,
            ))
        .toList();
  }
}