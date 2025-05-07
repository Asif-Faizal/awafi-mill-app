import 'product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}