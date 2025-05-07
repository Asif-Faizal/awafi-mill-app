import '../../domain/product/product_entity.dart';
import '../../domain/product/product_repo.dart';
import 'product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await dataSource.fetchProducts();
    return productModels.map((model) => Product(
      averageRating: model.averageRating ?? 0.0,
      totalReviews: model.totalReviews,
      isListed: model.isListed,
      inWishlist: model.inWishlist ?? false,
      inCart: model.inCart ?? false,
      id: model.id,
      name: model.name,
      ean: model.ean,
      sku: model.sku,
      images: model.images,
                variants: model.variants.map((variant) => ProductVariantEntity(
                  id: variant.id,
                weight: variant.weight,
                inPrice: variant.inPrice,
                outPrice: variant.outPrice,
                stockQuantity: variant.stockQuantity,
              )).toList(),
    )).toList();
  }
}