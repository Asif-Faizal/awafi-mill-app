
import 'collection_product_entity.dart';
import 'collection_product_repo.dart';

class GetCollectionProductsUseCase {
  final CollectionProductRepository repository;

  GetCollectionProductsUseCase(this.repository);

  Future<List<CollectionProductEntity>> call(String subCategoryId) async {
    return await repository.getCollectionProducts(subCategoryId);
  }
}