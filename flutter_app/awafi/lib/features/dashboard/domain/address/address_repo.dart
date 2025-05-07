import 'address_entity.dart';

abstract class AddressRepository {
  Future<Address> getAddress();
}