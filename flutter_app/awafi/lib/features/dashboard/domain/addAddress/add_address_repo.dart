import 'add_address_entity.dart';

abstract class AddAddressRepository {
  Future<Map<String, dynamic>> addAddress(AddAddressEntity address);
}