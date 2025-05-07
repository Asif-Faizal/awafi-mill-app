import 'cart_entity.dart';
import 'cart_repo.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<List<CartItem>> call() async {
    return await repository.getCartItems();
  }
}