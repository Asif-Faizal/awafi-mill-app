
import 'collection_product_entity.dart';

abstract class CollectionProductRepository {
  Future<List<CollectionProductEntity>> getCollectionProducts(String subCategoryId);
}