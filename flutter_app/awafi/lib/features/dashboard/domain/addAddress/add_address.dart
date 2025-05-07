import 'add_address_entity.dart';
import 'add_address_repo.dart';

class AddAddressUseCase {
  final AddAddressRepository repository;

  AddAddressUseCase({required this.repository});

  Future<Map<String, dynamic>> execute(AddAddressEntity address) async {
    return await repository.addAddress(address);
  }
}