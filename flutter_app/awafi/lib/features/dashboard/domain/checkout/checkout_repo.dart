import 'checkout_entity.dart';

abstract class CheckoutRepository {
  Future<void> checkout(CheckoutEntity checkoutEntity);
}