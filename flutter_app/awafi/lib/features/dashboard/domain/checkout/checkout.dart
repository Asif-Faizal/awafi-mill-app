
import 'checkout_entity.dart';
import 'checkout_repo.dart';

class CheckoutUseCase {
  final CheckoutRepository repository;

  CheckoutUseCase(this.repository);

  Future<void> call(CheckoutEntity checkoutEntity) {
    return repository.checkout(checkoutEntity);
  }
}