import 'add_cart_entity.dart';
import 'add_cart_repo.dart';

class AddCartItemUseCase {
  final AddCartRepo repository;

  AddCartItemUseCase({required this.repository});

  Future<void> call(AddCartItem cartItem) async {
    await repository.addCartItem(cartItem);
  }
}