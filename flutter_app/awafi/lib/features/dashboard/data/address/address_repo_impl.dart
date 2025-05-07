import '../../domain/address/address_entity.dart';
import '../../domain/address/address_repo.dart';
import 'address_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressDataSource dataSource;

  AddressRepositoryImpl(this.dataSource);

  @override
  Future<Address> getAddress() async {
    final model = await dataSource.getAddress();
    return Address(
      addressLine1: model.addressLine1,
      addressLine2: model.addressLine2,
      city: model.city,
      postalCode: model.postalCode,
      country: model.country,
    );
  }
}