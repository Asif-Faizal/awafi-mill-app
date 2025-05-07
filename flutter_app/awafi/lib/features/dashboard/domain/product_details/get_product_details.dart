import 'product_details_entity.dart';
import 'product_details_repo.dart';

class GetProductIndividualDetails {
  final ProductIndividualRepository repository;

  GetProductIndividualDetails(this.repository);

  Future<ProductIndividualEntity> call(String productId) {
    return repository.getProductDetails(productId);
  }
}
