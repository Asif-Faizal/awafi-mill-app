import 'address_entity.dart';
import 'address_repo.dart';

class GetAddressUseCase {
  final AddressRepository repository;

  GetAddressUseCase(this.repository);

  Future<Address> call() async {
    return await repository.getAddress();
  }
}