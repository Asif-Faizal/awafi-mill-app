import 'product_details_entity.dart';

abstract class ProductIndividualRepository {
  Future<ProductIndividualEntity> getProductDetails(String productId);
}
