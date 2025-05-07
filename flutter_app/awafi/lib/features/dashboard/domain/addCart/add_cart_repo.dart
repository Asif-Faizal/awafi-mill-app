

import 'add_cart_entity.dart';

abstract class AddCartRepo {
  Future<void> addCartItem(AddCartItem cartItem);
}
