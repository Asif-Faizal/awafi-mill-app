import '../../domain/cart/cart_entity.dart';
import '../../domain/cart/cart_repo.dart';
import 'cart_datasource.dart';
class CartRepositoryImpl implements CartRepository {
  final CartDataSource dataSource;

  CartRepositoryImpl(this.dataSource);

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final models = await dataSource.fetchCartItems();
      return models
          .map((model) => CartItem(
                productId: model.productId,
                variantId: model.variantId,
                name: model.name,
                quantity: model.quantity,
                weight: model.weight,
                inPrice: model.inPrice,
                outPrice: model.outPrice,
                images: model.images,
                stockQuantity: model.stockQuantity,
                rating: model.rating,
              ))
          .toList();
    } on UnauthenticatedException {
      throw UnauthenticatedException();
    } on CartNotFoundException {
      throw CartNotFoundException();
    } catch (e) {
      throw Exception('Error fetching cart items: $e');
    }
  }

  @override
  Future<List<CartItem>> updateCartQuantity(String productId, String variantId, int quantity) async {
    try {
      final updatedCartItems = await dataSource.updateCartQuantity(productId, variantId, quantity);
      return updatedCartItems
          .map((model) => CartItem(
                productId: model.productId,
                variantId: model.variantId,
                name: model.name,
                quantity: model.quantity,
                weight: model.weight,
                inPrice: model.inPrice,
                outPrice: model.outPrice,
                images: model.images,
                stockQuantity: model.stockQuantity,
                rating: model.rating,
              ))
          .toList();
    } on UnauthorisedException {
      throw Exception('UserUnauthorized');
    }
  }

  @override
  Future<List<CartItem>> removeCartItem(String productId, String variantId) async {
    try {
      final updatedCartItems = await dataSource.removeCartItem(productId, variantId);
      return updatedCartItems
          .map((model) => CartItem(
                productId: model.productId,
                variantId: model.variantId,
                name: model.name,
                quantity: model.quantity,
                weight: model.weight,
                inPrice: model.inPrice,
                outPrice: model.outPrice,
                images: model.images,
                stockQuantity: model.stockQuantity,
                rating: model.rating,
              ))
          .toList();
    } on UnauthorisedException {
      throw Exception('UserUnauthorized');
    }
  }
}
class UnauthorisedException implements Exception {}